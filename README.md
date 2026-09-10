# devops-assessment

## Terraform

AWS infra lives under `infra/`:

```
infra/
  modules/    # network (vpc + all 3 security groups), ecs (alb + fargate), rds (postgres)
  envs/       # dev and prod, each a standalone root module with its own tfvars + local state
```

### Architecture

```
Internet → ALB (public subnets) → ECS/Fargate service (private subnets) → RDS PostgreSQL (private subnets)
```

- One VPC across 2 AZs.
- Public subnets host only the ALB and the NAT gateway.
- Private subnets host the ECS tasks and the RDS instance.
- Security groups are chained so each tier only accepts traffic from the tier directly in front of it:
  - `alb_sg`: ingress 80/443 from the internet (0.0.0.0/0).
  - `ecs_sg`: ingress on the container port, source = `alb_sg` only.
  - `rds_sg`: ingress on 5432, source = `ecs_sg` only.
- RDS has no public accessibility and no route to the internet. It's reachable only from ECS.

### Module boundaries (`infra/modules/`)

- `network/`: VPC, subnets, NAT gateway, and the three chained security groups (alb → ecs → rds).
- `ecs/`: ALB, target group, Fargate cluster/service/task definition.
- `rds/`: the Postgres instance, private-only, sized entirely through variables.

Each env (`dev`/`prod`) wires these together with its own sizing, via `terraform.tfvars`.

### Environment structure (`infra/envs/`)

Each of `dev/` and `prod/` is a standalone root module: `main.tf` wires the three modules, `variables.tf` declares inputs, `terraform.tfvars` holds the actual values, `backend.tf` sets up local state, `outputs.tf` surfaces the ALB DNS name and RDS endpoint.

### Validating

No real AWS deployment here. Validate from either `infra/envs/dev` or `infra/envs/prod`:

```bash
terraform fmt -check
terraform init
terraform validate
terraform plan -refresh=false
```

## Database

Local PostgreSQL via Docker Compose:

```
docker-compose.yml
db/
  01_schema.sql   # hotel_bookings + booking_events
scripts/
  backup.sh
  restore.sh
```

```bash
docker compose up -d
```

Postgres runs `db/01_schema.sql` on first boot (mounted straight into `/docker-entrypoint-initdb.d`), so a fresh `docker compose up -d` gives you the schema with no extra steps.

### Backup and restore

```bash
./scripts/backup.sh
```

Dumps the running database with `pg_dump`, gzips it, and writes a timestamped file to `backups/` (gitignored, nothing here gets committed).

```bash
./scripts/restore.sh backups/<the-file>.sql.gz
```