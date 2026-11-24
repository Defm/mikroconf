# Evidence: filter layout after 6.1/7.2

Captured: 2026-11-24T11:35:12+0300 from anna (read-only).

Absolute positions from `/ip firewall filter print` (not `print where`/`stats` — those numbers mislead).

```
 
131    ;;; DUMMY7
       chain=forward action=passthrough src-address-list=alist-fw-empty-dummy
       log=no log-prefix=""
 
132    ;;; jump dhcp-server
       chain=input action=jump jump-target=chain-dhcp-server protocol=udp
       dst-port=67,68
 
133    ;;; DHCP clients to server
       chain=chain-dhcp-server action=accept protocol=udp
       in-interface-list=list-router-input-services dst-port=67,68
 
134    ;;; return dhcp-server
       chain=chain-dhcp-server action=return
 
135    ;;; jump ntp-server
       chain=input action=jump jump-target=chain-ntp-server protocol=udp
       dst-port=123
 
136    ;;; NTP clients to server
       chain=chain-ntp-server action=accept protocol=udp
       in-interface-list=list-router-input-services dst-port=123
 
137    ;;; return ntp-server
       chain=chain-ntp-server action=return
 
138    ;;; jump reverse-proxy
       chain=input action=jump jump-target=chain-reverse-proxy protocol=tcp
       dst-port=443
 
139    ;;; clients to reverse-proxy
       chain=chain-reverse-proxy action=accept protocol=tcp
       src-address=192.168.90.0/24 dst-port=443
 
140    ;;; return reverse-proxy
       chain=chain-reverse-proxy action=return
 
141    ;;; TCP/UDP ports necessary for SMB
       chain=input action=accept protocol=udp
       src-address-list=alist-fw-smb-allow dst-port=137-138 log=no
       log-prefix=""
 
142    ;;; TCP/UDP ports necessary for SMB
       chain=input action=accept protocol=tcp
       src-address-list=alist-fw-smb-allow dst-port=137,139 log=no
       log-prefix=""
 
143    ;;; Accept Related or Established Connections
       chain=input action=accept connection-state=established,related log=no
       log-prefix=""
```

## Continuity

Positions 132–140 contiguous: dhcp jump/accept/return, ntp jump/accept/return, reverse-proxy jump/accept/return; next is SMB input.
