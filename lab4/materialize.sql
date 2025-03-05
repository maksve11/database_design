-- Generalization View
CREATE MATERIALIZED VIEW mv_generalized_users AS
SELECT 
    id,
    SUBSTRING(name FROM 1 FOR 1) || '*****' AS name,
    email,
    '*****' AS password,
    registration_date
FROM users;

-- Adding Noise View
CREATE MATERIALIZED VIEW mv_noisy_users AS
SELECT 
    id,
    name,
    email,
    password,
    registration_date + (RANDOM() * INTERVAL '30 days')
FROM users;

-- Randomization View
CREATE MATERIALIZED VIEW mv_randomized_users AS
SELECT 
    id,
    name,
    email,
    password,
    registration_date + (INTERVAL '1 day' * FLOOR(RANDOM() * 365))
FROM users;