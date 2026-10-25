# Driveline — Car Dealership Inventory

A full-stack car showroom and inventory application built with **FastAPI, file-based SQLite, React, Vite, and Tailwind CSS**. Customers can register, sign in, search vehicles, and purchase stock. Administrators can manage listings, replenish stock, and delete vehicles.

## Start here on Windows

1. Extract this ZIP into a **new folder**, such as `C:\Projects\driveline-complete`. Do not overwrite your existing repository or its `PROMPTS.md`.
2. Open that folder in VS Code. Python 3.12+ and Node 24 LTS are recommended. The candidate's Python 3.13 environment should also be checked locally.
3. Double-click **SETUP.cmd** and wait for successful completion. This installs dependencies and creates a random local JWT signing secret without printing it.
4. Double-click **START_BACKEND.cmd**. Leave it running.
5. Double-click **START_FRONTEND.cmd**. Leave it running.
6. Open **http://localhost:5173**. The API browser is **http://127.0.0.1:8000/docs**.
7. Select **Create account**, register your own account, and sign in.

No default admin passwords, accounts, JWT secret, or database are shipped. Your database is created automatically on the first backend start. The initial showroom is empty until vehicles are added or optional sample data is loaded.

### Make your account an administrator

Register your email in the UI first. In a third VS Code terminal, from the extracted project root:

```powershell
cd backend
.\.venv\Scripts\python.exe -m app.admin --email "your-registered-email@example.com"
```

Sign out and sign in again. The dashboard will display **Add vehicle**, **Edit**, **Restock**, and **Delete** controls. Promotion is a local operator command, not a public API.

### Optional sample showroom

From `backend`:

```powershell
.\.venv\Scripts\python.exe -m app.seed
```

Refresh the dashboard. Six sample vehicles are inserted **only if inventory is empty**. Existing listings are preserved. Sample data includes one sold-out vehicle so you can inspect the disabled Purchase button.

## Manual installation

Run these separately in PowerShell from the project root:

```powershell
cd backend
python -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
.\.venv\Scripts\python.exe init_env.py
.\.venv\Scripts\python.exe -m uvicorn app.main:app --reload
```

In a second terminal, from the project root:

```powershell
cd frontend
npm.cmd ci
npm.cmd run dev
```

No virtual-environment activation or system execution-policy change is needed. On Linux/macOS use `.venv/bin/python` in place of `.venv\Scripts\python.exe`, and `npm` in place of `npm.cmd`.

## Screenshots

These are actual browser captures of this package with synthetic sample inventory and test accounts. Sample accounts/database are excluded from the ZIP.

![Login screen](docs/screenshots/login-desktop.png)
![Administrator showroom](docs/screenshots/admin-dashboard.png)
![Vehicle entry form](docs/screenshots/admin-vehicle-form.png)
![Customer showroom](docs/screenshots/customer-dashboard.png)

Mobile screenshots are also in `docs/screenshots/`.

## Features and access rules

| Operation | Customer | Admin |
|---|---|---|
| Register / sign in | Yes | Yes |
| View and search inventory | Yes | Yes |
| Purchase available vehicles | Yes | Yes |
| Add and update vehicles through API | Yes | Yes |
| Add/update forms in the UI | No | Yes |
| Restock or delete | No | Yes |

The assignment marks create/update API endpoints as protected, and only explicitly restricts delete/restock to admins. This implementation follows that distinction. Hiding UI controls never substitutes for backend permission checks.

- Prices use **INR** in the UI. SQLite stores integer paise in the `price_cents` column (the existing project column name is retained for compatibility).
- API prices are JSON numbers, limited to two decimal places. Conversion into integer paise uses Python Decimal.
- Stock quantities must be integers. Invalid input returns 422. Purchase conflicts and excessive stock return 409.
- The stock limit is 1,000,000,000 units. Purchase uses one conditional SQL UPDATE to prevent overselling, including concurrent requests.
- Search uses case-insensitive **exact** make/model/category matches, combined with AND. Minimum/maximum prices are inclusive.
- PUT replaces all editable fields; it is not a partial PATCH.
- Sold-out listings remain visible, with the Purchase button disabled.
- Purchase updates inventory only; this kata does not implement payment collection or order history.

## API

| Method | Endpoint | Access | Success |
|---|---|---|---|
| POST | `/api/auth/register` | Public | 201 |
| POST | `/api/auth/login` | Public | 200 |
| GET | `/api/auth/me` | Signed in | 200 |
| POST | `/api/vehicles` | Signed in | 201 |
| GET | `/api/vehicles` | Signed in | 200 |
| GET | `/api/vehicles/search` | Signed in | 200 |
| PUT | `/api/vehicles/{id}` | Signed in | 200 |
| DELETE | `/api/vehicles/{id}` | Admin | 204, empty body |
| POST | `/api/vehicles/{id}/purchase` | Signed in | 200 |
| POST | `/api/vehicles/{id}/restock` | Admin | 200 |

Purchase/restock body: `{"quantity": 1}`. Registration body: `{"name":"Your name","email":"you@example.com","password":"your own password"}`. Login accepts email and password and returns `access_token` and `token_type: bearer`. Protected requests use `Authorization: Bearer <token>`.

The extra `/api/auth/me` endpoint provides the authenticated account/role for the frontend; it does not expose password fields.

## Architecture and code map

