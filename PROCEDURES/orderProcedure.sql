-----------------------------------------------------------------------------------------------------------------------
-- Create a Order Procedure -------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------


-- CREATE A ORDER HEADER
CREATE OR REPLACE PROCEDURE sp_order_create_order_header(
  new_user_id INTEGER,
)
LANGUAGE plpgsql
AS $$
DECLARE
  new_order_id INTEGER;
BEGIN
  INSERT INTO custom_order(user_id, shop_id)
  VALUES (new_user_id, new_shop_id)


-- CREATE A ORDER LINE
CREATE OR REPLACE PROCEDURE sp_order_create_order_header(
  new_user_id INTEGER,
)
LANGUAGE plpgsql
AS $$
DECLARE
  new_order_id INTEGER;
BEGIN
  INSERT INTO custom_order(user_id, shop_id)
  VALUES (new_user_id, new_shop_id)

-- CREATE OR REPLACE PROCEDURE sp_order_create(
--   new_user_id INTEGER,
--   new_shop_id INTEGER,
--   new_order_item_json JSON
-- )
-- LANGUAGE plpgsql
-- AS $$
-- DECLARE
--   new_order_id INTEGER;
--   new_item JSON;
--   new_product_id INTEGER;
--   new_quantity INTEGER;
--   new_unit_price NUMERIC(10,2);
--   new_item_total NUMERIC(10,2);
--   new_total_amount NUMERIC(10,2) := 0;
-- BEGIN
--   -- Insert a Order
--   INSERT INTO custom_order(user_id, shop_id)
--   VALUES (new_user_id, new_shop_id)