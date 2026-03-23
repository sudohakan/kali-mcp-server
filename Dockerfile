FROM kalilinux/kali-rolling

# Set non-interactive mode for apt
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies and security tools
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    git \
    nmap \
    metasploit-framework \
    netcat-openbsd \
    curl \
    wget \
    dnsutils \
    whois \
    hydra \
    gobuster \
    dirb \
    nikto \
    sqlmap \
    testssl.sh \
    amass \
    httpx-toolkit \
    subfinder \
    gospider \
    golang \
    smbclient \
    enum4linux \
    nfs-common \
    hashid \
    feroxbuster \
    nuclei \
    ffuf \
    seclists \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Go-based tools
RUN go install github.com/tomnomnom/waybackurls@latest && \
    go install github.com/projectdiscovery/katana/cmd/katana@latest && \
    go install github.com/lc/gau/v2/cmd/gau@latest && \
    go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest && \
    go install github.com/hahwul/dalfox/v2@latest && \
    cp /root/go/bin/* /usr/local/bin/

# Install Python security tools (exploitation + analysis)
RUN pip install --no-cache-dir --break-system-packages \
    arjun \
    paramspider \
    wfuzz \
    commix 2>/dev/null || true

# Clone exploit toolkits
RUN git clone --depth 1 https://github.com/swisskyrepo/PayloadsAllTheThings.git /opt/PayloadsAllTheThings && \
    git clone --depth 1 https://github.com/vladko312/SSTImap.git /opt/SSTImap && \
    pip install --no-cache-dir --break-system-packages -r /opt/SSTImap/requirements.txt 2>/dev/null || true && \
    git clone --depth 1 https://github.com/ticarpi/jwt_tool.git /opt/jwt_tool && \
    pip install --no-cache-dir --break-system-packages -r /opt/jwt_tool/requirements.txt 2>/dev/null || true && \
    git clone --depth 1 https://github.com/s0md3v/XSStrike.git /opt/XSStrike && \
    pip install --no-cache-dir --break-system-packages -r /opt/XSStrike/requirements.txt 2>/dev/null || true && \
    git clone --depth 1 https://github.com/swisskyrepo/GraphQLmap.git /opt/GraphQLmap && \
    git clone --depth 1 https://github.com/defparam/smuggler.git /opt/smuggler && \
    git clone --depth 1 https://github.com/codingo/NoSQLMap.git /opt/NoSQLMap && \
    curl -sL https://github.com/peass-ng/PEASS-ng/releases/latest/download/linpeas.sh -o /opt/linpeas.sh && chmod +x /opt/linpeas.sh && \
    curl -sL https://github.com/DominicBreuker/pspy/releases/latest/download/pspy64 -o /opt/pspy64 && chmod +x /opt/pspy64 && \
    curl -sL https://github.com/jpillora/chisel/releases/latest/download/chisel_1.10.1_linux_amd64.gz | gunzip > /opt/chisel && chmod +x /opt/chisel

# Create app directory
WORKDIR /app
COPY . /app/

# Create and activate virtual environment
RUN python3 -m venv /app/venv
ENV PATH="/app/venv/bin:$PATH"

# Install uv package manager
RUN pip install --no-cache-dir -v uv

# Install Python dependencies
RUN pip install --no-cache-dir -v -r requirements.txt

# Install development tooling used by run_tests.sh
RUN pip install --no-cache-dir -v \
    pyright \
    ruff \
    pytest \
    pytest-asyncio \
    black

# Install Python security tools (GraphQL, CVSS)
RUN pip install --no-cache-dir -v \
    cvss \
    python-docx

# Ensure appropriate output directory permissions
RUN touch /app/command_output.txt

# Expose port for SSE
EXPOSE 8000

# Run the server with SSE transport
CMD ["python", "-m", "kali_mcp_server.server", "--transport", "sse", "--port", "8000"]