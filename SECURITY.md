# Security Policy

## Overview

kali-mcp exposes Kali Linux penetration testing tools via the Model Context Protocol (MCP).
This is a **high-privilege tool** — it runs as root inside a Docker container and executes
real offensive security tools (nmap, hydra, sqlmap, etc.) on the host network.

Understanding the security model is mandatory before deployment.

## Security Model

### What this tool does
- Executes network reconnaissance, port scanning, vulnerability scanning, and exploit-search operations
- Runs as root (`user: "0:0"`) inside a Docker container — required for raw socket operations (SYN scans, ARP spoofing, tcpdump)
- Exposes results over an HTTP/SSE interface on port 8000

### Threat surface
| Surface | Risk | Mitigation |
|---------|------|-----------|
| Unauthenticated MCP endpoint | Any process with network access can issue commands | Bind to `127.0.0.1` only; never expose port 8000 publicly |
| Root container | Container escape leads to full host compromise | Keep Docker and the host kernel patched; use `--cap-drop ALL --cap-add NET_RAW` where possible |
| Tool execution | Tools may generate network traffic toward unintended targets | Only point tools at systems you own or have explicit written authorization for |
| Session persistence (`./sessions/`) | Sessions store raw tool output including credentials and scan data | Restrict filesystem permissions; clean sessions after each engagement |

### Network binding
The compose file binds to `0.0.0.0:8000` by default. **Before running in any shared environment**, change this to:

```yaml
ports:
  - "127.0.0.1:8000:8000"
```

## Supported Versions

| Version | Supported |
|---------|-----------|
| 1.x     | Yes       |
| < 1.0   | No        |

## Authorized Use Only

This tool is designed for:
- Penetration testers working under a signed scope of work
- CTF (Capture the Flag) participants on designated challenge infrastructure
- Security researchers on their own systems or dedicated lab environments

**Using this tool against systems you do not own or have explicit written authorization to test is illegal in most jurisdictions.**

## Reporting a Vulnerability

If you discover a security vulnerability in kali-mcp itself (not in the bundled Kali tools):

1. **Do not open a public GitHub issue.**
2. Email **hakantpc@outlook.com.tr** with subject `[kali-mcp] Security Vulnerability`.
3. Include: description, reproduction steps, potential impact, and suggested fix (if any).
4. You will receive a response within **5 business days**.
5. We follow a **90-day disclosure timeline** — fixes will be published and credited before the deadline.

### What qualifies
- Unauthenticated remote code execution on the host via the MCP endpoint
- Container escape vulnerabilities introduced by this project's configuration
- Credential or session-data leakage through the API

### What does not qualify
- Vulnerabilities in upstream Kali Linux tools (report those upstream)
- Issues requiring physical access to the host
- Social engineering attacks
