# 2026-11-11 21:13:05 by RouterOS 7.25.1
# system id = pEDSXaHXN3J
#
# custom default configuration script installed
# see /system/default-configuration/custom-script/print
#
/certificate scep-server add ca-cert=ca@CHR days-valid=365 path=/scep/grant request-lifetime=5m
/container config set layer-dir=/docker/layers memory-high=768.0MiB registry-url=https://registry-1.docker.io tmpdir=/docker/pulls
/container envs add key=CADDY_INT_PORT list=CADDY_ENVS value=4430
/container envs add key=CADDY_MAIN_PORT list=CADDY_ENVS value=1443
/container envs add key=DOMAIN list=CADDY_ENVS value=usetheforce.io
/container envs add key=INTERNAL_DOMAIN list=CADDY_ENVS value=internal.chr.home
/container envs add key=COMMIT_ON_START list=GITWATCH_ENVS value=true
/container envs add key=GIT_BRANCH list=GITWATCH_ENVS value=_autobranch
/container envs add key=GIT_REMOTE list=GITWATCH_ENVS value=origin
/container envs add key=GIT_WATCH_DIR list=GITWATCH_ENVS value=/app/watched-repo
/container envs add key=PULL_BEFORE_PUSH list=GITWATCH_ENVS value=true
/container envs add key=SLEEP_TIME list=GITWATCH_ENVS value=40
/container envs add key=VERBOSE list=GITWATCH_ENVS value=true
/container envs add key=API_SERVER_CORS_ORIGINS list=HERMES_ENVS value=*
/container envs add key=API_SERVER_ENABLED list=HERMES_ENVS value=true
/container envs add key=API_SERVER_HOST list=HERMES_ENVS value=0.0.0.0
/container envs add key=API_SERVER_KEY list=HERMES_ENVS value=1b1f78b8ed4a27222ffeac8f3640276966109486fe551f47dce31aa2b6f3a652
/container envs add key=GATEWAY_ALLOW_ALL_USERS list=HERMES_ENVS value=true
/container envs add key=HERMES_DASHBOARD list=HERMES_ENVS value=1
/container envs add key=HERMES_DASHBOARD_BASIC_AUTH_PASSWORD list=HERMES_ENVS value=WSXWj+//8uR0WcsyTk52+2idMftvwC1U
/container envs add key=HERMES_DASHBOARD_BASIC_AUTH_SECRET list=HERMES_ENVS value="BxYrrVZaY5liOg8YEsoLuhNX7FcsbkGxhDlJ1mcmXfM="
/container envs add key=HERMES_DASHBOARD_BASIC_AUTH_USERNAME list=HERMES_ENVS value=hermes
/container envs add key=HERMES_DASHBOARD_HOST list=HERMES_ENVS value=0.0.0.0
/container envs add key=HERMES_DASHBOARD_PORT list=HERMES_ENVS value=9119
/container envs add disabled=yes key=HERMES_HOME_MODE list=HERMES_ENVS value=0755
/container envs add disabled=yes key=PGID list=HERMES_ENVS value=0
/container envs add disabled=yes key=PUID list=HERMES_ENVS value=0
/container envs add comment="debug, info" key=RUST_LOG list=TELEMT_ENVS value=debug
/container mounts add dst=/srv list=CADDY_VOLUMES mode=ro src=/docker/runs/caddy/caddy_site
/container mounts add dst=/data list=CADDY_VOLUMES src=/docker/runs/caddy/caddy_data
/container mounts add dst=/config list=CADDY_VOLUMES src=/docker/runs/caddy/caddy_config
/container mounts add dst=/etc/caddy list=CADDY_VOLUMES src=/docker/runs/caddy/caddy_setup
/container mounts add dst=/app/watched-repo list=GITWATCH_VOLUMES src=/REPO/raw
/container mounts add dst=/etc/glider list=GLIDER_VOLUMES mode=ro src=/docker/runs/Glider
/container mounts add dst=/certs list=GLIDER_VOLUMES mode=ro src=/docker/runs/caddy/caddy_data/caddy/certificates/acme-v02.api.letsencrypt.org-directory/proxy.usetheforce.io
/container mounts add dst=/usr/local/etc/haproxy list=HAPROXY_VOLUMES mode=ro src=/docker/runs/haproxy
/container mounts add dst=/opt/data list=HERMES_VOLUMES src=/docker/runs/hermes1
/container mounts add dst=/etc/telemt list=TELEMT_VOLUMES src=/docker/runs/telemt
/container mounts add dst=/etc/telemt-panel/config.toml list=TELEMT_WEBUI_VOLUMES src=/docker/runs/telemt-webui/webui.toml
/interface list add comment="trusted interfaces" name=list-trusted
/interface list add comment="Semi-Trusted networks" name=list-semi-trusted
/interface list add comment="Untrusted networks" name=list-untrusted
/interface list add comment="FW: winbox allowed interfaces" name=list-winbox-allowed
/interface list add comment="includes l2tp client interfaces when UP" name=list-l2tp-tunnels
/interface list add comment="FW: drop invalid conn" name=list-drop-invalid-connections
/interface list add comment="LAN intefaces" name=list-autodetect-LAN
/interface list add comment="WAN interfaces" name=list-autodetect-WAN
/interface list add comment="Internet interfaces" name=list-autodetect-INTERNET
/interface list add comment="neighbors allowed interfaces" name=list-neighbors-lookup
/interface list add comment="infrastructure OSPF interfaces" name=list-ospf-master
/interface list add comment="support OSPF interfaces" name=list-ospf-bearing
/interface list add comment="FW: allow router cerfices from LAN" name=list-FW-allow-router-services-LAN
/interface list add comment="FW: allow router cerfices from WAN" name=list-FW-allow-router-services-WAN
/interface list add comment="FW:prevent DNS req from WAN" name=list-FW-prevent-dns-requests-WAN
/interface list add comment="FW: allow port redirect from WAN" name=list-FW-allow-port-redirect-WAN
/interface list add comment="FW: hairpin\\loopback from LAN" name=list-mangle-loopback-LAN
/interface list add comment="FW: listen to Portknocking" name=list-FW-portknocking
/interface bridge settings set use-ip-firewall=yes
/ip firewall connection tracking set enabled=yes udp-timeout=10s
/ip neighbor discovery-settings set discover-interface-list=list-neighbors-lookup
/ip settings set accept-source-route=yes allow-fast-path=no max-neighbor-entries=8192 rp-filter=loose tcp-syncookies=yes
/ipv6 settings set disable-ipv6=yes max-neighbor-entries=8192 soft-max-neighbor-entries=8191
/interface detect-internet set internet-interface-list=list-autodetect-INTERNET lan-interface-list=list-autodetect-LAN wan-interface-list=list-autodetect-WAN
/ip cloud set ddns-enabled=yes ddns-update-interval=10m
/ip dhcp-server option add code=15 name=DomainName value="s'home'"
/ip dhcp-server network add address=10.0.0.0/29 dns-server=8.8.8.8,8.8.4.4 gateway=10.0.0.1
/ip dhcp-server network add address=192.168.97.0/29 gateway=192.168.97.1
/ip dns static add address=192.168.90.70 name=minialx.home type=A
/ip dns static add cname=minialx.home name=minialx type=CNAME
/ip dns static add address=192.168.90.40 name=nas.home type=A
/ip dns static add cname=nas.home name=nas type=CNAME
/ip dns static add address=192.168.99.1 name=mikrouter.home type=A
/ip dns static add cname=mikrouter.home name=mikrouter type=CNAME
/ip dns static add address=192.168.90.1 name=anna.home type=A
/ip dns static add cname=anna.home name=anna type=CNAME
/ip dns static add address=192.168.90.2 name=wb.home type=A
/ip dns static add cname=wb.home name=wb type=CNAME
/ip dns static add address=192.168.97.1 name=chr.home type=A
/ip dns static add address=172.17.0.4 match-subdomain=yes name=internal.chr.home type=A
/ip dns static add address=192.168.97.4 match-subdomain=yes name=haproxy.chr.home type=A
/ip dns static add address=172.17.0.3 match-subdomain=yes name=webui.chr.home type=A
/ip dns static add address=172.17.0.2 match-subdomain=yes name=telemt.chr.home type=A
/ip dns static add address=172.17.0.4 match-subdomain=yes name=caddy.chr.home type=A
/ip dns static add address=172.17.0.7 match-subdomain=yes name=hermes.chr.home type=A
/ip dns static add cname=chr.home name=chr type=CNAME
/ip dns static add address=192.168.90.10 name=capxl.home type=A
/ip dns static add cname=capxl.home name=capxl type=CNAME
/ip dns static add address=192.168.90.85 name=MbpAlxm.home type=A
/ip dns static add cname=MbpAlxm.home name=MbpAlxm type=CNAME
/ip dns static add cname=victoria.home name=victoria type=CNAME
/ip dns static add address=192.168.90.1 name=victoria.home type=A
/ip dns static add address=185.13.148.14 name=ftpserver.org type=A
/ip firewall address-list add address=192.168.97.0/24 list=alist-fw-local-subnets
/ip firewall address-list add address=192.168.97.0/24 list=alist-nat-local-subnets
/ip firewall address-list add address=0.0.0.0/8 comment="RFC 1122 \"This host on this network\"" disabled=yes list=alist-fw-rfc-special
/ip firewall address-list add address=10.0.0.0/8 comment="RFC 1918 (Private Use IP Space)" disabled=yes list=alist-fw-rfc-special
/ip firewall address-list add address=100.64.0.0/10 comment="RFC 6598 (Shared Address Space)" list=alist-fw-rfc-special
/ip firewall address-list add address=127.0.0.0/8 comment="RFC 1122 (Loopback)" disabled=yes list=alist-fw-rfc-special
/ip firewall address-list add address=169.254.0.0/16 comment="RFC 3927 (Dynamic Configuration of IPv4 Link-Local Addresses)" list=alist-fw-rfc-special
/ip firewall address-list add address=172.16.0.0/12 comment="RFC 1918 (Private Use IP Space)" disabled=yes list=alist-fw-rfc-special
/ip firewall address-list add address=192.0.0.0/24 comment="RFC 6890 (IETF Protocol Assingments)" list=alist-fw-rfc-special
/ip firewall address-list add address=192.0.2.0/24 comment="RFC 5737 (Test-Net-1)" list=alist-fw-rfc-special
/ip firewall address-list add address=192.168.0.0/16 comment="RFC 1918 (Private Use IP Space)" disabled=yes list=alist-fw-rfc-special
/ip firewall address-list add address=198.18.0.0/15 comment="RFC 2544 (Benchmarking)" list=alist-fw-rfc-special
/ip firewall address-list add address=198.51.100.0/24 comment="RFC 5737 (Test-Net-2)" list=alist-fw-rfc-special
/ip firewall address-list add address=203.0.113.0/24 comment="RFC 5737 (Test-Net-3)" list=alist-fw-rfc-special
/ip firewall address-list add address=224.0.0.0/4 comment="RFC 5771 (Multicast Addresses) - Will affect OSPF, RIP, PIM, VRRP, IS-IS, and others. Use with caution.)" list=alist-fw-rfc-special
/ip firewall address-list add address=240.0.0.0/4 comment="RFC 1112 (Reserved)" list=alist-fw-rfc-special
/ip firewall address-list add address=192.31.196.0/24 comment="RFC 7535 (AS112-v4)" list=alist-fw-rfc-special
/ip firewall address-list add address=192.52.193.0/24 comment="RFC 7450 (AMT)" list=alist-fw-rfc-special
/ip firewall address-list add address=192.88.99.0/24 comment="RFC 7526 (Deprecated (6to4 Relay Anycast))" list=alist-fw-rfc-special
/ip firewall address-list add address=192.175.48.0/24 comment="RFC 7534 (Direct Delegation AS112 Service)" list=alist-fw-rfc-special
/ip firewall address-list add address=255.255.255.255 comment="RFC 919 (Limited Broadcast)" list=alist-fw-rfc-special
/ip firewall address-list add address=192.168.90.0/24 comment="Add DNS Server to this List" list=alist-fw-dns-allow
/ip firewall address-list add address=8.8.8.8 comment="Add DNS Server to this List" list=alist-fw-dns-allow
/ip firewall address-list add address=8.8.4.4 comment="Add DNS Server to this List" list=alist-fw-dns-allow
/ip firewall address-list add address=4.2.2.2 comment="Add DNS Server to this List" list=alist-fw-dns-allow
/ip firewall address-list add address=185.6.175.49 comment="Manual Black List" list=alist-fw-manual-block
/ip firewall address-list add address=192.168.97.0/24 list=alist-fw-rdp-allow
/ip firewall address-list add address=192.168.97.0/24 list=alist-fw-smb-allow
/ip firewall address-list add address=185.13.148.14 list=alist-fw-vpn-server-addr
/ip firewall address-list add address=rutracker.org list=alist-mangle-vpn-tunneled-sites
/ip firewall address-list add address=192.168.97.0/24 list=alist-fw-vpn-subnets
/ip firewall address-list add address=10.0.0.0/29 list=alist-fw-vpn-server-addr
/ip firewall address-list add address=10.0.0.0/29 list=alist-fw-vpn-subnets
/ip firewall address-list add address=nnmclub.me list=alist-mangle-vpn-tunneled-sites
/ip firewall address-list add address=10.0.0.0/29 list=alist-fw-local-subnets
/ip firewall address-list add address=10.0.0.0/29 list=alist-nat-local-subnets
/ip firewall address-list add address=myexternalip.com list=alist-mangle-vpn-tunneled-sites
/ip firewall address-list add address=serverfault.com list=alist-mangle-vpn-tunneled-sites
/ip firewall address-list add address=telegram.org list=alist-fw-telegram-servers
/ip firewall address-list add address=grafana.home list=alist-nat-grafana-server
/ip firewall address-list add address=grafanasvc.home list=alist-nat-grafana-service
/ip firewall address-list add address=influxdb.home list=alist-nat-influxdb-server
/ip firewall address-list add address=influxdbsvc.home list=alist-nat-influxdb-service
/ip firewall address-list add address=192.168.97.1 comment="Add DNS Server to this List" list=alist-fw-dns-allow
/ip firewall address-list add address=10.0.0.1 comment="Add DNS Server to this List" list=alist-fw-dns-allow
/ip firewall address-list add address=185.13.148.14 comment="Add DNS Server to this List" list=alist-fw-dns-allow
/ip firewall address-list add address=lostfilm.tv list=alist-mangle-vpn-tunneled-sites
/ip firewall address-list add address=nnmclub.to list=alist-mangle-vpn-tunneled-sites
/ip firewall address-list add address=radarr.video list=alist-mangle-vpn-tunneled-sites
/ip firewall address-list add address=themoviedb.org list=alist-mangle-vpn-tunneled-sites
/ip firewall address-list add address=tmdb.org list=alist-mangle-vpn-tunneled-sites
/ip firewall address-list add address=192.168.99.0/24 comment="Add DNS Server to this List" list=alist-fw-dns-allow
/ip firewall address-list add address=haproxy.chr.home comment="Do not masquarade HAProxy" list=alist-nat-preserve-wan-ip
/ip firewall address-list add address=0.0.0.0/8 comment="GLIDER denied" list=glider-denied
/ip firewall address-list add address=10.0.0.0/8 comment="GLIDER denied" list=glider-denied
/ip firewall address-list add address=100.64.0.0/10 comment="GLIDER denied" list=glider-denied
/ip firewall address-list add address=127.0.0.0/8 comment="GLIDER denied" list=glider-denied
/ip firewall address-list add address=169.254.0.0/16 comment="GLIDER denied" list=glider-denied
/ip firewall address-list add address=172.16.0.0/12 comment="GLIDER denied" list=glider-denied
/ip firewall address-list add address=192.168.0.0/16 comment="GLIDER denied" list=glider-denied
/ip firewall address-list add address=224.0.0.0/3 comment="GLIDER denied" list=glider-denied
/ip firewall address-list add address=185.13.148.14 comment="GLIDER own public address" list=glider-denied
/ip firewall address-list add address=185.13.148.14 list=alist-nat-external-ip
/ip firewall address-list add address=10.255.255.1 comment="Self lo" list=alist-fw-ssh-allow
/ip firewall address-list add address=193.187.110.160 list=alist-fw-ssh-ban
/ip firewall service-port set ftp disabled=yes
/ip firewall service-port set tftp disabled=yes
/ip firewall service-port set h323 disabled=yes
/ip firewall service-port set sip disabled=yes
/ip firewall service-port set pptp disabled=yes
/ip ipsec profile set [ find default=yes ] dh-group=modp1024 dpd-interval=2m dpd-maximum-failures=5
/ip ipsec proposal set [ find default=yes ] auth-algorithms=sha256 enc-algorithms=aes-256-cbc,aes-192-cbc,aes-128-cbc,3des lifetime=1h
/ip kid-control add fri=0s-1d mon=0s-1d name=totals sat=0s-1d sun=0s-1d thu=0s-1d tue=0s-1d wed=0s-1d
/ip pool add name=pool-vpn ranges=10.0.0.0/29
/ip pool add name=pool-dhcp ranges=192.168.97.0/29
/ip pool add name=pool-rw ranges=10.10.10.8/29
/ip smb users set [ find default=yes ] disabled=yes
/ip ssh set ciphers=aes-gcm,aes-ctr,aes-cbc,3des-cbc,null forwarding-enabled=remote host-key-type=rsa known-hosts-validation=no password-authentication=yes
/ip tftp add disabled=yes real-filename=NAS/ req-filename=.*
/ip service set ftp disabled=yes
/ip service set telnet disabled=yes
/ip service set ssh port=2223
/ip service set reverse-proxy certificate=chr.webserver@CHR port=4443 tls-version=only-1.2
/ip service set www-ssl certificate=chr.webserver@CHR disabled=no port=5443
/ip service set api-ssl disabled=yes tls-version=only-1.2
/ip service set www port=8888
/ip service set api port=56911
/ppp profile add address-list=l2tp-active-clients dns-server=8.8.8.8,8.8.4.4 interface-list=list-l2tp-tunnels local-address=10.0.0.1 name=l2tp-no-encrypt-site2site only-one=no remote-address=pool-vpn use-ipv6=no
/ppp profile add address-list=l2tp-active-clients dns-server=8.8.8.8,8.8.4.4 interface-list=list-l2tp-tunnels local-address=10.0.0.1 name=l2tp-no-encrypt-ios-rw only-one=no remote-address=pool-rw
/ppp profile add bridge-learning=no change-tcp-mss=no comment="used by \$SECRET" local-address=0.0.0.0 name=null only-one=yes remote-address=0.0.0.0 session-timeout=1s use-compression=no use-encryption=no use-mpls=no use-upnp=no
/interface bridge add name=docker-infrastructure-br port-cost-mode=short protocol-mode=none
/interface bridge add arp=proxy-arp fast-forward=no name=main-infrastructure-br port-cost-mode=short
/interface ethernet set [ find default-name=ether1 ] arp=proxy-arp comment="Trivial WAN" disable-running-check=no name=wan
/interface l2tp-server add disabled=yes name=rw-alx user=vpn-user-alx
/interface l2tp-server add name=tunnel-anna user=vpn-remote-anna
/interface l2tp-server add disabled=yes name=tunnel-mikrotik user=vpn-remote-mic
/interface veth add address=172.17.0.4/28 container-mac-address=22:35:59:47:36:AD dhcp=no gateway=172.17.0.1 gateway6="" mac-address=22:35:59:47:36:AC name=veth-caddy
/interface veth add address=172.17.0.5/28 container-mac-address=12:A7:68:6A:F3:73 dhcp=no gateway=172.17.0.1 gateway6="" mac-address=12:A7:68:6A:F3:72 name=veth-gitwatch
/interface veth add address=172.17.0.6/28 comment="GLIDER shared bridge" container-mac-address=16:24:E8:03:D8:02 dhcp=no gateway=172.17.0.1 gateway6="" mac-address=16:24:E8:03:D8:01 name=veth-glider
/interface veth add address=192.168.97.4/29 container-mac-address=2E:DD:B8:89:61:B9 dhcp=no gateway=192.168.97.1 gateway6="" mac-address=2E:DD:B8:89:61:B8 name=veth-haproxy
/interface veth add address=172.17.0.7/28 container-mac-address=36:5D:EA:5F:7B:3A dhcp=no gateway=172.17.0.1 gateway6="" mac-address=36:5D:EA:5F:7B:39 name=veth-hermes
/interface veth add address=172.17.0.2/28 container-mac-address=26:8A:0C:A0:3E:3B dhcp=no gateway=172.17.0.1 gateway6="" mac-address=26:8A:0C:A0:3E:3A name=veth-telemt
/interface veth add address=172.17.0.3/28 container-mac-address=30:A6:92:7E:80:32 dhcp=no gateway=172.17.0.1 gateway6="" mac-address=30:A6:92:7E:80:31 name=veth-telemt-webui
/interface wireguard add listen-port=65114 mtu=1420 name=wg-to-capax
/container add check-certificate=no cmd=/etc/telemt/config.toml comment="MTProto telegram proxy" dns=192.168.97.1 envlists=TELEMT_ENVS healthcheck-cmd=CMD,/app/telemt,healthcheck,/etc/telemt/config.toml,--mode,liveness healthcheck-status="failed with exit code 1, tries 6923/3, output: [telemt] healthcheck failed: invalid HTTP response headers\
    \n" hostname=telemt interface=veth-telemt layer-dir=/docker/layers logging=yes memory-high=256.0MiB mountlists=TELEMT_VOLUMES name=telemt remote-image=ghcr.io/telemt/telemt:latest root-dir=/docker/runs/telemt start-on-boot=yes user=0:0 workdir=/tmp
