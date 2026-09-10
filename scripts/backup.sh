#!/usr/bin/env bash
# Dumps the tripare_bookings database from the running container into
# backups/, with a timestamp in the filename so nothing gets overwritten.
set -euo pipefail

container_name="tripare_bookings_db"
db_name="tripare_bookings"
db_user="booking_admin"

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
backup_dir="${project_root}/backups"
mkdir -p "$backup_dir"

run_stamp="$(date +"%Y%m%d_%H%M%S")"
dump_path="${backup_dir}/tripare_bookings_${run_stamp}.sql.gz"

if ! docker ps --format '{{.Names}}' | grep -qx "$container_name"; then
    echo "Container '$container_name' isn't running. Start it with 'docker compose up -d' first." >&2
    exit 1
fi

echo "Dumping '$db_name' from '$container_name'..."
docker exec -t "$container_name" pg_dump -U "$db_user" -d "$db_name" | gzip > "$dump_path"

dump_size="$(du -h "$dump_path" | cut -f1)"
echo "Done. Wrote $dump_size to $dump_path"
