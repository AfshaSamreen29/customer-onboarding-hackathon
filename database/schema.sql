USE onboarding;

CREATE TABLE customers (
  customer_id VARCHAR(30) PRIMARY KEY,
  tenant_id VARCHAR(30) NOT NULL UNIQUE,
  company_name VARCHAR(150) NOT NULL,
  industry VARCHAR(50),
  employee_count INT,
  gst_number VARCHAR(20),
  address_line1 VARCHAR(200),
  city VARCHAR(60),
  state VARCHAR(60),
  postal_code VARCHAR(12),
  country VARCHAR(60),
  plan_code VARCHAR(30) NOT NULL,
  seats INT NOT NULL,
  billing_currency CHAR(3) NOT NULL,
  region VARCHAR(20) NOT NULL,
  account_status VARCHAR(25) NOT NULL,
  marketing_opt_in BOOLEAN DEFAULT FALSE,
  terms_accepted_at TIMESTAMP NOT NULL,
  correlation_id VARCHAR(50),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL,
  email_status VARCHAR(20) NOT NULL DEFAULT 'PENDING',  -- ADDED: PENDING / SENT / FAILED
  email_attempts INT NOT NULL DEFAULT 0,                 -- ADDED: for retry tracking
  INDEX idx_customers_status (account_status)            -- ADDED: fast alert counts
);

CREATE TABLE customer_users (
  user_id VARCHAR(30) PRIMARY KEY,
  customer_id VARCHAR(30) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  first_name VARCHAR(60) NOT NULL,
  last_name VARCHAR(60) NOT NULL,
  phone VARCHAR(20),
  job_title VARCHAR(80),
  user_role VARCHAR(20) NOT NULL,
  user_status VARCHAR(20) NOT NULL,
  password_hash VARCHAR(255),                            -- ADDED: hash only, never plaintext
  CONSTRAINT fk_user_customer FOREIGN KEY (customer_id)
    REFERENCES customers (customer_id)
);

CREATE TABLE verification_tokens (
  token_hash VARCHAR(128) PRIMARY KEY,
  customer_id VARCHAR(30) NOT NULL,
  email VARCHAR(150) NOT NULL,
  expires_at TIMESTAMP NOT NULL,
  consumed_at TIMESTAMP NULL,
  attempts INT DEFAULT 0,
  INDEX idx_tokens_customer (customer_id)                -- ADDED: find a customer's tokens
);

CREATE TABLE idempotency_keys (
  idempotency_key VARCHAR(60) PRIMARY KEY,
  request_hash VARCHAR(128) NOT NULL,
  response_body TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

SHOW TABLES;