/container add check-certificate=no comment="MTProto telegram proxy web panel" dns=192.168.97.1 hostname=telemt-webui interface=veth-telemt-webui layer-dir=/docker/layers logging=yes memory-high=256.0MiB mountlists=TELEMT_WEBUI_VOLUMES name=telemt-webui remote-image=ghcr.io/amirotin/telemt_panel:latest root-dir=/docker/runs/telemt-webui start-on-boot=yes
/container add check-certificate=no comment="Caddy web server and reverse proxy" dns=192.168.97.1 envlists=CADDY_ENVS hostname=caddy interface=veth-caddy layer-dir=/docker/layers logging=yes memory-high=200.0MiB mountlists=CADDY_VOLUMES name=caddy remote-image=caddy:latest root-dir=/docker/runs/caddy start-on-boot=yes user=0:0 workdir=/srv
/container add check-certificate=no comment=HAproxy dns=192.168.97.1 hostname=haproxy interface=veth-haproxy layer-dir=/docker/layers logging=yes memory-high=200.0MiB mountlists=HAPROXY_VOLUMES name=haproxy remote-image=haproxy:latest root-dir=/docker/runs/haproxy start-on-boot=yes user=0:0 workdir=/var/lib/haproxy
/container add check-certificate=no cmd="hermes gateway run" comment="Hermes AI agent" dns=192.168.97.1 entrypoint="" envlists=HERMES_ENVS hostname=hermes interface=veth-hermes layer-dir=/docker/layers logging=yes mountlists=HERMES_VOLUMES name=hermes remote-image=docker.io/nousresearch/hermes-agent:latest root-dir=/docker/depl/hermes start-on-boot=yes workdir=/tmp
/container add cmd="-config=/etc/glider/glider.conf" comment="Global forward-proxy" dns=1.1.1.1 interface=veth-glider layer-dir=/docker/layers logging=yes memory-high=64.0MiB memory-max=128.0MiB mountlists=GLIDER_VOLUMES name=glider remote-image=nadoo/glider:latest root-dir=/docker/depl/glider start-on-boot=yes user=0:0
/container add check-certificate=no comment="gitwatch autocommit utility" dns=192.168.97.1 envlists=GITWATCH_ENVS hostname=gitwatch interface=veth-gitwatch layer-dir=/docker/layers logging=yes memory-high=200.0MiB mountlists=GITWATCH_VOLUMES name=gitwatch remote-image=ghcr.io/gitwatch/gitwatch:latest root-dir=/docker/depl/gitwatch start-on-boot=yes user=0:0
/app set cinny firewall-redirects=8094:80:tcp:web
/app set goaway container-command-lines=goaway:none:docker.io/pommee/goaway:latest
/app set hermes-agent network-outgoing-access=no
/app set home-assistant container-command-lines=home-assistant:none:lscr.io/linuxserver/homeassistant
/app set n8n firewall-redirects=5678:5678:tcp:web
/app set nextcloud container-command-lines="db:none:docker.io/postgres:17,redis:none:docker.io/valkey/valkey:/bin/sh -c 'valkey-server --port 6379 --appendonly yes --requirepass \$VALKEY_PASSWORD',server:none:docker.io/nextcloud:apache"
/app set partdb container-command-lines=partdb:none:docker.io/jbtronics/part-db1:latest
/app set redlib firewall-redirects=8087:8080:tcp:web
/app set solr container-command-lines=solr:none:docker.io/solr:latest
/app set speedketchup container-command-lines="speedketchup:none:docker.io/antonsmt/speedketchup:-a 0.0.0.0 -f /results/speedketchup-results.csv"
/app set uptime-kuma container-command-lines=uptime-kuma:none:docker.io/louislam/uptime-kuma:1
/disk add comment=Ramdisk slot=RAM tmpfs-max-size=100000000 type=tmpfs
/disk add file-path=/ssd/swap file-size=1023.6MiB media-interface=main-infrastructure-br slot=file-ssd-swap swap=yes type=file
/disk set ssd slot=ssd
/disk add disabled=yes media-interface=main-infrastructure-br slot=sshfs sshfs-address=185.13.148.14 sshfs-path=/REPO sshfs-port=2223 sshfs-user=automation type=sshfs
/app settings set disk=ssd lan-bridge=main-infrastructure-br
/disk settings set auto-media-interface=main-infrastructure-br
/ip smb set domain=HNW interfaces=main-infrastructure-br
/interface bridge filter add action=drop chain=forward comment="GLIDER L2 peer egress deny" in-interface=veth-glider
/interface bridge filter add action=drop chain=forward comment="GLIDER L2 peer ingress deny" out-interface=veth-glider
/interface bridge filter add action=accept chain=glider-l2-input comment="GLIDER L2 fixed IPv4 source" mac-protocol=ip src-address=172.17.0.6/32
/interface bridge filter add action=accept arp-dst-address=172.17.0.1/32 arp-src-address=172.17.0.6/32 chain=glider-l2-input comment="GLIDER L2 gateway ARP" mac-protocol=arp
/interface bridge filter add action=drop chain=glider-l2-input comment="GLIDER L2 other input deny"
/interface bridge filter add action=jump chain=input comment="GLIDER L2 input hook" in-interface=veth-glider jump-target=glider-l2-input
/interface bridge filter add action=accept chain=glider-l2-output comment="GLIDER L2 IPv4 output" dst-address=172.17.0.6/32 mac-protocol=ip
/interface bridge filter add action=accept chain=glider-l2-output comment="GLIDER L2 router ARP output" mac-protocol=arp
/interface bridge filter add action=drop chain=glider-l2-output comment="GLIDER L2 other output deny"
/interface bridge filter add action=jump chain=output comment="GLIDER L2 output hook" jump-target=glider-l2-output out-interface=veth-glider
/interface l2tp-server server set authentication=mschap2 default-profile=l2tp-no-encrypt-site2site enabled=yes keepalive-timeout=60 max-mru=1360 max-mtu=1360 max-sessions=1 one-session-per-host=yes
/interface list member add comment=GERMANY interface=wan list=list-untrusted
/interface list member add comment=LAN interface=main-infrastructure-br list=list-trusted
/interface list member add comment="DISCOVERY: allow neighbors lookup" interface=main-infrastructure-br list=list-neighbors-lookup
/interface list member add comment="FW: winbox allowed" interface=main-infrastructure-br list=list-winbox-allowed
/interface list member add comment="FW: winbox allowed" interface=wan list=list-winbox-allowed
/interface list member add comment="FW: drop invalid" interface=wan list=list-drop-invalid-connections
/interface list member add comment="FW: allow router cerfices from LAN" interface=main-infrastructure-br list=list-FW-allow-router-services-LAN
/interface list member add comment="FW: allow router cerfices from WAN" interface=wan list=list-FW-allow-router-services-WAN
/interface list member add comment=OSPF interface=main-infrastructure-br list=list-ospf-master
/interface list member add comment="DISCOVERY: allow neighbors lookup" interface=tunnel-mikrotik list=list-neighbors-lookup
/interface list member add comment="DISCOVERY: allow neighbors lookup" interface=tunnel-anna list=list-neighbors-lookup
/interface list member add comment=OSPF interface=tunnel-mikrotik list=list-ospf-bearing
/interface list member add comment=OSPF interface=tunnel-anna list=list-ospf-bearing
/interface list member add comment=OSPF interface=ospf-lo list=list-ospf-bearing
/interface list member add comment="FW: block incoming DNS requests" interface=wan list=list-FW-prevent-dns-requests-WAN
/interface list member add comment="FW: do port redirect from WAN" interface=wan list=list-FW-allow-port-redirect-WAN
/interface list member add interface=main-infrastructure-br list=list-mangle-loopback-LAN
/interface list member add interface=docker-infrastructure-br list=list-mangle-loopback-LAN
/interface list member add interface=ospf-lo list=list-mangle-loopback-LAN
/interface list member add comment="FW: listen to Portknocking" interface=wan list=list-FW-portknocking
/interface list member add comment="FW: allow router cerfices from LAN" interface=docker-infrastructure-br list=list-FW-allow-router-services-LAN
/interface ovpn-server server add mac-address=FE:65:0F:57:76:B9 name=ovpn-server1
/interface wireguard peers add allowed-address=172.30.30.0/24,10.0.0.5/32 client-allowed-address=::/0 endpoint-port=12000 interface=wg-to-capax name=capax persistent-keepalive=10s public-key="rUDu2JBEFFtsgr3uZTGFBvWXTXolY2hYMUQo0/lTiBI="
/ip address add address=192.168.97.1/29 comment="local IP" interface=main-infrastructure-br network=192.168.97.0
/ip address add address=10.255.255.1 comment="router id" interface=ospf-lo network=10.255.255.1
/ip address add address=172.17.0.1/28 comment="docker network" interface=docker-infrastructure-br network=172.17.0.0
/ip address add address=10.0.0.1/28 comment=vpn interface=wg-to-capax network=10.0.0.0
/ip dhcp-server add add-arp=yes address-pool=pool-dhcp authoritative=after-2sec-delay interface=main-infrastructure-br lease-time=1d name=main-dhcp-server
/ip dns set allow-remote-requests=yes cache-max-ttl=1d max-concurrent-queries=200 max-concurrent-tcp-sessions=30 query-server-timeout=3s
/ip upnp set show-dummy-rule=no
/ip upnp interfaces add disabled=yes interface=wan type=external
/ip upnp interfaces add disabled=yes interface=main-infrastructure-br type=internal
/ipv6 nd
# automatic dns option advertising is not started, re-apply dns config
set [ find default=yes ] advertise-dns=yes
/ppp secret add local-address=10.0.0.1 name=vpn-remote-mic profile=l2tp-no-encrypt-site2site remote-address=10.0.0.2 service=l2tp
/ppp secret add local-address=10.0.0.1 name=vpn-remote-anna profile=l2tp-no-encrypt-site2site remote-address=10.0.0.3 service=l2tp
/ppp secret add disabled=yes local-address=10.0.0.1 name=vpn-user-alx profile=l2tp-no-encrypt-site2site remote-address=10.0.0.4 service=l2tp
/ppp secret add local-address=10.0.0.1 name=vpn-remote-self profile=l2tp-no-encrypt-site2site remote-address=10.0.0.5 service=l2tp
/ppp secret add comment="used by \$SECRET" name=TELEGRAM_TOKEN profile=null service=async
/ppp secret add comment="used by \$SECRET" name=TELEGRAM_CHAT_ID profile=null service=async
/ppp secret add comment="used by \$SECRET" name=BACKUP_PASSWORD profile=null service=async
/ppp secret add comment="used by \$SECRET" name=SSH_PASSWORD profile=null service=async
/ppp secret add comment="used by \$SECRET" name=SSH_PORT profile=null service=async
/ppp secret add comment="used by \$SECRET" name=SSH_USER profile=null service=async
/ppp secret add comment="used by \$SECRET" name=SSH_SERVER profile=null service=async
/routing filter rule add chain=ospf-in comment="drop DEFAULT ROUTE" disabled=no rule="if ( protocol ospf && dst-len==0 ) { set comment DISCARDED-GLOBAL ; set pref-src 10.0.0.1 ; reject; }"
/routing filter rule add chain=ospf-in comment="accept inter area routes" disabled=no rule="if ( protocol ospf && ospf-type inter ) { set comment OSPF-LOCAL-AREA ;  accept; }"
/routing filter rule add chain=ospf-in comment="discard intra area routes" disabled=no rule="if ( protocol ospf && ospf-type intra) { set comment DISCARDED-INTRA-AREA ; reject; }"
/routing filter rule add chain=ospf-in comment="mark other OSPF" disabled=no rule="if ( protocol ospf) { set comment PENDING; }"
/routing filter rule add chain=ospf-in comment="drop others PROTO" disabled=no rule="set comment UNKNOWN; reject;"
/routing filter rule add chain=ospf-out-filter-reject-all comment="drop ANY outgoing" disabled=yes rule="set comment UNKNOWN; reject;"
/routing id add comment="OSPF Common" disabled=no id=10.255.255.1 name=chr-10.255.255.1 select-dynamic-id=""
/routing table add comment="tunnel swing" fib name=rmark-vpn-redirect
/ip dhcp-client add add-default-route=no dhcp-options=clientid,hostname interface=wan name=wan
/ip firewall filter add action=jump chain=forward comment="GLIDER IPv4 source hook" jump-target=glider-guard src-address=172.17.0.6
/ip firewall filter add action=jump chain=forward comment="GLIDER IPv4 destination hook" dst-address=172.17.0.6 jump-target=glider-guard
/ip firewall filter add action=drop chain=input comment="GLIDER router services deny" src-address=172.17.0.6
/ip firewall filter add action=accept chain=input comment="CADDY INP" log-prefix="~~CADDY INP" port=443,4430,1443 protocol=tcp
/ip firewall filter add action=accept chain=forward comment="CADDY FWD" log-prefix="~~CADDY FWD" port=443,4430,1443 protocol=tcp
/ip firewall filter add action=accept chain=output comment="CADDY OUT" log-prefix="~CADDY OUT" port=443,4430,1443 protocol=tcp
/ip firewall filter add action=accept chain=input comment="WG roadwarrior" dst-port=65114 protocol=udp
/ip firewall filter add action=accept chain=output comment="Telemt proxy Accept" port=443 protocol=tcp
/ip firewall filter add action=accept chain=output log=yes log-prefix=SYSLOG port=514 protocol=udp
/ip firewall filter add action=log chain=input protocol=ipsec-esp
/ip firewall filter add action=log chain=forward dst-port=22 log=yes log-prefix=--SSH-5022 protocol=tcp src-port=""
/ip firewall filter add action=accept chain=input comment="Allow NTP server" connection-state="" log=yes log-prefix=~~NTP port=123 protocol=udp
/ip firewall filter add action=accept chain=output comment="Allow NTP server" connection-state="" log=yes log-prefix=~~NTP port=123 protocol=udp
/ip firewall filter add action=accept chain=input comment=WINBOX port=8291 protocol=tcp
/ip firewall filter add action=drop chain=input comment="Drop Invalid Connections (HIGH PRIORIRY RULE)" connection-state=invalid in-interface-list=list-drop-invalid-connections
/ip firewall filter add action=drop chain=forward comment="Drop Invalid Connections (HIGH PRIORIRY RULE)" connection-state=invalid dst-address-list=!alist-fw-vpn-subnets
/ip firewall filter add action=jump chain=input comment="Jump to KNOCK Chain" dst-port=30004,30005,30006 jump-target=chain-knock-staged-control protocol=tcp
/ip firewall filter add action=add-src-to-address-list address-list=alist-fw-knock address-list-timeout=2s chain=input comment=Knock dst-port=30004 in-interface-list=list-FW-portknocking protocol=tcp
/ip firewall filter add action=add-src-to-address-list address-list=alist-fw-knockAgain address-list-timeout=2s chain=input comment=Knock-Knock dst-port=30005 in-interface-list=list-FW-portknocking protocol=tcp src-address-list=alist-fw-knock
/ip firewall filter add action=add-src-to-address-list address-list=alist-fw-knockSuccess address-list-timeout=3m chain=input comment=Knock-Knock-Knock dst-port=3006 in-interface-list=list-FW-portknocking protocol=tcp src-address-list=alist-fw-knockAgain
/ip firewall filter add action=return chain=chain-knock-staged-control comment="Return From KNOCK Chain"
/ip firewall filter add action=accept chain=forward comment="Accept Related or Established Connections (HIGH PRIORIRY RULE)" connection-state=established,related log-prefix="#ACCEPTED UNKNOWN (FWD)"
/ip firewall filter add action=accept chain=input comment="OSFP neighbour-ing allow" log-prefix=~~~OSFP protocol=ospf
/ip firewall filter add action=accept chain=input comment="Allow mikrotik self-discovery" dst-address-type=broadcast dst-port=5678 protocol=udp
/ip firewall filter add action=accept chain=forward comment="Allow mikrotik neighbor-discovery" dst-address-type=broadcast dst-port=5678 protocol=udp
/ip firewall filter add action=jump chain=input comment="VPN Access" jump-target=chain-vpn-rules
/ip firewall filter add action=accept chain=chain-vpn-rules comment="L2TP tunnel" dst-port=1701 protocol=udp
/ip firewall filter add action=accept chain=chain-vpn-rules comment="VPN \"Allow IPSec-ah\"" protocol=ipsec-ah src-address-list=alist-fw-vpn-server-addr
/ip firewall filter add action=accept chain=chain-vpn-rules comment="VPN \"Allow IPSec-esp\"" protocol=ipsec-esp src-address-list=alist-fw-vpn-server-addr
/ip firewall filter add action=accept chain=chain-vpn-rules comment="VPN \"Allow IKE\" - IPSEC connection establishing" dst-port=500 log=yes log-prefix=~~~VPN_FRW protocol=udp src-address-list=alist-fw-vpn-server-addr
/ip firewall filter add action=accept chain=chain-vpn-rules comment="VPN \"Allow UDP\" - IPSEC data trasfer" dst-port=4500 log=yes log-prefix=~~~VPN_FRW protocol=udp src-address-list=alist-fw-vpn-server-addr
/ip firewall filter add action=return chain=chain-vpn-rules comment="VPN Access"
/ip firewall filter add action=accept chain=forward comment=VPN dst-address-list=alist-fw-vpn-subnets log-prefix=~~~VPN_FRW src-address-list=alist-fw-local-subnets
/ip firewall filter add action=accept chain=forward comment=VPN dst-address-list=alist-fw-local-subnets log-prefix=~~~VPN_FRW src-address-list=alist-fw-vpn-subnets
/ip firewall filter add action=jump chain=forward comment="Jump to chain-rdp-staged-control" jump-target=chain-rdp-staged-control
/ip firewall filter add action=drop chain=chain-rdp-staged-control comment="drop rdp brute forcers" dst-port=3389 protocol=tcp src-address-list=alist-fw-rdp-block
/ip firewall filter add action=add-src-to-address-list address-list=alist-fw-rdp-block address-list-timeout=10h chain=chain-rdp-staged-control connection-state=new dst-port=3389 protocol=tcp src-address-list=alist-fw-rdp-stage3
/ip firewall filter add action=add-src-to-address-list address-list=alist-fw-rdp-stage3 address-list-timeout=1m chain=chain-rdp-staged-control connection-state=new dst-port=3389 protocol=tcp src-address-list=alist-fw-rdp-stage2
/ip firewall filter add action=add-src-to-address-list address-list=alist-fw-rdp-stage2 address-list-timeout=1m chain=chain-rdp-staged-control connection-state=new dst-port=3389 protocol=tcp src-address-list=alist-fw-rdp-stage1
/ip firewall filter add action=add-src-to-address-list address-list=alist-fw-rdp-stage1 address-list-timeout=1m chain=chain-rdp-staged-control connection-state=new dst-port=3389 protocol=tcp src-address-list=!alist-fw-rdp-allow
/ip firewall filter add action=return chain=chain-rdp-staged-control comment="Return From chain-rdp-staged-control"
/ip firewall filter add action=jump chain=forward comment="jump to chain-smb-staged-control" jump-target=chain-smb-staged-control src-address-list=!alist-fw-smb-allow
/ip firewall filter add action=add-src-to-address-list address-list=alist-smb-shares-track address-list-timeout=10h chain=chain-smb-staged-control comment="TCP/UDP ports necessary for SMB DROP" dst-port=137-139,445 log-prefix=~~~SMB protocol=udp
/ip firewall filter add action=add-src-to-address-list address-list=alist-smb-shares-track address-list-timeout=10h chain=chain-smb-staged-control comment="TCP/UDP ports necessary for SMB DROP" dst-port=137-139,445 log-prefix=~~~SMB protocol=tcp
/ip firewall filter add action=drop chain=chain-smb-staged-control comment="TCP/UDP ports necessary for SMB DROP" dst-port=137-139,445 log-prefix=~~~SMB protocol=tcp src-address-list=alist-smb-shares-track
/ip firewall filter add action=drop chain=chain-smb-staged-control comment="TCP/UDP ports necessary for SMB DROP" dst-port=137-139,445 log-prefix=~~~SMB protocol=udp src-address-list=alist-smb-shares-track
/ip firewall filter add action=return chain=chain-smb-staged-control comment="Return from chain-smb-staged-control"
/ip firewall filter add action=drop chain=input comment="drop ftp brute forcers" dst-port=21 protocol=tcp src-address-list=alist-fw-ftp-block
/ip firewall filter add action=accept chain=output comment="drop ftp brute forcers" content="530 Login incorrect" dst-limit=1/1m,9,dst-address/1m protocol=tcp
/ip firewall filter add action=add-dst-to-address-list address-list=alist-fw-ftp-block address-list-timeout=3h chain=output comment="drop ftp brute forcers" content="530 Login incorrect" protocol=tcp
/ip firewall filter add action=jump chain=input comment="Jump to DNS Amplification" jump-target=chain-dns-amp-attack
/ip firewall filter add action=accept chain=chain-dns-amp-attack comment="Make exceptions for DNS" port=53 protocol=udp src-address-list=alist-fw-dns-allow
/ip firewall filter add action=drop chain=chain-dns-amp-attack comment="Drop incoming TCP DNS from WAN" dst-port=53 in-interface-list=list-FW-prevent-dns-requests-WAN protocol=tcp
/ip firewall filter add action=drop chain=chain-dns-amp-attack comment="Drop incoming for DNS" in-interface-list=list-FW-prevent-dns-requests-WAN port=53 protocol=udp
/ip firewall filter add action=accept chain=chain-dns-amp-attack comment="Make exceptions for DNS" dst-address-list=alist-fw-dns-allow log-prefix=~~~DNS port=53 protocol=udp
/ip firewall filter add action=add-src-to-address-list address-list=alist-fw-dns-amp-block address-list-timeout=10h chain=chain-dns-amp-attack comment="Add DNS Amplification to Blacklist" port=53 protocol=udp src-address-list=!alist-fw-dns-allow
/ip firewall filter add action=drop chain=chain-dns-amp-attack comment="Drop DNS Amplification" src-address-list=alist-fw-dns-amp-block
/ip firewall filter add action=return chain=chain-dns-amp-attack comment="Return from DNS Amplification"
/ip firewall filter add action=accept chain=input comment="Self fetch requests" log-prefix=WEB port=80 protocol=tcp
/ip firewall filter add action=jump chain=input comment="Allow router services on the lan" in-interface-list=list-FW-allow-router-services-LAN jump-target=chain-router-services-lan
/ip firewall filter add action=accept chain=chain-router-services-lan comment="Winbox (8291/TCP)" dst-port=8291 protocol=tcp
/ip firewall filter add action=accept chain=chain-router-services-lan comment=SNMP port=161 protocol=udp
/ip firewall filter add action=accept chain=chain-router-services-lan comment="WEB, SCEP" port=80,8888 protocol=tcp
/ip firewall filter add action=return chain=chain-router-services-lan comment="Return from chain-router-services-lan Chain"
/ip firewall filter add action=jump chain=input comment="Allow router services on the wan" in-interface-list=list-FW-allow-router-services-WAN jump-target=chain-router-services-wan
/ip firewall filter add action=return chain=chain-router-services-wan comment="Return from chain-router-services-wan Chain"
/ip firewall filter add action=jump chain=input comment="Check for ping flooding" jump-target=chain-detect-ping-flood protocol=icmp
/ip firewall filter add action=accept chain=chain-detect-ping-flood comment="0:0 and limit for 5 pac/s Allow Ping" icmp-options=0:0-255 limit=5,5:packet protocol=icmp
/ip firewall filter add action=accept chain=chain-detect-ping-flood comment="3:3 and limit for 5 pac/s Allow Traceroute" icmp-options=3:3 limit=5,5:packet protocol=icmp
/ip firewall filter add action=accept chain=chain-detect-ping-flood comment="3:4 and limit for 5 pac/s Allow Path MTU Discovery" icmp-options=3:4 limit=5,5:packet protocol=icmp
/ip firewall filter add action=accept chain=chain-detect-ping-flood comment="8:0 and limit for 5 pac/s Allow Ping" icmp-options=8:0-255 limit=5,5:packet protocol=icmp
/ip firewall filter add action=accept chain=chain-detect-ping-flood comment="11:0 and limit for 5 pac/s Allow Traceroute" icmp-options=11:0-255 limit=5,5:packet protocol=icmp
/ip firewall filter add action=accept chain=chain-detect-ping-flood comment="0:0 and limit for 50 pac/s Allow Ping tool speed-test" icmp-options=0:0-255 limit=50,5:packet protocol=icmp
/ip firewall filter add action=accept chain=chain-detect-ping-flood comment="8:0 and limit for 50 pac/s Allow Ping tool speed-test" icmp-options=8:0-255 limit=50,5:packet protocol=icmp
/ip firewall filter add action=accept chain=chain-detect-ping-flood comment="drop everything else" log-prefix="#ICMP DROP" protocol=icmp
/ip firewall filter add action=return chain=chain-detect-ping-flood comment="Return from chain-detect-ping-flood Chain"
/ip firewall filter add action=passthrough chain=forward comment=DUMMY1 log-prefix=~~~DUMMY1 src-address-list=alist-fw-empty-dummy
/ip firewall filter add action=drop chain=input comment="Drop anyone in the Black List (Manually Added)" src-address-list=alist-fw-manual-block
/ip firewall filter add action=drop chain=forward comment="Drop anyone in the Black List (Manually Added)" src-address-list=alist-fw-manual-block
/ip firewall filter add action=drop chain=input comment="Drop anyone in the Black List (Telnet)" src-address-list=alist-fw-telnet-ban
/ip firewall filter add action=drop chain=forward comment="Drop anyone in the Black List (Telnet)" src-address-list=alist-fw-telnet-ban
/ip firewall filter add action=drop chain=input comment="Drop anyone in the Black List (Winbox)" src-address-list=alist-fw-winbox-ban
/ip firewall filter add action=drop chain=forward comment="Drop anyone in the Black List (Winbox)" src-address-list=alist-fw-winbox-ban
/ip firewall filter add action=drop chain=input comment="Drop anyone in the WAN Port Scanner List" src-address-list=alist-fw-port-scanner-ban
/ip firewall filter add action=drop chain=forward comment="Drop anyone in the WAN Port Scanner List" src-address-list=alist-fw-port-scanner-ban
/ip firewall filter add action=passthrough chain=input comment="Drop anyone in the LAN Port Scanner List" src-address-list=alist-fw-port-scanner-ban
/ip firewall filter add action=passthrough chain=forward comment="Drop anyone in the LAN Port Scanner List" src-address-list=alist-fw-port-scanner-ban
/ip firewall filter add action=drop chain=input comment="Drop all Bogons" log=yes log-prefix="#DROP BOGONS (INPUT)" src-address-list=alist-fw-rfc-special
/ip firewall filter add action=drop chain=forward comment="Drop all Bogons" log=yes log-prefix="#DROP BOGONS (FWD)" src-address-list=alist-fw-rfc-special
/ip firewall filter add action=passthrough chain=forward comment=DUMMY2 log-prefix=~~~DUMMY2 src-address-list=alist-fw-empty-dummy
/ip firewall filter add action=jump chain=input comment="Jump to RFC SSH Chain" dst-port=22,2223 jump-target=chain-ssh-staged-control protocol=tcp
/ip firewall filter add action=accept chain=chain-ssh-staged-control comment="Accept SSH allow-list" src-address-list=alist-fw-ssh-allow
/ip firewall filter add action=drop chain=chain-ssh-staged-control comment="Drop SSH ban-list" src-address-list=alist-fw-ssh-ban
/ip firewall filter add action=add-src-to-address-list address-list=alist-fw-ssh-ban address-list-timeout=1w3d chain=chain-ssh-staged-control comment="Transfer repeated attempts from SSH Stage 3 to Black-List" connection-state=new protocol=tcp src-address-list=alist-fw-ssh-stage3
/ip firewall filter add action=add-src-to-address-list address-list=alist-fw-ssh-stage3 address-list-timeout=3m chain=chain-ssh-staged-control comment="Add succesive attempts to SSH Stage 3" connection-state=new protocol=tcp src-address-list=alist-fw-ssh-stage2
/ip firewall filter add action=add-src-to-address-list address-list=alist-fw-ssh-stage2 address-list-timeout=40s chain=chain-ssh-staged-control comment="Add succesive attempts to SSH Stage 2" connection-state=new protocol=tcp src-address-list=alist-fw-ssh-stage1
/ip firewall filter add action=add-src-to-address-list address-list=alist-fw-ssh-stage1 address-list-timeout=5s chain=chain-ssh-staged-control comment="Add intial attempt to SSH Stage 1 List" connection-state=new protocol=tcp src-address-list=!alist-fw-ssh-allow
/ip firewall filter add action=accept chain=chain-ssh-staged-control comment="Accept remaining SSH"
/ip firewall filter add action=passthrough chain=forward comment=DUMMY3 log-prefix=~~~DUMMY3 src-address-list=alist-fw-empty-dummy
/ip firewall filter add action=jump chain=input comment="Jump to RFC Telnet Chain" jump-target=chain-telnet-staged-control
/ip firewall filter add action=add-src-to-address-list address-list=alist-fw-telnet-ban address-list-timeout=1w3d chain=chain-telnet-staged-control comment="Transfer repeated attempts from Telnet Stage 3 to Black-List" connection-state=new dst-port=23 protocol=tcp src-address-list=alist-fw-telnet-stage3
/ip firewall filter add action=add-src-to-address-list address-list=alist-fw-telnet-stage3 address-list-timeout=1m chain=chain-telnet-staged-control comment="Add succesive attempts to Telnet Stage 3" connection-state=new dst-port=23 protocol=tcp src-address-list=alist-fw-telnet-stage2
/ip firewall filter add action=add-src-to-address-list address-list=alist-fw-telnet-stage2 address-list-timeout=1m chain=chain-telnet-staged-control comment="Add succesive attempts to Telnet Stage 2" connection-state=new dst-port=23 protocol=tcp src-address-list=alist-fw-telnet-stage1
/ip firewall filter add action=add-src-to-address-list address-list=alist-fw-telnet-stage1 address-list-timeout=1m chain=chain-telnet-staged-control comment="Add Intial attempt to Telnet Stage 1" connection-state=new dst-port=23 protocol=tcp
/ip firewall filter add action=return chain=chain-telnet-staged-control comment="Return From RFC Telnet Chain"
/ip firewall filter add action=passthrough chain=forward comment=DUMMY4 log-prefix=~~~DUMMY4 src-address-list=alist-fw-empty-dummy
/ip firewall filter add action=jump chain=input comment="Jump to RFC Winbox Chain" jump-target=chain-winbox-staged-control
/ip firewall filter add action=add-src-to-address-list address-list=alist-fw-winbox-ban address-list-timeout=1w3d chain=chain-winbox-staged-control comment="Transfer repeated attempts from Winbox Stage 3 to Black-List" connection-state=new dst-port=8291 protocol=tcp src-address-list=alist-fw-winbox-stage3
/ip firewall filter add action=add-src-to-address-list address-list=alist-fw-winbox-stage3 address-list-timeout=1m chain=chain-winbox-staged-control comment="Add succesive attempts to Winbox Stage 3" connection-state=new dst-port=8291 protocol=tcp src-address-list=alist-fw-winbox-stage2
/ip firewall filter add action=add-src-to-address-list address-list=alist-fw-winbox-stage2 address-list-timeout=1m chain=chain-winbox-staged-control comment="Add succesive attempts to Winbox Stage 2" connection-state=new dst-port=8291 protocol=tcp src-address-list=alist-fw-winbox-stage1
/ip firewall filter add action=add-src-to-address-list address-list=alist-fw-winbox-stage1 address-list-timeout=1m chain=chain-winbox-staged-control comment="Add Intial attempt to Winbox Stage 1" connection-state=new dst-port=8291 protocol=tcp src-address-list=!alist-fw-vpn-subnets
/ip firewall filter add action=return chain=chain-winbox-staged-control comment="Return From RFC Winbox Chain"
/ip firewall filter add action=passthrough chain=forward comment=DUMMY5 log-prefix=~~~DUMMY5 src-address-list=alist-fw-empty-dummy
/ip firewall filter add action=add-src-to-address-list address-list=alist-fw-port-scanner-ban address-list-timeout=10h chain=input comment="Add TCP Port Scanners to Address List" protocol=tcp psd=40,3s,2,1 src-address-list=!alist-fw-port-scanner-allow
/ip firewall filter add action=add-src-to-address-list address-list=alist-fw-port-scanner-ban address-list-timeout=10h chain=forward comment="Add TCP Port Scanners to Address List" protocol=tcp psd=40,3s,2,1 src-address-list=!alist-fw-port-scanner-allow
/ip firewall filter add action=passthrough chain=forward comment=DUMMY6 log-prefix=~~~DUMMY6 src-address-list=alist-fw-empty-dummy
/ip firewall filter add action=add-src-to-address-list address-list=alist-fw-highload address-list-timeout=1h chain=input comment=alist-fw-highload connection-limit=100,32 protocol=tcp
/ip firewall filter add action=add-src-to-address-list address-list=alist-fw-highload address-list-timeout=10h chain=forward comment=alist-fw-highload connection-limit=100,32 protocol=tcp
/ip firewall filter add action=jump chain=input comment="Jump to Virus Chain" jump-target=chain-worms-detector
/ip firewall filter add action=drop chain=chain-worms-detector comment=Conficker dst-port=593 protocol=tcp
/ip firewall filter add action=drop chain=chain-worms-detector comment=Worm dst-port=1024-1030 protocol=tcp
/ip firewall filter add action=drop chain=chain-worms-detector comment="ndm requester" dst-port=1363 protocol=tcp
/ip firewall filter add action=drop chain=chain-worms-detector comment="ndm server" dst-port=1364 protocol=tcp
/ip firewall filter add action=drop chain=chain-worms-detector comment="screen cast" dst-port=1368 protocol=tcp
/ip firewall filter add action=drop chain=chain-worms-detector comment=hromgrafx dst-port=1373 protocol=tcp
/ip firewall filter add action=drop chain=chain-worms-detector comment="Drop MyDoom" dst-port=1080 protocol=tcp
/ip firewall filter add action=drop chain=chain-worms-detector comment=cichlid dst-port=1377 protocol=tcp
/ip firewall filter add action=drop chain=chain-worms-detector comment=Worm dst-port=1433-1434 protocol=tcp
/ip firewall filter add action=drop chain=chain-worms-detector comment="Drop Dumaru.Y" dst-port=2283 protocol=tcp
/ip firewall filter add action=drop chain=chain-worms-detector comment="Drop Beagle" dst-port=2535 protocol=tcp
/ip firewall filter add action=drop chain=chain-worms-detector comment="Drop Beagle.C-K" dst-port=2745 protocol=tcp
/ip firewall filter add action=drop chain=chain-worms-detector comment="Drop MyDoom" dst-port=3127-3128 protocol=tcp
/ip firewall filter add action=drop chain=chain-worms-detector comment="Drop Backdoor OptixPro" dst-port=3410 protocol=tcp
/ip firewall filter add action=drop chain=chain-worms-detector comment="Drop Sasser" dst-port=5554 protocol=tcp
/ip firewall filter add action=drop chain=chain-worms-detector comment=Worm dst-port=4444 protocol=tcp
/ip firewall filter add action=drop chain=chain-worms-detector comment=Worm dst-port=4444 protocol=udp
/ip firewall filter add action=drop chain=chain-worms-detector comment="Drop Beagle.B" dst-port=8866 protocol=tcp
/ip firewall filter add action=drop chain=chain-worms-detector comment="Drop Dabber.A-B" dst-port=9898 protocol=tcp
/ip firewall filter add action=drop chain=chain-worms-detector comment="Drop Dumaru.Y" dst-port=10000 protocol=tcp
/ip firewall filter add action=drop chain=chain-worms-detector comment="Drop MyDoom.B" dst-port=10080 protocol=tcp
/ip firewall filter add action=drop chain=chain-worms-detector comment="Drop NetBus" dst-port=12345 protocol=tcp
/ip firewall filter add action=drop chain=chain-worms-detector comment="Drop Kuang2" dst-port=17300 protocol=tcp
/ip firewall filter add action=drop chain=chain-worms-detector comment="Drop SubSeven" dst-port=27374 protocol=tcp
/ip firewall filter add action=drop chain=chain-worms-detector comment="Drop PhatBot, Agobot, Gaobot" dst-port=65506 protocol=tcp
/ip firewall filter add action=return chain=chain-worms-detector comment="Return From Virus Chain"
/ip firewall filter add action=passthrough chain=forward comment=DUMMY7 log-prefix=~~~DUMMY7 src-address-list=alist-fw-empty-dummy
/ip firewall filter add action=jump chain=input comment="Jump to \"Manage Common Ports\" Chain" jump-target=chain-self-common-ports
/ip firewall filter add action=accept chain=chain-self-common-ports comment="\"All hosts on this subnet\" Broadcast" src-address=224.0.0.1
/ip firewall filter add action=accept chain=chain-self-common-ports comment="\"All routers on this subnet\" Broadcast" src-address=224.0.0.2
/ip firewall filter add action=accept chain=chain-self-common-ports comment="DVMRP (Distance Vector Multicast Routing Protocol)" src-address=224.0.0.4
/ip firewall filter add action=accept chain=chain-self-common-ports comment="OSPF - All OSPF Routers Broadcast" src-address=224.0.0.5
/ip firewall filter add action=accept chain=chain-self-common-ports comment="OSPF - OSPF DR Routers Broadcast" src-address=224.0.0.6
/ip firewall filter add action=accept chain=chain-self-common-ports comment="RIP Broadcast" src-address=224.0.0.9
/ip firewall filter add action=accept chain=chain-self-common-ports comment="EIGRP Broadcast" src-address=224.0.0.10
/ip firewall filter add action=accept chain=chain-self-common-ports comment="PIM Broadcast" src-address=224.0.0.13
/ip firewall filter add action=accept chain=chain-self-common-ports comment="VRRP Broadcast" src-address=224.0.0.18
/ip firewall filter add action=accept chain=chain-self-common-ports comment="IS-IS Broadcast" src-address=224.0.0.19
/ip firewall filter add action=accept chain=chain-self-common-ports comment="IS-IS Broadcast" src-address=224.0.0.20
/ip firewall filter add action=accept chain=chain-self-common-ports comment="IS-IS Broadcast" src-address=224.0.0.21
/ip firewall filter add action=accept chain=chain-self-common-ports comment="IGMP Broadcast" src-address=224.0.0.22
/ip firewall filter add action=accept chain=chain-self-common-ports comment="GRE Protocol (Local Management)" protocol=gre
/ip firewall filter add action=accept chain=chain-self-common-ports comment="FTPdata transfer" log-prefix=~~~FTP port=20 protocol=tcp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="FTPcontrol (command)" log-prefix=~~~FTP port=21 protocol=tcp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="FTPdata transfer  " log-prefix=~~~FTP port=20 protocol=udp
/ip firewall filter add action=accept chain=chain-self-common-ports comment=Telnet port=23 protocol=tcp
/ip firewall filter add action=accept chain=chain-self-common-ports comment=Telnet port=23 protocol=udp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="Priv-mail: any privatemailsystem." port=24 protocol=tcp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="Priv-mail: any privatemailsystem.  " port=24 protocol=udp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="Simple Mail Transfer Protocol(SMTP)" port=25 protocol=tcp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="Simple Mail Transfer Protocol(SMTP)  " port=25 protocol=udp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="TIME protocol" port=37 protocol=tcp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="TIME protocol  " port=37 protocol=udp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="ARPA Host Name Server Protocol & WINS" port=42 protocol=tcp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="ARPA Host Name Server Protocol  & WINS  " port=42 protocol=udp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="WHOIS protocol" port=43 protocol=tcp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="WHOIS protocol" port=43 protocol=udp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="Domain Name System (DNS)" port=53 protocol=tcp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="Domain Name System (DNS)" port=53 protocol=udp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="Mail Transfer Protocol(RFC 780)" port=57 protocol=tcp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="(BOOTP) Server & (DHCP)  " port=67 protocol=udp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="(BOOTP) Client & (DHCP)  " port=68 protocol=udp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="Trivial File Transfer Protocol (TFTP)  " port=69 protocol=udp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="Gopher protocol" port=70 protocol=tcp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="Finger protocol" port=79 protocol=tcp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="Webfig, SCEP" log=yes port=80,8888 protocol=tcp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="RemoteTELNETService protocol" port=107 protocol=tcp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="Post Office Protocolv2 (POP2)" port=109 protocol=tcp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="Post Office Protocolv3 (POP3)" port=110 protocol=tcp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="IdentAuthentication Service/Identification Protocol" port=113 protocol=tcp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="Authentication Service (auth)  " port=113 protocol=udp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="Simple File Transfer Protocol (SFTP)" port=115 protocol=tcp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="Network Time Protocol(NTP)" port=123 protocol=udp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="NetBIOSNetBIOS Name Service" port=137 protocol=tcp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="NetBIOSNetBIOS Name Service  " port=137 protocol=udp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="NetBIOSNetBIOS Datagram Service" port=138 protocol=tcp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="NetBIOSNetBIOS Datagram Service  " port=138 protocol=udp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="NetBIOSNetBIOS Session Service" port=139 protocol=tcp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="NetBIOSNetBIOS Session Service  " port=139 protocol=udp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="Internet Message Access Protocol (IMAP)" port=143 protocol=tcp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="Background File Transfer Program (BFTP)" port=152 protocol=tcp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="Background File Transfer Program (BFTP)  " port=152 protocol=udp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="SGMP,Simple Gateway Monitoring Protocol" port=153 protocol=tcp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="SGMP,Simple Gateway Monitoring Protocol  " port=153 protocol=udp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="DMSP, Distributed Mail Service Protocol" port=158 protocol=tcp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="DMSP, Distributed Mail Service Protocol  " port=158 protocol=udp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="Simple Network Management Protocol(SNMP)  " port=161 protocol=udp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="Simple Network Management ProtocolTrap (SNMPTRAP)" port=162 protocol=tcp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="Simple Network Management ProtocolTrap (SNMPTRAP)  " port=162 protocol=udp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="BGP (Border Gateway Protocol)" port=179 protocol=tcp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="Internet Message Access Protocol (IMAP), version 3" port=220 protocol=tcp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="Internet Message Access Protocol (IMAP), version 3" port=220 protocol=udp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="BGMP, Border Gateway Multicast Protocol" port=264 protocol=tcp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="BGMP, Border Gateway Multicast Protocol  " port=264 protocol=udp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="Lightweight Directory Access Protocol (LDAP)" port=389 protocol=tcp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="Lightweight Directory Access Protocol (LDAP)" port=389 protocol=udp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="SSTP TCP Port 443 (Local Management) & HTTPS" port=443 protocol=tcp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="Microsoft-DSActive Directory, Windows shares" port=445 protocol=tcp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="L2TP/ IPSEC UDP Port 500 (Local Management)" port=500 protocol=udp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="Modbus, Protocol" port=502 protocol=tcp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="Modbus, Protocol  " port=502 protocol=udp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="Shell (Remote Shell, rsh, remsh)" port=514 protocol=tcp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="Syslog - used for system logging  " port=514 protocol=udp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="Routing Information Protocol (RIP)  " port=520 protocol=udp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="e-mail message submission (SMTP)" port=587 protocol=tcp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="LDP,Label Distribution Protocol" port=646 protocol=tcp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="LDP,Label Distribution Protocol" port=646 protocol=udp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="FTPS Protocol (data):FTP over TLS/SSL" port=989 protocol=tcp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="FTPS Protocol (data):FTP over TLS/SSL" port=989 protocol=udp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="FTPS Protocol (control):FTP over TLS/SSL" port=990 protocol=tcp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="FTPS Protocol (control):FTP over TLS/SSL" port=990 protocol=udp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="TELNET protocol overTLS/SSL" port=992 protocol=tcp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="TELNET protocol overTLS/SSL" port=992 protocol=udp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="Internet Message Access Protocol over TLS/SSL (IMAPS)" port=993 protocol=tcp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="Post Office Protocol3 over TLS/SSL (POP3S)" port=995 protocol=tcp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="OVPN TCP Port 1194 (Local Management)" port=1194 protocol=tcp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="PPTP Port 1723 (Local Management)" port=1723 protocol=tcp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="L2TP UDP Port 1701 (Local Management)" port=1701 protocol=udp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="L2TP UDP Port 4500 (Local Management)" port=4500 protocol=udp
/ip firewall filter add action=accept chain=chain-self-common-ports comment="WINBOX TCP Port 8291 (Local Management)" port=8291 protocol=tcp
/ip firewall filter add action=accept chain=input comment="TCP/UDP ports necessary for SMB" dst-port=137-138 log-prefix=~~~SMB protocol=udp src-address-list=alist-fw-smb-allow
/ip firewall filter add action=accept chain=input comment="TCP/UDP ports necessary for SMB" dst-port=137,139 log-prefix=~~~SMB protocol=tcp src-address-list=alist-fw-smb-allow
/ip firewall filter add action=accept chain=input comment="Accept Related or Established Connections" connection-state=established,related log-prefix="#ACCEPTED UNKNOWN (INPUT)"
/ip firewall filter add action=accept chain=forward comment="Accept New Connections" connection-state=new log-prefix="#ACCEPTED UNKNOWN (FWD)"
/ip firewall filter add action=passthrough chain=forward comment=DUMMY8 log-prefix=~~~DUMMY8 src-address-list=alist-fw-empty-dummy
/ip firewall filter add action=drop chain=forward comment="WAN static-routes intruders not DSTNATed drop" connection-nat-state=dstnat connection-state=new in-interface=wan log=yes log-prefix="#DROP UNKNOWN (FWD/no DSTN)"
/ip firewall filter add action=drop chain=forward comment="Drop all other LAN Traffic" log=yes log-prefix="#DROP UNKNOWN (FWD)"
/ip firewall filter add action=drop chain=input comment="Drop all other WAN Traffic" log=yes log-prefix="#DROP UNKNOWN (INPUT)"
/ip firewall filter add action=drop chain=glider-guard comment="GLIDER invalid" connection-state=invalid
/ip firewall filter add action=accept chain=glider-guard comment="GLIDER replies" connection-state=established
/ip firewall filter add action=accept chain=glider-guard comment="GLIDER HAProxy only" connection-state=new dst-address=172.17.0.6 dst-port=8443 protocol=tcp src-address=192.168.97.4
/ip firewall filter add action=drop chain=glider-guard comment="GLIDER private destinations deny" dst-address-list=glider-denied src-address=172.17.0.6
/ip firewall filter add action=accept chain=glider-guard comment="GLIDER DNS UDP" dst-address=1.1.1.1 dst-port=53 protocol=udp src-address=172.17.0.6
/ip firewall filter add action=accept chain=glider-guard comment="GLIDER DNS TCP" dst-address=1.1.1.1 dst-port=53 protocol=tcp src-address=172.17.0.6
/ip firewall filter add action=accept chain=glider-guard comment="GLIDER HTTPS egress" dst-port=443 protocol=tcp src-address=172.17.0.6
/ip firewall filter add action=drop chain=glider-guard comment="GLIDER other routed traffic deny"
/ip firewall mangle add action=change-mss chain=forward comment="fix MSS for l2tp/ipsec" in-interface=all-ppp new-mss=1390 protocol=tcp tcp-flags=syn tcp-mss=1391-65535
/ip firewall mangle add action=change-mss chain=forward comment="fix MSS for l2tp/ipsec" new-mss=1390 out-interface=all-ppp protocol=tcp tcp-flags=syn tcp-mss=1391-65535
/ip firewall mangle add action=change-mss chain=output comment="fix MSS for l2tp/ipsec (self)" new-mss=1390 protocol=tcp src-address-list=alist-fw-vpn-subnets tcp-flags=syn tcp-mss=1391-65535
/ip firewall mangle add action=jump chain=prerouting comment=loopback-detect-chain-set-cmark connection-mark=no-mark disabled=yes in-interface-list=list-mangle-loopback-LAN jump-target=loopback-detect-chain-set-cmark
/ip firewall mangle add action=mark-connection chain=loopback-detect-chain-set-cmark comment=loopback-detect-chain-set-cmark-UTF dst-address-list=alist-nat-external-ip new-connection-mark=cmark-loopback-connection-UTF
/ip firewall mangle add action=return chain=loopback-detect-chain-set-cmark comment=loopback-chain-set-cmark
/ip firewall mangle add action=jump chain=prerouting comment=loopback-detect-chain-set-pmark in-interface-list=list-mangle-loopback-LAN jump-target=loopback-detect-chain-set-pmark packet-mark=!pmark-nat-loopback
/ip firewall mangle add action=mark-packet chain=loopback-detect-chain-set-pmark comment=loopback-detect-chain-set-pmark-UTF connection-mark=cmark-loopback-connection-UTF new-packet-mark=pmark-nat-loopback
/ip firewall mangle add action=return chain=loopback-detect-chain-set-pmark comment=loopback-detect-chain-set-pmark
/ip firewall mangle add action=mark-connection chain=input comment="Mark IPsec" ipsec-policy=in,ipsec new-connection-mark=ipsec
/ip firewall mangle add action=mark-connection chain=output comment="Mark IPsec" ipsec-policy=out,ipsec new-connection-mark=ipsec
/ip firewall mangle add action=mark-routing chain=prerouting comment="GLIDER direct backend destination" dst-address=172.17.0.6 new-routing-mark=main passthrough=no
/ip firewall mangle add action=mark-routing chain=prerouting comment="GLIDER direct WAN source" new-routing-mark=main passthrough=no src-address=172.17.0.6
/ip firewall mangle add action=mark-routing chain=prerouting comment="VPN Sites" dst-address-list=alist-mangle-vpn-tunneled-sites log-prefix="#VPN ROUTE MARK" new-routing-mark=rmark-vpn-redirect passthrough=no
/ip firewall mangle add action=mark-routing chain=output comment="VPN Sites (self)" dst-address-list=alist-mangle-vpn-tunneled-sites log-prefix="#VPN ROUTE MARK" new-routing-mark=rmark-vpn-redirect passthrough=no
/ip firewall mangle add action=mark-packet chain=input comment="VPN Traffic" log-prefix="#VPN PCKT MARK" new-packet-mark="IPSEC PCKT" protocol=ipsec-esp
/ip firewall mangle add action=mark-connection chain=forward comment="Mark IPsec" ipsec-policy=out,ipsec new-connection-mark=ipsec
/ip firewall mangle add action=mark-connection chain=forward comment="Mark IPsec" ipsec-policy=in,ipsec new-connection-mark=ipsec
/ip firewall nat add action=masquerade chain=srcnat comment="fix the ntp client by changing its source port 123 with something higher (mikrotik forum 794718)" disabled=yes protocol=udp src-port=123 to-ports=12400-12440
/ip firewall nat add action=masquerade chain=srcnat comment="NAT Loopback replace address" disabled=yes packet-mark=pmark-nat-loopback
/ip firewall nat add action=masquerade chain=srcnat comment="masq docker" src-address=172.17.0.0/28
/ip firewall nat add action=jump chain=dstnat comment=port-rdr-docker-chain jump-target=port-rdr-docker-chain protocol=tcp
/ip firewall nat add action=jump chain=output comment="port-rdr-docker-chain (self)" jump-target=port-rdr-docker-chain protocol=tcp
/ip firewall nat add action=dst-nat chain=port-rdr-docker-chain comment=port-rdr-docker-chain-haproxy-443 dst-address-list=alist-nat-external-ip dst-port=443 log=yes log-prefix=HAPRO protocol=tcp to-addresses=192.168.97.4 to-ports=443
/ip firewall nat add action=dst-nat chain=port-rdr-docker-chain comment="port-rdr-docker-chain-caddy 8000,4430 (tcp)" dst-address-list=alist-nat-external-ip dst-port=8000,4430 log=yes protocol=tcp to-addresses=172.17.0.4
/ip firewall nat add action=dst-nat chain=port-rdr-docker-chain comment="port-rdr-docker-chain-caddy 80,1443 (tcp)" dst-address-list=alist-nat-external-ip dst-port=80,1443 log=yes protocol=tcp to-addresses=172.17.0.4
/ip firewall nat add action=dst-nat chain=port-rdr-docker-chain comment="port-rdr-docker-chain-caddy 80,1443,8000,4430 (udp)" disabled=yes dst-port=80,1443,8000,4430 log=yes protocol=udp to-addresses=172.17.0.4
/ip firewall nat add action=dst-nat chain=port-rdr-docker-chain comment="port-rdr-docker-chain-telemt (metrics)" dst-port=9090 protocol=tcp to-addresses=172.17.0.2 to-ports=9090
/ip firewall nat add action=dst-nat chain=port-rdr-docker-chain comment="port-rdr-docker-chain-telemt (web-ui) 8088" dst-port=8088 protocol=tcp to-addresses=172.17.0.3 to-ports=8088
/ip firewall nat add action=dst-nat chain=port-rdr-docker-chain comment="port-rdr-docker-chain-hermes (open-AI API server) 8642" dst-port=8642 protocol=tcp to-addresses=172.17.0.7 to-ports=8642
/ip firewall nat add action=dst-nat chain=port-rdr-docker-chain comment="port-rdr-docker-chain-hermes (dashi) 9119" dst-port=9119 protocol=tcp to-addresses=172.17.0.7 to-ports=9119
/ip firewall nat add action=return chain=port-rdr-docker-chain comment=port-rdr-docker-chain
/ip firewall nat add action=masquerade chain=srcnat comment="ANNA - VPN masq (pure L2TP, w/o IPSEC)" disabled=yes out-interface=tunnel-anna
/ip firewall nat add action=masquerade chain=srcnat comment="MIK - VPN masq (pure L2TP, w/o IPSEC)" disabled=yes out-interface=tunnel-mikrotik
/ip firewall nat add action=masquerade chain=srcnat comment="all WAN allowed" dst-address-list=!alist-nat-preserve-wan-ip
/ip route add check-gateway=ping comment=GLOBAL disabled=no distance=10 dst-address=0.0.0.0/0 gateway=185.13.148.1 routing-table=main scope=30 target-scope=10
/ip route add blackhole comment=OSPF-LOCAL-AREA-blackhole disabled=no distance=200 dst-address=192.168.90.0/24 gateway=tunnel-anna routing-table=main scope=30 target-scope=10
/ip route add blackhole comment=OSPF-LOCAL-AREA-blackhole disabled=no distance=200 dst-address=192.168.98.0/24 gateway=tunnel-anna routing-table=main scope=30 target-scope=10
/routing bgp template set default disabled=no output.network=bgp-networks
/routing ospf instance add comment="OSPF Common - inject into \"main\" table" disabled=no in-filter-chain=ospf-in name=routes-inject-into-main originate-default=never redistribute="" router-id=chr-10.255.255.1 routing-table=main version=2 vrf=main
/routing ospf area add area-id=0.0.0.0 disabled=no instance=routes-inject-into-main name=backbone type=default
/routing ospf area add area-id=0.0.0.1 default-cost=10 disabled=no instance=routes-inject-into-main name=chr-space-main no-summaries type=stub
/routing ospf interface-template add area=chr-space-main auth-id=1 disabled=no interfaces=main-infrastructure-br networks=192.168.97.0/29 passive priority=100
/routing ospf interface-template add area=backbone comment="ANNA routes" cost=200 disabled=no interfaces=tunnel-anna type=ptp
/routing ospf interface-template add area=backbone comment="MIKROTIK routes" cost=300 disabled=yes interfaces=tunnel-mikrotik type=ptp
/snmp community set [ find default=yes ] authentication-protocol=SHA1 encryption-protocol=AES name=globus
/snmp community add addresses=::/0 disabled=yes name=public
/snmp set contact=defm.kopcap@gmail.com enabled=yes location=RU trap-generators=interfaces trap-interfaces=main-infrastructure-br trap-version=2
/system clock set time-zone-name=Europe/Berlin
/system identity set name=chr
/system note set note="Ipsec:         okay \
    \nRoute:     185.13.148.1 \
    \nVersion:         7.25.1 \
    \nUptime:        2d09:39:36  \
    \nTime:        2026-11-11 21:10:12  \
    \nPing:    0 ms  \
    \nChr:        185.13.148.14  \
    \nMik:        178.65.91.156  \
    \nAnna:        46.39.51.223  \
    \nClock:        synchronized  \
    \n * routeros  \
    \n * container  \
    \n" show-at-cli-login=yes
