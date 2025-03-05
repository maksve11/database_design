-- Мастер-таблица для партиционирования по дате
CREATE TABLE transactions_master (
  id               uuid           NOT NULL,
  transaction_kind INT            NOT NULL CHECK (transaction_kind IN (1, 2, 3)),
  date             TIMESTAMP       NOT NULL,
  cost             DECIMAL(10, 2) DEFAULT 0 CHECK (cost >= 0),
  user_id          uuid           NOT NULL,
  book_id          uuid,
  subscription_id  uuid
) PARTITION BY RANGE (date);

-- Создание партиций
CREATE TABLE transactions_2022 PARTITION OF transactions_master
  FOR VALUES FROM ('2022-01-01') TO ('2023-01-01');

CREATE TABLE transactions_2023 PARTITION OF transactions_master
  FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

CREATE TABLE transactions_2024 PARTITION OF transactions_master
  FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

INSERT INTO transactions_master (id, transaction_kind, date, cost, user_id, book_id, subscription_id)
SELECT id, transaction_kind, date, cost, user_id, book_id, subscription_id
FROM transactions;

-- Очищаем таблицу transactions
DELETE FROM transactions;

-- Добавляем уникальные ограничения для партиций (с учетом столбцов id и date)
ALTER TABLE transactions_2022 ADD CONSTRAINT transactions_2022_pkey PRIMARY KEY (id, date);
ALTER TABLE transactions_2023 ADD CONSTRAINT transactions_2023_pkey PRIMARY KEY (id, date);
ALTER TABLE transactions_2024 ADD CONSTRAINT transactions_2024_pkey PRIMARY KEY (id, date);

-- -- Функция для вставки данных в соответствующие партиции
CREATE OR REPLACE FUNCTION insert_into_transactions_master() 
RETURNS TRIGGER AS $$
BEGIN
  IF pg_trigger_depth() > 0 THEN
    RETURN NEW; 
  END IF;

  IF (NEW.date >= '2022-01-01' AND NEW.date < '2023-01-01') THEN
    INSERT INTO transactions_2022 VALUES (NEW.*);
  END IF;

  IF (NEW.date >= '2023-01-01' AND NEW.date < '2024-01-01') THEN
    INSERT INTO transactions_2023 VALUES (NEW.*);
  END IF;

  IF (NEW.date >= '2024-01-01' AND NEW.date < '2025-01-01') THEN
    INSERT INTO transactions_2024 VALUES (NEW.*);
  END IF;

  IF NOT (NEW.date >= '2022-01-01' AND NEW.date < '2025-01-01') THEN
    RAISE EXCEPTION 'Date out of range: %, %', NEW.id, NEW.date;
  END IF;

  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- -- Триггер для автоматической вставки данных в соответствующие партиции
CREATE TRIGGER transactions_insert_trigger
  BEFORE INSERT ON transactions_master
  FOR EACH ROW EXECUTE PROCEDURE insert_into_transactions_master();

-- -- Отключение триггера
-- ALTER TABLE transactions_master DISABLE TRIGGER transactions_insert_trigger;

-- Включаем триггер
-- ALTER TABLE transactions_master ENABLE TRIGGER transactions_insert_trigger;
