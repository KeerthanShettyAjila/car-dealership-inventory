# Finish the assignment submission

The application source, tests, screenshots, and report are provided. The account-specific submission steps below must be completed by you.

## Preserve your real work

Extract the ZIP separately first. Keep the original repository and its `.git`, `backend/.env`, `backend/dealership.db`, and full `PROMPTS.md`. Copy the new source into the original working tree only after making a backup. Do not overwrite your existing PROMPTS.md with the shortened packaging record.

Run the checks in README.md and inspect `git diff`. Commit the integrated application honestly as work integrated now. Do not create fabricated Red/Green commits for features already finished. Keep existing genuine TDD commits.

Every AI-assisted commit must contain this trailer:

```
Co-authored-by: ChatGPT <AI@users.noreply.github.com>
```

## Finish the raw AI logs

Your task requires root PROMPTS.md with raw, unedited chats or real public chat links. The packaged file is explicitly incomplete for the earlier conversation. Preserve the original messages and append the rest of this conversation, or insert a real public conversation link after checking it for passwords/tokens. A generated summary is not sufficient. Review the My AI Usage section and personalize it accurately.

## Publish your repository

1. Sign into your GitHub account in your browser.
2. Create a **public** repository named `car-dealership-inventory`. When pushing an existing local repository, leave GitHub's initialize README/license/gitignore options unchecked.
3. Open the original repository root in your VS Code terminal.
4. Run `git status` and `git log --oneline` to verify your files and real development history.
5. Run `git remote -v`. If there is no origin, add the exact HTTPS repository URL GitHub gives you:

```powershell
git remote add origin https://github.com/YOUR_USERNAME/car-dealership-inventory.git
git push -u origin main
```

Replace YOUR_USERNAME with your actual account. If origin already exists, verify where it points before changing it; do not blindly overwrite a remote. GitHub may open a browser for authentication.

6. Open the published repository and verify the README, screenshots, test report, co-author trailers, and PROMPTS.md are visible. Check that no `.env`, password/token, local database, or dependency directory is tracked.
7. Submit that real public repository URL. No public repository was created by this ZIP.

A live deployment is optional. Local operation does not imply hosted deployment.
