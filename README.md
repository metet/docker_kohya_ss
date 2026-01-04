# Docker setup to run Kohya-ss with GeForce 5080

This repository contains a Dockerized setup for running **Kohya-ss** with PyTorch + CUDA 13.0 support.

---

## Requirements

- Docker >= 23.x
- Docker Compose
- NVIDIA Container Toolkit (`nvidia-docker2`)
- NVIDIA drivers on the host
- Linux x86_64 (for CUDA wheels)

---

## Clone the Repository

```bash
git clone https://github.com/metet/docker_kohya_ss.git
cd docker_kohya_ss
```

---

## Getting Started

### 1. Start the container

```bash
docker compose up
```

* This will build the image (first time only) and start the container
* The build installs all dependencies from `pyproject.toml` and `uv.lock`
* The Kohya-ss GUI will be available at `http://localhost:7860`

### 2. Stop the container

```bash
docker compose down
```

Or press `CTRL+C` if running in the foreground.

---

## Configuration

The `docker-compose.yaml` includes:

* **GPU Access**: `runtime: nvidia` with all GPUs exposed
* **CUDA Architecture**: `TORCH_CUDA_ARCH_LIST=9.0` targets RTX 5080 / Blackwell GPUs
* **Shared Memory**: `shm_size: 2gb` prevents CUDA crashes
* **Port Mapping**: Port 7860 for web UI
* **Volume Mounts**:
  * `./models` → Model storage
  * `./dataset/source` → Source datasets
  * `./dataset/images`, `./dataset/logs`, `./dataset/outputs` → Training data
  * `./.cache` → Performance caching

---

## License

See [LICENSE](LICENSE) file for details. 






