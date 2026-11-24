# Evidence: list-router-input-services + reverse-proxy

Captured: 2026-11-24T11:35:12+0300

## interface list
```
Columns: NAME
# NAME                      
;;; DHCP/NTP router input services
0 list-router-input-services

Columns: LIST, INTERFACE
# LIST                        INTERFACE               
;;; main
0 list-router-input-services  main-infrastructure-br  
;;; guest
1 list-router-input-services  guest-infrastructure-br 
;;; docker
2 list-router-input-services  docker-infrastructure-br
;;; netinstall
3 list-router-input-services  adm-netinstall-br       

```

## reverse-proxy filter
```
*F6  ;;; jump reverse-proxy
     chain=input action=jump jump-target=chain-reverse-proxy protocol=tcp
     dst-port=443
 
*F7  ;;; clients to reverse-proxy
     chain=chain-reverse-proxy action=accept protocol=tcp
     src-address=192.168.90.0/24 dst-port=443
 
*F8  ;;; return reverse-proxy
     chain=chain-reverse-proxy action=return

```

## reverse-proxy service
```
Flags: D - DYNAMIC; c - CONNECTION
10     name="reverse-proxy" port=443 proto=tcp available-from=192.168.90.0/24
       certificate=C.anna.proxy@CHR tls-version=only-1.2 vrf=main
       max-sessions=20
 
11  Dc name="reverse-proxy" port=443 proto=tcp local=192.168.90.1
       remote=192.168.90.75:50121
 
12  Dc name="reverse-proxy" port=443 proto=tcp local=192.168.90.1
       remote=192.168.90.75:52397
 
13  Dc name="reverse-proxy" port=443 proto=tcp local=192.168.90.1
       remote=192.168.90.75:53185
 
14  Dc name="reverse-proxy" port=443 proto=tcp local=192.168.90.1
       remote=192.168.90.75:54478
 
15  Dc name="reverse-proxy" port=443 proto=tcp local=192.168.90.1
       remote=192.168.90.75:56772
 
16  Dc name="reverse-proxy" port=443 proto=tcp local=192.168.90.1
       remote=192.168.90.75:58219
 
17  Dc name="reverse-proxy" port=443 proto=tcp local=192.168.90.1
       remote=192.168.90.75:59564
 
18  Dc name="reverse-proxy" port=443 proto=tcp local=192.168.90.1
       remote=192.168.90.75:61929
 
19  Dc name="reverse-proxy" port=443 proto=tcp local=192.168.90.1
       remote=192.168.90.85:50558
 
20  Dc name="reverse-proxy" port=443 proto=tcp local=192.168.90.1
       remote=192.168.90.85:53499
 
21  Dc name="reverse-proxy" port=443 proto=tcp local=192.168.90.1
       remote=192.168.90.85:54266
 
22  Dc name="reverse-proxy" port=443 proto=tcp local=192.168.90.1
       remote=192.168.90.85:55229
 
23  Dc name="reverse-proxy" port=443 proto=tcp local=192.168.90.1
       remote=192.168.90.85:56229
 
24  Dc name="reverse-proxy" port=443 proto=tcp local=192.168.90.1
       remote=192.168.90.85:58235
 
25  Dc name="reverse-proxy" port=443 proto=tcp local=192.168.90.1
       remote=192.168.90.85:58794
 
26  Dc name="reverse-proxy" port=443 proto=tcp local=192.168.90.1
       remote=192.168.90.85:59055
 
27  Dc name="reverse-proxy" port=443 proto=tcp local=192.168.90.1
       remote=192.168.90.85:59982
 
28  Dc name="reverse-proxy" port=443 proto=tcp local=192.168.90.1
       remote=192.168.90.85:60211
 
29  Dc name="reverse-proxy" port=443 proto=tcp local=192.168.90.1
       remote=192.168.90.85:61552
 
30  Dc name="reverse-proxy" port=443 proto=tcp local=192.168.90.1
       remote=192.168.90.85:62260

```
