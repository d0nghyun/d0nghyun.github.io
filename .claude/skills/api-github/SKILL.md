---
name: api-github
description: "GitHub REST API for issues, PRs, repos. Uses PAT."
allowed-tools: Bash, Read, Grep
user-invocable: true
---
# GitHub API Skill

## Authentication

```bash
CRED_FILE="${DHLEE_BRAIN_CREDENTIALS:?set DHLEE_BRAIN_CREDENTIALS to your dhlee-brain/.credentials dir}/github.json"
GITHUB_TOKEN=$(jq -r '.personal_access_token' "$CRED_FILE")
```

Create token at: https://github.com/settings/tokens (scopes: `repo`, `workflow`)

## Headers

```bash
-H "Authorization: Bearer $GITHUB_TOKEN"
-H "X-GitHub-Api-Version: 2022-11-28"
```

## Common Operations

### Get User
```bash
curl -s -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/user
```

### List Issues
```bash
curl -s -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/repos/{owner}/{repo}/issues?state=open"
```

### Create Issue
```bash
curl -s -X POST -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" -H "Content-Type: application/json" \
  -d '{"title":"Title","body":"Body","labels":["bug"]}' \
  https://api.github.com/repos/{owner}/{repo}/issues
```

### Get PR
```bash
curl -s -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/{owner}/{repo}/pulls/{pr_number}
```

### Create PR
```bash
curl -s -X POST -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" -H "Content-Type: application/json" \
  -d '{"title":"PR title","body":"Body","head":"feature","base":"main"}' \
  https://api.github.com/repos/{owner}/{repo}/pulls
```

## Rate Limits

Authenticated: 5,000 req/hour. Check `X-RateLimit-Remaining` header.

## Errors

| Status | Action |
|--------|--------|
| 401 | Check PAT |
| 403 | Rate limit or insufficient scope |
| 404 | Repo not found or no access |
