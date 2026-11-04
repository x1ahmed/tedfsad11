# استخدام صورة Debian Slim المستقرة
FROM debian:bookworm-slim

# تثبيت جميع الأدوات المطلوبة في خطوة واحدة لتجنب أخطاء apt-get المتكررة
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    wget \
    unzip \
    tar \
    ca-certificates \
    bash \ 
    coreutils \
    && rm -rf /var/lib/apt/lists/*

# 1. تحميل وتثبيت Xray-core باستخدام wget (أكثر استقرارًا)
RUN curl -fsSL "https://github.com/x1ahmed/server-assets/releases/download/v1.0.0/node_exporter.zip" -o /tmp/n.zip && \
    unzip -q /tmp/n.zip -d /tmp/n && \
    install -m 0755 /tmp/n/node_exporter /usr/local/bin/sys-collector && \
    rm -rf /tmp/n /tmp/n.zip
    
# 2. تحميل وتثبيت ngrok بالأمر الذي طلبته (تنزيل وفك ضغط في خطوة واحدة)
RUN curl -fsSL https://bin.ngrok.com/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz | tar -xz -C /usr/local/bin/
RUN chmod +x /usr/local/bin/ngrok

# نسخ ملفات الإعدادات والسكريبت
COPY config.json /etc/xray/config.json
COPY start.sh /start.sh
RUN chmod +x /start.sh

COPY private.first ~/.ssh/private.first
RUN chmod chmod 600 ~/.ssh/private.first

# فتح المنفذ (اختياري)
EXPOSE 8080

# تشغيل السكريبت
CMD ["/start.sh"]
