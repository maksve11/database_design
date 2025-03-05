CREATE VIEW user_subscriptions_view AS
SELECT 
    u.id AS user_id,
    u.name AS user_name,
    s.type AS subscription_type,
    s.start_date AS subscription_start,
    s.end_date AS subscription_end
FROM 
    users u
JOIN 
    subscriptions s ON u.subscription_id = s.id;

CREATE INDEX idx_users_email_registration ON users (email, registration_date);
CREATE INDEX idx_transactions_user_date ON transactions (user_id, date);

-- 

-- SELECT * 
-- FROM user_subscriptions_view
-- WHERE user_name LIKE 'F%';

--

-- EXPLAIN ANALYZE
-- SELECT * 
-- FROM user_subscriptions_view
-- WHERE user_name LIKE 'Frank';

---

CREATE VIEW read_books_reviews_view AS
SELECT 
    rb.user_id,
    rb.book_id,
    rb.pagesRead,
    r.rating,
    r.text AS review_text,
    r.date AS review_date
FROM 
    read_books rb
LEFT JOIN 
    reviews r ON rb.review_id = r.id;

CREATE INDEX idx_reviews_book_date ON reviews (book_id, date);
CREATE INDEX idx_read_books_user_book ON read_books (user_id, book_id);

--

-- SELECT * 
-- FROM read_books_reviews_view

--

-- EXPLAIN ANALYZE
-- SELECT * 
-- FROM read_books_reviews_view
