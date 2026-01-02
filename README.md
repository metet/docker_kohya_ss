
# Docker setup to run Kohya-ss with Geforce 5080

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
````

* This will install all dependencies defined in `pyproject.toml` and `uv.lock`
* The `.venv` is created inside the image, so no host setup is required
* This may take a few minutes on first build

---

### 2. Run the container (first time)

```bash
docker run -it --rm \
  --gpus all \
  -p 7860:7860 \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v ./models:/app/models \
  -v ./dataset/source:/dataset \
  -v ./dataset/images:/app/data \
  -v ./dataset/logs:/app/logs \
  -v ./dataset/outputs:/app/outputs \
  -v ./dataset/regularization:/app/regularization \
  ai-tool
```

* The `--gpus all` flag exposes all NVIDIA GPUs to the container
* Replace `/dataset` and `/models` paths if needed
* This will launch **Kohya-ss GUI** at `http://0.0.0.0:7860`

---

### 3. Stop the container

If running in the foreground, press `CTRL+C` to stop.
If running detached:

```bash
docker ps         # find container ID
docker stop <id>
```

---

### 4. Run the container in the future

```bash
docker run -it --rm \
  --gpus all \
  -p 7860:7860 \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v ./models:/app/models \
  -v ./dataset/source:/dataset \
  -v ./dataset/images:/app/data \
  -v ./dataset/logs:/app/logs \
  -v ./dataset/outputs:/app/outputs \
  -v ./dataset/regularization:/app/regularization \
  ai-tool
```

> Since dependencies are already built in the image, this will be much faster than the first build.

---

## Notes

* The Dockerfile uses **multi-stage build**:

  * Builder stage installs dependencies via `uv` and lockfile
  * Runtime stage copies `.venv` and the app, resulting in a smaller image
* GPU support requires NVIDIA drivers on the host
* `TORCH_CUDA_ARCH_LIST=9.0` targets RTX 5080 / Blackwell GPUs
* Logs and cache are mounted to `.cache` folders for performance

---

## Optional: Docker Compose

If using Docker Compose:

```bash
docker compose up
docker compose down
```

Ensure `docker-compose.yaml` has proper GPU access (`runtime: nvidia` or `--gpus all`).

---

## License

MIT / your choice

````

---

# Step 5: Add, commit, and push README

```bash
git add README.md
git commit -m "Add README with Docker instructions"
git push origin main
````

---

# ✅ Summary

* Initialize Git locally
* Create GitHub repo and link remote
* Add `README.md` with:

  * Build instructions
  * Run / stop instructions
  * Notes about GPU and caching
* Push everything to GitHub

---

If you want, I can also **write a minimal `.github/workflows/docker-build.yml`** so GitHub automatically builds the Docker image on each push — this is great for CI/CD.

Do you want me to do that?