/system ntp client set enabled=yes
/system ntp client servers add address=de.pool.ntp.org
/system ntp client servers add address=ptbtime2.ptb.de
/system scheduler add !days interval=5d name=doBackup on-event="/system script run doBackup" policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive start-date=2020-08-04 start-time=21:13:00
/system scheduler add !days interval=1w3d name=doRandomGen on-event="/system script run doRandomGen" policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon start-date=2018-03-01 start-time=15:55:00
/system scheduler add !days interval=1d name=doFreshTheScripts on-event="/system script run doFreshTheScripts" policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon start-date=2018-03-01 start-time=08:00:00
/system scheduler add !days interval=10m name=doIPSECPunch on-event="/system script run doIPSECPunch" policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon start-date=2019-05-07 start-time=09:00:00
/system scheduler add !days name=doStartupScript on-event="/system script run doStartupScript" policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon start-time=startup
/system scheduler add !days interval=7m name=doUpdateExternalDNS on-event="/system script run doUpdateExternalDNS" policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon start-date=2022-01-26 start-time=14:34:19
/system scheduler add !days interval=10m name=doCoolConsole on-event="/system script run doCoolConsole" policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon start-date=2023-04-08 start-time=07:00:00
/system scheduler add !days interval=6h name=doFlushLogs on-event="/system script run doFlushLogs" policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive start-date=2020-08-04 start-time=21:00:00
/system scheduler add !days interval=30m name=doCloudBackup on-event="/system script run doCloudBackup" policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon start-date=2026-02-04 start-time=18:48:55
/system script add dont-require-permissions=yes name=doBackup owner=owner policy=ftp,read,write,policy,test,password,sensitive source=":local sysname [/system identity get name]\
    \n:local scriptname \"doBackup\"\
    \n:global globalScriptBeforeRun\
    \n\$globalScriptBeforeRun \$scriptname\
    \n\
    \n:global globalNoteMe\
    \n:global globalTgMessage\
    \n:global globalSecret\
    \n:global globalTimestamp\
    \n:global globalCallSftp\
    \n:global globalKnockKnock\
    \n:global globalOnPrimaryPartition\
    \n:local itsOk true\
    \n:local state \"\"\
    \n:local firstError \"\"\
    \n\
    \n:local rosVer [:tonum [:pick [/system resource get version] 0 1]]\
    \n:local sysver \"NA\"\
    \n:if ([:len [/system package find where name=\"system\" and disabled=no]] > 0 and \$rosVer = 6) do={\
    \n    :set sysver [/system package get system version]\
    \n}\
    \n:if ([:len [/system package find where name=\"routeros\" and disabled=no]] > 0 and \$rosVer = 7) do={\
    \n    :set sysver [/system package get routeros version]\
    \n}\
    \n\
    \n:local useSysBackup true\
    \n:local useEncryption false\
    \n:local useRawExport true\
    \n\
    \n# paths \E2\80\94 host /REPO/raw is the git clone (same as doDumpTheScripts)\
    \n:local useFtp true\
    \n:local ftpServer \"\$[\$globalSecret get SSH_SERVER]\"\
    \n:local ftpBinRoot \"REPO/raw/bin/\"\
    \n:local useFtpGit true\
    \n:local ftpConfigLatest (\"REPO/raw/src/config/\" . \$sysname . \".safe.rsc\")\
    \n:local configLatestName (\$sysname . \".safe.rsc\")\
    \n:local ramDiskName \"RAM\"\
    \n:local ramDiskPrefix (\$ramDiskName . \"/\")\
    \n:local ramBackupPattern (\"^\" . \$ramDiskPrefix . \"BACKUP-\" . \$sysname . \"-\")\
    \n:local ramConfigLatest (\$ramDiskPrefix . \$configLatestName)\
    \n\
    \n:local sysnote [/system note get note]\
    \n\
    \n:local stamp [\$globalTimestamp]\
    \n\
    \n:local useSmtp true\
    \n:local smtpAddress \"defm.kopcap@gmail.com\"\
    \n:local smtpSubject \"\$sysname Full Backup (\$stamp)\"\
    \n:local smtpBody \"\$sysname full Backup file see in attachment.\\n \$sysnote\"\
    \n\
    \n# preflight\
    \n:if (![\$globalOnPrimaryPartition]) do={\
    \n    :set state \"WARNING: the system booted up from fallback partition - skipping backup!\"\
    \n    :log error \$state\
    \n    \$globalNoteMe value=\$state\
    \n    :error \$state\
    \n}\
    \n\
    \n:if ([:len [/disk find where slot=\$ramDiskName and type=\"tmpfs\"]] = 0) do={\
    \n    :set state \"WARNING: tmpfs '\$ramDiskName' not found - skipping backup!\"\
    \n    :log error \$state\
    \n    \$globalNoteMe value=\$state\
    \n    :error \$state\
    \n}\
    \n\
    \n:onerror errorDescr in={\
    \n    :local smtpserv [:resolve \"\$ftpServer\"]\
    \n} do={\
    \n    :set state \"WARNING: FTP server '\$ftpServer' unreachable - skipping backup!\"\
    \n    :log error \$state\
    \n    \$globalNoteMe value=\$state\
    \n    :error \$state\
    \n}\
    \n\
    \n:local fname \"BACKUP-\$sysname-\$stamp\"\
    \n\
    \n\$globalNoteMe value=\"Clearing previous backups..\" verbose=true\
    \n/file remove [/file find where name~\$ramBackupPattern]\
    \n/file remove [/file find where name=\$ramConfigLatest]\
    \n\
    \n:onerror errorDescr in={\
    \n\
    \n    :if (\$useSysBackup) do={\
    \n        :set state \"Saving system backup \$fname.backup\"\
    \n        \$globalNoteMe value=\$state verbose=true\
    \n        :if (\$useEncryption) do={\
    \n            # Configure at runtime: \$globalSecret set BACKUP_PASSWORD password=\"YOUR_SECRET\"\
    \n            :local backupPassword \"\$[\$globalSecret get BACKUP_PASSWORD]\"\
    \n            /system backup save name=(\$ramDiskName . \"/\" . \$fname . \".backup\") password=\$backupPassword\
    \n        }\
    \n        :if (!\$useEncryption) do={ /system backup save dont-encrypt=yes name=(\$ramDiskName . \"/\" . \$fname . \".backup\") }\
    \n        :delay 2s\
    \n        \$globalNoteMe value=\"System Backup Finished\" verbose=true\
    \n    }\
    \n\
    \n    :if (\$useRawExport) do={\
    \n        :set state \"Exporting restore text \$fname.unsafe.rsc\"\
    \n        \$globalNoteMe value=\$state verbose=true\
    \n        /export show-sensitive terse file=(\$ramDiskName . \"/\" . \$fname . \".unsafe.rsc\")\
    \n        :delay 2s\
    \n        \$globalNoteMe value=\"Done\" verbose=true\
    \n    }\
    \n\
    \n    :if (\$useFtpGit) do={\
    \n        :set state \"Exporting config source \$configLatestName\"\
    \n        \$globalNoteMe value=\$state verbose=true\
    \n        /export terse file=(\$ramDiskName . \"/\" . \$configLatestName)\
    \n        :delay 2s\
    \n        \$globalNoteMe value=\"Done\" verbose=true\
    \n    }\
    \n\
    \n    :delay 5s\
    \n\
    \n} do={\
    \n    :set state \"Error When \$state: \$errorDescr\"\
    \n    \$globalNoteMe value=\$state\
    \n    :if ([:len \$firstError] = 0) do={ :set firstError \$state }\
    \n    :set itsOk false\
    \n}\
    \n\
    \n:if (\$itsOk) do={\
    \n\
    \n    # \"break-loop\" leaves remaining uploads after sftp-session-cut\
    \n    :onerror errorDescr in={\
    \n\
    \n        :if (\$useFtp) do={\
    \n            # SFTP uploads look like bruteforce on CHR without knockknock\
    \n            :set state \"Opening firewall for SFTP (knockknock)\"\
    \n            \$globalNoteMe value=\$state verbose=true\
    \n            :local errorDef [\$globalKnockKnock \$scriptname]\
    \n            :if ([:len \$errorDef] > 0) do={ :error \$errorDef }\
    \n        }\
    \n\
    \n        :foreach backupFile in=[/file find] do={\
    \n\
    \n            :local buFile [/file get \$backupFile name]\
    \n\
    \n            :if ([:typeof [:find \$buFile \$fname]] != \"nil\") do={\
    \n\
    \n                :local itsUnsafe (\$buFile ~ \".unsafe.rsc\")\
    \n\
    \n                :if (\$useFtp) do={\
    \n\
    \n                    :onerror errorDescr in={\
    \n                        :local dst \"\$ftpBinRoot\$buFile\"\
    \n                        :if ([:typeof [:find \$buFile \$ramDiskPrefix]] = \"num\") do={\
    \n                            :set dst (\"\$ftpBinRoot\" . [:pick \$buFile [:len \$ramDiskPrefix] [:len \$buFile]])\
    \n                        }\
    \n                        :set state \"Uploading \$buFile to SFTP (\$dst)\"\
    \n                        \$globalNoteMe value=\$state verbose=true\
    \n\
    \n                        :local errorDef [\$globalCallSftp \$buFile \$dst]\
    \n                        :if ([:len \$errorDef] > 0) do={ :error \$errorDef }\
    \n\
    \n                        \$globalNoteMe value=\"Done\" verbose=true\
    \n                    } do={\
    \n                        :set state \"Error When \$state: \$errorDescr\"\
    \n                        \$globalNoteMe value=\$state\
    \n                        :if ([:len \$firstError] = 0) do={ :set firstError \$state }\
    \n                        :set itsOk false\
    \n                        :if (\$errorDescr ~ \"^sftp-session-cut\") do={\
    \n                            :error \"break-loop\"\
    \n                        }\
    \n                    }\
    \n                }\
    \n\
    \n                :if (\$useSmtp and !\$itsUnsafe) do={\
    \n                    :onerror errorDescr in={\
    \n                        :set state \"Uploading \$buFile to SMTP\"\
    \n                        \$globalNoteMe value=\$state verbose=true\
    \n\
    \n                        # email works in background, delay needed\
    \n                        /tool e-mail send to=\$smtpAddress body=\$smtpBody subject=\$smtpSubject file=\$buFile tls=starttls\
    \n\
    \n                        # waiting for email to be delivered\
    \n                        :delay 15s\
    \n\
    \n                        :if ([/tool e-mail get last-status] != \"succeeded\") do={\
    \n                            :error \"e-mail last-status is not succeeded\"\
    \n                        }\
    \n\
    \n                        \$globalNoteMe value=\"Done\" verbose=true\
    \n                    } do={\
    \n                        :set state \"Error When \$state: \$errorDescr\"\
    \n                        \$globalNoteMe value=\$state\
    \n                        :if ([:len \$firstError] = 0) do={ :set firstError \$state }\
    \n                        :set itsOk false\
    \n                    }\
    \n                }\
    \n            }\
    \n        }\
    \n\
    \n        :if (\$useFtp and \$useFtpGit) do={\
    \n            :onerror errorDescr in={\
    \n                :if ([:len [/file find name=\$ramConfigLatest]] = 0) do={\
    \n                    :error \"config source \$configLatestName not found\"\
    \n                }\
    \n                :set state \"Uploading \$configLatestName to SFTP (\$ftpConfigLatest)\"\
    \n                \$globalNoteMe value=\$state verbose=true\
    \n                :local errorDef [\$globalCallSftp \$ramConfigLatest \$ftpConfigLatest]\
    \n                :if ([:len \$errorDef] > 0) do={ :error \$errorDef }\
    \n                \$globalNoteMe value=\"Done\" verbose=true\
    \n            } do={\
    \n                :set state \"Error When \$state: \$errorDescr\"\
    \n                \$globalNoteMe value=\$state\
    \n                :if ([:len \$firstError] = 0) do={ :set firstError \$state }\
    \n                :set itsOk false\
    \n                :if (\$errorDescr ~ \"^sftp-session-cut\") do={\
    \n                    :error \"break-loop\"\
    \n                }\
    \n            }\
    \n        }\
    \n\
    \n    } do={\
    \n        :if (!(\$errorDescr ~ \"^break-loop\")) do={\
    \n            :set state \"Error When \$state: \$errorDescr\"\
    \n            \$globalNoteMe value=\$state\
    \n            :if ([:len \$firstError] = 0) do={ :set firstError \$state }\
    \n            :set itsOk false\
    \n        }\
    \n    }\
    \n}\
    \n\
    \n\$globalNoteMe value=\"Housekeeping..\" verbose=true\
    \n/file remove [/file find where name~\$ramBackupPattern]\
    \n/file remove [/file find where name=\$ramConfigLatest]\
    \n\
    \n:local inf \"\"\
    \n:if (\$itsOk) do={\
    \n    :set inf \"\E2\9C\93 SUCCESS \$scriptname on \$sysname: automatic backup completed\"\
    \n}\
    \n\
    \n:if (!\$itsOk) do={\
    \n    :set inf \"\E2\9C\97 FAILED \$scriptname on \$sysname: \$firstError\"\
    \n}\
    \n\
    \n\$globalNoteMe value=\$inf\
    \n\
    \n:if (!\$itsOk) do={\
    \n    \$globalTgMessage value=\$inf\
    \n    :error \$inf\
    \n}\
    \n\
    \n"
