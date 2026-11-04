# استخدام صورة Xray الرسمية
FROM ghcr.io/xtls/xray-core:latest

# نسخ ملف الإعدادات إلى داخل الحاوية
COPY config.json /etc/xray/config.json

# فتح المنفذ الذي سيتم استخدامه (حسب صورتك 10002، لكن يفضل 443)
EXPOSE 10002

# تشغيل Xray
CMD ["run", "-c", "/etc/xray/config.json"]
