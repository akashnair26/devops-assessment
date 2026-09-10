#!/usr/bin/env bash
# Restores a .sql.gz backup produced by backup.sh into the running
# Postgres container, wiping whatever is currently in the 'public' schema first.
set -euo pipefail

container_name="tripare_bookings_db"
db_name="tripare_bookings"
db_user="booking_admin"

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
backup_dir="${project_root}/backups"

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <path-to-backup.sql.gz>"
    echo
    echo "Backups available in ${backup_dir}:"
    ls -1t "$backup_dir" 2>/dev/null | sed 's/^/  /' || echo "  (none yet, run backup.sh first)"
    exit 1
fi

requested_file="$1"
if [ -f "$requested_file" ]; then
    dump_path="$requested_file"
elif [ -f "${backup_dir}/${requested_file}" ]; then
    dump_path="${backup_dir}/${requested_file}"
else
    echo "Can't find backup file: $requested_file" >&2
    exit 1
fi

if ! docker ps --format '{{.Names}}' | grep -qx "$container_name"; then
    echo "Container '$container_name' isn't running. Start it with 'docker compose up -d' first." >&2
    exit 1
fi

echo "About to wipe and restore '$db_name' in '$container_name' from:"
echo "  $dump_path"
read -r -p "Type 'yes' to continue: " confirm_answer
if [ "$confirm_answer" != "yes" ]; then
    echo "Cancelled."
    exit 1
fi

echo "Dropping and recreating the public schema..."
docker exec -i "$container_name" psql -U "$db_user" -d "$db_name" \
    -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"

echo "Loading dump..."
gunzip -c "$dump_path" | docker exec -i "$container_name" psql -U "$db_user" -d "$db_name"

echo "Restore finished. Run 'scripts/backup.sh' style row counts (see README) to double-check it landed correctly."
