CREATE OR REPLACE PROCEDURE add_new_order(
  new_user_id INTEGER,
  new_shop_id INTEGER,
  new_order_item_json JSON
)
LANGUAGE plpgsql
AS $$
DECLARE
  new_order_id INTEGER;
  new_item JSON;
  new_product_id INTEGER;
  new_quantity INTEGER;
  new_unit_price NUMERIC(10,2);
  new_item_total NUMERIC(10,2);
  new_total_amount NUMERIC(10,2) := 0;
BEGIN
  -- Insert a Order
  INSERT INTO custom_order(user_id, shop_id)
  VALUES (new_user_id, new_shop_id)
  RETURNING id INTO new_order_id;

  -- Insert order items
  FOR new_item IN SELECT * FROM json_array_elements(new_order_item_json)
  LOOP
    new_product_id := (new_item->>'product_id')::INTEGER;
    new_quantity := (new_item->>'quantity')::INTEGER;

    -- Get price of product
    SELECT price INTO new_unit_price
    FROM product
    WHERE id = new_product_id;

    -- Calculate total
    new_item_total := new_quantity * new_unit_price;

    -- Insert into order_item
    INSERT INTO order_item(order_id, product_id, quantity, unit_price)
    VALUES (new_order_id, new_product_id, new_quantity, new_unit_price);

    -- Full Total
    new_total_amount := new_total_amount + new_item_total;

    -- Reduce Product Quantity
    UPDATE product
    SET stock = stock - new_quantity
    WHERE id = new_product_id AND stock >= new_quantity;

    -- Optional: Raise an exception if insufficient stock
    IF NOT FOUND THEN
      RAISE EXCEPTION 'Insufficient stock for product ID %', new_product_id;
    END IF;
  END LOOP;

  -- Update order with total amount
  UPDATE custom_order
  SET total_amount = new_total_amount
  WHERE id = new_order_id;
END;
$$;

-- Sample Call
-- CALL add_new_user('testuser', 'testuser@gmail.com', 'test_hashed_pw', 1);

-- custom_order
    -- id SERIAL PRIMARY KEY,
    -- user_id INTEGER REFERENCES app_user(id) ON DELETE SET NULL,
    -- shop_id INTEGER REFERENCES shop(id) ON DELETE CASCADE,
    -- total_amount NUMERIC(10,2) NOT NULL CHECK (total_amount >= 0),
    -- status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'shipped', 'completed', 'cancelled')),
    -- created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP

-- order_item
    -- id SERIAL PRIMARY KEY,
    -- order_id INTEGER REFERENCES custom_order(id) ON DELETE CASCADE,
    -- product_id INTEGER REFERENCES product(id) ON DELETE CASCADE,
    -- quantity INTEGER NOT NULL CHECK (quantity > 0),
    -- unit_price NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0),
    -- total_price NUMERIC(10,2) GENERATED ALWAYS AS (quantity * unit_price) STORED