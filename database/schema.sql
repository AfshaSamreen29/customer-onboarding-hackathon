CREATE DATABASE IF NOT EXISTS onboarding
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE onboarding;

CREATE TABLE IF NOT EXISTS customers (
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
  INDEX idx_customers_status (account_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS customer_users (
  user_id VARCHAR(30) PRIMARY KEY,
  customer_id VARCHAR(30) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  first_name VARCHAR(60) NOT NULL,
  last_name VARCHAR(60) NOT NULL,
  phone VARCHAR(20),
  job_title VARCHAR(80),
  user_role VARCHAR(20) NOT NULL,
  user_status VARCHAR(20) NOT NULL,
  password_hash VARCHAR(255),
  CONSTRAINT fk_user_customer FOREIGN KEY (customer_id)
    REFERENCES customers (customer_id)
  ,CONSTRAINT fk_user_customer FOREIGN KEY (customer_id)
    REFERENCES customers (customer_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS verification_tokens (
  token_hash VARCHAR(128) PRIMARY KEY,
  customer_id VARCHAR(30) NOT NULL,
  email VARCHAR(150) NOT NULL,
  expires_at TIMESTAMP NOT NULL,
  consumed_at TIMESTAMP NULL,
  attempts INT DEFAULT 0,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_tokens_customer_created (customer_id, created_at),
  CONSTRAINT fk_token_customer FOREIGN KEY (customer_id)
    REFERENCES customers (customer_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS idempotency_keys (
  idempotency_key VARCHAR(60) PRIMARY KEY,
  request_hash VARCHAR(128) NOT NULL,
  response_body TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;