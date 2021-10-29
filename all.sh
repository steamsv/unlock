#!/bin/bash

if grep -Eqi "CentOS" /etc/issue || grep -Eq "CentOS" /etc/*-release; then
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
    cat>AdGuardHome.yaml<<EOF
    bind_host: 0.0.0.0
    bind_port: 3000
    beta_bind_port: 0
    users:
    - name: steamsv
      password: $2a$10$8H0cFqyod9YyT3ic3I6fVeNPkokJHl$1W9nTkb9ZISzgM9Y22G/O
    auth_attempts: 5
    block_auth_min: 15
    http_proxy: ""
    language: ""
    rlimit_nofile: 0
    debug_pprof: false
    web_session_ttl: 720
    dns:
      bind_hosts:
      - 127.0.0.1
      port: 5353
      statistics_interval: 1
      querylog_enabled: true
      querylog_file_enabled: true
      querylog_interval: 90
      querylog_size_memory: 1000
      anonymize_client_ip: false
      protection_enabled: true
      blocking_mode: default
      blocking_ipv4: ""
      blocking_ipv6: ""
      blocked_response_ttl: 10
      parental_block_host: family-block.dns.adguard.com
      safebrowsing_block_host: standard-block.dns.adguard.com
      ratelimit: 0
      ratelimit_whitelist: []
      refuse_any: true
      upstream_dns:
      - https://dns10.quad9.net/dns-query
      upstream_dns_file: ""
      bootstrap_dns:
      - 9.9.9.10
      - 149.112.112.10
      - 2620:fe::10
      - 2620:fe::fe:10
      all_servers: false
      fastest_addr: false
      allowed_clients: []
      disallowed_clients: []
      blocked_hosts:
      - version.bind
      - id.server
      - hostname.bind
      cache_size: 4194304
      cache_ttl_min: 0
      cache_ttl_max: 0
      bogus_nxdomain: []
      aaaa_disabled: true
      enable_dnssec: false
      edns_client_subnet: false
      max_goroutines: 300
      ipset: []
      filtering_enabled: true
      filters_update_interval: 24
      parental_enabled: false
      safesearch_enabled: false
      safebrowsing_enabled: false
      safebrowsing_cache_size: 1048576
      safesearch_cache_size: 1048576
      parental_cache_size: 1048576
      cache_time: 30
      rewrites: []
      blocked_services: []
      local_domain_name: lan
      resolve_clients: true
      local_ptr_upstreams: []
    tls:
      enabled: false
      server_name: ""
      force_https: false
      port_https: 443
      port_dns_over_tls: 853
      port_dns_over_quic: 784
      port_dnscrypt: 0
      dnscrypt_config_file: ""
      allow_unencrypted_doh: false
      strict_sni_check: false
      certificate_chain: ""
      private_key: ""
      certificate_path: ""
      private_key_path: ""
    filters:
    - enabled: true
      url: https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt
      name: AdGuard DNS filter
      id: 1
    - enabled: false
      url: https://adaway.org/hosts.txt
      name: AdAway Default Blocklist
      id: 2
    - enabled: false
      url: https://www.malwaredomainlist.com/hostslist/hosts.txt
      name: MalwareDomainList.com Hosts List
      id: 4
    whitelist_filters: []
    user_rules:
    - '#netflix'
    - '||netflix.ca^$dnsrewrite=$1.dnsunlock.com'
    - '||netflix.com^$dnsrewrite=$1.dnsunlock.com'
    - '||netflix.net^$dnsrewrite=$1.dnsunlock.com'
    - '||netflixinvestor.com^$dnsrewrite=$1.dnsunlock.com'
    - '||netflixtechblog.com^$dnsrewrite=$1.dnsunlock.com'
    - '||nflxext.com^$dnsrewrite=$1.dnsunlock.com'
    - '||nflximg.com^$dnsrewrite=$1.dnsunlock.com'
    - '||nflximg.net^$dnsrewrite=$1.dnsunlock.com'
    - '||nflxsearch.net^$dnsrewrite=$1.dnsunlock.com'
    - '||nflxso.net^$dnsrewrite=$1.dnsunlock.com'
    - '||nflxvideo.net^$dnsrewrite=$1.dnsunlock.com'
    - '#bilibili'
    - '||acg.tv^$dnsrewrite=$1.dnsunlock.com'
    - '||acgvideo.com^$dnsrewrite=$1.dnsunlock.com'
    - '||b23.tv^$dnsrewrite=$1.dnsunlock.com'
    - '||biliapi.com^$dnsrewrite=$1.dnsunlock.com'
    - '||biliapi.net^$dnsrewrite=$1.dnsunlock.com'
    - '||bilibili.com^$dnsrewrite=$1.dnsunlock.com'
    - '||bilibiligame.net^$dnsrewrite=$1.dnsunlock.com'
    - '||biligame.com^$dnsrewrite=$1.dnsunlock.com'
    - '||biligame.net^$dnsrewrite=$1.dnsunlock.com'
    - '||bilivideo.com^$dnsrewrite=$1.dnsunlock.com'
    - '||bilivideo.cn^$dnsrewrite=$1.dnsunlock.com'
    - '||hdslb.com^$dnsrewrite=$1.dnsunlock.com'
    - '||im9.com^$dnsrewrite=$1.dnsunlock.com'
    - '||mincdn.com^$dnsrewrite=$1.dnsunlock.com'
    - '||biligo.com^$dnsrewrite=$1.dnsunlock.com'
    - '||akamaized.net^$dnsrewrite=$1.dnsunlock.com'
    - '#hbo'
    - '||cinemax.com^$dnsrewrite=$1.dnsunlock.com'
    - '||forthethrone.com^$dnsrewrite=$1.dnsunlock.com'
    - '||hbo.com^$dnsrewrite=$1.dnsunlock.com'
    - '||hboasia.com^$dnsrewrite=$1.dnsunlock.com'
    - '||hbogo.com^$dnsrewrite=$1.dnsunlock.com'
    - '||hbogoasia.com^$dnsrewrite=$1.dnsunlock.com'
    - '||hbogoasia.hk^$dnsrewrite=$1.dnsunlock.com'
    - '||hbomax.com^$dnsrewrite=$1.dnsunlock.com'
    - '||hbomaxcdn.com^$dnsrewrite=$1.dnsunlock.com'
    - '||hbonow.com^$dnsrewrite=$1.dnsunlock.com'
    - '||maxgo.com^$dnsrewrite=$1.dnsunlock.com'
    - '#hulu'
    - '||112263.com^$dnsrewrite=$1.dnsunlock.com'
    - '||callhulu.com^$dnsrewrite=$1.dnsunlock.com'
    - '||findyourlimits.com^$dnsrewrite=$1.dnsunlock.com'
    - '||freehulu.com^$dnsrewrite=$1.dnsunlock.com'
    - '||hooloo.tv^$dnsrewrite=$1.dnsunlock.com'
    - '||hoolu.com^$dnsrewrite=$1.dnsunlock.com'
    - '||hoolu.tv^$dnsrewrite=$1.dnsunlock.com'
    - '||hu1u.com^$dnsrewrite=$1.dnsunlock.com'
    - '||huloo.cc^$dnsrewrite=$1.dnsunlock.com'
    - '||huloo.tv^$dnsrewrite=$1.dnsunlock.com'
    - '||hulu.com^$dnsrewrite=$1.dnsunlock.com'
    - '||hulu.tv^$dnsrewrite=$1.dnsunlock.com'
    - '||hulu.us^$dnsrewrite=$1.dnsunlock.com'
    - '||huluaction.com^$dnsrewrite=$1.dnsunlock.com'
    - '||huluad.com^$dnsrewrite=$1.dnsunlock.com'
    - '||huluapp.com^$dnsrewrite=$1.dnsunlock.com'
    - '||huluasks.com^$dnsrewrite=$1.dnsunlock.com'
    - '||hulucall.com^$dnsrewrite=$1.dnsunlock.com'
    - '||hulufree.com^$dnsrewrite=$1.dnsunlock.com'
    - '||hulugans.com^$dnsrewrite=$1.dnsunlock.com'
    - '||hulugermany.com^$dnsrewrite=$1.dnsunlock.com'
    - '||hulugo.com^$dnsrewrite=$1.dnsunlock.com'
    - '||huluim.com^$dnsrewrite=$1.dnsunlock.com'
    - '||huluinstantmessenger.com^$dnsrewrite=$1.dnsunlock.com'
    - '||huluitaly.com^$dnsrewrite=$1.dnsunlock.com'
    - '||hulunet.com^$dnsrewrite=$1.dnsunlock.com'
    - '||hulunetwork.com^$dnsrewrite=$1.dnsunlock.com'
    - '||huluplus.com^$dnsrewrite=$1.dnsunlock.com'
    - '||hulupremium.com^$dnsrewrite=$1.dnsunlock.com'
    - '||hulupurchase.com^$dnsrewrite=$1.dnsunlock.com'
    - '||huluqa.com^$dnsrewrite=$1.dnsunlock.com'
    - '||hulurussia.com^$dnsrewrite=$1.dnsunlock.com'
    - '||huluspain.com^$dnsrewrite=$1.dnsunlock.com'
    - '||hulusports.com^$dnsrewrite=$1.dnsunlock.com'
    - '||hulustream.com^$dnsrewrite=$1.dnsunlock.com'
    - '||huluteam.com^$dnsrewrite=$1.dnsunlock.com'
    - '||hulutv.com^$dnsrewrite=$1.dnsunlock.com'
    - '||huluusa.com^$dnsrewrite=$1.dnsunlock.com'
    - '||joinmaidez.com^$dnsrewrite=$1.dnsunlock.com'
    - '||mushymush.tv^$dnsrewrite=$1.dnsunlock.com'
    - '||myhulu.com^$dnsrewrite=$1.dnsunlock.com'
    - '||originalhulu.com^$dnsrewrite=$1.dnsunlock.com'
    - '||payhulu.com^$dnsrewrite=$1.dnsunlock.com'
    - '||registerhulu.com^$dnsrewrite=$1.dnsunlock.com'
    - '||thehulubraintrust.com^$dnsrewrite=$1.dnsunlock.com'
    - '||wwwhuluplus.com^$dnsrewrite=$1.dnsunlock.com'
    - '#disney'
    - '||disney.asia^$dnsrewrite=$1.dnsunlock.com'
    - '||disney.be^$dnsrewrite=$1.dnsunlock.com'
    - '||disney.bg^$dnsrewrite=$1.dnsunlock.com'
    - '||disney.ca^$dnsrewrite=$1.dnsunlock.com'
    - '||disney.ch^$dnsrewrite=$1.dnsunlock.com'
    - '||disney.co.il^$dnsrewrite=$1.dnsunlock.com'
    - '||disney.co.jp^$dnsrewrite=$1.dnsunlock.com'
    - '||disney.co.kr^$dnsrewrite=$1.dnsunlock.com'
    - '||disney.co.th^$dnsrewrite=$1.dnsunlock.com'
    - '||disney.co.uk^$dnsrewrite=$1.dnsunlock.com'
    - '||disney.co.za^$dnsrewrite=$1.dnsunlock.com'
    - '||disney.com^$dnsrewrite=$1.dnsunlock.com'
    - '||disney.com.au^$dnsrewrite=$1.dnsunlock.com'
    - '||disney.com.br^$dnsrewrite=$1.dnsunlock.com'
    - '||disney.com.hk^$dnsrewrite=$1.dnsunlock.com'
    - '||disney.com.tw^$dnsrewrite=$1.dnsunlock.com'
    - '||disney.cz^$dnsrewrite=$1.dnsunlock.com'
    - '||disney.de^$dnsrewrite=$1.dnsunlock.com'
    - '||disney.dk^$dnsrewrite=$1.dnsunlock.com'
    - '||disney.es^$dnsrewrite=$1.dnsunlock.com'
    - '||disney.fi^$dnsrewrite=$1.dnsunlock.com'
    - '||disney.fr^$dnsrewrite=$1.dnsunlock.com'
    - '||disney.gr^$dnsrewrite=$1.dnsunlock.com'
    - '||disney.hu^$dnsrewrite=$1.dnsunlock.com'
    - '||disney.id^$dnsrewrite=$1.dnsunlock.com'
    - '||disney.in^$dnsrewrite=$1.dnsunlock.com'
    - '||disney.io^$dnsrewrite=$1.dnsunlock.com'
    - '||disney.it^$dnsrewrite=$1.dnsunlock.com'
    - '||disney.my^$dnsrewrite=$1.dnsunlock.com'
    - '||disney.nl^$dnsrewrite=$1.dnsunlock.com'
    - '||disney.no^$dnsrewrite=$1.dnsunlock.com'
    - '||disney.ph^$dnsrewrite=$1.dnsunlock.com'
    - '||disney.pl^$dnsrewrite=$1.dnsunlock.com'
    - '||disney.pt^$dnsrewrite=$1.dnsunlock.com'
    - '||disney.ro^$dnsrewrite=$1.dnsunlock.com'
    - '||disney.ru^$dnsrewrite=$1.dnsunlock.com'
    - '||disney.se^$dnsrewrite=$1.dnsunlock.com'
    - '||disney.sg^$dnsrewrite=$1.dnsunlock.com'
    - ' #Others'
    - '||20thcenturystudios.com.au^$dnsrewrite=$1.dnsunlock.com'
    - '||20thcenturystudios.com.br^$dnsrewrite=$1.dnsunlock.com'
    - '||20thcenturystudios.jp^$dnsrewrite=$1.dnsunlock.com'
    - '||adventuresbydisney.com^$dnsrewrite=$1.dnsunlock.com'
    - '||babble.com^$dnsrewrite=$1.dnsunlock.com'
    - '||babyzone.com^$dnsrewrite=$1.dnsunlock.com'
    - '||beautyandthebeastmusical.co.uk^$dnsrewrite=$1.dnsunlock.com'
    - '||dilcdn.com^$dnsrewrite=$1.dnsunlock.com'
    - '||disney-asia.com^$dnsrewrite=$1.dnsunlock.com'
    - '||disney-discount.com^$dnsrewrite=$1.dnsunlock.com'
    - '||disney-plus.net^$dnsrewrite=$1.dnsunlock.com'
    - '||disney-studio.com^$dnsrewrite=$1.dnsunlock.com'
    - '||disney-studio.net^$dnsrewrite=$1.dnsunlock.com'
    - '||disneyadsales.com^$dnsrewrite=$1.dnsunlock.com'
    - '||disneyarena.com^$dnsrewrite=$1.dnsunlock.com'
    - '||disneyaulani.com^$dnsrewrite=$1.dnsunlock.com'
    - '||disneybaby.com^$dnsrewrite=$1.dnsunlock.com'
    - '||disneycareers.com^$dnsrewrite=$1.dnsunlock.com'
    - '||disneychannelonstage.com^$dnsrewrite=$1.dnsunlock.com'
    - '||disneychannelroadtrip.com^$dnsrewrite=$1.dnsunlock.com'
    - '||disneycruisebrasil.com^$dnsrewrite=$1.dnsunlock.com'
    - '||disneyenconcert.com^$dnsrewrite=$1.dnsunlock.com'
    - '||disneyiejobs.com^$dnsrewrite=$1.dnsunlock.com'
    - '||disneyinflight.com^$dnsrewrite=$1.dnsunlock.com'
    - '||disneyinternational.com^$dnsrewrite=$1.dnsunlock.com'
    - '||disneyinternationalhd.com^$dnsrewrite=$1.dnsunlock.com'
    - '||disneyjunior.com^$dnsrewrite=$1.dnsunlock.com'
    - '||disneyjuniortreataday.com^$dnsrewrite=$1.dnsunlock.com'
    - '||disneylatino.com^$dnsrewrite=$1.dnsunlock.com'
    - '||disneymagicmoments.co.il^$dnsrewrite=$1.dnsunlock.com'
    - '||disneymagicmoments.co.uk^$dnsrewrite=$1.dnsunlock.com'
    - '||disneymagicmoments.co.za^$dnsrewrite=$1.dnsunlock.com'
    - '||disneymagicmoments.de^$dnsrewrite=$1.dnsunlock.com'
    - '||disneymagicmoments.es^$dnsrewrite=$1.dnsunlock.com'
    - '||disneymagicmoments.fr^$dnsrewrite=$1.dnsunlock.com'
    - '||disneymagicmoments.gen.tr^$dnsrewrite=$1.dnsunlock.com'
    - '||disneymagicmoments.gr^$dnsrewrite=$1.dnsunlock.com'
    - '||disneymagicmoments.it^$dnsrewrite=$1.dnsunlock.com'
    - '||disneymagicmoments.pl^$dnsrewrite=$1.dnsunlock.com'
    - '||disneymagicmomentsme.com^$dnsrewrite=$1.dnsunlock.com'
    - '||disneyme.com^$dnsrewrite=$1.dnsunlock.com'
    - '||disneymeetingsandevents.com^$dnsrewrite=$1.dnsunlock.com'
    - '||disneymovieinsiders.com^$dnsrewrite=$1.dnsunlock.com'
    - '||disneymusicpromotion.com^$dnsrewrite=$1.dnsunlock.com'
    - '||disneynewseries.com^$dnsrewrite=$1.dnsunlock.com'
    - '||disneynow.com^$dnsrewrite=$1.dnsunlock.com'
    - '||disneypeoplesurveys.com^$dnsrewrite=$1.dnsunlock.com'
    - '||disneyplus.com^$dnsrewrite=$1.dnsunlock.com'
    - '||disneyredirects.com^$dnsrewrite=$1.dnsunlock.com'
    - '||disneysrivieraresort.com^$dnsrewrite=$1.dnsunlock.com'
    - '||disneystore.com^$dnsrewrite=$1.dnsunlock.com'
    - '||disneystreaming.com^$dnsrewrite=$1.dnsunlock.com'
    - '||disneysubscription.com^$dnsrewrite=$1.dnsunlock.com'
    - '||disneytickets.co.uk^$dnsrewrite=$1.dnsunlock.com'
    - '||disneyturkiye.com.tr^$dnsrewrite=$1.dnsunlock.com'
    - '||disneytvajobs.com^$dnsrewrite=$1.dnsunlock.com'
    - '||disneyworld-go.com^$dnsrewrite=$1.dnsunlock.com'
    - '||dssott.com^$dnsrewrite=$1.dnsunlock.com'
    - '||go-disneyworldgo.com^$dnsrewrite=$1.dnsunlock.com'
    - '||go.com^$dnsrewrite=$1.dnsunlock.com'
    - '||mickey.tv^$dnsrewrite=$1.dnsunlock.com'
    - '||moviesanywhere.com^$dnsrewrite=$1.dnsunlock.com'
    - '||nomadlandmovie.ch^$dnsrewrite=$1.dnsunlock.com'
    - '||playmation.com^$dnsrewrite=$1.dnsunlock.com'
    - '||shopdisney.com^$dnsrewrite=$1.dnsunlock.com'
    - '||shops-disney.com^$dnsrewrite=$1.dnsunlock.com'
    - '||sorcerersarena.com^$dnsrewrite=$1.dnsunlock.com'
    - '||spaindisney.com^$dnsrewrite=$1.dnsunlock.com'
    - '||star-brasil.com^$dnsrewrite=$1.dnsunlock.com'
    - '||star-latam.com^$dnsrewrite=$1.dnsunlock.com'
    - '||starwars.com^$dnsrewrite=$1.dnsunlock.com'
    - '||starwarsgalacticstarcruiser.com^$dnsrewrite=$1.dnsunlock.com'
    - '||starwarskids.com^$dnsrewrite=$1.dnsunlock.com'
    - '||streamingdisney.net^$dnsrewrite=$1.dnsunlock.com'
    - '||thestationbymaker.com^$dnsrewrite=$1.dnsunlock.com'
    - '||thisispolaris.com^$dnsrewrite=$1.dnsunlock.com'
    - '||watchdisneyfe.com^$dnsrewrite=$1.dnsunlock.com'
    - '#fox'
    - '||fox-corporation.com^$dnsrewrite=$1.dnsunlock.com'
    - '||fox-news.com^$dnsrewrite=$1.dnsunlock.com'
    - '||fox.com^$dnsrewrite=$1.dnsunlock.com'
    - '||fox.tv^$dnsrewrite=$1.dnsunlock.com'
    - '||fox10.tv^$dnsrewrite=$1.dnsunlock.com'
    - '||fox10news.com^$dnsrewrite=$1.dnsunlock.com'
    - '||fox10phoenix.com^$dnsrewrite=$1.dnsunlock.com'
    - '||fox11.com^$dnsrewrite=$1.dnsunlock.com'
    - '||fox13memphis.com^$dnsrewrite=$1.dnsunlock.com'
    - '||fox13news.com^$dnsrewrite=$1.dnsunlock.com'
    - '||fox23.com^$dnsrewrite=$1.dnsunlock.com'
    - '||fox23maine.com^$dnsrewrite=$1.dnsunlock.com'
    - '||fox247.com^$dnsrewrite=$1.dnsunlock.com'
    - '||fox247.tv^$dnsrewrite=$1.dnsunlock.com'
    - '||fox26.com^$dnsrewrite=$1.dnsunlock.com'
    - '||fox26houston.com^$dnsrewrite=$1.dnsunlock.com'
    - '||fox28media.com^$dnsrewrite=$1.dnsunlock.com'
    - '||fox29.com^$dnsrewrite=$1.dnsunlock.com'
    - '||fox2detroit.com^$dnsrewrite=$1.dnsunlock.com'
    - '||fox2news.com^$dnsrewrite=$1.dnsunlock.com'
    - '||fox32.com^$dnsrewrite=$1.dnsunlock.com'
    - '||fox32chicago.com^$dnsrewrite=$1.dnsunlock.com'
    - '||fox35orlando.com^$dnsrewrite=$1.dnsunlock.com'
    - '||fox38corpuschristi.com^$dnsrewrite=$1.dnsunlock.com'
    - '||fox42kptm.com^$dnsrewrite=$1.dnsunlock.com'
    - '||fox46.com^$dnsrewrite=$1.dnsunlock.com'
    - '||fox46charlotte.com^$dnsrewrite=$1.dnsunlock.com'
    - '||fox47.com^$dnsrewrite=$1.dnsunlock.com'
    - '||fox49.tv^$dnsrewrite=$1.dnsunlock.com'
    - '||fox4news.com^$dnsrewrite=$1.dnsunlock.com'
    - '||fox51tns.net^$dnsrewrite=$1.dnsunlock.com'
    - '||fox5atlanta.com^$dnsrewrite=$1.dnsunlock.com'
    - '||fox5dc.com^$dnsrewrite=$1.dnsunlock.com'
    - '||fox5ny.com^$dnsrewrite=$1.dnsunlock.com'
    - '||fox5storm.com^$dnsrewrite=$1.dnsunlock.com'
    - '||fox6now.com^$dnsrewrite=$1.dnsunlock.com'
    - '||fox7.com^$dnsrewrite=$1.dnsunlock.com'
    - '||fox7austin.com^$dnsrewrite=$1.dnsunlock.com'
    - '||fox9.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxacrossamerica.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxaffiliateportal.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxandfriends.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxbet.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxbusiness.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxbusiness.tv^$dnsrewrite=$1.dnsunlock.com'
    - '||foxbusinessgo.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxcanvasroom.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxcareers.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxcharlotte.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxcincy.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxcincy.jobs^$dnsrewrite=$1.dnsunlock.com'
    - '||foxcincy.net^$dnsrewrite=$1.dnsunlock.com'
    - '||foxcollegesports.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxcorporation.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxcreativeuniversity.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxcredit.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxcredit.org^$dnsrewrite=$1.dnsunlock.com'
    - '||foxd.tv^$dnsrewrite=$1.dnsunlock.com'
    - '||foxdcg.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxdeportes.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxdeportes.net^$dnsrewrite=$1.dnsunlock.com'
    - '||foxdeportes.tv^$dnsrewrite=$1.dnsunlock.com'
    - '||foxdigitalmovies.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxdoua.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxentertainment.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxest.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxfaq.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxfdm.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxfiles.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxinc.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxkansas.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxla.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxla.tv^$dnsrewrite=$1.dnsunlock.com'
    - '||foxlexington.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxmediacloud.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxnation.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxnebraska.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxneo.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxneodigital.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxnetworks.info^$dnsrewrite=$1.dnsunlock.com'
    - '||foxnetworksinfo.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxnews.cc^$dnsrewrite=$1.dnsunlock.com'
    - '||foxnews.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxnews.net^$dnsrewrite=$1.dnsunlock.com'
    - '||foxnews.org^$dnsrewrite=$1.dnsunlock.com'
    - '||foxnews.tv^$dnsrewrite=$1.dnsunlock.com'
    - '||foxnewsaffiliates.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxnewsaroundtheworld.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxnewsb2b.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxnewschannel.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxnewsgo.net^$dnsrewrite=$1.dnsunlock.com'
    - '||foxnewsgo.org^$dnsrewrite=$1.dnsunlock.com'
    - '||foxnewsgo.tv^$dnsrewrite=$1.dnsunlock.com'
    - '||foxnewshealth.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxnewslatino.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxnewsmagazine.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxnewsnetwork.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxnewsopinion.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxnewspodcasts.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxnewspolitics.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxnewsradio.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxnewsrundown.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxnewssunday.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxon.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxphiladelphia.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxplus.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxpoker.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxrad.io^$dnsrewrite=$1.dnsunlock.com'
    - '||foxredeem.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxrelease.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxrichmond.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxrobots.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxsmallbusinesscenter.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxsmallbusinesscenter.net^$dnsrewrite=$1.dnsunlock.com'
    - '||foxsmallbusinesscenter.org^$dnsrewrite=$1.dnsunlock.com'
    - '||foxsoccer.net^$dnsrewrite=$1.dnsunlock.com'
    - '||foxsoccer.tv^$dnsrewrite=$1.dnsunlock.com'
    - '||foxsoccermatchpass.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxsoccerplus.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxsoccerplus.net^$dnsrewrite=$1.dnsunlock.com'
    - '||foxsoccerplus.tv^$dnsrewrite=$1.dnsunlock.com'
    - '||foxsoccershop.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxsports-chicago.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxsports-newyork.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxsports-world.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxsports.cl^$dnsrewrite=$1.dnsunlock.com'
    - '||foxsports.co^$dnsrewrite=$1.dnsunlock.com'
    - '||foxsports.co.ve^$dnsrewrite=$1.dnsunlock.com'
    - '||foxsports.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxsports.com.ar^$dnsrewrite=$1.dnsunlock.com'
    - '||foxsports.com.bo^$dnsrewrite=$1.dnsunlock.com'
    - '||foxsports.com.br^$dnsrewrite=$1.dnsunlock.com'
    - '||foxsports.com.co^$dnsrewrite=$1.dnsunlock.com'
    - '||foxsports.com.ec^$dnsrewrite=$1.dnsunlock.com'
    - '||foxsports.com.gt^$dnsrewrite=$1.dnsunlock.com'
    - '||foxsports.com.mx^$dnsrewrite=$1.dnsunlock.com'
    - '||foxsports.com.pe^$dnsrewrite=$1.dnsunlock.com'
    - '||foxsports.com.py^$dnsrewrite=$1.dnsunlock.com'
    - '||foxsports.com.uy^$dnsrewrite=$1.dnsunlock.com'
    - '||foxsports.com.ve^$dnsrewrite=$1.dnsunlock.com'
    - '||foxsports.gt^$dnsrewrite=$1.dnsunlock.com'
    - '||foxsports.info^$dnsrewrite=$1.dnsunlock.com'
    - '||foxsports.net^$dnsrewrite=$1.dnsunlock.com'
    - '||foxsports.net.br^$dnsrewrite=$1.dnsunlock.com'
    - '||foxsports.pe^$dnsrewrite=$1.dnsunlock.com'
    - '||foxsports.sv^$dnsrewrite=$1.dnsunlock.com'
    - '||foxsports.uy^$dnsrewrite=$1.dnsunlock.com'
    - '||foxsports2.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxsportsflorida.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxsportsgo.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxsportsla.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxsportsnetmilwaukee.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxsportsneworleans.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxsportsracing.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxsportssupports.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxsportsuniversity.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxsportsworld.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxstudiolot.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxsuper6.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxtel.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxtel.com.au^$dnsrewrite=$1.dnsunlock.com'
    - '||foxtelevisionstations.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxtv.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxtvdvd.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxuv.com^$dnsrewrite=$1.dnsunlock.com'
    - '||foxweatherwatch.com^$dnsrewrite=$1.dnsunlock.com'
    - '||fssta.com^$dnsrewrite=$1.dnsunlock.com'
    - '||fxn.ws^$dnsrewrite=$1.dnsunlock.com'
    - '||fxnetwork.com^$dnsrewrite=$1.dnsunlock.com'
    - '||fxnetworks.com^$dnsrewrite=$1.dnsunlock.com'
    - '# Bento Box Entertainment'
    - '||bentobox.tv^$dnsrewrite=$1.dnsunlock.com'
    - '# KTVU FOX'
    - '||kicu.tv^$dnsrewrite=$1.dnsunlock.com'
    - '||ktvu.com^$dnsrewrite=$1.dnsunlock.com'
    - '||myfoxsanfran.com^$dnsrewrite=$1.dnsunlock.com'
    - '# Other '
    - '||afewmomentswith.com^$dnsrewrite=$1.dnsunlock.com'
    - '||anidom.com^$dnsrewrite=$1.dnsunlock.com'
    - '||casoneexchange.com^$dnsrewrite=$1.dnsunlock.com'
    - '||coronavirusnow.com^$dnsrewrite=$1.dnsunlock.com'
    - '||fse.tv^$dnsrewrite=$1.dnsunlock.com'
    - '||geraldoatlarge.com^$dnsrewrite=$1.dnsunlock.com'
    - '||gooddaychicago.com^$dnsrewrite=$1.dnsunlock.com'
    - '||joeswall.com^$dnsrewrite=$1.dnsunlock.com'
    - '||kilmeadeandfriends.com^$dnsrewrite=$1.dnsunlock.com'
    - '||maskedsingerfox.com^$dnsrewrite=$1.dnsunlock.com'
    - '||my13la.com^$dnsrewrite=$1.dnsunlock.com'
    - '||my20dc.com^$dnsrewrite=$1.dnsunlock.com'
    - '||my20houston.com^$dnsrewrite=$1.dnsunlock.com'
    - '||my29tv.com^$dnsrewrite=$1.dnsunlock.com'
    - '||my45.com^$dnsrewrite=$1.dnsunlock.com'
    - '||my9nj.com^$dnsrewrite=$1.dnsunlock.com'
    - '||myfoxatlanta.com^$dnsrewrite=$1.dnsunlock.com'
    - '||myfoxaustin.com^$dnsrewrite=$1.dnsunlock.com'
    - '||myfoxboston.com^$dnsrewrite=$1.dnsunlock.com'
    - '||myfoxcharlotte.com^$dnsrewrite=$1.dnsunlock.com'
    - '||myfoxchicago.com^$dnsrewrite=$1.dnsunlock.com'
    - '||myfoxdc.com^$dnsrewrite=$1.dnsunlock.com'
    - '||myfoxdetroit.com^$dnsrewrite=$1.dnsunlock.com'
    - '||myfoxdfw.com^$dnsrewrite=$1.dnsunlock.com'
    - '||myfoxhouston.com^$dnsrewrite=$1.dnsunlock.com'
    - '||myfoxhurricane.com^$dnsrewrite=$1.dnsunlock.com'
    - '||myfoxla.com^$dnsrewrite=$1.dnsunlock.com'
    - '||myfoxlosangeles.com^$dnsrewrite=$1.dnsunlock.com'
    - '||myfoxlubbock.com^$dnsrewrite=$1.dnsunlock.com'
    - '||myfoxmaine.com^$dnsrewrite=$1.dnsunlock.com'
    - '||myfoxny.com^$dnsrewrite=$1.dnsunlock.com'
    - '||myfoxorlando.com^$dnsrewrite=$1.dnsunlock.com'
    - '||myfoxphilly.com^$dnsrewrite=$1.dnsunlock.com'
    - '||myfoxphoenix.com^$dnsrewrite=$1.dnsunlock.com'
    - '||myfoxtampa.com^$dnsrewrite=$1.dnsunlock.com'
    - '||myfoxtampabay.com^$dnsrewrite=$1.dnsunlock.com'
    - '||myfoxtwincities.com^$dnsrewrite=$1.dnsunlock.com'
    - '||myfoxzone.com^$dnsrewrite=$1.dnsunlock.com'
    - '||myq2.com^$dnsrewrite=$1.dnsunlock.com'
    - '||newsnowfox.com^$dnsrewrite=$1.dnsunlock.com'
    - '||orlandohurricane.com^$dnsrewrite=$1.dnsunlock.com'
    - '||paradisehotelquizfox.com^$dnsrewrite=$1.dnsunlock.com'
    - '||q13.com^$dnsrewrite=$1.dnsunlock.com'
    - '||q13fox.com^$dnsrewrite=$1.dnsunlock.com'
    - '||realamericanstories.com^$dnsrewrite=$1.dnsunlock.com'
    - '||realamericanstories.info^$dnsrewrite=$1.dnsunlock.com'
    - '||realamericanstories.net^$dnsrewrite=$1.dnsunlock.com'
    - '||realamericanstories.org^$dnsrewrite=$1.dnsunlock.com'
    - '||realamericanstories.tv^$dnsrewrite=$1.dnsunlock.com'
    - '||realmilwaukeenow.com^$dnsrewrite=$1.dnsunlock.com'
    - '||rprimelab.com^$dnsrewrite=$1.dnsunlock.com'
    - '||shopspeedtv.com^$dnsrewrite=$1.dnsunlock.com'
    - '||soccermatchpass.com^$dnsrewrite=$1.dnsunlock.com'
    - '||speeddreamride.com^$dnsrewrite=$1.dnsunlock.com'
    - '||speedfantasybid.com^$dnsrewrite=$1.dnsunlock.com'
    - '||speedracegear.com^$dnsrewrite=$1.dnsunlock.com'
    - '||speedxtra.com^$dnsrewrite=$1.dnsunlock.com'
    - '||teenchoice.com^$dnsrewrite=$1.dnsunlock.com'
    - '||testonfox.com^$dnsrewrite=$1.dnsunlock.com'
    - '||theclasshroom.com^$dnsrewrite=$1.dnsunlock.com'
    - '||thefoxnation.com^$dnsrewrite=$1.dnsunlock.com'
    - '||thegeorgiascene.com^$dnsrewrite=$1.dnsunlock.com'
    - '||whatthefox.com^$dnsrewrite=$1.dnsunlock.com'
    - '||whosthehost.com^$dnsrewrite=$1.dnsunlock.com'
    - '||wofl.tv^$dnsrewrite=$1.dnsunlock.com'
    - '||woflthenewsstation.com^$dnsrewrite=$1.dnsunlock.com'
    - '||wogx.com^$dnsrewrite=$1.dnsunlock.com'
    - '#bahamut'
    - '||hinet.net^$dnsrewrite=$1.dnsunlock.com'
    - '||gamer.com.tw^$dnsrewrite=$1.dnsunlock.com'
    - '||bahamut.com.tw^$dnsrewrite=$1.dnsunlock.com'
    - '||pp-measurement.com^$dnsrewrite=$1.dnsunlock.com'
    - '#iqiyi'
    - '||71.am^$dnsrewrite=$1.dnsunlock.com'
    - '||iqiyi.com^$dnsrewrite=$1.dnsunlock.com'
    - '||iqiyipic.com^$dnsrewrite=$1.dnsunlock.com'
    - '||pps.tv^$dnsrewrite=$1.dnsunlock.com'
    - '||ppsimg.com^$dnsrewrite=$1.dnsunlock.com'
    - '||qiyi.com^$dnsrewrite=$1.dnsunlock.com'
    - '||qiyipic.com^$dnsrewrite=$1.dnsunlock.com'
    - '||qy.net^$dnsrewrite=$1.dnsunlock.com'
    - '#tvb'
    - '||bigbigchannel.com.hk^$dnsrewrite=$1.dnsunlock.com'
    - '||bigbigshop.com^$dnsrewrite=$1.dnsunlock.com'
    - '||encoretvb.com^$dnsrewrite=$1.dnsunlock.com'
    - '||tvb.com^$dnsrewrite=$1.dnsunlock.com'
    - '||tvb.com.au^$dnsrewrite=$1.dnsunlock.com'
    - '||tvbanywhere.com^$dnsrewrite=$1.dnsunlock.com'
    - '||tvbanywhere.com.sg^$dnsrewrite=$1.dnsunlock.com'
    - '||tvbc.com.cn^$dnsrewrite=$1.dnsunlock.com'
    - '||tvbeventpower.com.hk^$dnsrewrite=$1.dnsunlock.com'
    - '||tvbusa.com^$dnsrewrite=$1.dnsunlock.com'
    - '||tvbweekly.com^$dnsrewrite=$1.dnsunlock.com'
    - '||tvmedia.net.au^$dnsrewrite=$1.dnsunlock.com'
    - '||windows.net^$dnsrewrite=$1.dnsunlock.com'
    - '||omtrdc.net^$dnsrewrite=$1.dnsunlock.com'
    - '||mytvsuper.com^$dnsrewrite=$1.dnsunlock.com'
    - '#abema'
    - '||abema.io^$dnsrewrite=$1.dnsunlock.com'
    - '||abema.tv^$dnsrewrite=$1.dnsunlock.com'
    - '||adx.promo^$dnsrewrite=$1.dnsunlock.com'
    - '||ameba.jp^$dnsrewrite=$1.dnsunlock.com'
    - '||amebame.com^$dnsrewrite=$1.dnsunlock.com'
    - '||amebaownd.com^$dnsrewrite=$1.dnsunlock.com'
    - '||amebaowndme.com^$dnsrewrite=$1.dnsunlock.com'
    - '||ameblo.jp^$dnsrewrite=$1.dnsunlock.com'
    - '||bucketeer.jp^$dnsrewrite=$1.dnsunlock.com'
    - '||dokusho-ojikan.jp^$dnsrewrite=$1.dnsunlock.com'
    - '||hayabusa.dev^$dnsrewrite=$1.dnsunlock.com'
    - '||hayabusa.io^$dnsrewrite=$1.dnsunlock.com'
    - '||hayabusa.media^$dnsrewrite=$1.dnsunlock.com'
    - '||winticket.jp^$dnsrewrite=$1.dnsunlock.com'
    - '||akamaized.net^$dnsrewrite=$1.dnsunlock.com'
    - '#dmm'
    - '||dmm.com^$dnsrewrite=$1.dnsunlock.com'
    - '||dmm.co.jp^$dnsrewrite=$1.dnsunlock.com'
    - '||dmmgames.com^$dnsrewrite=$1.dnsunlock.com'
    - '||dmm.hk^$dnsrewrite=$1.dnsunlock.com'
    - '||dmm-extension.com^$dnsrewrite=$1.dnsunlock.com'
    - '||dmmapis.com^$dnsrewrite=$1.dnsunlock.com'
    - '#dazn'
    - '||dazn-api.com^$dnsrewrite=$1.dnsunlock.com'
    - '||dazn.com^$dnsrewrite=$1.dnsunlock.com'
    - '||dazndn.com^$dnsrewrite=$1.dnsunlock.com'
    - '||indazn.com^$dnsrewrite=$1.dnsunlock.com'
    - '||indaznlab.com^$dnsrewrite=$1.dnsunlock.com'
    - '#cygames'
    - '||cygames.jp^$dnsrewrite=$1.dnsunlock.com'
    dhcp:
      enabled: false
      interface_name: ""
      dhcpv4:
        gateway_ip: ""
        subnet_mask: ""
        range_start: ""
        range_end: ""
        lease_duration: 86400
        icmp_timeout_msec: 1000
        options: []
      dhcpv6:
        range_start: ""
        lease_duration: 86400
        ra_slaac_only: false
        ra_allow_slaac: false
    clients: []
    log_compress: false
    log_localtime: false
    log_max_backups: 0
    log_max_size: 100
    log_max_age: 3
    log_file: ""
    verbose: false
    schema_version: 10
    EOF
    cp /root/sniproxyinstall/nginxdns.conf /usr/local/openresty/nginx/conf/nginx.conf
    chmod +x /root/sniproxyinstall/ipwhite
    chmod +x /root/sniproxyinstall/ddns
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