- `backend/app/main.py`: application factory, REST endpoints, HTTP error mapping.
- `backend/app/database.py`: SQLite schema, parameterized queries, transaction boundaries, atomic stock updates.
- `backend/app/schemas.py`: input validation and explicit public response models.
- `backend/app/security.py`: Argon2 password hashing and JWT creation.
- `backend/app/dependencies.py`: JWT verification, live account lookup, admin authorization.
- `backend/app/admin.py`: local account promotion command.
- `backend/app/seed.py`: optional sample inventory.
- `backend/app/vehicle_schemas.py`: compatibility import for the earlier guided project.
- `frontend/src/api.js`: HTTP client and readable API error handling.
- `frontend/src/components/AuthForm.jsx`: register/login forms, errors, loading state.
- `frontend/src/components/Dashboard.jsx`: inventory, search, summary, server-backed actions.
- `frontend/src/components/VehicleCard.jsx`: vehicle details and purchase/admin controls.
- `frontend/src/components/VehicleDialog.jsx`: accessible native modal forms and delete confirmation.

SQLite has `users` and `vehicles` tables. Password hashes stay in `users`. The UI never receives password hashes. The session JWT stays in React memory, so refresh signs the user out; it is not persisted in localStorage. Tokens expire after 30 minutes, and API 401 responses return the interface to login.

The Vite development proxy forwards `/api` to the backend, so no permissive CORS middleware is required. For production hosting, configure a reverse proxy for `/api`; the Vite development proxy does not exist in the built static files.

## Run tests and checks

From `backend`:

```powershell
.\.venv\Scripts\python.exe -m pytest tests -v --cov=app --cov-branch --cov-report=term-missing --cov-report=html:../docs/backend-coverage --junitxml=../docs/backend-tests.xml
```

From `frontend`:

```powershell
npm.cmd test
npm.cmd run test:coverage
npm.cmd run lint
npm.cmd run build
```

See **[TEST_REPORT.md](TEST_REPORT.md)** for the package's measured results and environment. HTML coverage reports, JUnit XML, raw output, and browser smoke-check results are included in `docs/`. Coverage is evidence of exercised code, not a guarantee that the application has no defects.

A non-blocking Starlette warning may state that httpx-based TestClient is deprecated. The tested httpx setup is retained for compatibility with the guided project; do not silently suppress the warning or change dependencies without rerunning tests.

## Continue in your existing repository

This ZIP contains source files, not a replacement Git history. Keep your existing `.git`, `backend/.env`, `backend/dealership.db`, and original **PROMPTS.md**. Back up the folder before copying changes. Copy the new source/configuration/test files into your working repository, install dependencies, rerun tests, and commit the integration as work done now. Do not delete earlier tests simply to make a count match.

Example honest integration commit (from the repository root after checking `git diff`):

```powershell
git add backend/app backend/tests backend/requirements.txt backend/init_env.py backend/.env.example backend/pytest.ini frontend docs README.md TEST_REPORT.md SETUP.cmd START_BACKEND.cmd START_FRONTEND.cmd .gitignore
git commit -m "feat: integrate complete dealership interface and verification" -m "Used ChatGPT to generate and test the full interface, extend backend checks, and prepare documentation. Reviewed the resulting changes and ran local checks." -m "Co-authored-by: ChatGPT <AI@users.noreply.github.com>"
```

Use the example only after actually reviewing and running the checks. Do not claim manual review you have not performed.

The earlier guided Red/Green commits remain your TDD evidence. Tests for this packaged version were written before its implementation; the included initial failure logs are import/collection failures, not separate feature-by-feature Red commits. No fabricated Git commits or dates are included. New completed code should be committed truthfully as completed code, not represented as a historical TDD sequence.

## My AI Usage

**Tool:** ChatGPT.

**How it was used:** ChatGPT helped plan the API, guide Windows setup, write tests and backend functions, diagnose indentation and routing errors, design the React/Tailwind interface, implement authentication and inventory interactions, and create this complete package and its documentation. A substantial portion of the code and tests was AI-generated. The candidate ran the earlier guided commands and tests locally and supplied their results. The packaged implementation was also checked in a separate execution environment; its results are distinguished in TEST_REPORT.md.

**Impact and reflection:** AI accelerated scaffolding, test-case design, debugging, and integration. It also required checking its suggestions: a generated file can be unsaved, a passing 404 test can pass for the wrong reason, coverage can omit new code, and a batch of finished code does not establish an authentic historical TDD sequence. The candidate remains responsible for reviewing the implementation, verifying it on their machine, explaining the design, and describing which parts they changed themselves. Personalize this reflection truthfully before submission.

**Co-authorship:** Include `Co-authored-by: ChatGPT <AI@users.noreply.github.com>` on every AI-assisted commit, including test/debug/documentation changes.

**Raw records:** Preserve the original conversation in root `PROMPTS.md`, or add a genuine public conversation link. The packaged PROMPTS.md contains only a small verbatim record from this packaging request and explicitly marks the missing earlier record. It is not a substitute for the full raw chat required by the assignment.

## Submission checklist

- [ ] Review the code and explain authentication, permissions, SQL transactions, price storage, and React state.
- [ ] Run backend/frontend checks on your Windows machine.
- [ ] Preserve your genuine Red/Green Git history and add AI co-author trailers to new commits.
- [ ] Complete root PROMPTS.md with full unedited logs or a real public chat link.
- [ ] Personalize My AI Usage accurately.
- [ ] Create a public GitHub/GitLab repository and push the existing local repository.
- [ ] Verify `.env`, databases, passwords, and tokens are not tracked.
- [ ] Include README, screenshots, and test report; confirm image links render on GitHub.
- [ ] Submit the actual public repository URL. This package does not create or publish a repository for you.

A hosted live application is optional and has not been deployed by this package.
