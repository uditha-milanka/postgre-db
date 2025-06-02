---------------------------------------------------------------------------------------------------------
-- TABLES
---------------------------------------------------------------------------------------------------------

-- USERS
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- SHOPS
CREATE TABLE shops (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- CATEGORIES
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- PRODUCTS
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    shop_id INTEGER REFERENCES shops(id) ON DELETE CASCADE,
    category_id INTEGER REFERENCES categories(id),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price NUMERIC(10,2) NOT NULL CHECK (price >= 0),
    stock INTEGER NOT NULL DEFAULT 0 CHECK (stock >= 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ORDERS
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
    shop_id INTEGER REFERENCES shops(id) ON DELETE CASCADE,
    total_amount NUMERIC(10,2) CHECK (total_amount >= 0),
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'shipped', 'completed', 'cancelled')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ORDER ITEMS
CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(id) ON DELETE CASCADE,
    product_id INTEGER REFERENCES products(id) ON DELETE CASCADE,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0),
    total_price NUMERIC(10,2) GENERATED ALWAYS AS (quantity * unit_price) STORED
);

-- ROLES
CREATE TABLE roles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- USER ROLES
CREATE TABLE user_roles (
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    role_id INTEGER REFERENCES roles(id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, role_id)
);

-- USER ROLES
CREATE TABLE shop_owners (
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    shop_id INTEGER REFERENCES shops(id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, shop_id)
);


---------------------------------------------------------------------------------------------------------
-- VIEWS
---------------------------------------------------------------------------------------------------------


-- USER ROLE VIEW
CREATE OR REPLACE VIEW user_role_view AS
SELECT
    users.id AS user_id,
    users.username,
    users.email,
    users.created_at AS user_created_at,
    roles.id AS role_id,
    roles.name AS role_name,
    roles.description AS role_description,
    roles.created_at AS role_created_at
FROM
    users
INNER JOIN
    user_roles ON users.id = user_roles.user_id
INNER JOIN
    roles ON user_roles.role_id = roles.id;


-- ADMIN USERS VIEW
CREATE OR REPLACE VIEW admin_users AS
SELECT
    *
FROM
    user_role_view
WHERE
    user_role_view.role_name = 'admin';


-- USER ORDERS VIEW
CREATE OR REPLACE VIEW user_orders_view AS
SELECT
    orders.id AS order_id,
    users.id AS user_id,
    users.username AS user_name,
    users.email AS user_email,
    orders.shop_id AS shop_id,
    shops.name AS shop_name,
    orders.total_amount,
    orders.status,
    orders.created_at
FROM
    orders
INNER JOIN
    users ON orders.user_id = users.id
INNER JOIN
    shops ON orders.shop_id = shops.id;