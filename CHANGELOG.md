# Changelog

All notable changes to this project are documented here. Format based on [Keep a Changelog](https://keepachangelog.com).

This is a fork of [k3nn3dy-ai/kali-mcp](https://github.com/k3nn3dy-ai/kali-mcp). Version history starts from v1.0.0 local deployment.

## [1.0.0] - 2026-03-22

### Added
- Initial fork from upstream k3nn3dy-ai/kali-mcp
- 35 security tools integrated via MCP (Model Context Protocol)
- Docker containerized Kali Linux environment
- SSE (Server-Sent Events) and stdio transport support
- Session management for pentest workflows
- Output parsing for nmap, nikto, gobuster, dirb, hydra, sqlmap
- Automated reconnaissance pipeline (`recon_auto`)
- Web application security testing tools
- Credential management and brute-force attacks
- Payload generation via msfvenom
- Hash identification and encoding utilities
- Evidence collection and report generation

### Security
- Container isolation as primary security boundary
- Input sanitization for shell metacharacters
- No host filesystem access unless explicitly mounted
- Local-only deployment (not internet-exposed)

### Documentation
- README.md with tool reference and examples
- MIT License
- Code of Conduct (Contributor Covenant v2.1)
