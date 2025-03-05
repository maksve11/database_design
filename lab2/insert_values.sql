CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. Заполнение таблицы статусов
INSERT INTO statuses (id, name) VALUES
(uuid_generate_v4(), 'Active'),
(uuid_generate_v4(), 'Inactive'),
(uuid_generate_v4(), 'Pending'),
(uuid_generate_v4(), 'Cancelled'),
(uuid_generate_v4(), 'Expired');

-- 2. Заполнение таблицы ролей пользователей
INSERT INTO user_roles (id, role) VALUES
(uuid_generate_v4(), 1),  -- Reader
(uuid_generate_v4(), 2),  -- Author
(uuid_generate_v4(), 3);  -- Admin

-- 3. Заполнение таблицы подписок
INSERT INTO subscriptions (id, type, start_date, end_date, status_id) VALUES
(uuid_generate_v4(), 'Standard', NOW(), NOW() + INTERVAL '1 year', (SELECT id FROM statuses WHERE name='Active')),
(uuid_generate_v4(), 'Premium', NOW(), NOW() + INTERVAL '1 year', (SELECT id FROM statuses WHERE name='Active')),
(uuid_generate_v4(), 'Basic', NOW(), NOW() + INTERVAL '1 year', (SELECT id FROM statuses WHERE name='Active')),
(uuid_generate_v4(), 'Family', NOW(), NOW() + INTERVAL '1 year', (SELECT id FROM statuses WHERE name='Active')),
(uuid_generate_v4(), 'Student', NOW(), NOW() + INTERVAL '1 year', (SELECT id FROM statuses WHERE name='Pending'));

-- 4. Заполнение таблицы пользователей
INSERT INTO users (id, name, email, password, registration_date, subscription_id, user_role_id) VALUES
(uuid_generate_v4(), 'Alice', 'alice@example.com', 'password1', NOW(), (SELECT id FROM subscriptions WHERE type = 'Standard'), (SELECT id FROM user_roles WHERE role = 1)),
(uuid_generate_v4(), 'Bob', 'bob@example.com', 'password2', NOW(), (SELECT id FROM subscriptions WHERE type = 'Premium'), (SELECT id FROM user_roles WHERE role = 2)),
(uuid_generate_v4(), 'Charlie', 'charlie@example.com', 'password3', NOW(), (SELECT id FROM subscriptions WHERE type = 'Basic'), (SELECT id FROM user_roles WHERE role = 3)),
(uuid_generate_v4(), 'David', 'david@example.com', 'password4', NOW(), (SELECT id FROM subscriptions WHERE type = 'Family'), (SELECT id FROM user_roles WHERE role = 1)),
(uuid_generate_v4(), 'Eva', 'eva@example.com', 'password5', NOW(), (SELECT id FROM subscriptions WHERE type = 'Student'), (SELECT id FROM user_roles WHERE role = 2)),
(uuid_generate_v4(), 'Frank', 'frank@example.com', 'password6', NOW(), (SELECT id FROM subscriptions WHERE type = 'Standard'), (SELECT id FROM user_roles WHERE role = 1)),
(uuid_generate_v4(), 'Grace', 'grace@example.com', 'password7', NOW(), (SELECT id FROM subscriptions WHERE type = 'Premium'), (SELECT id FROM user_roles WHERE role = 2)),
(uuid_generate_v4(), 'Hannah', 'hannah@example.com', 'password8', NOW(), (SELECT id FROM subscriptions WHERE type = 'Basic'), (SELECT id FROM user_roles WHERE role = 1)),
(uuid_generate_v4(), 'Ian', 'ian@example.com', 'password9', NOW(), (SELECT id FROM subscriptions WHERE type = 'Family'), (SELECT id FROM user_roles WHERE role = 3)),
(uuid_generate_v4(), 'Jack', 'jack@example.com', 'password10', NOW(), (SELECT id FROM subscriptions WHERE type = 'Student'), (SELECT id FROM user_roles WHERE role = 1));

-- 5. Заполнение таблицы авторов
INSERT INTO authors (id, name, bio, user_id) VALUES
(uuid_generate_v4(), 'Author One', 'Bio of Author One', (SELECT id FROM users WHERE name='Bob')),
(uuid_generate_v4(), 'Author Two', 'Bio of Author Two', (SELECT id FROM users WHERE name='Eva')),
(uuid_generate_v4(), 'Author Three', 'Bio of Author Three', (SELECT id FROM users WHERE name='Charlie'));

