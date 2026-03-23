<div align="center">

# 🔐 Kali MCP Server

**AI-assisted penetration testing with 48 security tools in a Docker container.**

[![Version](https://img.shields.io/badge/version-1.1.0-blue?style=flat-square)](CHANGELOG.md)
[![Python](https://img.shields.io/badge/python-3.12%2B-brightgreen?style=flat-square)](https://python.org)
[![Docker](https://img.shields.io/badge/docker-required-blue?style=flat-square)](https://docker.com)
[![License](https://img.shields.io/badge/license-MIT-green?style=flat-square)](LICENSE)
[![CI](https://img.shields.io/github/actions/workflow/status/sudohakan/kali-mcp-server/ci.yml?style=flat-square&label=CI)](https://github.com/sudohakan/kali-mcp-server/actions)
[![Stars](https://img.shields.io/github/stars/sudohakan/kali-mcp-server?style=flat-square)](https://github.com/sudohakan/kali-mcp-server/stargazers)

[Quick Start](#-quick-start) · [Features](#-features) · [Tools](#-tool-categories) · [Architecture](#-architecture) · [Contributing](#-contributing)

</div>

---

## What is this?

A Docker-containerized MCP server running on Kali Linux that gives AI assistants access to 35 security and penetration testing tools. Communicate via SSE on port 8000 and let Claude run nmap scans, enumerate subdomains, test SSL/TLS, crack hashes, and generate payloads through natural language.

---

## ✨ Features

| Feature | Details |
|:--------|:--------|
| **48 security tools** | Network scanning, web testing, credential attacks, exploitation, encoding |
| **Session management** | Create, switch, track sessions with full command history |
| **Evidence collection** | Save outputs, generate reports (Markdown/JSON/text) |
| **Credential store** | Per-session credential tracking for discovered creds |
| **Output parsing** | Structured JSON from nmap, nikto, gobuster, hydra, sqlmap |
| **Payload generation** | Msfvenom payloads + one-liner reverse shells (8 languages) |
| **Auto recon** | Multi-stage reconnaissance pipeline with depth levels |
| **Docker isolation** | All tools run inside a container — no host pollution |

---

## 🚀 Quick Start

**1. Clone and build**

```bash
git clone https://github.com/sudohakan/kali-mcp-server.git
cd kali-mcp-server
docker compose up --build -d
```

**2. Configure Claude Code**

Add to `.claude.json`:

```json
{
  "mcpServers": {
    "kali-mcp": {
      "type": "sse",
      "url": "http://localhost:8000/sse"
    }
  }
}
```

**3. Use it**

Ask Claude: *"Scan 192.168.1.0/24 for open ports"* or *"Check SSL configuration of example.com"*

---

## 🛠️ Tool Categories

<details>
<summary><strong>Reconnaissance & Scanning (5 tools)</strong></summary>

| Tool | Description |
|------|-------------|
| `port_scan` | Smart nmap wrapper with presets |
| `dns_enum` | DNS enumeration with zone transfers |
| `network_discovery` | Multi-stage network reconnaissance |
| `subdomain_enum` | Subdomain enumeration (subfinder, amass) |
| `recon_auto` | Automated multi-stage pipeline |

</details>

<details>
<summary><strong>Web Application Testing (7 tools)</strong></summary>

| Tool | Description |
|------|-------------|
| `vulnerability_scan` | Automated vulnerability assessment |
| `web_enumeration` | Application discovery and enumeration |
| `web_audit` | Comprehensive security audit |
| `spider_website` | Web crawling with gospider |
| `form_analysis` | Discover and analyze forms |
| `header_analysis` | HTTP header security assessment |
| `ssl_analysis` | SSL/TLS security via testssl.sh |

</details>

<details>
<summary><strong>Credential & Brute-Force (2 tools)</strong></summary>

| Tool | Description |
|------|-------------|
| `hydra_attack` | Brute-force (SSH, FTP, HTTP, SMB, MySQL, RDP) |
| `credential_store` | Store/retrieve discovered credentials |

</details>

<details>
<summary><strong>Payload & Exploit (3 tools)</strong></summary>

| Tool | Description |
|------|-------------|
| `payload_generate` | Msfvenom payloads (reverse/bind/meterpreter) |
| `reverse_shell` | One-liner generators (bash, python, php, perl, nc, ruby, java, powershell) |
| `exploit_search` | Searchsploit-powered exploit discovery |

</details>

<details>
<summary><strong>Encoding, Parsing & Evidence (10 tools)</strong></summary>

| Tool | Description |
|------|-------------|
| `encode_decode` | Base64, URL, hex, HTML, ROT13 |
| `hash_identify` | Hash type identification |
| `parse_nmap` | Structured JSON from nmap output |
| `parse_tool_output` | Parse nikto, gobuster, dirb, hydra, sqlmap |
| `save_output` | Timestamped evidence storage |
| `create_report` | Generate Markdown/JSON/text reports |
| `file_analysis` | Type detection, strings, hashes, metadata |
| `download_file` | Download with hash verification |
| `enum_shares` | SMB/NFS share enumeration |
| `run` | Execute any shell command in Kali |

</details>

<details>
<summary><strong>Session Management (6 tools)</strong></summary>

| Tool | Description |
|------|-------------|
| `session_create` | Create new pentest session |
| `session_list` | List all sessions |
| `session_switch` | Switch between sessions |
| `session_status` | Current session status |
| `session_delete` | Delete session and evidence |
| `session_history` | Command history |

</details>

---

## 🏗️ Architecture

```
┌──────────────┐     SSE/HTTP      ┌─────────────────────────────┐
│  Claude Code │ ◄──────────────► │  Kali MCP Server (Docker)   │
│  or any MCP  │    port 8000     │                             │
│  client      │                  │  nmap, sqlmap, hydra        │
└──────────────┘                  │  metasploit, nikto, amass   │
                                  │  subfinder, testssl         │
                                  │  hashcat, gobuster, ffuf    │
                                  │  Session & Evidence mgmt   │
                                  └─────────────────────────────┘
```

---

## 📁 Project Structure

```
kali-mcp-server/
├── kali_mcp_server/
│   ├── __init__.py
│   ├── server.py          # MCP server setup
│   ├── tools.py           # 35 tool implementations
│   └── utils.py           # Shared utilities
├── sessions/              # Pentest session data
├── tests/
│   ├── test_server.py
│   └── test_tools.py
├── Dockerfile             # Kali Linux image
├── docker-compose.yml
├── pyproject.toml
└── README.md
```

---

## 🤝 Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for Docker build workflow, how to add new tools, and PR process.

---

## 📄 License

[MIT](LICENSE) — Copyright 2026 Hakan Topcu

> **Disclaimer:** For authorized security testing only. Always obtain proper authorization before testing systems you do not own.
