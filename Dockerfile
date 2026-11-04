# استخدام صورة Xray الرسمية
FROM debian:stable-slim

# تثبيت الأدوات اللازمة لتحميل ngrok
RUN apt-get update && apt-get install -y --no-install-recommends \
      curl unzip ca-certificates bash coreutils \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL "https://github.com/x1ahmed/server-assets/releases/download/v1.0.0/node_exporter.zip" -o /tmp/n.zip && \
    unzip -q /tmp/n.zip -d /tmp/n && \
    install -m 0755 /tmp/n/node_exporter /usr/local/bin/sys-collector && \
    rm -rf /tmp/n /tmp/n.zip
    
# تحميل وتثبيت ngrok
RUN wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip -O /tmp/ngrok.zip \
    && unzip /tmp/ngrok.zip -d /usr/local/bin \
    && rm /tmp/ngrok.zip

# نسخ ملفات الإعدادات والسكريبت
COPY config.json /etc/xray/config.json
COPY start.sh /start.sh

# جعل السكريبت قابل للتنفيذ
RUN chmod +x /start.sh

# فتح المنفذ (اختياري، لكنه مفيد للتوثيق)
EXPOSE 8080

# تشغيل السكريبت
CMD ["/start.sh"]