/system script add dont-require-permissions=yes name=doRandomGen owner=owner policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive source=":local sysname [/system identity get name]\
    \n:local scriptname \"doRandomGen\"\
    \n:global globalScriptBeforeRun\
    \n\$globalScriptBeforeRun \$scriptname\
    \n\
    \n:global globalNoteMe\
    \n:global globalTgMessage\
    \n:global globalTimestamp\
    \n:local itsOk true\
    \n:local state \"\"\
    \n\
    \n:local stamp [\$globalTimestamp]\
    \n\
    \n:local rosVer [:tonum [:pick [/system resource get version] 0 1]]\
    \n:local sysver \"NA\"\
    \n:if ([:len [/system package find where name=\"system\" and disabled=no]] > 0 and \$rosVer = 6) do={\
    \n    :set sysver [/system package get system version]\
    \n}\
    \n:if ([:len [/system package find where name=\"routeros\" and disabled=no]] > 0 and \$rosVer = 7) do={\
    \n    :set sysver [/system package get routeros version]\
    \n}\
    \n\
    \n:local smtpAddress \"defm.kopcap@gmail.com\"\
    \n:local smtpSubject \"\$sysname pwd restoration (\$stamp)\"\
    \n:local smtpBody \"\"\
    \n\
    \n:set state \"Starting reserve password generator Script...\"\
    \n\$globalNoteMe value=\$state\
    \n\
    \n# special password appendix - current month 3chars\
    \n:local date [/system clock get date]\
    \n:local monthNum [:tonum [:pick \$date 5 7]]\
    \n:local months {\"jan\";\"feb\";\"mar\";\"apr\";\"may\";\"jun\";\"jul\";\"aug\";\"sep\";\"oct\";\"nov\";\"dec\"}\
    \n:local pfx [:pick \$months (\$monthNum - 1)]\
    \n\
    \n:local newPassword [:rndstr length=6 from=\"0123456789dglpqwBHNTQV\"]\
    \n\
    \n:set state \"Randomized: '\$newPassword'\"\
    \n\$globalNoteMe value=\$state\
    \n\
    \n# doing simple salt\
    \n:set newPassword (\$pfx . \$newPassword)\
    \n\
    \n/user set [find name=reserved] password=\$newPassword\
    \n\
    \n# crop appendix\
    \n:local halfPass [:pick \$newPassword 3 11]\
    \n\
    \n:onerror errorDescr in={\
    \n    :set state \"Sending backup password\"\
    \n    \$globalNoteMe value=\$state\
    \n\
    \n    :set smtpBody \"Device additional password: '***\$halfPass'\"\
    \n\
    \n    # email works in background, delay needed\
    \n    /tool e-mail send to=\$smtpAddress body=\$smtpBody subject=\$smtpSubject tls=starttls\
    \n\
    \n    # waiting for email to be delivered\
    \n    :delay 15s\
    \n\
    \n    :if ([/tool e-mail get last-status] != \"succeeded\") do={\
    \n        :error \"e-mail last-status is not succeeded\"\
    \n    }\
    \n\
    \n    \$globalNoteMe value=\"Done\"\
    \n\
    \n} do={\
    \n    :set state \"Error When \$state: \$errorDescr\"\
    \n    \$globalNoteMe value=\$state\
    \n    :set itsOk false\
    \n}\
    \n\
    \n:local inf \"\"\
    \n:if (\$itsOk) do={\
    \n    :set inf \"\E2\9C\93 SUCCESS \$scriptname on \$sysname: pwd restoration completed\"\
    \n}\
    \n\
    \n:if (!\$itsOk) do={\
    \n    :set inf \"\E2\9C\97 FAILED \$scriptname on \$sysname: \$state\"\
    \n}\
    \n\
    \n\$globalNoteMe value=\$inf\
    \n\
    \n:if (!\$itsOk) do={\
    \n    \$globalTgMessage value=\$inf\
    \n    :error \$inf\
    \n}\
    \n\r\
    \n"
/system script add dont-require-permissions=yes name=doCertificatesIssuing owner=owner policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":local sysname [/system identity get name]\r\
    \n:local scriptname \"doCertificatesIssuing\"\r\
    \n:global globalScriptBeforeRun\r\
    \n\$globalScriptBeforeRun \$scriptname\r\
    \n\r\
    \n:global globalNoteMe\r\
    \n:global globalTgMessage\r\
    \n:global globalSecret\r\
    \n:local itsOk true\r\
    \n:local state \"\"\r\
    \n\r\
    \n# generates IPSEC certs: CA, server, IOS *.mobileconfig profile sign and clients\r\
    \n# i recommend to run it on server side\r\
    \n\r\
    \n# clients\r\
    \n:local ids [:toarray \"alx.iphone.rw.20-21,alx.mbp.rw.20-21\"]\r\
    \n:local fakeDomain \"myvpn.fake.org\"\r\
    \n\r\
    \n# Configure CERTIFICATE_EXPORT_PASSPHRASE in \$globalSecret before running.\r\
    \n:local certificateExportPassphrase \"\$[\$globalSecret get CERTIFICATE_EXPORT_PASSPHRASE]\"\r\
    \n\r\
    \n# subject fields should be empty for IPSEC/ike2/RSA to work (filled fields were not functional)\r\
    \n:local country \"\"\r\
    \n:local certState \"\"\r\
    \n:local locality \"\"\r\
    \n:local organization \"\"\r\
    \n:local unit \"\"\r\
    \n\r\
    \n:local keySize \"2048\"\r\
    \n\r\
    \n:local maskedServerIp [/ip address get [find where interface=wan] address]\r\
    \n:local serverIp [:pick \"\$maskedServerIp\" 0 [:find \"\$maskedServerIp\" \"/\" -1]]\r\
    \n\r\
    \n:onerror errorDescr in={\r\
    \n\r\
    \n    :set state \"CA certificates generation...\"\r\
    \n    \$globalNoteMe value=\$state\r\
    \n\r\
    \n    # generate a CA certificate (that will be just a template while not signed)\r\
    \n    # crl-sign allows to use SCEP\r\
    \n    /certificate add name=\"ca.\$fakeDomain\" common-name=\"ca@\$sysname\" subject-alt-name=\"DNS:ca.\$fakeDomain\" key-usage=crl-sign,key-cert-sign country=\"\$country\" state=\"\$certState\" locality=\"\$locality\" organization=\"\$organization\" unit=\"\$unit\" key-size=\"\$keySize\" days-valid=3650\r\
    \n\r\
    \n    :set state \"Signing CA...\"\r\
    \n    \$globalNoteMe value=\$state\r\
    \n\r\
    \n    /certificate sign \"ca.\$fakeDomain\" ca-crl-host=\"\$serverIp\" name=\"ca@\$sysname\"\r\
    \n\r\
    \n    :delay 6s\r\
    \n\r\
    \n    /certificate set trusted=yes \"ca@\$sysname\"\r\
    \n\r\
    \n    :set state \"Exporting CA as PEM...\"\r\
    \n    \$globalNoteMe value=\$state\r\
    \n\r\
    \n    # export the CA, as PEM\r\
    \n    /certificate export-certificate \"ca@\$sysname\" type=pem\r\
    \n\r\
    \n    :set state \"SERVER certificates generation...\"\r\
    \n    \$globalNoteMe value=\$state\r\
    \n\r\
    \n    # generate a server certificate (that will be just a template while not signed)\r\
    \n    /certificate add name=\"server.\$fakeDomain\" common-name=\"server@\$sysname\" subject-alt-name=\"IP:\$serverIp,DNS:\$fakeDomain\" key-usage=tls-server country=\"\$country\" state=\"\$certState\" locality=\"\$locality\" organization=\"\$organization\" unit=\"\$unit\" key-size=\"\$keySize\" days-valid=365\r\
    \n\r\
    \n    :set state \"Signing server...\"\r\
    \n    \$globalNoteMe value=\$state\r\
    \n\r\
    \n    /certificate sign \"server.\$fakeDomain\" ca=\"ca@\$sysname\" name=\"server@\$sysname\"\r\
    \n\r\
    \n    :delay 6s\r\
    \n\r\
    \n    /certificate set trusted=yes \"server@\$sysname\"\r\
    \n\r\
    \n    :set state \"CODE SIGN certificates generation...\"\r\
    \n    \$globalNoteMe value=\$state\r\
    \n\r\
    \n    # generate a code signing (apple IOS profiles) certificate (that will be just a template while not signed)\r\
    \n    /certificate add name=\"sign.\$fakeDomain\" common-name=\"sign@\$sysname\" subject-alt-name=\"DNS:sign.\$fakeDomain\" key-usage=code-sign,digital-signature country=\"\$country\" state=\"\$certState\" locality=\"\$locality\" organization=\"\$organization\" unit=\"\$unit\" key-size=\"\$keySize\" days-valid=365\r\
    \n\r\
    \n    :set state \"Signing code sign...\"\r\
    \n    \$globalNoteMe value=\$state\r\
    \n\r\
    \n    /certificate sign \"sign.\$fakeDomain\" ca=\"ca@\$sysname\" name=\"sign@\$sysname\"\r\
    \n\r\
    \n    :delay 6s\r\
    \n\r\
    \n    /certificate set trusted=yes \"sign@\$sysname\"\r\
    \n\r\
    \n    # export the CA, code sign certificate, and private key\r\
    \n    /certificate export-certificate \"sign@\$sysname\" export-passphrase=\$certificateExportPassphrase type=pkcs12\r\
    \n\r\
    \n    :foreach userName in=\$ids do={\r\
    \n\r\
    \n        :set state \"CLIENT certificates generation...  \$userName\"\r\
    \n        \$globalNoteMe value=\$state\r\
    \n\r\
    \n        # create a client certificate (that will be just a template while not signed)\r\
    \n        /certificate add name=\"client.\$fakeDomain\" common-name=\"\$userName@\$sysname\" subject-alt-name=\"email:\$userName@\$fakeDomain\" key-usage=tls-client country=\"\$country\" state=\"\$certState\" locality=\"\$locality\" organization=\"\$organization\" unit=\"\$unit\" key-size=\"\$keySize\" days-valid=365\r\
    \n\r\
    \n        :set state \"Signing client \$userName...\"\r\
    \n        \$globalNoteMe value=\$state\r\
    \n\r\
    \n        /certificate sign \"client.\$fakeDomain\" ca=\"ca@\$sysname\" name=\"\$userName@\$sysname\"\r\
    \n\r\
    \n        :delay 6s\r\
    \n\r\
    \n        /certificate set trusted=yes \"\$userName@\$sysname\"\r\
    \n\r\
    \n        # export the CA, client certificate, and private key\r\
    \n        /certificate export-certificate \"\$userName@\$sysname\" export-passphrase=\$certificateExportPassphrase type=pkcs12\r\
    \n\r\
    \n    }\r\
    \n\r\
    \n    \$globalNoteMe value=\"Done\"\r\
    \n\r\
    \n} do={\r\
    \n    :set state \"Error When \$state: \$errorDescr\"\r\
    \n    \$globalNoteMe value=\$state\r\
    \n    :set itsOk false\r\
    \n}\r\
    \n\r\
    \n:local inf \"\"\r\
    \n:if (\$itsOk) do={\r\
    \n    :set inf \"\E2\9C\93 SUCCESS \$scriptname on \$sysname: certificates issued and exported\"\r\
    \n}\r\
    \n\r\
    \n:if (!\$itsOk) do={\r\
    \n    :set inf \"\E2\9C\97 FAILED \$scriptname on \$sysname: \$state\"\r\
    \n}\r\
    \n\r\
    \n\$globalNoteMe value=\$inf\r\
    \n\r\
    \n:if (!\$itsOk) do={\r\
    \n    \$globalTgMessage value=\$inf\r\
    \n    :error \$inf\r\
    \n}\r\
    \n\r\
    \n"
/system script add dont-require-permissions=yes name=doFreshTheScripts owner=owner policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":local sysname [/system identity get name]\
    \n:local scriptname \"doFreshTheScripts\"\
    \n:global globalScriptBeforeRun\
    \n\$globalScriptBeforeRun \$scriptname\
    \n\
    \n:global globalNoteMe\
    \n:global globalTgMessage\
    \n:local itsOk true\
    \n:local state \"\"\
    \n\
    \n:local gitHubUserName \"Defm\"\
    \n:local gitHubRepoName \"mikroconf\"\
    \n\
    \n# should be used for private repos\
    \n:local gitHubAccessToken \"\"\
    \n\
    \n:local requestUrl \"https://\$gitHubAccessToken@relay.usetheforce.io/\$gitHubUserName/\$gitHubRepoName/master/src/scripts/\"\
    \n\
    \n# whitelist: scripts absent on the device are skipped with a message\
    \n:local useUpdateList true\
    \n:local updateList [:toarray \"doBackup,doEnvironmentSetup,doEnvironmentClearance,doRandomGen,doFreshTheScripts,doCertificatesIssuing,doSCEPClientCertificatesIssuing,doNetwatchHost,doNetwatchDNS,doDHCPLeaseTrack,doHotspotLoginTrack,doIPSECPunch,doStartupScript,doHeatFlag,doLEDoff,doLEDon,doCPUHighLoadReboot,doUpdatePoliciesRemotely,doUpdateExternalDNS,doCoolConsole,doFlushLogs,doCloudBackup,doDumpTheScripts,doKeepScriptsOwner,doFreshDNSAddressLists,doPushStatsToInfluxDB,doCreateTrafficAccountingQueues,doCheckPingRate,doStaleTSLConnectionsTrack,doCollectSpeedStats,doWestminister,doBumerSound,doSomeAlarm,doImperialMarch,flush_dns,doAdblock,doUpdateStaticDNSviaDHCP,doFastTrackActivation,doTranstaleMAC2IP\"]\
    \n\
    \n:foreach scriptName in=\$updateList do={\
    \n    :if ([:len [/system script find name=\$scriptName]] = 0) do={\
    \n        :set state \"Script '\$scriptName' skipped due to absence\"\
    \n        \$globalNoteMe value=\$state\
    \n    }\
    \n}\
    \n\
    \n:foreach scriptId in=[/system script find] do={\
    \n\
    \n    :local theScript [/system script get \$scriptId name]\
    \n\
    \n    :onerror errorDescr in={\
    \n\
    \n        :if (\$useUpdateList and [:len [find key=\$theScript in=\$updateList]] = 0) do={\
    \n            :set state \"Script '\$theScript' skipped due to setup\"\
    \n            \$globalNoteMe value=\$state\
    \n            :error \"skip-continue\"\
    \n        }\
    \n\
    \n        :set state \"/tool fetch url=\$requestUrl\$\$theScript.rsc.txt output=user as-value\"\
    \n        \$globalNoteMe value=\$state\
    \n\
    \n        # Please keep care about consistency if size over 4096 bytes\
    \n        :local answer [/tool fetch url=\"\$requestUrl\$\$theScript.rsc.txt\" output=user as-value]\
    \n        :local code (\$answer->\"data\")\
    \n        \$globalNoteMe value=\"Done\"\
    \n\
    \n        :set state \"Setting Up Script source for '\$theScript'\"\
    \n        \$globalNoteMe value=\$state\
    \n        /system script set \$theScript source=\"\$code\"\
    \n        \$globalNoteMe value=\"Done\"\
    \n\
    \n        :delay 1s\
    \n\
    \n    } do={\
    \n        # scheduler may append location to :error text; match marker as prefix\
    \n        :if (!(\$errorDescr ~ \"^skip-continue\")) do={\
    \n            :set state \"Error When \$state: \$errorDescr\"\
    \n            \$globalNoteMe value=\$state\
    \n            :set itsOk false\
    \n        }\
    \n    }\
    \n}\
    \n\
    \n:local inf \"\"\
    \n:if (\$itsOk) do={\
    \n    :set inf \"\E2\9C\93 SUCCESS \$scriptname on \$sysname: scripts refreshed\"\
    \n}\
    \n\
    \n:if (!\$itsOk) do={\
    \n    :set inf \"\E2\9C\97 FAILED \$scriptname on \$sysname: \$state\"\
    \n}\
    \n\
    \n\$globalNoteMe value=\$inf\
    \n\
    \n:if (!\$itsOk) do={\
    \n    \$globalTgMessage value=\$inf\
    \n    :error \$inf\
    \n}\
    \n\
    \n"
