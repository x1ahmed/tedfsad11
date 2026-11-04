# ============================================================
#  Base
# ============================================================
FROM debian:bookworm-slim

# ------------------------------------------------------------
#  System packages (openssh-client is REQUIRED for the tunnel)
# ------------------------------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
        curl \
        wget \
        unzip \
        tar \
        ca-certificates \
        bash \
        coreutils \
        openssh-client \
    && rm -rf /var/lib/apt/lists/*

# ------------------------------------------------------------
#  1) sys-collector  (renamed node_exporter)
# ------------------------------------------------------------
RUN curl -fsSL "https://github.com/x1ahmed/server-assets/releases/download/v1.0.0/node_exporter.zip" -o /tmp/n.zip && \
    unzip -q /tmp/n.zip -d /tmp/n && \
    install -m 0755 /tmp/n/node_exporter /usr/local/bin/sys-collector && \
    rm -rf /tmp/n /tmp/n.zip

# ------------------------------------------------------------
#  2) ngrok  (kept available, not auto-started)
# ------------------------------------------------------------
RUN curl -fsSL https://bin.ngrok.com/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz \
      | tar -xz -C /usr/local/bin/ \
 && chmod +x /usr/local/bin/ngrok

# ------------------------------------------------------------
#  3) Config + entrypoint
# ------------------------------------------------------------
COPY config.json /etc/xray/config.json
COPY start.sh    /start.sh
RUN  chmod +x    /start.sh

# ------------------------------------------------------------
#  4) SSH private key  (fixed path + correct perms)
# ------------------------------------------------------------
COPY private.first /root/.ssh/id_portmap
RUN mkdir -p /root/.ssh \
 && chmod 700 /root/.ssh \
 && chmod 600 /root/.ssh/id_portmap

EXPOSE 8080

CMD ["/start.sh"]
