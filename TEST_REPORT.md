# Test report — complete packaged version

Executed on 25 October 2026 in the packaging environment: Linux, Python 3.12.14, Node 24.22.1, FastAPI 0.162.0, Vite 8.3.5, Vitest 5.0.5. These are newly executed results for this ZIP, distinct from the earlier 65-test Windows suite reported in the guided conversation. Run this full suite on your own Windows/Python 3.13 machine before submission.

| Check | Result | Evidence |
|---|---|---|
| Backend pytest | **87 passed** | `docs/backend-test-output.txt`, `docs/backend-tests.xml` |
| Backend combined statement/branch coverage | **98%** | `docs/backend-coverage/index.html` |
| Frontend Vitest | **20 passed** | `docs/frontend-test-output.txt`, `docs/frontend-tests.xml` |
| Frontend statement coverage | **83.75%** | `docs/frontend-coverage/index.html` |
| Frontend branch coverage | **88.63%** | Same report |
| Frontend line coverage | **83.78%** | Same report |
| ESLint | **Passed, no errors** | `docs/frontend-lint-output.txt` |
| Vite production build | **Passed** | `docs/frontend-build-output.txt` |
| Chromium browser smoke checks | **12 passed** | `docs/browser-smoke-report.json` and screenshots |

## Backend behavior exercised

- Registration, public response fields, Argon2 password verification, stored hashes, duplicate emails including case variations, invalid input, and prevention of role injection.
- JWT signature, expiry, issue time, required claims, subject validation, missing accounts, missing authentication, and current-user profile.
- Protected vehicle creation/listing, disk persistence across app instances, field validation, exact case-insensitive search, combined/inclusive price filters, and invalid ranges.
- Updates preserve vehicle IDs; rejected updates preserve stored data.
- Purchase quantities, stock exhaustion, oversell prevention, and four concurrent requests competing for two units (exactly two succeed).
- Admin-only restock and deletion, denied customer access, missing vehicles, and a maximum-stock conflict.
- Local admin CLI success/failure, idempotent promotion preserving the account, and optional sample seeding without overwriting inventory.

Uncovered backend statements include the module-entry guards for CLI execution and the compatibility-only schema import. See the HTML report for exact lines rather than inferring complete coverage from a rounded percentage.

## Frontend behavior exercised

Login rendering, registration mode, registration success, login failure, authenticated inventory, sign-out, disabled sold-out purchase, bearer-authenticated purchase, server-side search, admin add/edit/restock, delete confirmation, expired-session handling, empty state, invalid price range, connection errors, request cancellation, malformed server responses, and API validation errors.

Frontend unit tests mock HTTP responses. The separate live Chromium checks used the actual FastAPI/SQLite server through Vite's proxy, rather than mocked responses.

## Live browser checks

1. Login screen renders.
2. Administrator signs in and fetches real inventory.
3. Administrator creates a vehicle through UI and API.
4. Administrator updates it.
5. Administrator restocks it.
6. Administrator deletes it after confirmation.
7. Search filters the server inventory.
8. Sold-out vehicle Purchase is disabled.
9. Customer cannot see admin controls.
10. Customer purchase changes persisted quantity.
11. Mobile dashboard has no horizontal overflow at 390px width.
12. No uncaught browser JavaScript errors occur during the checked workflows.

Screenshots use synthetic inventory and synthetic display accounts. Database files and credentials from these checks are not included in the ZIP. Vehicle artwork is a Lucide icon, not a photograph of the actual vehicle.

## TDD and provenance

The earlier step-by-step local repository has the user's real Red/Green commits. Preserve that history. For this packaging turn, the supplied backend and frontend test files were initially run before source modules existed; their initial import/collection failures are retained in `docs/packaging-red-backend.txt` and `docs/packaging-red-frontend.txt`. They are not feature-by-feature failing assertion evidence or a replacement for genuine TDD commits. Additional coverage tests were added after the initial implementations and are regression tests. No history was synthesized inside this ZIP.

## Warnings and limits

- One non-blocking Starlette warning reports deprecated httpx-based TestClient support; tests pass with the recorded dependencies.
- npm emits an environment-specific proxy configuration warning in the packaging environment. This is not an application build failure.
- No deployment, real payment processing, security penetration test, or load test is claimed.
- The dev proxy is for local development. A deployed frontend needs a reverse proxy to the backend and durable database storage.
- Windows setup scripts are provided but were not executed on Windows in this packaging environment. The user must verify them locally.
- Coverage and passing tests do not guarantee defect-free software.

Regenerate the reports using the commands in README.md after making changes.
