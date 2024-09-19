#!/usr/bin/env bash

TOKEN=${GITHUB_TOKEN:?"required environment variable is not set"}
ORG=${GITHUB_ORG:?"required environment variable is not set"}
BASE_DIR=${BASE_DIR:-$(pwd)}
BASE_DIR=$(sed "s|//*|/|g; s|/*$||" <<< $BASE_DIR)

local=$(find "$BASE_DIR" -mindepth 1 -maxdepth 1 -type d ! -name "*.wiki" -exec basename {} \; | sort)
remote=""
page=1
while true; do
  repos=$(curl -s -H "Authorization: token ${TOKEN}" "https://api.github.com/orgs/$ORG/repos?per_page=100&page=${page}" | jq -r '.[].name')
  if [ -n "${repos}" ]; then
    remote="${remote}"$'\n'"${repos}"
    page=$((page + 1))
  else
    break
  fi
done
remote=$(echo "$remote" | sort)
echo "Missing locally"
comm -13 <(echo "$local") <(echo "$remote") | sed "s/^/    /"
echo "Missing in remote"
comm -23 <(echo "$local") <(echo "$remote") | sed "s/^/    /"
