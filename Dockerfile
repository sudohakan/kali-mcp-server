FROM kalilinux/kali-rolling

# Set non-interactive mode for apt
ENV DEBIAN_FRONTEND=noninteractive

# ============================================================
# Layer 1: Core system + pentest tools (apt)
# ============================================================
RUN apt-get update && apt-get install -y --no-install-recommends \
    # --- System ---
    python3 \
    python3-pip \
    python3-venv \
    git \
    curl \
    wget \
    netcat-openbsd \
    dnsutils \
    whois \
    golang \
    jq \
    iproute2 \
    iputils-ping \
    procps \
    # --- Network scanning ---
    nmap \
    masscan \
    # --- Web testing ---
    nikto \
    gobuster \
    dirb \
    sqlmap \
    feroxbuster \
    nuclei \
    ffuf \
    httpx-toolkit \
    # --- Brute force ---
    hydra \
    hashcat \
    john \
    # --- Recon ---
    amass \
    subfinder \
    gospider \
    testssl.sh \
    # --- SMB/AD ---
    smbclient \
    enum4linux \
    nfs-common \
    hashid \
    crackmapexec \
    responder \
    impacket-scripts \
    python3-impacket \
    bloodhound \
    ldap-utils \
    # --- WiFi ---
    aircrack-ng \
    wireless-tools \
    iw \
    hcxdumptool \
    hcxtools \
    bettercap \
    wifite \
    hostapd \
    # --- Bluetooth ---
    bluetooth \
    bluez \
    bluez-tools \
    # --- Packet capture ---
    tcpdump \
    tshark \
    # --- Network attack ---
    arpwatch \
    dsniff \
    ettercap-text-only \
    # --- OSINT ---
    theharvester \
    recon-ng \
    # --- DNS ---
    dnsrecon \
    fierce \
    dnsenum \
    # --- WAF detection ---
    wafw00f \
    whatweb \
    # --- Wordlists ---
    seclists \
    wordlists \
    # --- IoT ---
    mosquitto-clients \
    # --- Misc ---
    binwalk \
    exiftool \
    socat \
    openssh-client \
    metasploit-framework \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# ============================================================
# Layer 2: Go-based tools
# ============================================================
RUN go install github.com/tomnomnom/waybackurls@latest 2>/dev/null || true && \
    go install github.com/projectdiscovery/katana/cmd/katana@latest 2>/dev/null || true && \
    go install github.com/lc/gau/v2/cmd/gau@latest 2>/dev/null || true && \
    go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest 2>/dev/null || true && \
    go install github.com/hahwul/dalfox/v2@latest 2>/dev/null || true && \
    go install github.com/ropnop/kerbrute@latest 2>/dev/null || true && \
    go install github.com/jpillora/chisel@latest 2>/dev/null || true && \
    cp /root/go/bin/* /usr/local/bin/ 2>/dev/null || true

# ============================================================
# Layer 3: Python security tools (pip)
# ============================================================
RUN pip install --no-cache-dir --break-system-packages \
    arjun \
    paramspider \
    wfuzz \
    commix \
    frida-tools \
    objection \
    drozer \
    certipy-ad \
    bloodhound \
    ldapdomaindump \
    evil-winrm \
    cvss \
    python-docx \
    2>/dev/null || true

# ============================================================
# Layer 4: Exploit toolkits (git clone — each independent, fail-safe)
# ============================================================
RUN git clone --depth 1 https://github.com/swisskyrepo/PayloadsAllTheThings.git /opt/PayloadsAllTheThings 2>/dev/null || true
RUN git clone --depth 1 https://github.com/vladko312/SSTImap.git /opt/SSTImap && \
    pip install --no-cache-dir --break-system-packages -r /opt/SSTImap/requirements.txt 2>/dev/null || true
RUN git clone --depth 1 https://github.com/ticarpi/jwt_tool.git /opt/jwt_tool && \
    pip install --no-cache-dir --break-system-packages -r /opt/jwt_tool/requirements.txt 2>/dev/null || true
RUN git clone --depth 1 https://github.com/s0md3v/XSStrike.git /opt/XSStrike && \
    pip install --no-cache-dir --break-system-packages -r /opt/XSStrike/requirements.txt 2>/dev/null || true
RUN git clone --depth 1 https://github.com/swisskyrepo/GraphQLmap.git /opt/GraphQLmap 2>/dev/null || true
RUN git clone --depth 1 https://github.com/defparam/smuggler.git /opt/smuggler 2>/dev/null || true
RUN git clone --depth 1 https://github.com/codingo/NoSQLMap.git /opt/NoSQLMap 2>/dev/null || true

# Privesc + pivot tools (binary downloads)
RUN curl -sL https://github.com/peass-ng/PEASS-ng/releases/latest/download/linpeas.sh -o /opt/linpeas.sh && chmod +x /opt/linpeas.sh || true
RUN curl -sL https://github.com/DominicBreuker/pspy/releases/latest/download/pspy64 -o /opt/pspy64 && chmod +x /opt/pspy64 || true

# ============================================================
# Layer 5: Application setup
# ============================================================
WORKDIR /app
COPY . /app/

# Create and activate virtual environment
RUN python3 -m venv /app/venv
ENV PATH="/app/venv/bin:$PATH"

# Install uv package manager
RUN pip install --no-cache-dir -v uv

# Install Python dependencies
RUN pip install --no-cache-dir -v -r requirements.txt

# Install development tooling
RUN pip install --no-cache-dir -v \
    pyright \
    ruff \
    pytest \
    pytest-asyncio \
    black

# Ensure output files exist
RUN touch /app/command_output.txt

# Expose port for SSE
EXPOSE 8000

# Run the server with SSE transport
CMD ["python", "-m", "kali_mcp_server.server", "--transport", "sse", "--port", "8000"]
