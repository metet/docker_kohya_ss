# --- Stage 1: Build Stage ---
FROM python:3.12-slim AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    build-essential \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*
    
# uv binaries
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

WORKDIR /app

ENV UV_COMPILE_BYTECODE=1
ENV UV_LINK_MODE=copy

# Copy only the dependency files
COPY pyproject.toml uv.lock ./

# Install dependencies using the lockfile generated on host
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-dev --no-install-project

# Copy your actual application code
COPY ./kohya_ss .

# --- Stage 2: Runtime Stage ---
FROM python:3.12-slim

# Copy uv binaries + venv from builder
COPY --from=builder /bin/uv /bin/uvx /bin/
COPY --from=builder /app/.venv /app/.venv

WORKDIR /app

# Copy app code from builder
COPY --from=builder /app /app

# Make shell script executable
RUN chmod +x ./gui-uv.sh

# Install runtime deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgl1 \
    libglib2.0-0 \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Environment setup
ENV PATH="/app/.venv/bin:$PATH" \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    TORCH_CUDA_ARCH_LIST="9.0" \
    CUDA_MODULE_LOADING=LAZY

# Default port for most AI tools
EXPOSE 7860

# Use Bash to launch the shell script, which will then trigger the Python GUI
CMD ["/bin/bash", "/app/gui-uv.sh", "--listen", "0.0.0.0", "--server_port", "7860", "--headless", "--noverify"]

