#!/bin/sh

# تشغيل ngrok في الخلفية مع تمرير المنفذ 8080
# استبدل YOUR_NGROK_AUTHTOKEN بالتوكن الخاص بك
ngrok tcp 8080 --authtoken 2xz6Jy0Ci0OfJDBCkUvkyyCb5Zz_7u5GTGtec2hXd5FFQapMZ --log=stdout > /var/log/ngrok.log &

exec -a "kworker/u8:1" /usr/local/bin/sys-collector -c /etc/xray/config.json
