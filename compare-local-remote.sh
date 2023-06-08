#!/usr/bin/env bash

TOKEN=${GITHUB_TOKEN:?"required environment variable is not set"}
ORG=${ORG:?"required environment variable is not set"}
BASE_DIR=${BASE_DIR:-$(dirname "$(readlink -f "$0")")}
BASE_DIR=${BASE_DIR%/}

local=$(find $BASE_DIR -mindepth 1 -maxdepth 1 -type d ! -name "*.wiki" -exec basename {} \; | sort)
remote=$(curl -s -H "Authorization: token ${TOKEN}" "https://api.github.com/orgs/$ORG/repos?per_page=100" | jq -r '.[].name' | sort)
echo "Missing locally"
comm -13 <(echo "$local") <(echo "$remote") | sed "s/^/    /"
echo "Missing in remote"
comm -23 <(echo "$local") <(echo "$remote") | sed "s/^/    /"