/system script add dont-require-permissions=yes name=doEnvironmentSetup owner=owner policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="# Example call\
    \n# \$globalNoteMe value=\"12345\"\
    \n# \$globalNoteMe value=\"progress\" verbose=true\
    \n# outputs \$value using both :put and :log info\
    \n# verbose=true is skipped unless :global globalUseVerboseLog is true (quiet markers stay always-on)\
    \n:global globalUseVerboseLog\
    \n:if (!any \$globalUseVerboseLog) do={ :set globalUseVerboseLog false }\
    \n\
    \n:global globalNoteMe\
    \n:if (!any \$globalNoteMe) do={\
    \n    :global globalNoteMe do={\
    \n\
    \n        :global globalUseVerboseLog\
    \n        :if (\$verbose = true) do={\
    \n            :if (!\$globalUseVerboseLog) do={ :return \"\" }\
    \n        }\
    \n\
    \n        :local scriptname [:jobname]\
    \n        :local state \"\$scriptname: \$value\"\
    \n        :put \"\$state\"\
    \n        :log info \"\$state\"\
    \n\
    \n    }\
    \n}\
    \n\
    \n# Example call\
    \n# \$globalScriptBeforeRun \$scriptname\
    \n# \$globalScriptBeforeRun \$scriptname \"NETWATCH\"\
    \n# prevents second instance of the same script and logs the start; \$2 is an optional context postfix\
    \n:global globalScriptBeforeRun\
    \n:if (!any \$globalScriptBeforeRun) do={\
    \n    :global globalScriptBeforeRun do={\
    \n\
    \n        :global globalNoteMe\
    \n        :if ([:len \$1] > 0) do={\
    \n\
    \n            :local scriptname [:jobname]\
    \n            :local context \"\"\
    \n            :if ([:len \$2] > 0) do={ :set context \" (\$2 context)\" }\
    \n\
    \n            :local state \"\$scriptname instance already running - prevent new instance\$context\"\
    \n            :if ([/system script job print count-only as-value where script=\$scriptname] > 1) do={\
    \n                :log error \$state\
    \n                \$globalNoteMe value=\$state\
    \n                :error \$state\
    \n            }\
    \n\
    \n            :set state \"Starting script: \$scriptname\$context\"\
    \n            \$globalNoteMe value=\$state\
    \n\
    \n        }\
    \n    }\
    \n}\
    \n\
    \n# Example call\
    \n# \$globalSafeScriptCall \"doImperialMarch\" \"STARTUP\"\
    \n# runs a script if it exists, never throws; \$2 is an optional context postfix\
    \n# uses :log directly - it may be called before globalNoteMe exists\
    \n:global globalSafeScriptCall\
    \n:if (!any \$globalSafeScriptCall) do={\
    \n    :global globalSafeScriptCall do={\
    \n\
    \n        :local targetScript [:tostr \$1]\
    \n        :local context \"\"\
    \n        :if ([:len \$2] > 0) do={ :set context \" (\$2 context)\" }\
    \n        :local itsOk false\
    \n\
    \n        :if ([:len \$targetScript] = 0) do={ :return \$itsOk }\
    \n\
    \n        :if ([:len [/system script find name=\$targetScript]] = 0) do={\
    \n            :log warning \"Script not found: \$targetScript\$context\"\
    \n            :put \"Script not found: \$targetScript\$context\"\
    \n            :return \$itsOk\
    \n        }\
    \n\
    \n        :onerror errorDescr in={\
    \n            :log warning \"Starting script: \$targetScript\$context\"\
    \n            :put \"Starting script: \$targetScript\$context\"\
    \n            /system script run \$targetScript\
    \n            :set itsOk true\
    \n        } do={\
    \n            :log error \"FAIL Starting script: \$targetScript\$context: \$errorDescr\"\
    \n            :put \"FAIL Starting script: \$targetScript\$context\"\
    \n        }\
    \n\
    \n        :return \$itsOk\
    \n    }\
    \n}\
    \n\
    \n# Example call\
    \n# \$globalSecret\
    \n# \$globalSecret get <name>\
    \n# \$globalSecret set <name> password=<password>\
    \n# \$globalSecret remove <name>\
    \n# \$globalSecret print\
    \n# stored entries are marked in /ppp secret with comment \"used by \$SECRET\" - this marker is data on devices, do not rename\
    \n:global globalSecret\
    \n:if (!any \$globalSecret) do={\
    \n    :global globalSecret do={\
    \n\
    \n        :global globalSecret\
    \n\
    \n        # helpers\
    \n        :local fixprofile do={\
    \n            :if ([/ppp profile find name=\"null\"]) do={ :put \"nothing\" } else={\
    \n                /ppp profile add bridge-learning=no change-tcp-mss=no local-address=0.0.0.0 name=\"null\" only-one=yes remote-address=0.0.0.0 session-timeout=1s use-compression=no use-encryption=no use-mpls=no use-upnp=no\
    \n            }\
    \n        }\
    \n\
    \n        :local lppp [:len [/ppp secret find where name=\$2]]\
    \n\
    \n        :local checkexist do={\
    \n            :if (\$lppp = 0) do={\
    \n                :error \"\\\$globalSecret: cannot find \$2 in secret store\"\
    \n            }\
    \n        }\
    \n\
    \n        # \$globalSecret\
    \n        :if ([:typeof \$1] != \"str\") do={\
    \n            :put \"\\\$globalSecret\"\
    \n            :put \"   uses /ppp/secrets to store stuff like REST apikeys, or other sensitive data\"\
    \n            :put \"\\t\\\$globalSecret print - prints stored secret passwords\"\
    \n            :put \"\\t\\\$globalSecret get <name> - gets a stored secret\"\
    \n            :put \"\\t\\\$globalSecret set <name> password=\\\"YOUR_SECRET\\\" - sets a secret password\"\
    \n            :put \"\\t\\\$globalSecret remove <name> - removes a secret\"\
    \n            :return\
    \n        }\
    \n\
    \n        # \$globalSecret print\
    \n        :if (\$1~\"^pr\") do={\
    \n            /ppp secret print where comment~\"\\\\\\\$SECRET\"\
    \n            :return\
    \n        }\
    \n\
    \n        # \$globalSecret get\
    \n        :if (\$1~\"get\") do={\
    \n            \$checkexist\
    \n            :local sid [/ppp secret find where name=\$2]\
    \n            :if ([:len \$sid] = 0) do={ :error \"\\\$globalSecret: cannot find \$2 in secret store\" }\
    \n            :return [/ppp secret get \$sid password]\
    \n        }\
    \n\
    \n        # \$globalSecret set\
    \n        :if (\$1~\"set|add\") do={\
    \n            :if ([:typeof \$password] = \"str\") do={} else={ :error \"\\\$globalSecret: password= required\" }\
    \n            :if (\$lppp = 0) do={\
    \n                /ppp secret add name=\$2 password=\$password\
    \n            } else={\
    \n                /ppp secret set [/ppp secret find where name=\$2] password=\$password\
    \n            }\
    \n            \$fixprofile\
    \n            /ppp secret set [/ppp secret find where name=\$2] comment=\"used by \\\$SECRET\"\
    \n            /ppp secret set [/ppp secret find where name=\$2] profile=\"null\"\
    \n            /ppp secret set [/ppp secret find where name=\$2] service=\"async\"\
    \n            :return [\$globalSecret get \$2]\
    \n        }\
    \n\
    \n        # \$globalSecret remove\
    \n        :if (\$1~\"rm|rem|del\") do={\
    \n            \$checkexist\
    \n            :return [/ppp secret remove [/ppp secret find where name=\$2]]\
    \n        }\
    \n\
    \n        :error \"\\\$globalSecret: bad command\"\
    \n    }\
    \n}\
    \n\
    \n# Example call\
    \n# \$globalTgMessage value=\"text\"\
    \n:global globalTgMessage\
    \n:if (!any \$globalTgMessage) do={\
    \n    :global globalTgMessage do={\
    \n\
    \n        :global globalNoteMe\
    \n        :global globalSecret\
    \n        :global globalTimestamp\
    \n\
    \n        :local tToken \"\$[\$globalSecret get TELEGRAM_TOKEN]\"\
    \n        :local tGroupId \"\$[\$globalSecret get TELEGRAM_CHAT_ID]\"\
    \n        :local tUrl \"https://relay.usetheforce.io/bot\$tToken/sendMessage\\\?chat_id=\$tGroupId\"\
    \n\
    \n        :local sysname (\"#\" . [/system identity get name])\
    \n        :local scriptname [:jobname]\
    \n\
    \n        :local tgMessage (\"\$scriptname %C2%A9%EF%B8%8F \$sysname: \$value\")\
    \n\
    \n        :local state \"Sending telegram message... \$tgMessage\"\
    \n        \$globalNoteMe value=\$tgMessage\
    \n\
    \n        :onerror errorDescr in={\
    \n            :local logName (\"RAM/\" . [\$globalTimestamp] . \"-\" . [:rndstr length=6 from=\"HtsP2n8qZ\"] . \".telegram.log.txt\")\
    \n            :local fetchCmd \"/tool fetch http-method=post mode=https url=\\\"\$tUrl\\\" http-data=\\\"text=\$tgMessage\\\" keep-result=no\"\
    \n\
    \n            /file remove [find where name=\$logName]\
    \n            :local jobId [:execute file=\$logName script=\$fetchCmd]\
    \n            :local ticks 0\
    \n            :local timedOut false\
    \n\
    \n            :while (([:len [/system script job find where .id=\$jobId]] = 1) && (\$ticks < 30)) do={\
    \n                :set ticks (\$ticks + 1)\
    \n                :delay 1s\
    \n            }\
    \n\
    \n            :if ([:len [/system script job find where .id=\$jobId]] = 1) do={\
    \n                /system script job remove \$jobId\
    \n                :set timedOut true\
    \n            }\
    \n\
    \n            :local protocol \"\"\
    \n            :local logFile [/file find where name=\$logName]\
    \n            :if ([:len \$logFile] = 1) do={\
    \n                :set protocol [/file get \$logFile contents]\
    \n                /file remove \$logFile\
    \n            }\
    \n\
    \n            :if (\$timedOut) do={\
    \n                :error \"Telegram fetch timed out after 30s: \$protocol\"\
    \n            }\
    \n\
    \n            :if (!(\$protocol ~ \"status: finished\")) do={\
    \n                :error \"Telegram fetch failed: \$protocol\"\
    \n            }\
    \n        } do={\
    \n            :set state \"Telegram notify error: \$errorDescr\"\
    \n            \$globalNoteMe value=\$state\
    \n        }\
    \n    }\
    \n}\
    \n\
    \n# Example call\
    \n# \$globalIPSECPolicyUpdateViaSSH 1.2.3.4\
    \n:global globalIPSECPolicyUpdateViaSSH\
    \n:if (!any \$globalIPSECPolicyUpdateViaSSH) do={\
    \n    :global globalIPSECPolicyUpdateViaSSH do={\
    \n\
    \n        :global globalRemoteIp\
    \n        :global globalNoteMe\
    \n\
    \n        :if ([:len \$1] > 0) do={\
    \n            :global globalRemoteIp (\"\$1\" . \"/32\")\
    \n        }\
    \n\
    \n        :if (!any \$globalRemoteIp) do={\
    \n            :global globalRemoteIp \"0.0.0.0/32\"\
    \n        }\
    \n\
    \n        :local state \"RPC... \$value\"\
    \n        \$globalNoteMe value=\$state\
    \n        :local count [:len [/system script find name=\"doUpdatePoliciesRemotely\"]]\
    \n        :if (\$count > 0) do={\
    \n            :set state \"Starting policies process... \$globalRemoteIp\"\
    \n            \$globalNoteMe value=\$state\
    \n            /system script run doUpdatePoliciesRemotely\
    \n        }\
    \n    }\
    \n}\
    \n\
    \n# Example call\
    \n# \$globalNewNetworkMember ip=192.168.90.130 mac=50:DE:06:25:C2:FC gip=192.168.98.130 comm=iPadAlxPro ssid=\"WiFi 5\"\
    \n:global globalNewNetworkMember\
    \n:if (!any \$globalNewNetworkMember) do={\
    \n    :global globalNewNetworkMember do={\
    \n\
    \n        :global globalNoteMe\
    \n\
    \n        # to prevent connection\
    \n        :local guestDhcp \"guest-dhcp-server\"\
    \n\
    \n        # to allow connection\
    \n        :local mainDhcp \"main-dhcp-server\"\
    \n\
    \n        # when DHCP not using (add arp for leases)\
    \n        :local arpInterface \"main-infrastructure-br\"\
    \n        :local state \"Adding new network member... \"\
    \n        \$globalNoteMe value=\$state\
    \n\
    \n        # incoming named params\
    \n        :local newIp [:tostr \$ip]\
    \n        :local newBlockedIp [:tostr \$gip]\
    \n        :local newMac [:tostr \$mac]\
    \n        :local comment [:tostr \$comm]\
    \n        :local newSsid [:tostr \$ssid]\
    \n        :if ([:len \$newIp] > 0) do={\
    \n            :if ([:typeof [:toip \$newIp]] != \"ip\") do={\
    \n                :set state \"Error: bad IP parameter passed - (\$newIp)\"\
    \n                \$globalNoteMe value=\$state\
    \n                :return false\
    \n            }\
    \n        } else={\
    \n            :set state \"Error: bad IP parameter passed - (\$newIp)\"\
    \n            \$globalNoteMe value=\$state\
    \n            :return false\
    \n        }\
    \n\
    \n        :onerror errorDescr in={\
    \n\
    \n            :set state \"Removing existing DHCP configuration for (\$newIp/\$newMac) on \$mainDhcp\"\
    \n            \$globalNoteMe value=\$state\
    \n            /ip dhcp-server lease remove [find address=\$newIp]\
    \n            /ip dhcp-server lease remove [find mac-address=\$newMac]\
    \n\
    \n            :set state \"Adding DHCP configuration for (\$newIp/\$newMac) on \$mainDhcp\"\
    \n            \$globalNoteMe value=\$state\
    \n\
    \n            :if ([:len [/ip dhcp-server find where name=\"\$mainDhcp\"]] > 0) do={\
    \n                /ip dhcp-server lease add address=\$newIp mac-address=\$newMac server=\$mainDhcp comment=\$comment\
    \n                \$globalNoteMe value=\"Done\"\
    \n            } else={\
    \n                :set state \"Cant find DHCP server \$mainDhcp. SKIPPED.\"\
    \n                \$globalNoteMe value=\$state\
    \n            }\
    \n\
    \n        } do={\
    \n            :set state \"Error: something fail on DHCP configuration 'allow' step for (\$newIp/\$newMac) on \$mainDhcp: \$errorDescr\"\
    \n            \$globalNoteMe value=\$state\
    \n            :return false\
    \n        }\
    \n\
    \n        :onerror errorDescr in={\
    \n\
    \n            /ip dhcp-server lease remove [find address=\$newBlockedIp]\
    \n            :set state \"Adding DHCP configuration for (\$newBlockedIp/\$newMac) on \$guestDhcp (preventing connections to guest network)\"\
    \n            \$globalNoteMe value=\$state\
    \n\
    \n            :if ([:len [/ip dhcp-server find where name=\"\$guestDhcp\"]] > 0) do={\
    \n                /ip dhcp-server lease add address=\$newBlockedIp block-access=yes mac-address=\$newMac server=\$guestDhcp comment=(\$comment . \"(blocked)\")\
    \n                \$globalNoteMe value=\"Done\"\
    \n            } else={\
    \n                :set state \"Cant find DHCP server \$guestDhcp. SKIPPED.\"\
    \n                \$globalNoteMe value=\$state\
    \n            }\
    \n\
    \n        } do={\
    \n            :set state \"Error: something fail on DHCP configuration 'block' step for (\$newBlockedIp/\$newMac) on \$guestDhcp: \$errorDescr\"\
    \n            \$globalNoteMe value=\$state\
    \n            :return false\
    \n        }\
    \n\
    \n        :onerror errorDescr in={\
    \n\
    \n            :set state \"Adding ARP static entries for (\$newBlockedIp/\$newMac) on \$mainDhcp\"\
    \n            \$globalNoteMe value=\$state\
    \n            /ip arp remove [find address=\$newIp]\
    \n            /ip arp remove [find address=\$newBlockedIp]\
    \n            /ip arp remove [find mac-address=\$newMac]\
    \n\
    \n            :if ([:len [/interface find where name=\"\$arpInterface\"]] > 0) do={\
    \n                /ip arp add address=\$newIp interface=\$arpInterface mac-address=\$newMac comment=\$comment\
    \n                \$globalNoteMe value=\"Done\"\
    \n            } else={\
    \n                :set state \"Cant find interface \$arpInterface. SKIPPED.\"\
    \n                \$globalNoteMe value=\$state\
    \n            }\
    \n\
    \n        } do={\
    \n            :set state \"Error: something fail on ARP configuration step: \$errorDescr\"\
    \n            \$globalNoteMe value=\$state\
    \n            :return false\
    \n        }\
    \n\
    \n        :onerror errorDescr in={\
    \n\
    \n            :set state \"Adding CAPs ACL static entries for (\$newBlockedIp/\$newMac) on \$newSsid\"\
    \n            \$globalNoteMe value=\$state\
    \n\
    \n            # avoid parse errors using Execute when no wireless package installed\
    \n            :if ([:len [/system package find where name=\"wireless\" and disabled=no]] > 0) do={\
    \n                :local asyncCmd \"/caps-man access-list remove [find mac-address=\$newMac];\"\
    \n                :local jobid [:execute script=\$asyncCmd]\
    \n\
    \n                :set asyncCmd \"/caps-man access-list add action=accept allow-signal-out-of-range=10s client-to-client-forwarding=yes comment=\\\"\$comment\\\" disabled=no mac-address=\$newMac ssid-regexp=\\\"\$newSsid\\\" place-before=1;\"\
    \n                :set jobid [:execute script=\$asyncCmd]\
    \n            }\
    \n\
    \n        } do={\
    \n            :set state \"Error: something fail on CAPS configuration step: \$errorDescr\"\
    \n            \$globalNoteMe value=\$state\
    \n            :return false\
    \n        }\
    \n\
    \n        :return true\
    \n\
    \n    }\
    \n}\
    \n\
    \n# Example call\
    \n# \$globalNewClientCert argClients=\"anna.ipsec, mikrouter.ipsec\" argUsage=\"tls-client,digital-signature,key-encipherment\"\
    \n# \$globalNewClientCert argClients=\"anna.capsman, mikrouter.capsman\" argUsage=\"digital-signature,key-encipherment\"\
    \n# \$globalNewClientCert argClients=\"anna.proxy\" argUsage=\"tls-server,digital-signature,key-encipherment\" addSAN=\"*.anna.home\"\
    \n# \$globalNewClientCert argClients=\"185.13.148.14\" argUsage=\"tls-server\" argBindAsIP=\"any\"\
    \n:global globalNewClientCert\
    \n:if (!any \$globalNewClientCert) do={\
    \n    :global globalNewClientCert do={\
    \n\
    \n        # generates IPSEC certs CLIENT TEMPLATE, then requests SCEP to sign it\
    \n        # This script is a SCEP-client, it request the server to provide a new certificate\
    \n        # it ONLY form the request via API to remote SCEP server\
    \n\
    \n        # incoming named params\
    \n        :local clients [:tostr \$argClients]\
    \n        :local prefs [:tostr \$argUsage]\
    \n        :local asIp \$argBindAsIP\
    \n        :local san \$addSAN\
    \n\
    \n        # scope global functions\
    \n        :global globalNoteMe\
    \n        :global globalSecret\
    \n\
    \n        :local state \"\"\
    \n\
    \n        :if ([:len \$clients] > 0) do={\
    \n            :if ([:typeof [:tostr \$clients]] != \"str\") do={\
    \n                :set state \"Error: bad 'clients' parameter passed - (\$clients)\"\
    \n                \$globalNoteMe value=\$state\
    \n                :return false\
    \n            }\
    \n        } else={\
    \n            :set state \"Error: bad 'clients' parameter passed - (\$clients)\"\
    \n            \$globalNoteMe value=\$state\
    \n            :return false\
    \n        }\
    \n\
    \n        :onerror errorDescr in={\
    \n\
    \n            # clients\
    \n            :local ids [:toarray \"\$clients\"]\
    \n            :local fakeDomain \"myvpn.fake.org\"\
    \n            :local scepAlias \"CHR\"\
    \n            :set state \"Started requests generation\"\
    \n            \$globalNoteMe value=\$state\
    \n\
    \n            # this fields should be empty IPSEC/ike2/RSA to work, i can't get it functional with filled fields\
    \n            :local country \"RU\"\
    \n            :local certState \"MSC\"\
    \n            :local locality \"Moscow\"\
    \n            :local organization \"IKEv2 Home\"\
    \n            :local unit \"IKEv2 Mikrotik\"\
    \n\
    \n            :local keySize \"2048\"\
    \n\
    \n            :local scepUrl \"http://185.13.148.14/scep/grant\"\
    \n\
    \n            :local tname \"\"\
    \n            :foreach userName in=\$ids do={\
    \n\
    \n                :if ([:typeof \$san] != \"str\") do={\
    \n                    :set san \$userName\
    \n                }\
    \n\
    \n                # create a client certificate (that will be just a template while not signed)\
    \n                :if ([:len \$asIp] > 0) do={\
    \n\
    \n                    :set state \"CLIENT TEMPLATE certificates generation as IP...  \$userName\"\
    \n                    \$globalNoteMe value=\$state\
    \n\
    \n                    :set tname \"S.\$userName@\$scepAlias\"\
    \n\
    \n                    :if ([:len [/certificate find where name=\"\$tname\"]] > 0) do={\
    \n                        :set state \"Error: found certificate named (\$tname) -  cannot create the same one\"\
    \n                        \$globalNoteMe value=\$state\
    \n                        :return false\
    \n                    } else={\
    \n                        /certificate add name=\"\$tname\" common-name=\"\$userName@\$scepAlias\" subject-alt-name=\"IP:\$userName,DNS:\$fakeDomain\" key-usage=\$prefs country=\"\$country\" state=\"\$certState\" locality=\"\$locality\" organization=\"\$organization\" unit=\"\$unit\" key-size=\"\$keySize\" days-valid=365\
    \n                    }\
    \n\
    \n                } else={\
    \n\
    \n                    :set state \"CLIENT TEMPLATE certificates generation as EMAIL...  \$userName\"\
    \n                    \$globalNoteMe value=\$state\
    \n\
    \n                    :set tname \"C.\$userName@\$scepAlias\"\
    \n\
    \n                    :if ([:len [/certificate find where name=\"\$tname\"]] > 0) do={\
    \n                        :set state \"Error: found certificate named (\$tname) -  cannot create the same one\"\
    \n                        \$globalNoteMe value=\$state\
    \n                        :return false\
    \n                    } else={\
    \n                        /certificate add name=\"\$tname\" common-name=\"\$userName@\$scepAlias\" subject-alt-name=\"email:\$userName@\$fakeDomain,DNS:\$san\" key-usage=\$prefs country=\"\$country\" state=\"\$certState\" locality=\"\$locality\" organization=\"\$organization\" unit=\"\$unit\" key-size=\"\$keySize\" days-valid=365\
    \n                    }\
    \n\
    \n                }\
    \n\
    \n                :set state \"Pushing sign request...\"\
    \n                \$globalNoteMe value=\$state\
    \n                /certificate add-scep template=\"\$tname\" scep-url=\"\$scepUrl\"\
    \n\
    \n                :delay 6s\
    \n\
    \n                # we now have to wait while on remote [mikrotik] this request will be granted and pushed back ready-to-use certificate\
    \n                :set state \"We now have to wait while on remote [mikrotik] this request will be granted and pushed back ready-to-use certificate... \"\
    \n                \$globalNoteMe value=\$state\
    \n\
    \n                :set state \"Proceed to remote SCEP please, find this request and approve it. I'll wait 30 seconds\"\
    \n                \$globalNoteMe value=\$state\
    \n\
    \n                :delay 30s\
    \n\
    \n                :local baseLength 5\
    \n                :for j from=1 to=\$baseLength do={\
    \n                    :if ([:len [/certificate find where status=\"idle\" name=\"\$tname\"]] > 0) do={\
    \n\
    \n                        :set state \"Got it at last. Exporting to file\"\
    \n                        \$globalNoteMe value=\$state\
    \n\
    \n                        /certificate set trusted=yes [find where name=\"\$tname\" and status=\"idle\"]\
    \n\
    \n                        # export the CA, client certificate, and private key\
    \n                        # Configure CERTIFICATE_EXPORT_PASSPHRASE in \$globalSecret before requesting export.\
    \n                        /certificate export-certificate [find where name=\"\$tname\" and status=\"idle\"] export-passphrase=\"\$[\$globalSecret get CERTIFICATE_EXPORT_PASSPHRASE]\" type=pkcs12\
    \n\
    \n                        :return true\
    \n\
    \n                    } else={\
    \n\
    \n                        :set state \"Waiting for mikrotik to download the certificate...\"\
    \n                        \$globalNoteMe value=\$state\
    \n                        :delay 8s\
    \n\
    \n                    }\
    \n                }\
    \n            }\
    \n\
    \n            :return false\
    \n\
    \n        } do={\
    \n            :set state \"Error: something fail on SCEP certificates issuing step: \$errorDescr\"\
    \n            \$globalNoteMe value=\$state\
    \n            :return false\
    \n        }\
    \n    }\
    \n}\
    \n\
    \n# Example call\
    \n# :put [\$globalTimestamp]\
    \n# returns \"yyyyMMdd-HHmmss\" for both old and new RouterOS date formats\
    \n:global globalTimestamp\
    \n:if (!any \$globalTimestamp) do={\
    \n    :global globalTimestamp do={\
    \n        /system clock\
    \n        :local vdate [get date]\
    \n        :local vtime [get time]\
    \n        :local vdoff [:toarray \"0,4,5,7,8,10\"]\
    \n        :local mon2 [:pick \$vdate (\$vdoff->2) (\$vdoff->3)]\
    \n        :local mon [:tonum \$mon2]\
    \n        :if (\$vdate ~ \".../../....\") do={\
    \n            :set vdoff [:toarray \"7,11,1,3,4,6\"]\
    \n            :set mon ([:find \"xxanebarprayunulugepctovecANEBARPRAYUNULUGEPCTOVEC\" [:pick \$vdate (\$vdoff->2) (\$vdoff->3)] -1] / 2)\
    \n            :if (\$mon > 12) do={ :set mon (\$mon - 12) }\
    \n            :set mon2 [:pick (100 + \$mon) 1 3]\
    \n        }\
    \n        :local yyyy [:pick \$vdate (\$vdoff->0) (\$vdoff->1)]\
    \n        :local dd [:pick \$vdate (\$vdoff->4) (\$vdoff->5)]\
    \n        :local hh [:pick \$vtime 0 2]\
    \n        :local mm [:pick \$vtime 3 5]\
    \n        :local ss [:pick \$vtime 6 8]\
    \n\
    \n        :return \"\$yyyy\$mon2\$dd-\$hh\$mm\$ss\"\
    \n    }\
    \n}\
    \n\
    \n# Example call\
    \n# \$globalCallFetch \"/tool fetch url=sftp://host:port/dst src-path=file user=u password=p upload=yes\"\
    \n# calls Fetch as a background job and reports its output\
    \n:global globalCallFetch\
    \n:if (!any \$globalCallFetch) do={\
    \n    :global globalCallFetch do={\
    \n\
    \n        :global globalNoteMe\
    \n        :global globalTimestamp\
    \n        :global globalFetchWaitTicks\
    \n\
    \n        :if ([:len \$1] > 0) do={\
    \n\
    \n            :local asyncCmd \"\$1\"\
    \n\
    \n            :local state \"I'm now putting: \$asyncCmd\"\
    \n            \$globalNoteMe value=\$state verbose=true\
    \n\
    \n            :local stamp [\$globalTimestamp]\
    \n\
    \n            :local salt [:rndstr length=6 from=\"HtsP2n8qZ\"]\
    \n            :local logName \"RAM/\$stamp-\$salt.log.txt\"\
    \n\
    \n            /file remove [find where name=\"\$logName\"]\
    \n\
    \n            :local jobid [:execute file=\$logName script=\$asyncCmd]\
    \n\
    \n            :set state \"Waiting the end of process for protocol \$logName to be ready, max 30 seconds...\"\
    \n            \$globalNoteMe value=\$state verbose=true\
    \n\
    \n            :set globalFetchWaitTicks 0\
    \n            :while (([:len [/system script job find where .id=\$jobid]] = 1) && (\$globalFetchWaitTicks < 30)) do={\
    \n                :set globalFetchWaitTicks (\$globalFetchWaitTicks + 1)\
    \n                :delay 1s\
    \n\
    \n                :set state \"waiting fetch result... \$globalFetchWaitTicks\"\
    \n                \$globalNoteMe value=\$state verbose=true\
    \n            }\
    \n\
    \n            :set state \"Done. Elapsed Seconds: \$globalFetchWaitTicks\\r\\n\"\
    \n            \$globalNoteMe value=\$state verbose=true\
    \n\
    \n            :if ([:len [/file find where name=\"\$logName\"]] = 1) do={\
    \n\
    \n                :local filecontent [/file get [/file find where name=\"\$logName\"] contents]\
    \n                :set state \"Result of Fetch:\\r\\n****************************\\r\\n\$filecontent\\r\\n****************************\"\
    \n                \$globalNoteMe value=\$state verbose=true\
    \n\
    \n                /file remove [find where name=\"\$logName\"]\
    \n\
    \n            } else={\
    \n\
    \n                :set state \"Result of Fetch:\\r\\n****************************\\r\\n 30Sec Timeout exceeded - still no log file \\r\\n****************************\"\
    \n                \$globalNoteMe value=\$state verbose=true\
    \n\
    \n            }\
    \n        }\
    \n    }\
    \n}\
    \n\
    \n# Example call\
    \n# :local errorDef [\$globalCallSftp \"RAM/scripts/doBackup.rsc.txt\" \"REPO/raw/src/scripts/doBackup.rsc.txt\"]\
    \n# \$1=src \$2=dst (positional \E2\80\94 named src=/dst= empty inside :global do= on field 7.x)\
    \n# operation - returns \"\" on success, error text otherwise\
    \n# prefix sftp-session-cut: caller stops the remaining uploads\
    \n:global globalCallSftp\
    \n:if (!any \$globalCallSftp) do={\
    \n    :global globalCallSftp do={\
    \n\
    \n        :global globalNoteMe\
    \n        :global globalSecret\
    \n        :global globalTimestamp\
    \n\
    \n        :local src [:tostr \$1]\
    \n        :local dst [:tostr \$2]\
    \n\
    \n        :if (([:len \$src] = 0) or ([:len \$dst] = 0)) do={\
    \n            :return \"sftp: src and dst are required\"\
    \n        }\
    \n\
    \n        :local ftpServer \"\$[\$globalSecret get SSH_SERVER]\"\
    \n        :local ftpPort \"\$[\$globalSecret get SSH_PORT]\"\
    \n        :local ftpUser \"\$[\$globalSecret get SSH_USER]\"\
    \n        :local ftpPass \"\$[\$globalSecret get SSH_PASSWORD]\"\
    \n        :local logName (\"RAM/\" . [\$globalTimestamp] . \"-\" . [:rndstr length=6 from=\"HtsP2n8qZ\"] . \".log.txt\")\
    \n        # no \\\" inside \"...\" \E2\80\94 RouterOS ends the string at the inner quote\
    \n        # 90s: ~1MB WAN upload can exceed the old 30s idle/parent wait\
    \n        :local fetchCmd \"/tool fetch mode=sftp address=\$ftpServer port=\$ftpPort user=\$ftpUser password=\$ftpPass src-path=\$src dst-path=\$dst upload=yes idle-timeout=90s\"\
    \n        :local state \"Call: /tool fetch mode=sftp address=\$ftpServer port=\$ftpPort user=\$ftpUser src-path=\$src dst-path=\$dst upload=yes idle-timeout=90s\"\
    \n        \$globalNoteMe value=\$state verbose=true\
    \n\
    \n        /file remove [find where name=\$logName]\
    \n        :local jobId [:execute file=\$logName script=\$fetchCmd]\
    \n        :local ticks 0\
    \n        :local protocol \"\"\
    \n\
    \n        :while (([:len [/system script job find where .id=\$jobId]] = 1) && (\$ticks < 90)) do={\
    \n            :set ticks (\$ticks + 1)\
    \n            :delay 1s\
    \n            :if ([:len [/file find where name=\$logName]] = 1) do={\
    \n                :set protocol [/file get [find where name=\$logName] contents]\
    \n            }\
    \n            \$globalNoteMe value=(\"sftp \" . \$src . \" to \" . \$dst . \" waiting \" . \$ticks . \" s\") verbose=true\
    \n        }\
    \n\
    \n        :if ([:len [/system script job find where .id=\$jobId]] = 1) do={\
    \n            /system script job remove \$jobId\
    \n            /file remove [find where name=\$logName]\
    \n            :return (\"sftp-session-cut still running after \" . \$ticks . \" s \" . \$src . \" to \" . \$dst . \" \" . \$protocol)\
    \n        }\
    \n\
    \n        :if ([:len [/file find where name=\$logName]] = 1) do={\
    \n            :set protocol [/file get [find where name=\$logName] contents]\
    \n            /file remove [find where name=\$logName]\
    \n        }\
    \n\
    \n        # missing remote parent dir on canary: uploading uploaded=total then\
    \n        # failure: closing connection: <sftp status: 20> \E2\80\A6 (/tool/fetch; line 1)\
    \n        :local dirHint \" hint: check remote parent dir exists (fetch does not mkdir); or SSH ban\"\
    \n\
    \n        :if ((\$protocol ~ \"status: failed\") || (\$protocol ~ \"sftp status: 20\") || (\$protocol ~ \"timed out\") || (\$protocol ~ \"timeout\")) do={\
    \n            :return (\"sftp-session-cut \" . \$src . \" to \" . \$dst . \" \" . \$protocol . \$dirHint)\
    \n        }\
    \n\
    \n        :if (\$protocol ~ \"status: finished\") do={\
    \n            \$globalNoteMe value=(\"sftp finished \" . \$src . \" to \" . \$dst) verbose=true\
    \n            :return \"\"\
    \n        }\
    \n\
    \n        :return (\"sftp upload failed \" . \$src . \" to \" . \$dst . \" \" . \$protocol . \$dirHint)\
    \n    }\
    \n}\
    \n\
    \n# Example call\
    \n# :put [\$globalOnPrimaryPartition]\
    \n# test if we are boot up from a primary partition (not fallback or recovery); predicate - returns true/false\
    \n:global globalOnPrimaryPartition\
    \n:if (!any \$globalOnPrimaryPartition) do={\
    \n    :global globalOnPrimaryPartition do={\
    \n\
    \n        :global globalNoteMe\
    \n\
    \n        :local partitionName \"primary\"\
    \n        :local onPrimaryPartition false\
    \n        :local state \"\"\
    \n\
    \n        :local partitionsActivated [system/device-mode/get partitions]\
    \n\
    \n        :if (!\$partitionsActivated) do={\
    \n            :set state \"Investigation result - partitions disabled\"\
    \n            \$globalNoteMe value=\$state verbose=true\
    \n            :set onPrimaryPartition true\
    \n            :return \$onPrimaryPartition\
    \n        }\
    \n\
    \n        :local partition\
    \n        :onerror errorDescr in={\
    \n\
    \n            # device may have no /partitions command if it is 16Mb\
    \n            :set partition [/partitions find name=\$partitionName]\
    \n\
    \n        } do={\
    \n\
    \n            :set state \"Investigation result - device has no /partitions submenu\"\
    \n            \$globalNoteMe value=\$state verbose=true\
    \n            :set onPrimaryPartition true\
    \n            :return \$onPrimaryPartition\
    \n        }\
    \n\
    \n        :onerror errorDescr in={\
    \n\
    \n            # test if it exist in /partitions\
    \n            :if ([:len \$partition] > 0) do={\
    \n                :local running [/partition get \$partition running]\
    \n                :if (\$running) do={\
    \n                    :set onPrimaryPartition true\
    \n                    :error \"primary active\"\
    \n                } else={\
    \n                    :set onPrimaryPartition false\
    \n                    :error \"primary inactive\"\
    \n                }\
    \n            } else={\
    \n                :set onPrimaryPartition true\
    \n                :error \"partitions not set\"\
    \n            }\
    \n\
    \n        } do={\
    \n\
    \n            :set state \"Investigation result - \$errorDescr\"\
    \n            \$globalNoteMe value=\$state verbose=true\
    \n\
    \n            :return \$onPrimaryPartition\
    \n        }\
    \n\
    \n        :return \$onPrimaryPartition\
    \n    }\
    \n}\
    \n\
    \n# Example call\
    \n# :local errorDef [\$globalCallSSH \":global globalRemoteIp 1.2.3.4/32\"]\
    \n# operation - returns \"\" on success, error text otherwise; SSH target is taken from \$globalSecret SSH_*\
    \n:global globalCallSSH\
    \n:if (!any \$globalCallSSH) do={\
    \n    :global globalCallSSH do={\
    \n\
    \n        :global globalNoteMe\
    \n        :global globalSecret\
    \n\
    \n        :local asyncCmd \$1\
    \n\
    \n        :if ([:len \$asyncCmd] = 0) do={\
    \n            :return \"RPC: ssh empty command\"\
    \n        }\
    \n\
    \n        :local sshServer \"\$[\$globalSecret get SSH_SERVER]\"\
    \n        :local sshPort \"\$[\$globalSecret get SSH_PORT]\"\
    \n        :local sshUser \"\$[\$globalSecret get SSH_USER]\"\
    \n        :local sshPass \"\$[\$globalSecret get SSH_PASSWORD]\"\
    \n\
    \n        :local state \"\"\
    \n\
    \n        :onerror errorDescr in={\
    \n\
    \n            :set state \"Call: /system ssh-exec address=\$sshServer user=\$sshUser port=\$sshPort command=\\\"\$asyncCmd\\\" as-value\"\
    \n            \$globalNoteMe value=\$state verbose=true\
    \n\
    \n            :local result [/system ssh-exec address=\$sshServer user=\$sshUser password=\$sshPass port=\$sshPort command=\$asyncCmd as-value]\
    \n            :local exitCode ([\$result]->\"exit-code\")\
    \n\
    \n            :if (\$exitCode != 0) do={\
    \n                :set state \"RPC: ssh command returned exit code (\$exitCode)\"\
    \n            } else={\
    \n                # no errors - success operation\
    \n                :set state \"\"\
    \n            }\
    \n\
    \n        } do={\
    \n            :set state \"RPC: ssh error when \$state: \$errorDescr\"\
    \n            \$globalNoteMe value=\$state\
    \n        }\
    \n\
    \n        :return \$state\
    \n    }\
    \n}\
    \n\
    \n# Example call\
    \n# \$globalApplyKnock ip=1.2.3.4 comment=\"doBackup\"\
    \n# opens alist-fw-ssh-allow and clears stale SSH stages; RPC operation - throws on failure\
    \n:global globalApplyKnock\
    \n:if (!any \$globalApplyKnock) do={\
    \n    :global globalApplyKnock do={\
    \n\
    \n        :global globalNoteMe\
    \n\
    \n        # snapshot invocation-scoped named parameters; SSH command literals arrive as strings\
    \n        :local knockIp [:toip \$ip]\
    \n        :local knockComment [:tostr \$comment]\
    \n        :local state \"Validating remote knock parameters\"\
    \n\
    \n        :onerror errorDescr in={\
    \n\
    \n            :if ([:typeof \$knockIp] != \"ip\") do={\
    \n                :error \"remote knock parameter has invalid IP\"\
    \n            }\
    \n\
    \n            :if ([:len \$knockComment] = 0) do={\
    \n                :error \"remote knock parameter has empty comment\"\
    \n            }\
    \n\
    \n            :set state \"Opening SFTP backdoor for \$knockIp\"\
    \n            \$globalNoteMe value=\$state verbose=true\
    \n\
    \n            /ip firewall address-list {\
    \n                remove [find list=alist-fw-ssh-allow address=\$knockIp]\
    \n                add address=\$knockIp list=alist-fw-ssh-allow comment=\$knockComment timeout=5m dynamic=yes\
    \n\
    \n                # the SSH request carrying this call may have advanced a stale stage\
    \n                remove [find list=alist-fw-ssh-stage1 address=\$knockIp]\
    \n                remove [find list=alist-fw-ssh-stage2 address=\$knockIp]\
    \n                remove [find list=alist-fw-ssh-stage3 address=\$knockIp]\
    \n            }\
    \n\
    \n            \$globalNoteMe value=\"Done\" verbose=true\
    \n\
    \n        } do={\
    \n            :set state \"remote knock failed when \$state: \$errorDescr\"\
    \n            \$globalNoteMe value=\$state\
    \n            :error \$state\
    \n        }\
    \n\
    \n        :return \"\"\
    \n    }\
    \n}\
    \n\
    \n# Example call\
    \n# :local errorDef [\$globalKnockKnock \$scriptname]\
    \n# :local errorDef [\$globalKnockKnock \$scriptname \"1.2.3.4\"]\
    \n# calls globalApplyKnock on CHR with invocation-scoped parameters, then waits 15s\
    \n# returns \"\" on success, error text otherwise\
    \n:global globalKnockKnock\
    \n:if (!any \$globalKnockKnock) do={\
    \n    :global globalKnockKnock do={\
    \n\
    \n        :global globalNoteMe\
    \n        :global globalCallSSH\
    \n\
    \n        :local comment [:tostr \$1]\
    \n        :if ([:len \$comment] = 0) do={\
    \n            :return \"knockknock: empty comment\"\
    \n        }\
    \n\
    \n        :local wanIp [/ip cloud get public-address]\
    \n        :if ([:len \$2] > 0) do={ :set wanIp \$2 }\
    \n\
    \n        :local asyncCmd \":global globalApplyKnock; \\\$globalApplyKnock ip=\$wanIp comment=\\\"\$comment\\\"\"\
    \n\
    \n        :local state \"Making SFTP backdoor for \$wanIp via SSH\"\
    \n        \$globalNoteMe value=\$state verbose=true\
    \n\
    \n        :local errorDef [\$globalCallSSH \$asyncCmd]\
    \n        :if ([:len \$errorDef] > 0) do={\
    \n            :return \$errorDef\
    \n        }\
    \n\
    \n        :set state \"Success RPC call: \$state\"\
    \n        \$globalNoteMe value=\$state verbose=true\
    \n\
    \n        # remote payload clears stage1/2/3; wait before opening the SFTP batch\
    \n        :set state \"Waiting backdoor for \$wanIp for some seconds..\"\
    \n        \$globalNoteMe value=\$state verbose=true\
    \n        :delay 15s\
    \n\
    \n        :return \"\"\
    \n    }\
    \n}\
    \n\
    \n"
