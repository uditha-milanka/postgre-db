-- USERS
INSERT INTO users (username, email, password_hash)
VALUES
  ('uditha', 'uditha@gmail.com', 'hashed_pw_1'),
  ('milanka', 'milanka@ymail.com', 'hashed_pw_2'),
  ('pathirana', 'pathirana@hotmail.com', 'hashed_pw_3');

-- ROLES
INSERT INTO roles (name, description)
VALUES
  ('admin', 'System administrator with full access'),
  ('shop_owner', 'User that owns and manages a shop'),
  ('customer', 'User that places orders');


-- USER ROLES
INSERT INTO user_roles (user_id, role_id) VALUES (1, 1), (1, 2); -- Uditha is both admin and shop owner
INSERT INTO user_roles (user_id, role_id) VALUES (2, 2); -- Milanka is shop owner
INSERT INTO user_roles (user_id, role_id) VALUES (3, 3); -- Pathirana is customer

-- SHOPS
INSERT INTO shops (name)
VALUES
  ('Keels'),
  ('Food City'),
  ('Spar');

INSERT INTO shop_owners (user_id, shop_id) VALUES (1, 1), (2, 3); -- Uditha - Keels, Milanka - Spar

-- CATEGORIES
INSERT INTO categories (name)
VALUES
  ('Vegetables'),
  ('Canned Foods'),
  ('Fruits');

-- PRODUCTS
INSERT INTO products (shop_id, category_id, name, description, price, stock)
VALUES
  (1, 1, 'Carrot', 'Carrot is a vegetable', 450, 10),
  (1, 1, 'Cabbage', 'Cabbage is a vegetable', 90, 100),
  (2, 2, 'Salmon', 'Fresh salmon', 800, 50),
  (2, 2, 'Corn', 'Boiled corn kernels', 1800, 200),
  (3, 3, 'Pineapple', 'No No No...', 350, 30);


-- ORDERS
INSERT INTO orders (user_id, shop_id, total_amount, status)
VALUES
  (1, 1, 810, 'completed'),
  (2, 2, 2600, 'shipped'),
  (3, 3, 350, 'pending');

-- ORDER ITEMS
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES
  (1, 1, 1, 450),
  (1, 2, 2, 180),
  (2, 3, 1, 800),
  (2, 4, 1, 1800),
  (3, 5, 1, 350);
