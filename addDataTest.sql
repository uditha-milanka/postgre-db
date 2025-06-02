CALL add_new_user('testuser', 'testuser@gmail.com', 'test_hashed_pw', 1);

CALL add_new_order(
  4,  -- userid
  2,  -- shopid
  '[
    { "product_id": 1, "quantity": 2 },
    { "product_id": 3, "quantity": 1 }
  ]'::json
);