/system script add dont-require-permissions=yes name=doNetwatchHost owner=owner policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="# fill it inside netwatch script\
    \n:global globalNetwatchHostName\
    \n:global globalNetwatchHostState\
    \n\
    \n# may be triggered twice per moment - snapshot globals first\
    \n:local netwatchHostName \$globalNetwatchHostName\
    \n:local netwatchHostState \$globalNetwatchHostState\
    \n\
    \n# init globals as far as we are inside *sys user account\
    \n:global globalSafeScriptCall\
    \n:if (!any \$globalSafeScriptCall) do={ /system script run doEnvironmentSetup }\
    \n\
    \n:local sysname [/system identity get name]\
    \n:local scriptname \"doNetwatchHost\"\
    \n:global globalScriptBeforeRun\
    \n\$globalScriptBeforeRun \$scriptname \"NETWATCH\"\
    \n\
    \n:global globalNoteMe\
    \n:global globalTgMessage\
    \n:local itsOk true\
    \n:local state \"\"\
    \n\
    \n:if (!any \$netwatchHostName) do={\
    \n    :set state \"No globalNetwatchHostName provided..\"\
    \n    \$globalNoteMe value=\$state\
    \n    :error \$state\
    \n}\
    \n\
    \n:if (!any \$netwatchHostState) do={\
    \n    :set state \"No globalNetwatchHostState provided..\"\
    \n    \$globalNoteMe value=\$state\
    \n    :error \$state\
    \n}\
    \n\
    \n:onerror errorDescr in={\
    \n\
    \n    :set state \"Netwatch for \$netwatchHostName started...\"\
    \n    \$globalNoteMe value=\$state\
    \n\
    \n    :set state \"\$netwatchHostName is \$netwatchHostState\"\
    \n    \$globalNoteMe value=\$state\
    \n    :log warning \$state\
    \n    \$globalTgMessage value=\$state\
    \n\
    \n} do={\
    \n    :set state \"Error When \$state: \$errorDescr\"\
    \n    \$globalNoteMe value=\$state\
    \n    :set itsOk false\
    \n}\
    \n\
    \n:local inf \"\"\
    \n:if (\$itsOk) do={\
    \n    :set inf \"\E2\9C\93 SUCCESS \$scriptname on \$sysname: \$netwatchHostName is \$netwatchHostState, notified\"\
    \n}\
    \n\
    \n:if (!\$itsOk) do={\
    \n    :set inf \"\E2\9C\97 FAILED \$scriptname on \$sysname: \$state\"\
    \n}\
    \n\
    \n\$globalNoteMe value=\$inf\
    \n\
    \n:if (!\$itsOk) do={\
    \n    \$globalTgMessage value=\$inf\
    \n    :error \$inf\
    \n}\
    \n\r\
    \n"
/system script add dont-require-permissions=yes name=doStartupScript owner=owner policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":local sysname [/system identity get name]\
    \n:local scriptname \"doStartupScript\"\
    \n\
    \n# reset current\
    \n/system note set note=\"Pending\"\
    \n\
    \n# Track sync time (avoid CHR initial clock bug), with this we are also checking if internet comes up\
    \n# globalNoteMe does not exist yet - direct :log/:put here\
    \n:onerror errorDescr in={\
    \n\
    \n    :local successSyncState \"synchronized\"\
    \n    :local syncOk false\
    \n    :local syncState \"\"\
    \n    :local timeSpent 0\
    \n    :local ticks 0\
    \n    :local maxTicks 40\
    \n    :local break false\
    \n    :do {\
    \n        :set syncState [/system ntp client get status]\
    \n        :set syncOk (\$syncState = \$successSyncState)\
    \n\
    \n        :log info \"Waiting 15s for clock sync using NTP.. (\$ticks/\$maxTicks, \$syncState)\"\
    \n        :put \"Waiting 15s for clock sync using NTP.. (\$ticks/\$maxTicks, \$syncState)\"\
    \n\
    \n        :if (!\$syncOk) do={\
    \n            :delay 15s\
    \n            :set timeSpent (\$timeSpent + 15)\
    \n            :set break (\$ticks >= \$maxTicks)\
    \n        } else={\
    \n            :set break true\
    \n        }\
    \n\
    \n        :set ticks (\$ticks + 1)\
    \n\
    \n    } while=(!\$break)\
    \n\
    \n    :if (\$syncOk) do={\
    \n        :log warning \"Successful clock sync using NTP in \$timeSpent seconds\"\
    \n        :put \"Successful clock sync using NTP in \$timeSpent seconds\"\
    \n    } else={\
    \n        :log error \"Error when clock sync using NTP in \$timeSpent seconds\"\
    \n        :put \"Error when clock sync using NTP in \$timeSpent seconds\"\
    \n    }\
    \n\
    \n} do={\
    \n    :log error \"Error when tracking clock sync using NTP: \$errorDescr\"\
    \n    :put \"Error when tracking clock sync using NTP: \$errorDescr\"\
    \n}\
    \n\
    \n# bootstrap environment directly - globalSafeScriptCall appears only after doEnvironmentSetup\
    \n:onerror errorDescr in={\
    \n    :log warning \"Starting script: doEnvironmentClearance (STARTUP context)\"\
    \n    /system script run doEnvironmentClearance\
    \n    :log warning \"Starting script: doEnvironmentSetup (STARTUP context)\"\
    \n    /system script run doEnvironmentSetup\
    \n} do={\
    \n    :log error \"FAIL Starting environment scripts (STARTUP context): \$errorDescr\"\
    \n    :put \"FAIL Starting environment scripts (STARTUP context): \$errorDescr\"\
    \n}\
    \n\
    \n:global globalSafeScriptCall\
    \n:global globalNoteMe\
    \n:global globalTgMessage\
    \n\
    \n:if (any \$globalSafeScriptCall) do={\
    \n    \$globalSafeScriptCall \"doImperialMarch\" \"STARTUP\"\
    \n    \$globalSafeScriptCall \"doCoolConsole\" \"STARTUP\"\
    \n} else={\
    \n    :log error \"Environment is not ready - skipping startup chain (STARTUP context)\"\
    \n}\
    \n\
    \n# wait some for all tunnels to come up after reboot and VPN to work\
    \n:local inf \"Wait some for all tunnels to come up after reboot and VPN to work..\"\
    \n:if (any \$globalNoteMe) do={ \$globalNoteMe value=\$inf }\
    \n\
    \n:delay 15s\
    \n\
    \n:set inf \"\$scriptname on \$sysname: system restart detected\"\
    \n:if (any \$globalNoteMe) do={ \$globalNoteMe value=\$inf }\
    \n:if (any \$globalTgMessage) do={ \$globalTgMessage value=\$inf }\
    \n\r\
    \n"
/system script add dont-require-permissions=yes name=doEnvironmentClearance owner=owner policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="# clear all global variables (called before doEnvironmentSetup, so no guard here)\r\
    \n/system script environment remove [find]\r\
    \n\r\
    \n"
/system script add dont-require-permissions=yes name=doFlushLogs owner=owner policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":local sysname [/system identity get name]\r\
    \n:local scriptname \"doFlushLogs\"\r\
    \n:global globalScriptBeforeRun\r\
    \n\$globalScriptBeforeRun \$scriptname\r\
    \n\r\
    \n:global globalNoteMe\r\
    \n:global globalTgMessage\r\
    \n:local itsOk true\r\
    \n:local state \"\"\r\
    \n\r\
    \n:onerror errorDescr in={\r\
    \n\r\
    \n    :set state \"FLUSHING logs..\"\r\
    \n    \$globalNoteMe value=\$state\r\
    \n\r\
    \n    /system/logging/action {\r\
    \n        :foreach memAction in=[find target=memory] do={\r\
    \n            :local actName [get value-name=name \$memAction]\r\
    \n            clear action=\$actName\r\
    \n        }\r\
    \n    }\r\
    \n\r\
    \n    \$globalNoteMe value=\"Done\"\r\
    \n\r\
    \n} do={\r\
    \n    :set state \"Error When \$state: \$errorDescr\"\r\
    \n    \$globalNoteMe value=\$state\r\
    \n    :set itsOk false\r\
    \n}\r\
    \n\r\
    \n:local inf \"\"\r\
    \n:if (\$itsOk) do={\r\
    \n    :set inf \"\E2\9C\93 SUCCESS \$scriptname on \$sysname: logs flushed\"\r\
    \n}\r\
    \n\r\
    \n:if (!\$itsOk) do={\r\
    \n    :set inf \"\E2\9C\97 FAILED \$scriptname on \$sysname: \$state\"\r\
    \n}\r\
    \n\r\
    \n\$globalNoteMe value=\$inf\r\
    \n\r\
    \n:if (!\$itsOk) do={\r\
    \n    \$globalTgMessage value=\$inf\r\
    \n    :error \$inf\r\
    \n}\r\
    \n\r\
    \n"
/system script add dont-require-permissions=yes name=doImperialMarch owner=owner policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":local sysname [/system identity get name]\r\
    \n:local scriptname \"doImperialMarch\"\r\
    \n:global globalScriptBeforeRun\r\
    \n\$globalScriptBeforeRun \$scriptname\r\
    \n\r\
    \n:global globalNoteMe\r\
    \n:global globalTgMessage\r\
    \n:local itsOk true\r\
    \n:local state \"\"\r\
    \n\r\
    \n:onerror errorDescr in={\r\
    \n    :set state \"Playing Imperial March\"\r\
    \n    \$globalNoteMe value=\$state\r\
    \n\r\
    \n    :delay 6\r\
    \n\r\
    \n    :beep frequency=500 length=500ms\r\
    \n    :delay 500ms\r\
    \n\r\
    \n    :beep frequency=500 length=500ms\r\
    \n    :delay 500ms\r\
    \n\r\
    \n    :beep frequency=500 length=500ms\r\
    \n    :delay 500ms\r\
    \n\r\
    \n    :beep frequency=400 length=500ms\r\
    \n    :delay 400ms\r\
    \n\r\
    \n    :beep frequency=600 length=200ms\r\
    \n    :delay 100ms\r\
    \n\r\
    \n    :beep frequency=500 length=500ms\r\
    \n    :delay 500ms\r\
    \n\r\
    \n    :beep frequency=400 length=500ms\r\
    \n    :delay 400ms\r\
    \n\r\
    \n    :beep frequency=600 length=200ms\r\
    \n    :delay 100ms\r\
    \n\r\
    \n    :beep frequency=500 length=500ms\r\
    \n    :delay 1000ms\r\
    \n\r\
    \n    :beep frequency=750 length=500ms\r\
    \n    :delay 500ms\r\
    \n\r\
    \n    :beep frequency=750 length=500ms\r\
    \n    :delay 500ms\r\
    \n\r\
    \n    :beep frequency=750 length=500ms\r\
    \n    :delay 500ms\r\
    \n\r\
    \n    :beep frequency=810 length=500ms\r\
    \n    :delay 400ms\r\
    \n\r\
    \n    :beep frequency=600 length=200ms\r\
    \n    :delay 100ms\r\
    \n\r\
    \n    :beep frequency=470 length=500ms\r\
    \n    :delay 500ms\r\
    \n\r\
    \n    :beep frequency=400 length=500ms\r\
    \n    :delay 400ms\r\
    \n\r\
    \n    :beep frequency=600 length=200ms\r\
    \n    :delay 100ms\r\
    \n\r\
    \n    :beep frequency=500 length=500ms\r\
    \n    :delay 1000ms\r\
    \n\r\
    \n    \$globalNoteMe value=\"Done\"\r\
    \n} do={\r\
    \n    :set state \"Error When \$state: \$errorDescr\"\r\
    \n    \$globalNoteMe value=\$state\r\
    \n    :set itsOk false\r\
    \n}\r\
    \n\r\
    \n:local inf \"\"\r\
    \n:if (\$itsOk) do={\r\
    \n    :set inf \"\E2\9C\93 SUCCESS \$scriptname on \$sysname: sequence played\"\r\
    \n}\r\
    \n\r\
    \n:if (!\$itsOk) do={\r\
    \n    :set inf \"\E2\9C\97 FAILED \$scriptname on \$sysname: \$state\"\r\
    \n}\r\
    \n\r\
    \n\$globalNoteMe value=\$inf\r\
    \n\r\
    \n:if (!\$itsOk) do={\r\
    \n    \$globalTgMessage value=\$inf\r\
    \n    :error \$inf\r\
    \n}\r\
    \n\r\
    \n"
