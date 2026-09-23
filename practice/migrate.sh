#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# load .env into the environment
set -a
source "$SCRIPT_DIR/.env"
set +a

for f in "$SCRIPT_DIR"/migrations/*.sql; do
  echo "Applying $(basename "$f")..."
  docker exec -i postgres psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -v ON_ERROR_STOP=1 < "$f"
done