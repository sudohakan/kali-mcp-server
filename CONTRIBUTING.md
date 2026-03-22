# Contributing to kali-mcp

Thank you for improving kali-mcp. This guide covers the Docker build workflow, how to add new Kali tools, and the contribution process.

## Prerequisites

| Requirement | Version | Notes |
|------------|---------|-------|
| Docker | 24+ | With Compose v2 (`docker compose`) |
| Python | 3.10+ | For running tests outside Docker |
| uv | latest | Dependency management (`pip install uv`) |

## Development Setup

### 1. Clone and build

```bash
git clone https://github.com/sudohakan/kali-mcp.git
cd kali-mcp

# Build the Docker image (first build pulls the Kali base — ~1 GB)
docker compose build

# Start the server
docker compose up
```

The MCP server listens on `http://localhost:8000/sse`.

### 2. Run tests

```bash
# Inside Docker (recommended — tools must be present)
docker compose run --rm kali-mcp-server python -m pytest tests/ -v

# Outside Docker (Python-only unit tests, no Kali tools needed)
uv sync
uv run pytest tests/ -v -k "not integration"
```

### 3. Check code style

```bash
uv run black --check .
uv run flake8 .
```

## Adding a New Kali Tool

### Step 1 — Install the tool in the Dockerfile

Open `Dockerfile` and add the package to the `apt-get install` block:

```dockerfile
RUN apt-get install -y \
    nmap \
    your-new-tool \
    ...
```

### Step 2 — Implement the MCP tool handler

Add a new function in `kali_mcp_server/` (or `main.py` for simpler tools):

```python
@mcp.tool()
async def your_tool_name(target: str, options: str = "") -> str:
    """
    Brief description visible to the AI agent.

    Args:
        target: IP address, hostname, or URL to operate on
        options: Additional flags passed to the underlying tool
    """
    cmd = ["your-tool", target] + options.split()
    return await run_command(cmd)
```

### Step 3 — Add tests

Create `tests/test_your_tool.py`:

```python
import pytest
from unittest.mock import patch, AsyncMock

async def test_your_tool_basic():
    with patch("kali_mcp_server.run_command", new_callable=AsyncMock) as mock_run:
        mock_run.return_value = "tool output"
        result = await your_tool_name("192.168.1.1")
        assert "tool output" in result
```

### Step 4 — Verify the build

```bash
docker compose build --no-cache
docker compose run --rm kali-mcp-server your-tool --version
```

### Step 5 — Update documentation

- Add the tool to the **Features** table in `README.md`
- Add an entry to `CHANGELOG.md` under `### Added`

## Project Structure

```
kali-mcp/
├── kali_mcp_server/       # MCP tool handlers
├── main.py                # Entry point, server setup
├── tests/                 # Pytest test suite
├── sessions/              # Runtime: session output storage (gitignored)
├── Dockerfile             # Kali Linux base image + tool installation
├── docker-compose.yml     # Compose definition
├── pyproject.toml         # Python project metadata + dependencies
└── requirements.txt       # Pip-compatible requirements
```

## Commit Style

Use conventional commits:

```
feat: add nikto web scanner tool
fix: handle nmap timeout on unreachable hosts
docs: add tool usage examples to README
chore: update kali base image to 2025.1
```

## Pull Request Process

1. Fork the repository and create a branch: `feat/your-tool-name`
2. Make changes — keep PRs focused on one tool or fix
3. Ensure `docker compose build` succeeds
4. Ensure tests pass
5. Open a PR with a clear description of what the tool does and what targets it is designed for
6. PRs that add offensive tools must include a note on authorized use in the description

## Code of Conduct

This project follows the [Contributor Covenant v2.1](CODE_OF_CONDUCT.md). Please read it before contributing.

## Security Issues

Do **not** open public issues for security vulnerabilities. See [SECURITY.md](SECURITY.md).
