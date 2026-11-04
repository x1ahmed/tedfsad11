# استخدام صورة Debian Slim المستقرة
FROM debian:bookworm-slim

# تثبيت الأدوات الأساسية (curl لتنزيل الملفات، tar لفك الضغط، ca-certificates للاتصال الآمن)
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    tar \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 1. تحميل وتثبيت Xray-core
RUN curl -fsSL https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip -o /tmp/xray.zip \
    && apt-get install -y unzip \
    && unzip /tmp/xray.zip -d /usr/local/bin/ \
    && rm /tmp/xray.zip \
    && chmod +x /usr/local/bin/xray

# 2. تحميل وتثبيت ngrok بالأمر الذي طلبته (تنزيل وفك ضغط في خطوة واحدة)
# نستخدم -C /usr/local/bin/ لوضع الملف التنفيذي في مسار النظام مباشرة
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
