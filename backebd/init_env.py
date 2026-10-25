"""Generate a local signing key without printing or committing it."""

from pathlib import Path
import secrets

path = Path(__file__).resolve().parent / ".env"
if path.exists() and "JWT_SECRET=" in path.read_text():
    print("Existing JWT_SECRET preserved.")
else:
    with path.open("a") as output:
        output.write("\nJWT_SECRET=" + secrets.token_hex(32) + "\n")
    print("Created local JWT_SECRET in backend/.env.")
