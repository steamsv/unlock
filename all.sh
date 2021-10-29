#!/bin/bash

if grep -Eqi "CentOS" /etc/issue || grep -Eq "CentOS" /etc/*-release; then
    cd ..
    yum install epel-release -y
    yum install bind-utils -y
    yum install libev -y
    wget https://openresty.org/package/centos/openresty.repo
    mv openresty.repo /etc/yum.repos.d/
    yum check-update
    yum install -y openresty
    yum install -y openresty-resty
    wget https://static.adguard.com/adguardhome/release/AdGuardHome_linux_amd64.tar.gz
    tar xvf AdGuardHome_linux_amd64.tar.gz
    cd /root/AdGuardHome && ./AdGuardHome -s install && cd /root/

else
    echo "This script only supports CentOS."
    exit 1
fi

if [ $? -eq 0 ]; then
    rpm -ivh /root/sniproxyinstall/udns-0.4-3.el7.x86_64.rpm
    rpm -ivh /root/sniproxyinstall/sniproxy-0.6.0+git.8.g3fa47ea-1.el7.x86_64.rpm
    rm -rf /usr/local/openresty/nginx/conf/nginx.conf
    rm -rf /etc/sniproxy.conf
    rm -rf /root/AdGuardHome
    cp /root/sniproxyinstall/nginxall.conf /usr/local/openresty/nginx/conf/nginx.conf
    cp /root/sniproxyinstall/sniproxy.conf /etc/sniproxy.conf
    cp /root/sniproxyinstall/sniproxy.service /etc/systemd/system/sniproxy.service
    cp -r /root/sniproxyinstall/AdGuardHome /root/AdGuardHome
    cp /root/sniproxyinstall/nginxdns.conf /usr/local/openresty/nginx/conf/nginx.conf
    chmod +x /root/sniproxyinstall/ipwhite
    chmod +x /root/AdGuardHome/AdGuardHome
    echo "*/5 * * * * /root/sniproxyinstall/ipwhite" >> /var/spool/cron/root
    /root/sniproxyinstall/ipwhite
    systemctl restart sniproxy
    systemctl restart openresty
    systemctl restart openresty
    systemctl enable openresty
    systemctl restart AdGuardHome
    systemctl enable AdGuardHome
    echo "DNS SNIPROXY部署成功"
else
    echo "安装失败, 请检查仓库状况"
fi
