CREATE OR REPLACE PROCEDURE add_new_user(
  new_user_name VARCHAR,
  new_user_email VARCHAR,
  new_user_password TEXT,
  new_role_id INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
  new_user_id INTEGER;
BEGIN
  -- Insert a User
  INSERT INTO app_user(username, email, password_hash)
  VALUES (new_user_name, new_user_email, new_user_password);

  -- Set user role
  SELECT id INTO new_user_id FROM app_user WHERE username = new_user_name;
  INSERT INTO user_role(user_id, role_id)
  VALUES (new_user_id, new_role_id);
END;
$$;

-- Sample Call
-- CALL add_new_user('testuser', 'testuser@gmail.com', 'test_hashed_pw', 1);