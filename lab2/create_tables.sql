DROP TABLE IF EXISTS read_books CASCADE;
DROP TABLE IF EXISTS transactions CASCADE;
DROP TABLE IF EXISTS subscriptions CASCADE;
DROP TABLE IF EXISTS reviews CASCADE;
DROP TABLE IF EXISTS book_statuses CASCADE;
DROP TABLE IF EXISTS books CASCADE;
DROP TABLE IF EXISTS authors CASCADE;
DROP TABLE IF EXISTS user_roles CASCADE;
DROP TABLE IF EXISTS statuses CASCADE;
DROP TABLE IF EXISTS users CASCADE;

CREATE TABLE statuses
(
  id   uuid         NOT NULL PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

CREATE TABLE user_roles
(
  id      uuid NOT NULL PRIMARY KEY,
  role    INT  NULL DEFAULT 1 CHECK (role IN (1, 2, 3)) -- 1 - reader, 2 - author, 3 - admin
);

CREATE TABLE subscriptions
(
  id         uuid         NOT NULL PRIMARY KEY,
  type       VARCHAR(255) NOT NULL DEFAULT 'standard',
  start_date TIMESTAMP     NOT NULL,
  end_date   TIMESTAMP     NOT NULL,
  status_id  uuid         NOT NULL,
  CONSTRAINT FK_statuses_TO_subscriptions FOREIGN KEY (status_id) REFERENCES statuses (id) ON DELETE CASCADE
);

CREATE TABLE users
(
  id                uuid         NOT NULL PRIMARY KEY,
  name              VARCHAR(255) NOT NULL,
  email             VARCHAR(255) NOT NULL UNIQUE CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
  password          VARCHAR(255) NOT NULL,
  registration_date TIMESTAMP     NOT NULL,
  subscription_id   uuid NULL,
  user_role_id      uuid NOT NULL
  -- CONSTRAINT FK_subscriptions_TO_users FOREIGN KEY (subscription_id) REFERENCES subscriptions (id) ON DELETE SET NULL,
  -- CONSTRAINT FK_user_roles_TO_users FOREIGN KEY (user_role_id) REFERENCES user_roles (id) ON DELETE CASCADE
);

CREATE TABLE authors
(
  id      uuid         NOT NULL PRIMARY KEY,
  name    VARCHAR(255) NOT NULL UNIQUE,
  bio     VARCHAR(511),
  user_id uuid         NOT NULL,
  CONSTRAINT FK_users_TO_authors FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
);

CREATE TABLE books
(
  id          uuid           NOT NULL PRIMARY KEY,
  title       VARCHAR(255)   NOT NULL UNIQUE,
  year        INTEGER,       
  price       DECIMAL(10, 2) DEFAULT 0 CHECK (price >= 0),
  description TEXT,
  genre       INT            NOT NULL CHECK (genre IN (1, 2, 3, 4, 5)),
  author_id   uuid           NOT NULL,
  CONSTRAINT FK_authors_TO_books FOREIGN KEY (author_id) REFERENCES authors (id) ON DELETE CASCADE
);

CREATE TABLE book_statuses
(
  id         uuid     NOT NULL PRIMARY KEY,
  start_date TIMESTAMP NOT NULL,
  end_date   TIMESTAMP NOT NULL,
  book_id    uuid     NOT NULL,
  status_id  uuid     NOT NULL,
  CONSTRAINT FK_books_TO_book_statuses FOREIGN KEY (book_id) REFERENCES books (id) ON DELETE CASCADE,
  CONSTRAINT FK_statuses_TO_book_statuses FOREIGN KEY (status_id) REFERENCES statuses (id) ON DELETE CASCADE
);

CREATE TABLE reviews
(
  id      uuid      NOT NULL PRIMARY KEY,
  rating  INT       NOT NULL CHECK (rating >= 1 AND rating <= 5),
  text    TEXT,
  date    TIMESTAMP NOT NULL,
  user_id uuid      NOT NULL,
  book_id uuid      NOT NULL,
  CONSTRAINT FK_users_TO_reviews FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
  CONSTRAINT FK_books_TO_reviews FOREIGN KEY (book_id) REFERENCES books (id) ON DELETE CASCADE
);

CREATE TABLE read_books
(
  id         uuid     NOT NULL PRIMARY KEY,
  start_date TIMESTAMP,
  end_date   TIMESTAMP,
  pagesRead  INT      DEFAULT 0 CHECK (pagesRead >= 0),
  totalPages INT      NOT NULL CHECK (totalPages > 0),
  user_id    uuid     NOT NULL,
  book_id    uuid     NOT NULL,
  review_id  uuid,
  CONSTRAINT FK_users_TO_read_books FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
  CONSTRAINT FK_books_TO_read_books FOREIGN KEY (book_id) REFERENCES books (id) ON DELETE CASCADE,
  CONSTRAINT FK_reviews_TO_read_books FOREIGN KEY (review_id) REFERENCES reviews (id) ON DELETE CASCADE
);

CREATE TABLE transactions
(
  id               uuid           NOT NULL PRIMARY KEY,
  transaction_kind INT            NOT NULL CHECK (transaction_kind IN (1, 2, 3)),
  date             TIMESTAMP       NOT NULL,
  cost             DECIMAL(10, 2) DEFAULT 0 CHECK (cost >= 0),
  user_id          uuid           NOT NULL,
  book_id          uuid,
  subscription_id  uuid
  -- CONSTRAINT FK_users_TO_transactions FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
  -- CONSTRAINT FK_books_TO_transactions FOREIGN KEY (book_id) REFERENCES books (id) ON DELETE CASCADE
  -- CONSTRAINT FK_subscriptions_TO_transactions FOREIGN KEY (subscription_id) REFERENCES subscriptions (id) ON DELETE CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS authors_name ON authors(name);
CREATE UNIQUE INDEX IF NOT EXISTS title ON books(title);
CREATE UNIQUE INDEX IF NOT EXISTS email ON users(email);