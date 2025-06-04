---------------------------------------------------------------------------------------------------------
-- TABLES
---------------------------------------------------------------------------------------------------------

-- USERS
CREATE TABLE app_user (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- SHOPS
CREATE TABLE shop (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- CATEGORIES
CREATE TABLE product_category (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- PRODUCTS
CREATE TABLE product (
    id SERIAL PRIMARY KEY,
    shop_id INTEGER REFERENCES shop(id) ON DELETE CASCADE,
    category_id INTEGER REFERENCES product_category(id),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price NUMERIC(10,2) NOT NULL CHECK (price >= 0),
    stock INTEGER NOT NULL DEFAULT 0 CHECK (stock >= 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ORDERS
CREATE TABLE custom_order (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES app_user(id) ON DELETE SET NULL,
    shop_id INTEGER REFERENCES shop(id) ON DELETE CASCADE,
    total_amount NUMERIC(10,2) CHECK (total_amount >= 0),
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'shipped', 'completed', 'cancelled')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ORDER ITEMS
CREATE TABLE order_item (
    id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES custom_order(id) ON DELETE CASCADE,
    product_id INTEGER REFERENCES product(id) ON DELETE CASCADE,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0),
    total_price NUMERIC(10,2) GENERATED ALWAYS AS (quantity * unit_price) STORED
);

-- ROLES
CREATE TABLE role (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- USER ROLES
CREATE TABLE user_role (
    user_id INTEGER REFERENCES app_user(id) ON DELETE CASCADE,
    role_id INTEGER REFERENCES role(id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, role_id)
);

-- USER ROLES
CREATE TABLE shop_owner (
    user_id INTEGER REFERENCES app_user(id) ON DELETE CASCADE,
    shop_id INTEGER REFERENCES shop(id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, shop_id)
);


---------------------------------------------------------------------------------------------------------
-- VIEWS
---------------------------------------------------------------------------------------------------------


-- USER ROLE VIEW
CREATE OR REPLACE VIEW user_role_view AS
SELECT
    app_user.id AS user_id,
    app_user.username,
    app_user.email,
    app_user.created_at AS user_created_at,
    role.id AS role_id,
    role.name AS role_name,
    role.description AS role_description,
    role.created_at AS role_created_at
FROM
    app_user
INNER JOIN
    user_role ON app_user.id = user_role.user_id
INNER JOIN
    role ON user_role.role_id = role.id;


-- ADMIN USERS VIEW
CREATE OR REPLACE VIEW admin_user_view AS
SELECT
    *
FROM
    user_role_view
WHERE
    user_role_view.role_name = 'admin';


-- USER ORDERS VIEW
CREATE OR REPLACE VIEW user_order_view AS
SELECT
    custom_order.id AS order_id,
    app_user.id AS user_id,
    app_user.username AS user_name,
    app_user.email AS user_email,
    custom_order.shop_id AS shop_id,
    shop.name AS shop_name,
    custom_order.total_amount,
    custom_order.status,
    custom_order.created_at
FROM
    custom_order
INNER JOIN
    app_user ON custom_order.user_id = app_user.id
INNER JOIN
    shop ON custom_order.shop_id = shop.id;