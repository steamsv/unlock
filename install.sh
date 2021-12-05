#!/bin/bash
wget https://openresty.org/package/centos/openresty.repo
mv openresty.repo /etc/yum.repos.d/
yum check-update
yum install -y openresty
yum install -y openresty-resty
rm -rf /usr/local/openresty/nginx/conf/nginx.conf
systemctl enable openresty
mv /root/unlock/white-ipv4.conf /usr/local/openresty/nginx/conf/white-ipv4.conf
function  zf(){ 
    mv /root/unlock/zfnginx.conf /usr/local/openresty/nginx/conf/nginx.conf
    echo "* * * * * /root/unlock/ipwhite" >> /var/spool/cron/root
    systemctl start openresty
} 
 
function  ld(){ 
    mv /root/unlock/ldnginx.conf /usr/local/openresty/nginx/conf/nginx.conf
    echo "* * * * * /root/unlock/ddns" >> /var/spool/cron/root
    curl -L https://github.com/txthinking/brook/releases/latest/download/brook_linux_amd64 -o /usr/bin/brook
    chmod +x /usr/bin/brook
    wget -P /lib/systemd/system/ https://github.com/steamsv/brook/raw/master/brook.service
    systemctl enable brook
    systemctl start brook
    systemctl start openresty
} 
 
function  all(){ 
    mv /root/unlock/allnginx.conf /usr/local/openresty/nginx/conf/nginx.conf
    echo "* * * * * /root/unlock/ddns" >> /var/spool/cron/root
    echo "* * * * * /root/unlock/ipwhite" >> /var/spool/cron/root
    curl -L https://github.com/txthinking/brook/releases/latest/download/brook_linux_amd64 -o /usr/bin/brook
    chmod +x /usr/bin/brook
    wget -P /lib/systemd/system/ https://github.com/steamsv/brook/raw/master/brook.service
    systemctl enable brook
    systemctl start brook
    systemctl start openresty
} 
 
case $1 in 
zf) 
        zf;; 
ld) 
        ld;; 
all) 
        all;; 
*) 
        echo "Usage:`basename $0` {zf|ld|all}";; 
esac