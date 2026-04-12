<div align="center">

<img src="https://img.shields.io/badge/Kali%20MCP-Security%20Testing%20Platform-critical?style=for-the-badge&logo=kalilinux&logoColor=white" alt="Kali MCP" />

# Kali MCP Server

**AI-powered penetration testing through 36 MCP tools on a containerized Kali Linux**

Reconnaissance · Web Testing · Exploitation · Session Management · Evidence Collection

[![Version](https://img.shields.io/badge/version-1.1.0-blue?style=flat-square)](CHANGELOG.md)
[![Python](https://img.shields.io/badge/python-3.10%2B-brightgreen?style=flat-square)](https://python.org)
[![Docker](https://img.shields.io/badge/docker-required-blue?style=flat-square)](https://docker.com)
[![License](https://img.shields.io/badge/license-MIT-green?style=flat-square)](LICENSE)
[![CI](https://img.shields.io/github/actions/workflow/status/sudohakan/kali-mcp-server/ci.yml?style=flat-square&label=CI)](https://github.com/sudohakan/kali-mcp-server/actions)
[![Stars](https://img.shields.io/github/stars/sudohakan/kali-mcp-server?style=flat-square)](https://github.com/sudohakan/kali-mcp-server/stargazers)

[Quick Start](#quick-start) · [Tools](#tools) · [Architecture](#architecture) · [Contributing](#contributing)

</div>

---

## Why Kali MCP?

Most security tools require manual operation, context switching, and output parsing. Kali MCP gives AI assistants direct access to **36 security tools** inside a Docker-containerized Kali Linux. Communicate via SSE or stdio, and let Claude run nmap scans, enumerate subdomains, crack hashes, generate payloads, and produce structured reports through natural language.

| What you get | Details |
|:---|:---|
| **36 MCP tools** | Network scanning, web testing, credential attacks, exploitation, encoding, evidence collection |
| **50+ underlying binaries** | nmap, sqlmap, hydra, metasploit, nuclei, ffuf, amass, subfinder, hashcat, and more |
| **Session management** | Create, switch, and track pentest sessions with full command history |
| **Evidence pipeline** | Save outputs, generate reports (Markdown/JSON/text), structured output parsing |
| **Credential store** | Per-session credential tracking for discovered creds |
| **Payload generation** | Msfvenom payloads + reverse shell one-liners in 8 languages |
| **Auto recon** | Multi-stage reconnaissance pipeline with configurable depth |
| **Docker isolation** | All tools run inside a container with no host filesystem access |

---

## Quick Start

**1. Clone and build**

```bash
git clone https://github.com/sudohakan/kali-mcp-server.git
cd kali-mcp-server
docker compose up --build -d
```

**2. Configure your MCP client**

<details open>
<summary><strong>Claude Code (SSE)</strong></summary>

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

</details>

<details>
<summary><strong>Claude Code (stdio)</strong></summary>

```bash
claude mcp add kali-mcp -- docker exec -i kali-mcp-server python -m kali_mcp_server.server --transport stdio
```

</details>

**3. Use it**

Ask Claude: *"Scan 192.168.1.0/24 for open ports"* or *"Run a deep recon on example.com"*

---

## Tools

### Reconnaissance and Scanning (6 tools)

| Tool | Description |
|:-----|:------------|
| `port_scan` | Smart nmap wrapper with presets (quick, full, stealth, udp, service, aggressive) |
| `dns_enum` | Comprehensive DNS enumeration with zone transfer attempts |
| `network_discovery` | Multi-stage network reconnaissance (quick, comprehensive, stealth) |
| `subdomain_enum` | Subdomain enumeration via subfinder, amass |
| `recon_auto` | Automated multi-stage pipeline (DNS, ports, headers, SSL, exploits) |
| `enum_shares` | SMB/NFS share enumeration (smbclient, enum4linux, showmount) |

### Web Application Testing (7 tools)

| Tool | Description |
|:-----|:------------|
| `vulnerability_scan` | Automated vulnerability assessment (quick, comprehensive, web, network) |
| `web_enumeration` | Application discovery and directory enumeration |
| `web_audit` | Comprehensive web application security audit |
| `spider_website` | Web crawling with configurable depth and threads |
| `form_analysis` | Discover and analyze web forms for vulnerabilities |
| `header_analysis` | HTTP header security assessment |
| `ssl_analysis` | SSL/TLS configuration analysis via testssl.sh |

### Credential and Brute-Force (2 tools)

| Tool | Description |
|:-----|:------------|
| `hydra_attack` | Brute-force testing (SSH, FTP, HTTP, SMB, MySQL, RDP, and more) |
| `credential_store` | Store, retrieve, and search discovered credentials per session |

### Exploitation (3 tools)

| Tool | Description |
|:-----|:------------|
| `payload_generate` | Msfvenom payloads (reverse shell, bind shell, meterpreter) for 5 platforms |
| `reverse_shell` | One-liner generators (bash, python, php, perl, nc, ruby, java, powershell) |
| `exploit_search` | Searchsploit-powered exploit database search |

### Encoding and Analysis (4 tools)

| Tool | Description |
|:-----|:------------|
| `encode_decode` | Multi-format encoding/decoding (base64, URL, hex, HTML, ROT13) |
| `hash_identify` | Hash type identification (MD5, SHA, bcrypt, NTLM, and more) |
| `file_analysis` | File type detection, strings extraction, hash computation |
| `fetch` | Fetch website content for analysis |

### Output Parsing and Evidence (5 tools)

| Tool | Description |
|:-----|:------------|
| `parse_nmap` | Parse nmap output (text/XML) into structured JSON |
| `parse_tool_output` | Parse nikto, gobuster, dirb, hydra, sqlmap output |
| `save_output` | Timestamped evidence storage with categories |
| `create_report` | Generate structured reports (Markdown, JSON, text) |
| `download_file` | Download files with local storage |

### Session Management (7 tools)

| Tool | Description |
|:-----|:------------|
| `session_create` | Create new pentest session with name, description, target |
| `session_list` | List all sessions with metadata |
| `session_switch` | Switch between active sessions |
| `session_status` | Current session status and summary |
| `session_delete` | Delete session and all associated evidence |
| `session_history` | Command and evidence history for active session |
| `session_results` | Read recent output files for active session |

### System (2 tools)

| Tool | Description |
|:-----|:------------|
| `run` | Execute any shell command on the Kali Linux container |
| `resources` | List available system resources and command examples |

---

## Architecture

```
                              Docker Container (Kali Linux)
                             ┌─────────────────────────────────┐
┌──────────────┐  SSE/stdio  │  MCP Server (Python)            │
│  Claude Code ├────────────►│  ├── Tool Router (server.py)    │
│  or any MCP  │  port 8000  │  ├── 36 Tool Handlers (tools.py)│
│  client      │◄────────────┤  └── Session Manager            │
└──────────────┘             │                                 │
                             │  Underlying Binaries            │
                             │  nmap, sqlmap, hydra, nikto     │
                             │  metasploit, amass, subfinder   │
                             │  nuclei, ffuf, feroxbuster      │
                             │  hashcat, john, gobuster        │
                             │  testssl.sh, gospider, masscan  │
                             │  crackmapexec, impacket, ...    │
                             └─────────────────────────────────┘
```

**Transport options:**
- **SSE (default):** HTTP server on port 8000, ideal for Claude Desktop and persistent connections
- **stdio:** Standard I/O, ideal for Claude Code CLI integration

**Session data** is persisted via Docker volume mount (`./sessions:/app/sessions`).

---

## Project Structure

```
kali-mcp-server/
├── kali_mcp_server/
│   ├── server.py          # MCP server, tool registration, transport config
│   ├── tools.py           # 36 tool implementations
│   └── utils.py           # Shared utilities
├── tests/
│   ├── test_server.py     # Server integration tests
│   └── test_tools.py      # Tool unit tests
├── Dockerfile             # 5-layer Kali Linux image (apt, Go, pip, exploits, app)
├── docker-compose.yml     # Production compose with volume mounts
├── pyproject.toml         # Python project config (hatch build)
└── requirements.txt       # Python dependencies
```

---

## Docker Image Layers

The Dockerfile builds in 5 stages for optimal caching:

| Layer | Contents |
|:------|:---------|
| **1. System + apt tools** | nmap, sqlmap, hydra, nikto, metasploit, amass, subfinder, nuclei, ffuf, hashcat, john, crackmapexec, impacket, aircrack-ng, bettercap, tcpdump, tshark, seclists |
| **2. Go tools** | katana, gau, grpcurl, dalfox, waybackurls, kerbrute, chisel |
| **3. Python tools** | impacket, certipy-ad, frida-tools, arjun, paramspider, wfuzz, commix, bloodhound |
| **4. Exploit toolkits** | PayloadsAllTheThings, SSTImap, jwt_tool, XSStrike, GraphQLmap, smuggler, NoSQLMap, linpeas, pspy |
| **5. Application** | Virtual environment, MCP server, dev tooling |

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for Docker build workflow, how to add new tools, and the PR process.

---

## License

[MIT](LICENSE) : Copyright 2026 Hakan Topcu

> **Disclaimer:** This tool is intended for authorized security testing only. Always obtain proper written authorization before testing systems you do not own or operate.