-- 6. Заполнение таблицы книг
INSERT INTO books (id, title, year, price, description, genre, author_id) VALUES
(uuid_generate_v4(), 'The Great Gatsby', 1925, 10.99, 'A classic novel.', 1, (SELECT id FROM authors WHERE name='Author One')),
(uuid_generate_v4(), '1984', 1949, 8.99, 'A dystopian novel.', 2, (SELECT id FROM authors WHERE name='Author Two')),
(uuid_generate_v4(), 'To Kill a Mockingbird', 1960, 9.99, 'A novel about racial inequality.', 3, (SELECT id FROM authors WHERE name='Author Three')),
(uuid_generate_v4(), 'Pride and Prejudice', 1813, 12.99, 'A romantic novel.', 4, (SELECT id FROM authors WHERE name='Author One')),
(uuid_generate_v4(), 'Moby-Dick', 1851, 11.99, 'An adventure novel.', 5, (SELECT id FROM authors WHERE name='Author Three'));

-- 7. Заполнение таблицы статусов книг
INSERT INTO book_statuses (id, start_date, end_date, book_id, status_id) VALUES
(uuid_generate_v4(), NOW(), NOW() + INTERVAL '30 days', (SELECT id FROM books WHERE title='The Great Gatsby'), (SELECT id FROM statuses WHERE name='Active')),
(uuid_generate_v4(), NOW(), NOW() + INTERVAL '60 days', (SELECT id FROM books WHERE title='1984'), (SELECT id FROM statuses WHERE name='Pending')),
(uuid_generate_v4(), NOW(), NOW() + INTERVAL '45 days', (SELECT id FROM books WHERE title='To Kill a Mockingbird'), (SELECT id FROM statuses WHERE name='Expired')),
(uuid_generate_v4(), NOW(), NOW() + INTERVAL '90 days', (SELECT id FROM books WHERE title='Pride and Prejudice'), (SELECT id FROM statuses WHERE name='Active')),
(uuid_generate_v4(), NOW(), NOW() + INTERVAL '75 days', (SELECT id FROM books WHERE title='Moby-Dick'), (SELECT id FROM statuses WHERE name='Cancelled'));

-- 8. Заполнение таблицы рецензий
INSERT INTO reviews (id, rating, text, date, user_id, book_id) VALUES
(uuid_generate_v4(), 5, 'Great book!', NOW(), (SELECT id FROM users WHERE name='Alice'), (SELECT id FROM books WHERE title='The Great Gatsby')),
(uuid_generate_v4(), 4, 'Very interesting.', NOW(), (SELECT id FROM users WHERE name='Bob'), (SELECT id FROM books WHERE title='1984')),
(uuid_generate_v4(), 3, 'It was okay.', NOW(), (SELECT id FROM users WHERE name='Charlie'), (SELECT id FROM books WHERE title='To Kill a Mockingbird')),
(uuid_generate_v4(), 5, 'Loved it!', NOW(), (SELECT id FROM users WHERE name='David'), (SELECT id FROM books WHERE title='Pride and Prejudice')),
(uuid_generate_v4(), 2, 'Not my taste.', NOW(), (SELECT id FROM users WHERE name='Eva'), (SELECT id FROM books WHERE title='Moby-Dick'));

-- 9. Заполнение таблицы прочитанных книг
INSERT INTO read_books (id, start_date, end_date, pagesRead, totalPages, user_id, book_id) VALUES
(uuid_generate_v4(), NOW(), NOW() + INTERVAL '15 days', 100, 200, (SELECT id FROM users WHERE name='Alice'), (SELECT id FROM books WHERE title='The Great Gatsby')),
(uuid_generate_v4(), NOW(), NOW() + INTERVAL '10 days', 150, 300, (SELECT id FROM users WHERE name='Bob'), (SELECT id FROM books WHERE title='1984')),
(uuid_generate_v4(), NOW(), NOW() + INTERVAL '5 days', 50, 120, (SELECT id FROM users WHERE name='Charlie'), (SELECT id FROM books WHERE title='To Kill a Mockingbird'));

-- 10. Заполнение таблицы транзакций
-- COPY transactions (id, transaction_kind, date, cost, user_id, book_id, subscription_id)
-- FROM 'transactions.csv' DELIMITER ',' CSV HEADER;
