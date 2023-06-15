#!/usr/bin/env bash

TOKEN=${GITHUB_TOKEN:?"required environment variable is not set"}
ORG=${GITHUB_ORG:?"required environment variable is not set"}

curl -s -H "Authorization: token ${TOKEN}" "https://api.github.com/orgs/${ORG}/repos?per_page=100" \
  | jq -r '.[].name' \
  | sort \
  | while read repo; do
    echo -n "${repo}: "
    curl -s -H "Authorization: token ${TOKEN}" "https://api.github.com/repos/${ORG}/${repo}/collaborators" \
      | jq -r '[.[] | select(.role_name == "admin" or .role_name == "maintain") | .login] | sort | join(", ")'
  done
