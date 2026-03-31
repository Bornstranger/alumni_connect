FROM python:3.13-slim AS base

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# ---- Build stage ----
FROM base AS builder

COPY --from=ghcr.io/astral-sh/uv:0.9 /uv /uvx /bin/

COPY pyproject.toml uv.lock ./
RUN uv sync --frozen --no-dev --no-install-project

COPY . .
RUN uv sync --frozen --no-dev

RUN uv run python manage.py collectstatic --noinput \
    --settings=config.settings 2>/dev/null || true

# ---- Runtime stage ----
FROM base AS runtime

RUN groupadd --system app \
    && useradd --system --gid app --no-create-home app \
    && mkdir -p /app/logs /app/staticfiles \
    && chown -R app:app /app

COPY --from=builder --chown=app:app /app/.venv /app/.venv
COPY --from=builder --chown=app:app /app/config /app/config
COPY --from=builder --chown=app:app /app/manage.py /app/manage.py
COPY --from=builder --chown=app:app /app/staticfiles /app/staticfiles

ENV PATH="/app/.venv/bin:$PATH"

USER app

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD ["python", "-c", "import urllib.request; urllib.request.urlopen('http://localhost:8000/admin/')"]

CMD ["gunicorn", "config.wsgi:application", \
     "--bind", "0.0.0.0:8000", \
     "--workers", "4", \
     "--worker-tmp-dir", "/dev/shm", \
     "--access-logfile", "-", \
     "--error-logfile", "-"]
