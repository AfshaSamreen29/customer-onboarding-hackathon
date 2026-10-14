*# Customer Onboarding API (MuleSoft)*



*SaaS customer onboarding workflow built for the Cognizant NPN MuleSoft hackathon (Use Case 04).*



*## Endpoints (base path /api/v1)*

*- POST /customers/register - validate, create customer, user and token, send welcome email, queue provisioning event. Requires an Idempotency-Key header.*

*- GET /customers/verify?token=... - verify email, activate the account, publish the activation event.*

*- POST /customers/resend-verification - send a new verification link (rate limited).*

*- API console: http://localhost:8081/console/*



*## Requirements*

*- Java 17, Anypoint Studio 7.27, Mule runtime 4.12.1*

*- MySQL 8 (run database/schema.sql)*

*- A Mailtrap sandbox inbox (or another SMTP server)*



*## Run locally*

*1. Run database/schema.sql in MySQL.*

*2. Copy src/main/resources/config.properties.example to src/main/resources/config.properties and fill in your own values. This file is ignored by Git and must never be committed.*

*3. Import the project in Anypoint Studio, then Run As, Mule Application.*

*4. Example call:*



&#x20;       *curl -i -X POST "http://localhost:8081/api/v1/customers/register" -H "Content-Type: application/json" -H "Idempotency-Key: demo-0001" -d @tests/valid.json*



*## Tests*

*26 MUnit tests in src/test/munit (4 suites): registration, validation, duplicate email, idempotent replay, token verification, resend and rate limit, and the failure paths for database, email and queue. All external systems are mocked. In Studio: right-click a suite, MUnit, Run MUnit suite.*



*## Status and known gaps*

*Implemented: registration, validation, duplicate check, transactional account creation, hashed verification token, welcome email, provisioning event, idempotency, verification, resend with rate limit, compensation on queue failure, correlation IDs.*

*Not yet done: secure properties for credentials, API Auto Discovery, API policies, domain project, CloudHub deployment, retry for database connection errors, alerting beyond log lines, High Level Design document, frontend.*

