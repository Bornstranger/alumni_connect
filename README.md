# Alumni Connect

Alumni networking platform for colleges and schools, built with Django REST Framework.

## Tech Stack

- Python 3.13, Django 6.0, Django REST Framework 3.17
- PostgreSQL 17, Docker & Docker Compose
- uv (package manager), ruff (linter/formatter)

## Getting Started

> Make sure [Docker](https://docs.docker.com/get-docker/) and Docker Compose are installed.

**Step 1** -- Copy the environment file:

```bash
cp .env.example .env
```

**Step 2** -- Build and start the containers:

```bash
docker compose up -d --build
```

This brings up two services:
- `db` -- PostgreSQL 17 (port 5432)
- `app` -- Django application (port 8000)

The app container waits for the database health check to pass before starting.

**Step 3** -- Run database migrations:

```bash
docker compose exec app python manage.py migrate
```

**Step 4** -- Create an admin user (optional):

```bash
docker compose exec app python manage.py createsuperuser
```

**Step 5** -- Open in your browser:

- API: http://localhost:8000/api/
- Admin: http://localhost:8000/admin/

### Stopping

```bash
docker compose down       # stop containers
docker compose down -v    # stop and remove database volume
```

### Viewing logs

```bash
docker compose logs -f        # all services
docker compose logs -f app    # app only
```

## Development

This project uses a `Makefile` for common tasks. Run `make help` to see all available commands.

### Quick reference

```bash
make install        # install all dependencies
make check          # run all code quality checks (lint + format + typecheck + Django check)
make test           # run tests with coverage
make ci             # run the full CI pipeline locally (check + test + audit)
make lint-fix       # auto-fix lint issues
make format         # auto-format code
make hooks          # install pre-commit hooks (one-time setup)
```

### Other useful commands

```bash
make run            # start Django dev server
make migrate        # run migrations
make migrations     # create new migrations
make shell          # open Django shell
make audit          # audit dependencies for vulnerabilities
make pre-commit     # run pre-commit on all files
```

### Adding dependencies

```bash
uv add <package>               # runtime
uv add --dev <package>         # dev only
```

After adding dependencies, rebuild the app container:

```bash
make up
```

## Contributing

### Initial setup

Install dependencies and pre-commit hooks (one-time):

```bash
make install
make hooks
```

This enables automatic linting, formatting, and commit message validation on every commit.

### Branch naming

Use the following prefixes:

| Prefix | Purpose | Example |
|---|---|---|
| `feature/` | New functionality | `feature/alumni-profiles` |
| `fix/` | Bug fixes | `fix/login-redirect` |
| `refactor/` | Code improvements | `refactor/serializer-cleanup` |
| `docs/` | Documentation only | `docs/api-usage` |
| `chore/` | Tooling, CI, deps | `chore/upgrade-django` |

### Commit messages

This project uses [Conventional Commits](https://www.conventionalcommits.org/). Commitizen enforces this via a pre-commit hook.

```
<type>(optional scope): description

feat: add alumni search endpoint
fix(auth): handle expired tokens
docs: update setup guide
refactor(models): extract base model mixin
test: add profile API tests
chore(ci): add security audit job
```

Allowed types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`.

### Workflow

1. Create a branch from `main`:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Make your changes and run the full CI pipeline locally:
   ```bash
   make ci
   ```

3. Commit using conventional format. Pre-commit hooks will auto-lint and validate your message.

4. Open a pull request against `main`. CI will run automatically. All checks must pass before merging.

### CI Checks

| Job | Check | Fails if |
|---|---|---|
| **Lint & Format** | Ruff lint rules | Any lint violation is found |
| | Ruff format verification | Any file is not formatted |
| **Type Check** | Mypy strict mode with Django/DRF plugins | Any type error is found |
| **Django Checks** | `manage.py check --fail-level WARNING` | Any Django system warning or error |
| | `manage.py makemigrations --check` | Model changes exist without a migration |
| **Security Audit** | `pip-audit` dependency scan | Any known vulnerability in dependencies |
| | `manage.py check --deploy` | Production deployment warnings (non-blocking) |
| **Test** | Full test suite (parallel) | Any test fails or coverage drops below 30% |

> The **Test** job runs only after Lint, Type Check, and Django Checks pass.
> The **Security Audit** deployment check uses `continue-on-error` so it reports issues without blocking the pipeline.
