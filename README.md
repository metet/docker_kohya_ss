# AI Template Stable

This repository contains a Dockerized setup for running **Kohya-ss** with PyTorch + CUDA 13.0 support.

---

## Requirements

- Docker >= 23.x
- NVIDIA Container Toolkit (`nvidia-docker2`) if using GPU
- Linux x86_64 (for CUDA wheels)
- Optional: Docker Compose for multi-service setups

---

## Getting Started

### 1. Build the Docker image (first time)

```bash
# Enable BuildKit for faster caching
DOCKER_BUILDKIT=1 docker build -t ai-tool .
