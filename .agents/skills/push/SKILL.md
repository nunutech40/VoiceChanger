---
name: push
description: Stages all changes, commits with a descriptive message, and pushes to the remote repository. Use when you need to commit and push code changes to GitHub.
metadata:
  model: models/gemini-3.1-pro-preview
  last_modified: Sat, 09 May 2026 10:27:00 GMT
---

# Git Commit & Push Workflow

## Contents
- [Workflow](#workflow)
- [Examples](#examples)

## Workflow

Follow this sequential workflow when committing and pushing changes.

### Task Progress
- [ ] **Step 1: Stage all changes.** Run `git add -A` to stage all modified, new, and deleted files.
- [ ] **Step 2: Review staged changes.** Run `git status --short` to verify what will be committed. Ensure no unwanted files (e.g., `DerivedData`, `build/`, `.dart_tool/`) are staged.
- [ ] **Step 3: Unstage unwanted files.** If there are files that should not be committed (e.g., `.ios_derived_data/`, build artifacts), run `git restore --staged <file>` to unstage them.
- [ ] **Step 4: Commit with a descriptive message.** Run `git commit -m "type: short description"` using conventional commit format:
  - `feat:` for new features
  - `fix:` for bug fixes
  - `refactor:` for code restructuring
  - `docs:` for documentation changes
  - `chore:` for maintenance tasks
- [ ] **Step 5: Push to remote.** Run `git push origin <branch-name>` (usually `main`).
- [ ] **Step 6: Verify.** Check the output for any errors (e.g., rejected push due to remote changes).

## Examples

### Basic commit and push
```bash
git add -A
git status --short
git commit -m "feat: add user authentication"
git push origin main
```

### Commit with unstaging unwanted files
```bash
git add -A
git restore --staged .ios_derived_data/
git status --short
git commit -m "fix: resolve derived data conflict"
git push origin main
```
