#!/bin/bash
wget https://openresty.org/package/centos/openresty.repo
mv openresty.repo /etc/yum.repos.d/
yum check-update
yum install  -y bind-utils
yum install -y openresty
yum install -y openresty-resty
rm -rf /usr/local/openresty/nginx/conf/nginx.conf
systemctl enable openresty
mv /root/unlock/white-ipv4.conf /usr/local/openresty/nginx/conf/white-ipv4.conf
mv /root/unlock/ldnginx.conf /usr/local/openresty/nginx/conf/nginx.conf
wget https://static.adguard.com/adguardhome/release/AdGuardHome_linux_amd64.tar.gz
tar xvf AdGuardHome_linux_amd64.tar.gz
echo "* * * * * /root/unlock/ddns" >> /var/spool/cron/root
curl -L https://github.com/txthinking/brook/releases/latest/download/brook_linux_amd64 -o /usr/bin/brook
chmod +x /usr/bin/brook
chmod +x /root/unlock/ddns
wget -P /lib/systemd/system/ https://github.com/steamsv/brook/raw/master/brook.service
systemctl enable brook
systemctl start brook
systemctl restart openresty
systemctl status openresty
systemctl status brook
