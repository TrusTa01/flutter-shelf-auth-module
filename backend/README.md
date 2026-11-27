# Auth backend (Dart, shelf)

Backend of the auth module: registration with e-mail confirmation, sign-in by password or one-time code, server-side sessions. Dart 3.11, `shelf`, PostgreSQL 16. The client is in [`../frontend`](../frontend); the overview is in the [root README](../README.md).

## Run

**With Docker (recommended).** From the repository root:

```bash
cd docker
cp .env.example .env
docker compose up --build
```

This starts PostgreSQL and the backend on `http://localhost:8082`. Migrations are applied automatically on the first start with an empty volume. Later migrations are applied by hand (see [Migrations](#migrations)).

**Without Docker.** PostgreSQL must be running with the migrations applied.

```bash
cp .env.example .env          # DB_USER, DB_PASSWORD, DB_NAME
dart pub get
dart run bin/server.dev.dart
```

| Entry point | Use |
|---|---|
| `bin/server.dart` | Production. Reads configuration from environment variables; compiled to a native binary by the `Dockerfile` |
| `bin/server.dev.dart` | Local development. Reads `.env` |

| Variable | Default | |
|---|---|---|
| `DB_HOST` | `localhost` | |
| `DB_PORT` | `5432` | |
| `DB_USER`, `DB_PASSWORD`, `DB_NAME` | — | required |
| `PORT` | `8082` | HTTP port |

E-mail codes are written to the server log by `DevEmailSender`. To send real e-mail, implement `EmailCodeSenderService` (`lib/src/features/auth/shared/verify-email/domain/services/`) and register it instead of `DevEmailSender`.

## Migrations

| File | Creates |
|---|---|
| `0001_init_auth_users.sql` | schema `auth`, table `auth.users` |
| `0002_init_auth_sessions.sql` | `auth.sessions` |
| `0003_auth_email_codes.sql` | `auth.pending_registrations`, `auth.login_email_codes` |

Applied files are never edited; a schema change goes into a new `0004_*.sql`. To apply by hand:

```bash
psql "postgres://<user>:<password>@localhost:5432/<db>" -f migrations/0004_*.sql
```

## API

Base URL `http://localhost:8082`. Request and response bodies are JSON.

### Errors

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_FAILED",
    "message": "Some fields are invalid",
    "details": [
      { "field": "password", "code": "INVALID_PASSWORD", "message": "..." }
    ]
  }
}
```

`details` is present only for `VALIDATION_FAILED`. Errors common to all endpoints:

| Status | Code | When |
|---|---|---|
| 400 | `INVALID_JSON` | Body is not valid JSON |
| 400 | `INVALID_BODY` | JSON root is not an object |
| 400 | `INVALID_REQUEST_FIELDS` | A field is missing or has the wrong type |
| 400 | `VALIDATION_FAILED` | Field rules failed; every failed field is listed in `details` |
| 401 | `UNAUTHORIZED` | Protected endpoint without a valid token |

Field codes in `details`: `INVALID_LOGIN`, `INVALID_EMAIL`, `INVALID_PASSWORD`, `INVALID_USERNAME`, `INVALID_DISPLAY_NAME`.

### Authentication

Protected endpoints (`/auth/me`, `/auth/logout`, `/auth/logout/all`) need:

```http
Authorization: Bearer <access_token>
```

The token is 32 random bytes; the database keeps only its SHA-256 hash (`auth.sessions.token_hash`). A session lives 30 days.

### Registration

#### `POST /auth/register/start`

```json
{ "login": "john_doe", "email": "john@example.com", "password": "Password123" }
```

**201** `{ "registration_id": "uuid" }`. A 4-digit code is sent to the e-mail; it is valid for 15 minutes.

| Status | Code | When |
|---|---|---|
| 409 | `CONFLICT` | A pending registration with this e-mail already exists, including an expired one; remove it with `register/cancel` |

The e-mail is not checked against existing users at this step; a taken e-mail is reported by `complete-profile` as `EMAIL_TAKEN`.

#### `POST /auth/register/verify-email`

```json
{ "registration_id": "uuid", "code": "1234" }
```

**200** `{ "verified": true }`

| Status | Code | When |
|---|---|---|
| 400 | `INVALID_REGISTRATION` | Unknown `registration_id` |
| 400 | `INVALID_EMAIL_CODE` | Wrong code |
| 400 | `EMAIL_CODE_EXPIRED` | Code older than 15 minutes |
| 400 | `EMAIL_CODE_ATTEMPTS_EXCEEDED` | 5 wrong attempts |

#### `POST /auth/register/complete-profile`

```json
{ "registration_id": "uuid", "username": "john_doe", "display_name": "John Doe" }
```

**201**

```json
{
  "id": "uuid",
  "email": "john@example.com",
  "username": "john_doe",
  "display_name": "John Doe",
  "created_at": "2026-05-19T00:00:00.000Z"
}
```

| Status | Code | When |
|---|---|---|
| 400 | `INVALID_REGISTRATION` | Unknown `registration_id` |
| 400 | `EMAIL_NOT_VERIFIED` | `verify-email` was not completed |
| 409 | `EMAIL_TAKEN` | E-mail belongs to an existing user |
| 409 | `USERNAME_TAKEN` | Username is taken |

#### `POST /auth/register/cancel`

```json
{ "registration_id": "uuid" }
```

**200** `{ "cancelled": true }`

### Sign-in

#### `POST /auth/login/password`

```json
{ "identifier": "john@example.com", "password": "Password123" }
```

`identifier` is a login or an e-mail.

**200**

```json
{
  "access_token": "opaque-token",
  "user": {
    "id": "uuid",
    "email": "john@example.com",
    "username": "john_doe",
    "display_name": "John Doe",
    "created_at": "2026-05-19T00:00:00.000Z"
  },
  "expires_in": 2592000
}
```

`expires_in` is in seconds (30 days).

| Status | Code | When |
|---|---|---|
| 401 | `INVALID_CREDENTIALS` | Unknown identifier or wrong password |

#### `POST /auth/login/code/request`

```json
{ "identifier": "john@example.com" }
```

**200** `{ "sent": true }`, also for an unknown identifier.

| Status | Code | When |
|---|---|---|
| 429 | `EMAIL_CODE_RESEND_TOO_SOON` | Less than 60 seconds since the previous code for this account |

#### `POST /auth/login/code/verify`

```json
{ "identifier": "john@example.com", "code": "1234" }
```

**200**, same body as `login/password`.

| Status | Code | When |
|---|---|---|
| 400 | `INVALID_CREDENTIALS` | Unknown identifier |
| 400 | `INVALID_EMAIL_CODE` | Wrong code or no active code |
| 400 | `EMAIL_CODE_EXPIRED` | Code older than 15 minutes |
| 400 | `EMAIL_CODE_ATTEMPTS_EXCEEDED` | 5 wrong attempts |

### Session

| Endpoint | Response 200 |
|---|---|
| `GET /auth/me` | the user object, as in `complete-profile` |
| `POST /auth/logout` | `{ "ok": true }`; deletes the session of the token in the request |
| `POST /auth/logout/all` | `{ "ok": true }`; deletes every session of the user |

### Service

| Endpoint | |
|---|---|
| `GET /` | service info |
| `GET /health` | health check |

## Structure

```
lib/src/
├── server.dart              # pipeline, HTTP server, graceful shutdown
├── app_module.dart          # root router: /, /health, /auth
├── core/
│   ├── config/              # DbConfig from env
│   ├── data/                # Postgres error mapping mixin
│   ├── di/                  # get_it + injectable, connection pool
│   ├── api/                 # JSON responses
│   └── errors/              # AppException hierarchy, error codes
├── middleware/              # logging, errors, auth
└── features/auth/
    ├── auth_controller.dart # /auth/* routes
    ├── register/            # start, verify_email, complete_profile, cancel
    ├── login/               # password, request, verify
    ├── logout/
    ├── me/
    └── shared/              # tokens, e-mail codes, TTLs, policies
```

Each action has `api` (DTOs, mappers), `domain` (use case, repository interface, validation) and `data` (SQL repository).

## Tests

```bash
dart test
```

59 unit tests, no database needed. Endpoint tests in `test/unit/features/auth/api/` run requests through the real router and middleware with fake use cases. Protected routes are tested through the same `authMiddleware` as in production.

## Manual check

Collections and an environment for Postman are in [`postman/`](postman). With the server running:

1. `register/start` → take the code from the log → `register/verify-email` → `register/complete-profile`.
2. `login/password`, or `login/code/request` + `login/code/verify` → copy `access_token`.
3. `GET /auth/me` with the token → `200`.
4. `POST /auth/logout` → `GET /auth/me` → `401`.