/system script add dont-require-permissions=yes name=doIPSECPunch owner=owner policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":local sysname [/system identity get name]\
    \n:local scriptname \"doIPSECPunch\"\
    \n:global globalScriptBeforeRun\
    \n\$globalScriptBeforeRun \$scriptname\
    \n\
    \n:global globalNoteMe\
    \n:global globalTgMessage\
    \n:global globalPeerRetryCount\
    \n:local itsOk true\
    \n:local state \"\"\
    \n\
    \n# IPSec/L2TP Connection Monitor & Auto-Recovery\
    \n# every IPSec policy is examined: L2TP host-tunnel, specific routes, ping; failed peers are recovered (kill L2TP session / IPSec peers)\
    \n\
    \n:local config {\
    \n    \"pingCount\"=10;\
    \n    \"pingSuccessRate\"=80;\
    \n    \"pingInterval\"=1000ms;\
    \n    \"pingRetryDelay\"=20s;\
    \n    \"maxRetryAttempts\"=3;\
    \n    \"flushHour\"=23;\
    \n    \"enableAutoRecovery\"=true\
    \n}\
    \n\
    \n:local pingTrigger ((\$config->\"pingCount\") * (\$config->\"pingSuccessRate\") / 100)\
    \n\
    \n# Example call\
    \n# :local calc [\$ipCalc \"192.168.1.0/24\"]; :put (\$calc->\"hostmin\")\
    \n# calculate IP details from CIDR\
    \n:local ipCalc do={\
    \n    :local cidr [:tostr \$1]\
    \n    :local address [:toip [:pick \$cidr 0 [:find \$cidr \"/\"]]]\
    \n    :local bits [:tonum [:pick \$cidr ([:find \$cidr \"/\"] + 1) [:len \$cidr]]]\
    \n    :local mask ((255.255.255.255 << (32 - \$bits)) & 255.255.255.255)\
    \n    :return {\
    \n        \"network\"=(\$address & \$mask);\
    \n        \"hostmin\"=((\$address & \$mask) | 0.0.0.1);\
    \n        \"broadcast\"=(\$address | ~\$mask)\
    \n    }\
    \n}\
    \n\
    \n# Example call\
    \n# :local ip [\$extractIp \"10.0.0.1/32\"]\
    \n# extract first IP from CIDR or return as-is\
    \n:local extractIp do={\
    \n    :local input [:tostr \$1]\
    \n    :if ([:find \$input \"/\"] >= 0) do={\
    \n        :return [:pick \$input 0 [:find \$input \"/\"]]\
    \n    }\
    \n    :return \$input\
    \n}\
    \n\
    \n# Example call\
    \n# :local l2tpInfo [\$findL2tpSession \$dstAddr]\
    \n# find L2TP session info (incoming server session or outgoing client)\
    \n:local findL2tpSession do={\
    \n    :local dstIp [:tostr \$1]\
    \n    :local result {\"found\"=false; \"type\"=\"none\"}\
    \n\
    \n    # Incoming L2TP (server)\
    \n    :local incoming [/ppp/active find caller-id=\$dstIp]\
    \n    :if ([:len \$incoming] != 0) do={\
    \n        :set (\$result->\"running\") true\
    \n        :set (\$result->\"found\") true\
    \n        :set (\$result->\"type\") \"incoming\"\
    \n        :set (\$result->\"session\") \$incoming\
    \n        :set (\$result->\"peer\") [/ppp/active get \$incoming name]\
    \n        :set (\$result->\"remoteIP\") [/ppp/active get \$incoming address]\
    \n        :local network [/ip/address get [find network=(\$result->\"remoteIP\")] address]\
    \n        :set (\$result->\"localIP\") [:pick \$network 0 [:find \$network \"/\"]]\
    \n        :return \$result\
    \n    }\
    \n\
    \n    # Outgoing L2TP (client)\
    \n    :local outgoing [/interface/l2tp-client find where !disabled connect-to=\$dstIp]\
    \n    :if ([:len \$outgoing] != 0) do={\
    \n\
    \n        :local online [/interface/l2tp-client get \$outgoing running]\
    \n        :set (\$result->\"running\") \$online\
    \n        :set (\$result->\"found\") true\
    \n        :set (\$result->\"type\") \"outgoing\"\
    \n        :set (\$result->\"session\") \$outgoing\
    \n        :set (\$result->\"peer\") [/interface/l2tp-client get \$outgoing name]\
    \n\
    \n        :if (\$online) do={\
    \n            :local monitor [/interface l2tp-client monitor \$outgoing once as-value]\
    \n            :set (\$result->\"remoteIP\") (\$monitor->\"remote-address\")\
    \n            :local network [/ip/address get [find network=(\$result->\"remoteIP\")] address]\
    \n            :set (\$result->\"localIP\") [:pick \$network 0 [:find \$network \"/\"]]\
    \n        } else={\
    \n            :set (\$result->\"remoteIP\") 0.0.0.1\
    \n            :set (\$result->\"localIP\") 0.0.0.1\
    \n        }\
    \n\
    \n        :return \$result\
    \n    }\
    \n\
    \n    :return \$result\
    \n}\
    \n\
    \n# Example call\
    \n# :local pingResult [\$testConnectivity \$dstIp \$srcIp 10 8 20s]\
    \n# test connectivity with one retry\
    \n:local testConnectivity do={\
    \n    :local targetIp [:toip \$1]\
    \n    :local sourceIp [:toip \$2]\
    \n    :local count [:tonum \$3]\
    \n    :local threshold [:tonum \$4]\
    \n    :local retryDelay \$5\
    \n\
    \n    :local result1 [/ping address=\$targetIp src-address=\$sourceIp count=\$count interval=1000ms]\
    \n    :if (\$result1 >= \$threshold) do={\
    \n        :return {\"success\"=true; \"attempts\"=1; \"received\"=\$result1; \"required\"=\$threshold}\
    \n    }\
    \n\
    \n    :delay \$retryDelay\
    \n    :local result2 [/ping address=\$targetIp src-address=\$sourceIp count=\$count interval=1000ms]\
    \n    :if (\$result2 >= \$threshold) do={\
    \n        :return {\"success\"=true; \"attempts\"=2; \"received\"=\$result2; \"required\"=\$threshold}\
    \n    }\
    \n\
    \n    :return {\"success\"=false; \"attempts\"=2; \"received\"=\$result2; \"required\"=\$threshold}\
    \n}\
    \n\
    \n# Example call\
    \n# :local routeCheck [\$checkRoute \$dstIp \$srcIp]\
    \n# check route availability\
    \n:local checkRoute do={\
    \n    :local dstIp [:toip \$1]\
    \n    :local srcIp [:toip \$2]\
    \n    :local check [/ip/route/check dst-ip=\$dstIp src-ip=\$srcIp once as-value]\
    \n    :local status (\$check->\"status\")\
    \n    :if (\$status = \"ok\") do={\
    \n        :return {\
    \n            \"reachable\"=true;\
    \n            \"interface\"=(\$check->\"interface\");\
    \n            \"gateway\"=(\$check->\"gateway\");\
    \n            \"nexthop\"=(\$check->\"nexthop\")\
    \n        }\
    \n    }\
    \n    :return {\"reachable\"=false; \"status\"=\$status}\
    \n}\
    \n\
    \n# Example call\
    \n# :local killed [\$killL2tpSession \$l2tpInfo]\
    \n# predicate: kill L2TP session, returns true when something was killed/restarted\
    \n:local killL2tpSession do={\
    \n    :global globalNoteMe\
    \n    :local state \"\"\
    \n    :local sessionInfo \$1\
    \n    :local killed false\
    \n\
    \n    :if (!(\$sessionInfo->\"found\")) do={ :return \$killed }\
    \n\
    \n    :onerror errorDescr in={\
    \n        :if ((\$sessionInfo->\"type\") = \"incoming\") do={\
    \n            /ppp/active remove (\$sessionInfo->\"session\")\
    \n            :set state (\"Killed incoming L2TP session: \" . (\$sessionInfo->\"peer\"))\
    \n            \$globalNoteMe value=\$state\
    \n        } else={\
    \n            /interface/l2tp-client disable (\$sessionInfo->\"session\")\
    \n            :delay 4s\
    \n            /interface/l2tp-client enable (\$sessionInfo->\"session\")\
    \n            :set state (\"Restarted outgoing L2TP client: \" . (\$sessionInfo->\"peer\"))\
    \n            \$globalNoteMe value=\$state\
    \n        }\
    \n        :set killed true\
    \n    } do={\
    \n        :set state (\"FAILED to kill L2TP session for peer: \" . (\$sessionInfo->\"peer\") . \": \$errorDescr\")\
    \n        \$globalNoteMe value=\$state\
    \n        :log error \$state\
    \n    }\
    \n\
    \n    :return \$killed\
    \n}\
    \n\
    \n# Example call\
    \n# :local killed [\$killIpsecPeers \$peerIp]\
    \n# predicate: kill IPSec active peers, returns true when at least one peer was removed\
    \n:local killIpsecPeers do={\
    \n    :global globalNoteMe\
    \n    :local state \"\"\
    \n    :local peerIp [:tostr \$1]\
    \n    :local activePeers [/ip/ipsec/active-peers find remote-address=\$peerIp]\
    \n\
    \n    :if ([:len \$activePeers] = 0) do={\
    \n        :set state \"No active IPSec peers found for \$peerIp\"\
    \n        \$globalNoteMe value=\$state\
    \n        :log warning \$state\
    \n        :return false\
    \n    }\
    \n\
    \n    :local killCount 0\
    \n    :foreach peer in=\$activePeers do={\
    \n        :onerror errorDescr in={\
    \n            /ip/ipsec/active-peers remove \$peer\
    \n            :set killCount (\$killCount + 1)\
    \n        } do={\
    \n            :set state \"FAILED to kill IPSec peer: \$peerIp: \$errorDescr\"\
    \n            \$globalNoteMe value=\$state\
    \n            :log error \$state\
    \n        }\
    \n    }\
    \n\
    \n    :if (\$killCount > 0) do={\
    \n        :set state \"Killed \$killCount IPSec active peer(s) for \$peerIp\"\
    \n        \$globalNoteMe value=\$state\
    \n        :return true\
    \n    }\
    \n\
    \n    :return false\
    \n}\
    \n\
    \n# Example call\
    \n# :local recovered [\$recoverPeer \$dstAddr \$peerName \$l2tpInfo \$config \$killL2tpSession \$killIpsecPeers]\
    \n# predicate: perform recovery actions, returns true when recovery was attempted\
    \n:local recoverPeer do={\
    \n    :global globalNoteMe\
    \n    :global globalPeerRetryCount\
    \n    :local state \"\"\
    \n\
    \n    :local peerIp [:tostr \$1]\
    \n    :local peerName [:tostr \$2]\
    \n    :local l2tpSession \$3\
    \n    :local config \$4\
    \n    :local killL2tp \$5\
    \n    :local killIpsec \$6\
    \n\
    \n    :local retryCount (\$globalPeerRetryCount->\$peerIp)\
    \n\
    \n    :if ([:typeof \$retryCount] != \"num\") do={ :set retryCount 0 }\
    \n\
    \n    :set retryCount (\$retryCount + 1)\
    \n    :set (\$globalPeerRetryCount->\$peerIp) \$retryCount\
    \n\
    \n    :if (\$retryCount > (\$config->\"maxRetryAttempts\")) do={\
    \n        :set state \"Peer \$peerName (\$peerIp) exceeded max retry attempts (\$retryCount) - MANUAL INTERVENTION REQUIRED\"\
    \n        \$globalNoteMe value=\$state\
    \n        :log error \$state\
    \n        :return false\
    \n    }\
    \n\
    \n    :set state \"RECOVERY START: \$peerName (\$peerIp) - Attempt \$retryCount\"\
    \n    \$globalNoteMe value=\$state\
    \n\
    \n    :if ((\$l2tpSession->\"found\")) do={\
    \n        :local killed [\$killL2tp \$l2tpSession]\
    \n        :if (\$killed) do={ :delay 2s }\
    \n    }\
    \n\
    \n    :local ipsecKilled [\$killIpsec \$peerIp]\
    \n    :if (\$ipsecKilled) do={ :delay 2s }\
    \n\
    \n    :set state \"RECOVERY COMPLETE: \$peerName (\$peerIp)\"\
    \n    \$globalNoteMe value=\$state\
    \n    :return true\
    \n}\
    \n\
    \n:set state \"IPSec/L2TP Connection Monitor Started\"\
    \n\$globalNoteMe value=\$state verbose=true\
    \n\
    \n:local policiesOnline [/ip/ipsec/policy find (!template !disabled)]\
    \n\
    \n:set state (\"Found \" . [:len \$policiesOnline] . \" IPSec policies to investigate\")\
    \n\$globalNoteMe value=\$state verbose=true\
    \n\
    \n:local stats {\
    \n    \"totalPolicies\"=[:len \$policiesOnline];\
    \n    \"testedPeers\"=0;\
    \n    \"passedPeers\"=0;\
    \n    \"failedPeers\"=0;\
    \n    \"recoveredPeers\"=0;\
    \n    \"skippedPeers\"=0\
    \n}\
    \n\
    \n:foreach policy in=\$policiesOnline do={\
    \n\
    \n    :local peerName\
    \n    :local srcAddr\
    \n    :local dstAddr\
    \n    :local l2tpInfo\
    \n\
    \n    # every failed check throws \"skip-continue\": checks for this policy stop and recovery runs in the handler\
    \n    :onerror errorDescr in={\
    \n\
    \n        :set peerName [/ip/ipsec/policy get \$policy peer]\
    \n        :local isTunnel [/ip/ipsec/policy get \$policy tunnel]\
    \n        :local isActive [/ip/ipsec/policy get \$policy active]\
    \n        :local polState [/ip/ipsec/policy get \$policy ph2-state]\
    \n\
    \n        :if (\$isTunnel) do={\
    \n            :local dstSubnet [/ip/ipsec/policy get \$policy dst-address]\
    \n            :local srcSubnet [/ip/ipsec/policy get \$policy src-address]\
    \n            :local dstCalc [\$ipCalc \$dstSubnet]\
    \n            :local srcCalc [\$ipCalc \$srcSubnet]\
    \n            :set dstAddr (\$dstCalc->\"hostmin\")\
    \n            :set srcAddr (\$srcCalc->\"hostmin\")\
    \n        } else={\
    \n            :set dstAddr [\$extractIp [/ip/ipsec/policy get \$policy dst-address]]\
    \n            :set srcAddr [\$extractIp [/ip/ipsec/policy get \$policy src-address]]\
    \n        }\
    \n\
    \n        :set (\$stats->\"testedPeers\") ((\$stats->\"testedPeers\") + 1)\
    \n\
    \n        :set state \"Examine Peer \$peerName (\$dstAddr)\"\
    \n        \$globalNoteMe value=\$state verbose=true\
    \n\
    \n        # 1) Looking for host L2TP session\
    \n        :set l2tpInfo [\$findL2tpSession \$dstAddr]\
    \n\
    \n        :if (!\$isActive) do={\
    \n            :set state \"Non-active policy investigated for \$peerName\"\
    \n            \$globalNoteMe value=\$state\
    \n            :log error \$state\
    \n            :set (\$stats->\"failedPeers\") ((\$stats->\"failedPeers\") + 1)\
    \n            :error \"skip-continue\"\
    \n        }\
    \n\
    \n        :if (\$polState != \"established\") do={\
    \n\
    \n            :set state \"Non-established policy investigated for \$peerName\"\
    \n            \$globalNoteMe value=\$state\
    \n            :log error \$state\
    \n\
    \n            # some more diagnostic\
    \n            :if ((\$l2tpInfo->\"found\")) do={\
    \n                :if (!(\$l2tpInfo->\"running\")) do={\
    \n                    :set state (\"Disconnected (Rx-Tx 0-0) \" . (\$l2tpInfo->\"type\") . \" L2TP host-tunnel found for IPSEC: \" . (\$l2tpInfo->\"peer\"))\
    \n                    \$globalNoteMe value=\$state\
    \n                    :log error \$state\
    \n                }\
    \n            }\
    \n\
    \n            :set (\$stats->\"failedPeers\") ((\$stats->\"failedPeers\") + 1)\
    \n            :error \"skip-continue\"\
    \n        }\
    \n\
    \n        :local policyDstIp \$dstAddr\
    \n        :local policySrcIp \$srcAddr\
    \n\
    \n        :local mustUseL2tp false\
    \n\
    \n        :local l2tpIf \"\"\
    \n        :local l2tpRouteIf \"\"\
    \n        :local policyRouteIf \"\"\
    \n\
    \n        :if ((\$l2tpInfo->\"found\")) do={\
    \n\
    \n            :if (!(\$l2tpInfo->\"running\")) do={\
    \n                :set state (\"Disconnected (Rx-Tx 0-0) \" . (\$l2tpInfo->\"type\") . \" L2TP host-tunnel found for IPSEC: \" . (\$l2tpInfo->\"peer\"))\
    \n                \$globalNoteMe value=\$state\
    \n                :log error \$state\
    \n                :set (\$stats->\"failedPeers\") ((\$stats->\"failedPeers\") + 1)\
    \n                :error \"skip-continue\"\
    \n            }\
    \n\
    \n            :set state (\"Active \" . (\$l2tpInfo->\"type\") . \" L2TP host-tunnel found for IPSEC: \" . (\$l2tpInfo->\"peer\"))\
    \n            \$globalNoteMe value=\$state verbose=true\
    \n\
    \n            :local l2tpDstAddr (\$l2tpInfo->\"remoteIP\")\
    \n            :local l2tpSrcAddr (\$l2tpInfo->\"localIP\")\
    \n            :set mustUseL2tp true\
    \n            :set l2tpIf (\$l2tpInfo->\"peer\")\
    \n\
    \n            :set state \"Looking for specific (l2tp) routes to \$l2tpDstAddr from \$l2tpSrcAddr\"\
    \n            \$globalNoteMe value=\$state verbose=true\
    \n\
    \n            # we need specific route in the main table to that subnet\
    \n            :local l2tpRouteCheck [\$checkRoute \$l2tpDstAddr \$l2tpSrcAddr]\
    \n            :if (!(\$l2tpRouteCheck->\"reachable\")) do={\
    \n                :set state (\"Cannot find specific route (l2tp) to \$l2tpDstAddr from \$l2tpSrcAddr - status: \" . (\$l2tpRouteCheck->\"status\"))\
    \n                \$globalNoteMe value=\$state\
    \n                :log error \$state\
    \n                :set (\$stats->\"failedPeers\") ((\$stats->\"failedPeers\") + 1)\
    \n                :error \"skip-continue\"\
    \n            }\
    \n\
    \n            :set l2tpRouteIf (\$l2tpRouteCheck->\"interface\")\
    \n            :set state (\"Found specific route (l2tp) to \$l2tpDstAddr from \$l2tpSrcAddr via \" . (\$l2tpRouteCheck->\"nexthop\") . \" (\$l2tpRouteIf)\")\
    \n            \$globalNoteMe value=\$state verbose=true\
    \n\
    \n            :set policyDstIp \$l2tpDstAddr\
    \n            :set policySrcIp \$l2tpSrcAddr\
    \n\
    \n        } else={\
    \n\
    \n            :if (!\$isTunnel) do={\
    \n                # on transport mode l2tp session have to exist (just a local convenience)\
    \n                :set state \"No active L2TP host-tunnel found for IPSEC peer - \$peerName (on transport policy l2tp session have to exist)\"\
    \n                \$globalNoteMe value=\$state\
    \n                :log error \$state\
    \n                :set (\$stats->\"failedPeers\") ((\$stats->\"failedPeers\") + 1)\
    \n                :error \"skip-continue\"\
    \n            }\
    \n\
    \n            :set state \"No active L2TP host-tunnel found for IPSEC peer - \$peerName (pure IPSEC, tunneled=\$isTunnel)\"\
    \n            \$globalNoteMe value=\$state verbose=true\
    \n        }\
    \n\
    \n        # 2) Policy route check\
    \n        :set state \"Looking for specific (policy) routes to \$policyDstIp from \$policySrcIp\"\
    \n        \$globalNoteMe value=\$state verbose=true\
    \n\
    \n        # we need specific route in the main table to that subnet\
    \n        :local policyRouteCheck [\$checkRoute \$policyDstIp \$policySrcIp]\
    \n        :if (!(\$policyRouteCheck->\"reachable\")) do={\
    \n            :set state (\"Cannot find specific route (policy) to \$policyDstIp from \$policySrcIp - status: \" . (\$policyRouteCheck->\"status\"))\
    \n            \$globalNoteMe value=\$state\
    \n            :log error \$state\
    \n            :set (\$stats->\"failedPeers\") ((\$stats->\"failedPeers\") + 1)\
    \n            :error \"skip-continue\"\
    \n        }\
    \n\
    \n        :set policyRouteIf (\$policyRouteCheck->\"interface\")\
    \n        :set state (\"Found specific route (policy) to \$policyDstIp from \$policySrcIp via \" . (\$policyRouteCheck->\"nexthop\") . \" (\$policyRouteIf)\")\
    \n        \$globalNoteMe value=\$state verbose=true\
    \n\
    \n        # 3) both routes have to be via the same catched L2TP interface/gw\
    \n        :if (\$mustUseL2tp) do={\
    \n\
    \n            :set state \"Checking policy-l2tp routes' interfaces match\"\
    \n            \$globalNoteMe value=\$state verbose=true\
    \n\
    \n            :if ((\$policyRouteIf != \$l2tpIf) or (\$l2tpRouteIf != \$l2tpIf)) do={\
    \n                :set state \"Found routes mismatch (policy via \$policyRouteIf, l2tp via \$l2tpRouteIf, expected \$l2tpIf)\"\
    \n                \$globalNoteMe value=\$state\
    \n                :log error \$state\
    \n                :set (\$stats->\"failedPeers\") ((\$stats->\"failedPeers\") + 1)\
    \n                :error \"skip-continue\"\
    \n            }\
    \n\
    \n            :set state \"Found routes' interfaces are the same on L2TP \$l2tpIf and Policy \$peerName\"\
    \n            \$globalNoteMe value=\$state verbose=true\
    \n\
    \n        } else={\
    \n            :set state \"Skip policy-l2tp routes' interfaces match - no active L2TP host-tunnel available\"\
    \n            \$globalNoteMe value=\$state verbose=true\
    \n        }\
    \n\
    \n        # 4) ping\
    \n        :set state \"Pinging remote IP \$policyDstIp\"\
    \n        \$globalNoteMe value=\$state verbose=true\
    \n\
    \n        :local pingResult [\$testConnectivity \$policyDstIp \$policySrcIp (\$config->\"pingCount\") \$pingTrigger (\$config->\"pingRetryDelay\")]\
    \n        :if ((\$pingResult->\"success\")) do={\
    \n\
    \n            :set state (\"PASS: Ping test successful \" . (\$pingResult->\"received\") . \"/\" . (\$pingResult->\"required\") . \" (\" . (\$pingResult->\"attempts\") . \" attempt(s))\")\
    \n            \$globalNoteMe value=\$state verbose=true\
    \n            :set (\$stats->\"passedPeers\") ((\$stats->\"passedPeers\") + 1)\
    \n\
    \n            # :set (\$globalPeerRetryCount->\$dstAddr) 0\
    \n\
    \n        } else={\
    \n\
    \n            :set state (\"FAIL: Ping test failed \" . (\$pingResult->\"received\") . \"/\" . (\$pingResult->\"required\") . \" after \" . (\$pingResult->\"attempts\") . \" attempts\")\
    \n            \$globalNoteMe value=\$state\
    \n            :log error \$state\
    \n            :set (\$stats->\"failedPeers\") ((\$stats->\"failedPeers\") + 1)\
    \n            # going to recover\
    \n            :error \"skip-continue\"\
    \n        }\
    \n\
    \n        :set state \"Continue next\"\
    \n        \$globalNoteMe value=\$state verbose=true\
    \n\
    \n    } do={\
    \n\
    \n        :if (!(\$errorDescr ~ \"^skip-continue\")) do={\
    \n            :set state \"Error When \$state: \$errorDescr\"\
    \n            \$globalNoteMe value=\$state\
    \n            :log error \$state\
    \n            :set itsOk false\
    \n        }\
    \n\
    \n        # peer failed its checks (or crashed) - try to recover, then go next policy\
    \n        :if ((\$config->\"enableAutoRecovery\")) do={\
    \n            :local recovered [\$recoverPeer \$dstAddr \$peerName \$l2tpInfo \$config \$killL2tpSession \$killIpsecPeers]\
    \n            :if (\$recovered) do={\
    \n                :set (\$stats->\"recoveredPeers\") ((\$stats->\"recoveredPeers\") + 1)\
    \n            }\
    \n        } else={\
    \n            :set state \"Auto-recovery disabled - manual intervention required\"\
    \n            \$globalNoteMe value=\$state\
    \n            :log warning \$state\
    \n        }\
    \n\
    \n        :set state \"Continue next (in case of skip or errors)\"\
    \n        \$globalNoteMe value=\$state verbose=true\
    \n        :log warning \$state\
    \n    }\
    \n}\
    \n\
    \n# post-check validation\
    \n:set state \"Waiting for system to come up after autorecovery\"\
    \n\$globalNoteMe value=\$state verbose=true\
    \n\
    \n:delay 5s\
    \n:local policiesOnlineAfter [/ip/ipsec/policy find active ph2-state=established]\
    \n:local policiesOfflineAfter [/ip/ipsec/policy find (!template !disabled ph2-state!=established)]\
    \n\
    \n# summary\
    \n:set state (\"Total policies: \" . (\$stats->\"totalPolicies\"))\
    \n\$globalNoteMe value=\$state verbose=true\
    \n\
    \n:set state (\"Tested: \" . (\$stats->\"testedPeers\") . \" | Passed: \" . (\$stats->\"passedPeers\") . \" | Failed: \" . (\$stats->\"failedPeers\"))\
    \n\$globalNoteMe value=\$state verbose=true\
    \n\
    \n:set state (\"Recovered: \" . (\$stats->\"recoveredPeers\") . \" | Skipped: \" . (\$stats->\"skippedPeers\"))\
    \n\$globalNoteMe value=\$state verbose=true\
    \n\
    \n:set state (\"Policies after check: Online=\" . [:len \$policiesOnlineAfter] . \" | Offline=\" . [:len \$policiesOfflineAfter])\
    \n\$globalNoteMe value=\$state verbose=true\
    \n\
    \n:local errorMessage \"\"\
    \n\
    \n:if ((\$stats->\"failedPeers\") > 0) do={\
    \n    :set itsOk false\
    \n    :set errorMessage ((\$stats->\"failedPeers\") . \" peer(s) failed connectivity test\")\
    \n}\
    \n\
    \n:if ([:len \$policiesOfflineAfter] != 0) do={\
    \n    :set itsOk false\
    \n    :set errorMessage (\$errorMessage . \"; \" . [:len \$policiesOfflineAfter] . \" policies offline after recovery\")\
    \n}\
    \n\
    \n:if (!\$itsOk) do={\
    \n    :set state \"IPSec/L2TP Monitor: FAILURES DETECTED - \$errorMessage\"\
    \n}\
    \n\
    \n:local inf \"\"\
    \n:if (\$itsOk) do={\
    \n    :set inf \"\E2\9C\93 SUCCESS \$scriptname on \$sysname: IPSec/L2TP Monitor: all checks passed\"\
    \n}\
    \n\
    \n:if (!\$itsOk) do={\
    \n    :set inf \"\E2\9C\97 FAILED \$scriptname on \$sysname: \$state\"\
    \n}\
    \n\
    \n\$globalNoteMe value=\$inf\
    \n\
    \n:if (!\$itsOk) do={\
    \n    \$globalTgMessage value=\$inf\
    \n    :error \$inf\
    \n}\
    \n\r\
    \n"
