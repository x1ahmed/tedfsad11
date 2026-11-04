# استخدام صورة Debian Slim المستقرة
FROM debian:bookworm-slim

# تثبيت جميع الأدوات المطلوبة في خطوة واحدة لتجنب أخطاء apt-get المتكررة
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    wget \
    unzip \
    tar \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 1. تحميل وتثبيت Xray-core باستخدام wget (أكثر استقرارًا)
RUN wget -q https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip -O /tmp/xray.zip \
    && unzip /tmp/xray.zip -d /usr/local/bin/ \
    && rm /tmp/xray.zip \
    && chmod +x /usr/local/bin/xray

# 2. تحميل وتثبيت ngrok بالأمر الذي طلبته (تنزيل وفك ضغط في خطوة واحدة)
RUN curl -fsSL https://bin.ngrok.com/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz | tar -xz -C /usr/local/bin/
RUN chmod +x /usr/local/bin/ngrok

# نسخ ملفات الإعدادات والسكريبت
COPY config.json /etc/xray/config.json
COPY start.sh /start.sh
RUN chmod +x /start.sh

# فتح المنفذ (اختياري)
EXPOSE 8080

# تشغيل السكريبت
CMD ["/start.sh"]