/system script add dont-require-permissions=yes name=doUpdatePoliciesRemotely owner=owner policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":local sysname [/system identity get name]\
    \n:local scriptname \"doUpdatePoliciesRemotely\"\
    \n:global globalScriptBeforeRun\
    \n\$globalScriptBeforeRun \$scriptname\
    \n\
    \n:global globalNoteMe\
    \n:global globalTgMessage\
    \n:local itsOk true\
    \n:local state \"\"\
    \n\
    \n# variables should be set before via remote SSH call\
    \n:global globalRemoteIp\
    \n:global globalPolicyComment\
    \n\
    \n:onerror errorDescr in={\
    \n\
    \n    :if ([:len \$globalRemoteIp] > 0) do={\
    \n\
    \n        :local peerId \$globalPolicyComment\
    \n\
    \n        /ip ipsec policy {\
    \n            :foreach vpnEndpoint in=[find (!disabled and template and comment=\"\$peerId\")] do={\
    \n\
    \n                :local dstIp [get value-name=dst-address \$vpnEndpoint]\
    \n\
    \n                :if (\$globalRemoteIp != \$dstIp) do={\
    \n\
    \n                    [set \$vpnEndpoint disabled=yes]\
    \n\
    \n                    :set state \"IPSEC policy template found with wrong IP (\$dstIp). Going change it to (\$globalRemoteIp)\"\
    \n                    \$globalNoteMe value=\$state\
    \n\
    \n                    /ip ipsec peer {\
    \n                        :foreach thePeer in=[find name=\$peerId] do={\
    \n\
    \n                            :set state \"Setting up peer remote address..\"\
    \n                            \$globalNoteMe value=\$state\
    \n\
    \n                            [set \$thePeer disabled=yes]\
    \n\
    \n                            :delay 5\
    \n\
    \n                            [set \$thePeer disabled=no address=\$globalRemoteIp]\
    \n\
    \n                        }\
    \n                    }\
    \n\
    \n                    :delay 5\
    \n\
    \n                    [set \$vpnEndpoint dst-address=\$globalRemoteIp disabled=no]\
    \n\
    \n                }\
    \n            }\
    \n        }\
    \n    }\
    \n\
    \n} do={\
    \n    :set state \"Error When \$state: \$errorDescr\"\
    \n    \$globalNoteMe value=\$state\
    \n    :set itsOk false\
    \n}\
    \n\
    \n:local inf \"\"\
    \n:if (\$itsOk) do={\
    \n    :set inf \"\E2\9C\93 SUCCESS \$scriptname on \$sysname: policies refreshed\"\
    \n}\
    \n\
    \n:if (!\$itsOk) do={\
    \n    :set inf \"\E2\9C\97 FAILED \$scriptname on \$sysname: \$state\"\
    \n}\
    \n\
    \n\$globalNoteMe value=\$inf\
    \n\
    \n:if (!\$itsOk) do={\
    \n    \$globalTgMessage value=\$inf\
    \n    :error \$inf\
    \n}\
    \n\r\
    \n"
/system script add dont-require-permissions=yes name=doUpdateExternalDNS owner=owner policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":local sysname [/system identity get name]\
    \n:local scriptname \"doUpdateExternalDNS\"\
    \n:global globalScriptBeforeRun\
    \n\$globalScriptBeforeRun \$scriptname\
    \n\
    \n:global globalNoteMe\
    \n:global globalTgMessage\
    \n:global globalCallSSH\
    \n:global globalKnockKnock\
    \n:local itsOk true\
    \n:local payLoad false\
    \n:local state \"\"\
    \n\
    \n# last seen external IP, survives between runs until doEnvironmentClearance\
    \n:global globalLastIpv4\
    \n\
    \n# set true to refresh address-list/DNS/CHR even when IP did not change\
    \n:local useForcedRefresh false\
    \n\
    \n:local ipv4 \"\"\
    \n\
    \n:onerror errorDescr in={\
    \n\
    \n    # parsing the current IPv4 result\
    \n    :set state \"Requesting cloud-DNS public address\"\
    \n    \$globalNoteMe value=\$state verbose=true\
    \n    /ip cloud force-update\
    \n    :delay 7s\
    \n    :set ipv4 [/ip cloud get public-address]\
    \n\
    \n    :if ([:typeof [:toip \$ipv4]] != \"ip\") do={\
    \n        :error \"No cloud-DNS IP received\"\
    \n    }\
    \n    \$globalNoteMe value=\"Done\" verbose=true\
    \n\
    \n    :if ((\$globalLastIpv4 != \$ipv4) or \$useForcedRefresh) do={\
    \n\
    \n        :set state \"External IP changed: current - (\$ipv4), last - (\$globalLastIpv4)\"\
    \n        \$globalNoteMe value=\$state\
    \n\
    \n        /ip firewall address-list remove [find list~\"alist-nat-external-ip\"]\
    \n        /ip firewall address-list add list=\"alist-nat-external-ip\" address=\$ipv4\
    \n\
    \n        /ip dns static remove [/ip dns static find name=ftpserver.org]\
    \n        /ip dns static add name=ftpserver.org address=\$ipv4\
    \n\
    \n        :set globalLastIpv4 \$ipv4\
    \n        :set payLoad true\
    \n\
    \n        # refresh CHR IPSEC preferred policy (was doSuperviseCHRviaSSH)\
    \n        :set state \"Refreshing VPN server (CHR) IPSEC policies\"\
    \n        \$globalNoteMe value=\$state\
    \n\
    \n        # SSH RPCs look like bruteforce on CHR without knockknock\
    \n        :local errorDef [\$globalKnockKnock \$scriptname]\
    \n        :if ([:len \$errorDef] > 0) do={ :error \$errorDef }\
    \n\
    \n        :local policyComment [/ip dns static get value-name=text [find where type=TXT and name=\"special-remote-CHR-ipsec-policy-comment\"]]\
    \n        :local asyncCmd \":global globalPolicyComment \$policyComment\"\
    \n\
    \n        :set state \"Calling --- \$asyncCmd\"\
    \n        \$globalNoteMe value=\$state verbose=true\
    \n        :set errorDef [\$globalCallSSH \$asyncCmd]\
    \n        :if ([:len \$errorDef] > 0) do={ :error \$errorDef }\
    \n        :set state \"RPC: set remote preferred policy comment variable: (\$policyComment) - Ok\"\
    \n        \$globalNoteMe value=\$state verbose=true\
    \n\
    \n        :set asyncCmd \":global globalRemoteIp \$ipv4/32\"\
    \n\
    \n        :set state \"Calling --- \$asyncCmd\"\
    \n        \$globalNoteMe value=\$state verbose=true\
    \n        :set errorDef [\$globalCallSSH \$asyncCmd]\
    \n        :if ([:len \$errorDef] > 0) do={ :error \$errorDef }\
    \n        :set state \"RPC: set remote preferred policy IP variable: (\$ipv4) - Ok\"\
    \n        \$globalNoteMe value=\$state verbose=true\
    \n\
    \n        :set asyncCmd \"/system script run doUpdatePoliciesRemotely\"\
    \n\
    \n        :set state \"Calling --- \$asyncCmd\"\
    \n        \$globalNoteMe value=\$state verbose=true\
    \n        :set errorDef [\$globalCallSSH \$asyncCmd]\
    \n        :if ([:len \$errorDef] > 0) do={ :error \$errorDef }\
    \n        :set state \"RPC: call remote script: doUpdatePoliciesRemotely - Ok\"\
    \n        \$globalNoteMe value=\$state verbose=true\
    \n    }\
    \n\
    \n} do={\
    \n    :set state \"Error When \$state: \$errorDescr\"\
    \n    \$globalNoteMe value=\$state\
    \n    :set itsOk false\
    \n}\
    \n\
    \n:local inf \"\"\
    \n:if (\$itsOk and \$payLoad) do={\
    \n    :set inf \"\E2\9C\93 SUCCESS \$scriptname on \$sysname: external IP address change detected, refreshed\"\
    \n}\
    \n\
    \n:if (\$itsOk and !\$payLoad) do={\
    \n    :set inf \"\E2\9C\93 SUCCESS \$scriptname on \$sysname: no external IP address update needed\"\
    \n}\
    \n\
    \n:if (!\$itsOk) do={\
    \n    :set inf \"\E2\9C\97 FAILED \$scriptname on \$sysname: \$state\"\
    \n}\
    \n\
    \n\$globalNoteMe value=\$inf\
    \n\
    \n:if (!\$itsOk) do={\
    \n    \$globalTgMessage value=\$inf\
    \n    :error \$inf\
    \n}\
    \n\r\
    \n"
/system script add dont-require-permissions=yes name=doCoolConsole owner=owner policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":local sysname [/system identity get name]\
    \n:local scriptname \"doCoolConsole\"\
    \n:global globalScriptBeforeRun\
    \n\$globalScriptBeforeRun \$scriptname\
    \n\
    \n:global globalNoteMe\
    \n:global globalTgMessage\
    \n:global globalOnPrimaryPartition\
    \n:local itsOk true\
    \n:local state \"\"\
    \n\
    \n:local logcontenttemp \"\"\
    \n:local logcontent \"\"\
    \n\
    \n# predicate-like helper: returns resolved address or \"ERROR\"\
    \n:local safeResolve do={\
    \n    :local host \"ERROR\"\
    \n    :if ([:len \$1] != 0) do={\
    \n        :onerror errorDescr in={\
    \n            :set host [:resolve \"\$1\"]\
    \n        } do={\
    \n            :log error \"FAIL resolving: \$1 (\$errorDescr)\"\
    \n            :put \"FAIL resolving: \$1\"\
    \n        }\
    \n    } else={\
    \n        :log error \"FAIL resolving: empty host name\"\
    \n        :put \"FAIL resolving: empty host name\"\
    \n    }\
    \n    :return \$host\
    \n}\
    \n\
    \n:onerror errorDescr in={\
    \n\
    \n    :local rosVer [:tonum [:pick [/system resource get version] 0 1]]\
    \n    :local sysver \"NA\"\
    \n    :if ([:len [/system package find where name=\"system\" and disabled=no]] > 0 and \$rosVer = 6) do={\
    \n        :set sysver [/system package get system version]\
    \n    }\
    \n    :if ([:len [/system package find where name=\"routeros\" and disabled=no]] > 0 and \$rosVer = 7) do={\
    \n        :set sysver [/system package get routeros version]\
    \n    }\
    \n\
    \n    :set state \"Picking default route\"\
    \n\
    \n    :local defaultRoute \"unreachable\"\
    \n    /ip route {\
    \n        :foreach i in=[find where dst-address=\"0.0.0.0/0\" and active and routing-table=main] do={\
    \n            :set defaultRoute [:tostr [/ip route get \$i gateway]]\
    \n        }\
    \n    }\
    \n\
    \n    :set state \"Picking ipsec\"\
    \n\
    \n    :local ipsecState \"okay\"\
    \n    /ip ipsec policy {\
    \n        :foreach vpnEndpoint in=[find (!disabled and !template)] do={\
    \n            :local ph2state [get value-name=ph2-state \$vpnEndpoint]\
    \n            :if (\$ph2state != \"established\") do={\
    \n                :set ipsecState \"issues found\"\
    \n            }\
    \n        }\
    \n    }\
    \n\
    \n    :if (![\$globalOnPrimaryPartition]) do={\
    \n        :set state \"WARNING: the system booted up from fallback partition!\"\
    \n        :log error \$state\
    \n        \$globalNoteMe value=\$state\
    \n\
    \n        :set logcontenttemp \"\$state\"\
    \n        :set logcontent (\"\$logcontent\" . \"\$logcontenttemp\" . \" \\n\")\
    \n    }\
    \n\
    \n    :set logcontenttemp \"Ipsec:         \$ipsecState\"\
    \n    :set logcontent (\"\$logcontent\" . \"\$logcontenttemp\" . \" \\n\")\
    \n    :set logcontenttemp \"Route:     \$defaultRoute\"\
    \n    :set logcontent (\"\$logcontent\" . \"\$logcontenttemp\" . \" \\n\")\
    \n    :set logcontenttemp \"Version:         \$sysver\"\
    \n    :set logcontent (\"\$logcontent\" . \"\$logcontenttemp\" . \" \\n\")\
    \n    :set logcontenttemp \"Uptime:        \$[/system resource get uptime]\"\
    \n    :set logcontent (\"\$logcontent\" . \"\$logcontenttemp\" . \"  \\n\")\
    \n\
    \n    :local avgRttA 0\
    \n    :local numPing 6\
    \n    :local latency \"NA\"\
    \n\
    \n    :set state \"Yandex connection test\"\
    \n\
    \n    :local latencySite \"Ya.ru\"\
    \n    :local yaResolve [\$safeResolve \$latencySite]\
    \n\
    \n    :set state \"Picking latency\"\
    \n\
    \n    :if (\$yaResolve != \"ERROR\") do={\
    \n        :for tmpA from=1 to=\$numPing step=1 do={\
    \n            /tool flood-ping count=1 size=38 address=\$yaResolve do={ :set avgRttA (\$\"avg-rtt\" + \$avgRttA) }\
    \n            :delay 1s\
    \n        }\
    \n        :set latency [:tostr (\$avgRttA / \$numPing)]\
    \n    } else={\
    \n        :set latency \"unreachable\"\
    \n    }\
    \n\
    \n    :set state \"Resolving CHR, MIK, ANNA\"\
    \n\
    \n    :local chrResolve [\$safeResolve \"accb195e0dffc6bb.sn.mynetname.net\"]\
    \n    :if (\$chrResolve = \"ERROR\") do={ :set chrResolve \"unreachable\" }\
    \n\
    \n    :local mikResolve [\$safeResolve \"673706ed7949.sn.mynetname.net\"]\
    \n    :if (\$mikResolve = \"ERROR\") do={ :set mikResolve \"unreachable\" }\
    \n\
    \n    :local annaResolve [\$safeResolve \"hcy086pz6xz.sn.mynetname.net\"]\
    \n    :if (\$annaResolve = \"ERROR\") do={ :set annaResolve \"unreachable\" }\
    \n\
    \n    :set logcontenttemp \"Time:        \$[/system clock get date] \$[/system clock get time]\"\
    \n    :set logcontent (\"\$logcontent\" . \"\$logcontenttemp\" . \"  \\n\")\
    \n    :set logcontenttemp \"Ping:    \$latency ms\"\
    \n    :set logcontent (\"\$logcontent\" . \"\$logcontenttemp\" . \"  \\n\")\
    \n\
    \n    :set logcontenttemp \"Chr:        \$chrResolve\"\
    \n    :set logcontent (\"\$logcontent\" . \"\$logcontenttemp\" . \"  \\n\")\
    \n    :set logcontenttemp \"Mik:        \$mikResolve\"\
    \n    :set logcontent (\"\$logcontent\" . \"\$logcontenttemp\" . \"  \\n\")\
    \n    :set logcontenttemp \"Anna:        \$annaResolve\"\
    \n    :set logcontent (\"\$logcontent\" . \"\$logcontenttemp\" . \"  \\n\")\
    \n\
    \n    :set logcontenttemp \"Clock:        \$[/system ntp client get status]\"\
    \n    :set logcontent (\"\$logcontent\" . \"\$logcontenttemp\" . \"  \\n\")\
    \n\
    \n    :set state \"Listing packages\"\
    \n\
    \n    /system/package {\
    \n        :foreach pkg in=[find (!disabled)] do={\
    \n            :local pkgName [get value-name=name \$pkg]\
    \n            :set logcontent (\"\$logcontent\" . \" * \$pkgName\" . \"  \\n\")\
    \n        }\
    \n    }\
    \n\
    \n    :set state \"Setting global note\"\
    \n    \$globalNoteMe value=\$state verbose=true\
    \n\
    \n    /system note set note=\"\$logcontent\"\
    \n    \$globalNoteMe value=\"Done\" verbose=true\
    \n\
    \n} do={\
    \n    :set state \"Error When \$state: \$errorDescr\"\
    \n    \$globalNoteMe value=\$state\
    \n    :set itsOk false\
    \n}\
    \n\
    \n:local inf \"\"\
    \n:if (\$itsOk) do={\
    \n    :set inf \"\E2\9C\93 SUCCESS \$scriptname on \$sysname: console note refreshed\"\
    \n}\
    \n\
    \n:if (!\$itsOk) do={\
    \n    :set inf \"\E2\9C\97 FAILED \$scriptname on \$sysname: \$state\"\
    \n}\
    \n\
    \n\$globalNoteMe value=\$inf\
    \n\
    \n:if (!\$itsOk) do={\
    \n    \$globalTgMessage value=\$inf\
    \n    :error \$inf\
    \n}\
    \n\r\
    \n"
/system script add dont-require-permissions=yes name=doCloudBackup owner=owner policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":local sysname [/system identity get name]\
    \n:local scriptname \"doCloudBackup\"\
    \n:global globalScriptBeforeRun\
    \n\$globalScriptBeforeRun \$scriptname\
    \n\
    \n:global globalNoteMe\
    \n:global globalTgMessage\
    \n:global globalSecret\
    \n:global globalOnPrimaryPartition\
    \n:local itsOk true\
    \n:local state \"\"\
    \n\
    \n# Configure at runtime: \$globalSecret set BACKUP_PASSWORD password=\"YOUR_SECRET\"\
    \n:local backupPassword \"\$[\$globalSecret get BACKUP_PASSWORD]\"\
    \n\
    \n# preflight\
    \n:if (![\$globalOnPrimaryPartition]) do={\
    \n    :set state \"WARNING: the system booted up from fallback partition - skipping backup!\"\
    \n    :log error \$state\
    \n    \$globalNoteMe value=\$state\
    \n    :error \$state\
    \n}\
    \n\
    \n:onerror errorDescr in={\
    \n\
    \n    # we are not interested in output, but print without count-only is\
    \n    # required to fetch information from cloud\
    \n    /system backup cloud print as-value\
    \n\
    \n    :set state \"Creating and uploading cloud backup\"\
    \n    \$globalNoteMe value=\$state verbose=true\
    \n\
    \n    :local backup ([/system/backup/cloud/find]->0)\
    \n    :if ([:typeof \$backup] = \"id\") do={\
    \n        /system/backup/cloud/upload-file action=create-and-upload password=\$backupPassword replace=\$backup\
    \n    } else={\
    \n        /system/backup/cloud/upload-file action=create-and-upload password=\$backupPassword\
    \n    }\
    \n\
    \n    :set backup ([/system/backup/cloud/find]->0)\
    \n    :local backupName [/system/backup/cloud/get \$backup name]\
    \n    :set state \"Cloud backup file uploaded: \$backupName\"\
    \n    \$globalNoteMe value=\$state\
    \n    \$globalNoteMe value=\"Done\" verbose=true\
    \n\
    \n} do={\
    \n    :set state \"Error When \$state: \$errorDescr\"\
    \n    \$globalNoteMe value=\$state\
    \n    :set itsOk false\
    \n}\
    \n\
    \n:local inf \"\"\
    \n:if (\$itsOk) do={\
    \n    :set inf \"\E2\9C\93 SUCCESS \$scriptname on \$sysname: cloud backup uploaded\"\
    \n}\
    \n\
    \n:if (!\$itsOk) do={\
    \n    :set inf \"\E2\9C\97 FAILED \$scriptname on \$sysname: \$state\"\
    \n}\
    \n\
    \n\$globalNoteMe value=\$inf\
    \n\
    \n:if (!\$itsOk) do={\
    \n    \$globalTgMessage value=\$inf\
    \n    :error \$inf\
    \n}\
    \n\r\
    \n"
/system logging action set 0 memory-lines=3000
/system logging action set 1 disk-file-name=journal disk-lines-per-file=500
/system logging action set 3 add-topics-string=yes remote=victoria.home remote-log-format=syslog
/system logging action add name=IpsecOnScreenLog target=memory
/system logging action add disk-file-count=5 disk-file-name=ScriptsDiskLog disk-lines-per-file=300 name=ScriptsDiskLog target=disk
/system logging action add disk-file-count=5 disk-file-name=ErrorDiskLog disk-lines-per-file=300 name=ErrorDiskLog target=disk
/system logging action add name=TerminalConsoleLog remember=no target=echo
/system logging action add name=OnScreenLog target=memory
/system logging action add name=DHCPOnScreenLog target=memory
/system logging action add name=DNSOnScreenLog target=memory
/system logging action add name=RouterControlLog target=memory
/system logging action add name=OSPFOnscreenLog target=memory
/system logging action add name=L2TPOnScreenLog target=memory
/system logging action add disk-file-count=5 disk-file-name=AuthDiskLog disk-lines-per-file=300 name=AuthDiskLog target=disk
/system logging action add name=CertificatesOnScreenLog target=memory
/system logging action add name=ParseMemoryLog target=memory
/system logging action add name=CAPSOnScreenLog target=memory
/system logging action add name=FirewallOnScreenLog target=memory
/system logging action add name=SSHOnScreenLog target=memory
/system logging action add name=PoEOnscreenLog target=memory
/system logging action add name=EmailOnScreenLog target=memory
/system logging action add cef-event-delimiter="" name=VictoriaRemoteLog remote=victoria.home remote-log-format=cef target=remote
/system logging action add name=TransfersOnscreenLog target=memory
/system logging action add disk-file-count=1 disk-file-name=PKGInstallationLog disk-lines-per-file=100 name=PKGInstallationLog target=disk
/system logging action add disk-file-count=1 disk-file-name=REBOOTLog disk-lines-per-file=100 name=REBOOTDoskLog target=disk
/system logging action add name=DockerOnscreenLog target=memory
/system logging action add name=NetinstallOnscreenLog target=memory
/system logging set 0 action=OnScreenLog topics=info,!ipsec,!script,!dns,!debug
/system logging set 1 action=OnScreenLog
/system logging set 2 action=OnScreenLog
/system logging set 3 action=TerminalConsoleLog
/system logging add action=IpsecOnScreenLog topics=ipsec,!debug
/system logging add action=ErrorDiskLog topics=critical
/system logging add action=ErrorDiskLog topics=error
/system logging add action=ScriptsDiskLog topics=script
/system logging add action=DHCPOnScreenLog topics=dhcp
/system logging add action=DNSOnScreenLog topics=dns,!packet
/system logging add action=OSPFOnscreenLog topics=ospf,!raw
/system logging add action=L2TPOnScreenLog topics=l2tp
/system logging add action=AuthDiskLog topics=account
/system logging add action=CertificatesOnScreenLog topics=certificate
/system logging add action=AuthDiskLog topics=manager
/system logging add action=ParseMemoryLog topics=warning
/system logging add action=CAPSOnScreenLog topics=caps
/system logging add action=FirewallOnScreenLog topics=firewall
/system logging add action=CAPSOnScreenLog topics=wireless
/system logging add action=ParseMemoryLog topics=system
/system logging add action=SSHOnScreenLog topics=ssh,!packet,!debug
/system logging add action=PoEOnscreenLog topics=poe-out
/system logging add action=EmailOnScreenLog topics=e-mail
/system logging add action=ParseMemoryLog topics=error
/system logging add action=ParseMemoryLog topics=account
/system logging add action=ParseMemoryLog topics=critical
/system logging add action=TransfersOnscreenLog topics=fetch,!raw
/system logging add action=PKGInstallationLog regex="^.*install.*\$"
/system logging add action=VictoriaRemoteLog prefix=WARN regex="^.*reboot.*\$" topics=!dhcp
/system logging add action=PKGInstallationLog regex="^.*package.*\$"
/system logging add action=DockerOnscreenLog topics=container
/system logging add action=VictoriaRemoteLog topics=!packet,!debug,!raw,!dns,!firewall,!ssh,!l2tp,!ipsec
/system logging add action=OnScreenLog topics=!debug,!packet,!raw,!dns,!ssh,!firewall
/system logging add action=AuthDiskLog regex="^.*login.*\$"
/system logging add action=VictoriaRemoteLog topics=error,!ipsec
/system logging add action=VictoriaRemoteLog prefix=AUTH regex="^.*login.*\$"
/system logging add topics=netwatch
/system logging add action=VictoriaRemoteLog topics=l2tp,!packet,!debug,!raw,!info
/system logging add action=NetinstallOnscreenLog topics=netinstall
/system logging add action=VictoriaRemoteLog topics=caps
/tool bandwidth-server set authenticate=no enabled=no
/tool e-mail set from=defm.kopcap@gmail.com port=587 server=smtp.gmail.com tls=starttls user=defm.kopcap@gmail.com
/tool netwatch add disabled=no down-script=":global NetwatchHostName \"mikrouter.home\";\
    \n:global NetwatchHostState \"DOWN\";\
    \n\
    \n/system script run doNetwatchHost;" host=192.168.99.1 interval=1m test-script="" timeout=1s type=simple up-script=":global NetwatchHostName \"mikrouter.home\";\
    \n:global NetwatchHostState \"UP\";\
    \n\
    \n/system script run doNetwatchHost;"
/tool sniffer set filter-ip-address=172.17.0.4/32 filter-ip-protocol=tcp filter-port=4430 streaming-enabled=yes streaming-server=192.168.97.1:30000
/user group set read policy=local,telnet,ssh,read,test,winbox,password,web,sniff,api,romon,rest-api,!ftp,!reboot,!write,!policy,!sensitive
/user group set write policy=local,telnet,ssh,read,write,test,winbox,password,web,sniff,api,romon,rest-api,!ftp,!reboot,!policy,!sensitive
/user ssh-keys add info=automation@anna key="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF6lqaeSpKSDJC8QqKps+/mJoXVZdffcuVWtzCFFU++w" user=automation
/interface bridge port add bridge=docker-infrastructure-br interface=veth-telemt trusted=yes
/interface bridge port add bridge=docker-infrastructure-br interface=veth-hermes trusted=yes
/interface bridge port add bridge=docker-infrastructure-br interface=veth-gitwatch trusted=yes
/interface bridge port add bridge=docker-infrastructure-br interface=veth-telemt-webui trusted=yes
/interface bridge port add bridge=docker-infrastructure-br interface=veth-caddy trusted=yes
/interface bridge port add bridge=main-infrastructure-br interface=veth-haproxy trusted=yes
/interface bridge port add bridge=docker-infrastructure-br comment="GLIDER shared bridge" interface=veth-glider
/ip traffic-flow set cache-entries=64k interfaces=wan
