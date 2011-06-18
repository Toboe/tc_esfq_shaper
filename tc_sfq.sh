#!/bin/bash
for module in sch_htb cls_fw ; do
    /sbin/modprobe $module 2>&- >&-
done

        ICMP="match ip protocol 1 0xff"
        TCP="match ip protocol 6 0xff"
        UDP="match ip protocol 17 0xff"
        DPORT="match ip dport"
        SPORT="match ip sport"
        SRC="match ip src"
        DST="match ip dst"
        U32="protocol ip u32"
        DEV="eth1"
MARKPRIO1="0x10"
MARKPRIO2="0x20"
MARKPRIO3="0x30"
MARKPRIO4="0x40"

tc qdisc del dev $DEV root

tc qdisc add dev $DEV root handle 1: htb default 3
tc class add dev $DEV classid 1:1 parent 1: htb rate 900kbit ceil 1100kbit
tc class add dev $DEV classid 1:2 parent 1: htb rate 900kbit ceil 1100kbit

#tc qdisc add dev eth0 root handle 1: prio bands 5
##tc qdisc add dev eth0 parent 1:1 handle 10: pfifo
#tc qdisc add dev eth0 parent 1:2 handle 11: pfifo
#tc qdisc add dev eth0 parent 1:3 handle 12: htb default 0
tc class add dev $DEV classid 1:30 parent 1:2 htb rate 50kbit ceil 100kbit 
tc class add dev $DEV classid 1:40 parent 1:2 htb rate 20kbit ceil 50kbit 
tc class add dev $DEV classid 1:50 parent 1:2 htb rate 100kbit ceil 800kbit 
tc class add dev $DEV classid 1:60 parent 1:2 htb rate 100kbit ceil 150kbit 


tc qdisc add dev $DEV parent 1:30 handle 2: sfq perturb 10
tc qdisc add dev $DEV parent 1:40 handle 3: sfq perturb 10
tc qdisc add dev $DEV parent 1:50 handle 4: sfq perturb 10
tc qdisc add dev $DEV parent 1:60 handle 5: sfq perturb 10

tc filter add dev $DEV parent 1: protocol ip prio 0 handle $MARKPRIO1 fw classid 1:60

tc qdisc add dev $DEV root handle 1: htb default 3
tc class add dev $DEV classid 1:1 parent 1: htb rate 900kbit ceil 1100kbit
tc class add dev $DEV classid 1:2 parent 1: htb rate 900kbit ceil 1100kbit

#tc qdisc add dev eth0 root handle 1: prio bands 5
##tc qdisc add dev eth0 parent 1:1 handle 10: pfifo
#tc qdisc add dev eth0 parent 1:2 handle 11: pfifo
#tc qdisc add dev eth0 parent 1:3 handle 12: htb default 0
tc class add dev $DEV classid 1:30 parent 1:2 htb rate 50kbit ceil 100kbit 
tc class add dev $DEV classid 1:40 parent 1:2 htb rate 20kbit ceil 50kbit 
tc class add dev $DEV classid 1:50 parent 1:2 htb rate 100kbit ceil 800kbit 
tc class add dev $DEV classid 1:60 parent 1:2 htb rate 100kbit ceil 150kbit 


tc qdisc add dev $DEV parent 1:30 handle 2: sfq perturb 10
tc qdisc add dev $DEV parent 1:40 handle 3: sfq perturb 10
tc qdisc add dev $DEV parent 1:50 handle 4: sfq perturb 10
tc qdisc add dev $DEV parent 1:60 handle 5: sfq perturb 10

tc filter add dev $DEV parent 1: protocol ip prio 0 handle $MARKPRIO1 fw classid 1:60
tc filter add dev $DEV parent 1: protocol ip prio 1 handle $MARKPRIO2 fw classid 1:40
tc filter add dev $DEV parent 1: protocol ip prio 2 handle $MARKPRIO3 fw classid 1:50
tc filter add dev $DEV parent 1: protocol ip prio 3 handle $MARKPRIO4 fw classid 1:60


#iptables -t mangle -F

#iptables -t mangle -A FORWARD -p icmp -j MARK --set-mark $MARKPRIO1
#iptables -t mangle -A OUTPUT -p icmp -j MARK --set-mark $MARKPRIO1

#iptables -t mangle -A INPUT -p tcp --dport 21 -j MARK --set-mark $MARKPRIO1
#iptables -t mangle -A FORWARD -p tcp --dport 21 -j MARK --set-mark $MARKPRIO1
#iptables -t mangle -A OUTPUT -p tcp --dport 21 -j MARK --set-mark $MARKPRIO1

#iptables -t mangle -A FORWARD -p tcp --sport 5901 -j MARK --set-mark $MARKPRIO2
#iptables -t mangle -A FORWARD -p tcp --dport 5901 -j MARK --set-mark $MARKPRIO2

#iptables -t mangle -A FORWARD -p tcp --dport 5900 -j MARK --set-mark $MARKPRIO4
#iptables -t mangle -A FORWARD -p tcp --sport 5900 -j MARK --set-mark $MARKPRIO4

#iptables -t mangle -A FORWARD -p tcp --dport 80 -j MARK --set-mark $MARKPRIO3


tc filter add dev $DEV parent 1: protocol ip prio 2 handle $MARKPRIO3 fw classid 1:50
tc filter add dev $DEV parent 1: protocol ip prio 3 handle $MARKPRIO4 fw classid 1:60


#iptables -t mangle -F

#iptables -t mangle -A FORWARD -p icmp -j MARK --set-mark $MARKPRIO1
#iptables -t mangle -A OUTPUT -p icmp -j MARK --set-mark $MARKPRIO1

#iptables -t mangle -A INPUT -p tcp --dport 21 -j MARK --set-mark $MARKPRIO1
#iptables -t mangle -A FORWARD -p tcp --dport 21 -j MARK --set-mark $MARKPRIO1
#iptables -t mangle -A OUTPUT -p tcp --dport 21 -j MARK --set-mark $MARKPRIO1

#iptables -t mangle -A FORWARD -p tcp --sport 5901 -j MARK --set-mark $MARKPRIO2
#iptables -t mangle -A FORWARD -p tcp --dport 5901 -j MARK --set-mark $MARKPRIO2

#iptables -t mangle -A FORWARD -p tcp --dport 5900 -j MARK --set-mark $MARKPRIO4
#iptables -t mangle -A FORWARD -p tcp --sport 5900 -j MARK --set-mark $MARKPRIO4

#iptables -t mangle -A FORWARD -p tcp --dport 80 -j MARK --set-mark $MARKPRIO3
#iptables -t mangle -A OUTPUT -p tcp --dport 80 -j MARK --set-mark $MARKPRIO3











#tc filter add dev eth0 parent 1:0 $U32 $DPORT 80 0xffff classid 1:5
#tc filter add dev eth0 parent 1:0 $U32 $DPORT 21 0xffff classid 1:4
#tc filter add dev eth0 parent 1:0 prio 2 $U32 $TCP $DPORT 80 0xffff classid 1:5
#tc filter add dev eth0 parent 1:0 prio 2 $U32 $TCP $SPORT 80 0xffff classid 1:5

#tc filter add dev eth0 parent 1:0 prio 2 $U32 $UDP $DPORT 5900 0xffff classid 1:4
#tc filter add dev eth0 parent 1:0 prio 2 $U32 $UDP $SPORT 5900 0xffff classid 1:4

#tc filter add dev eth0 parent 1: protocol ip prio 19 u32 match ip protocol 17 0xff match ip sport 5900 0xffff flowid 1:5



















































#!bin/bash
MARKPRIO1="0x10"
MARKPRIO2="0x20"
MARKPRIO3="0x20"
MARKPRIO4="0x40"

# Включаем форвардинг
echo 1 > /proc/sys/net/ipv4/ip_forward
echo "net.ipv4.ip_forward = 1" >/etc/sysctl.conf

# Очищаем все цепочки таблицы filter
iptables -F
iptables -t nat -F
iptables -t mangle -F
#iptables -A POSTROUTING -t nat -s 192.168.1.1 -j MASQUERADE
#reroute from I-net to SSH server
#iptables -t nat -A PREROUTING -d 192.168.12.219 -p tcp --dport 22 -j DNAT --to 192.168.1.2:22
#iptables -t nat -A POSTROUTING -s 192.168.1.2 -p tcp --dport 22 -j SNAT --to 192.168.12.219:22

# Reroute from SSH to M2 ssh traffic
#iptables -t nat -A PREROUTING -d 172.16.0.4 -p tcp --dport 3456 -j DNAT --to 10.0.0.6:22
#iptables -t nat -A POSTROUTING -s 10.0.0.6 -p tcp --dport 22 -j SNAT --to 172.16.0.4:3456
# Reroute M2 to I-net.

iptables -t nat -A PREROUTING -d 192.168.12.219   -j DNAT --to 192.168.4.221
iptables -t nat -A POSTROUTING -s 192.168.4.221   -j SNAT --to 192.168.12.219
iptables -t nat -A PREROUTING -d 192.168.12.219   -j DNAT --to 192.168.4.223
iptables -t nat -A POSTROUTING -s 192.168.4.223   -j SNAT --to 192.168.12.219
iptables -t nat -A PREROUTING -d 192.168.12.219   -j DNAT --to 192.168.4.224
iptables -t nat -A POSTROUTING -s 192.168.4.224   -j SNAT --to 192.168.12.219


#iptables -t mangle -F

iptables -t mangle -A FORWARD -p icmp -j MARK --set-mark $MARKPRIO1
iptables -t mangle -A OUTPUT -p icmp -j MARK --set-mark $MARKPRIO1

iptables -t mangle -A INPUT -p tcp --dport 20 -j MARK --set-mark $MARKPRIO3
iptables -t mangle -A FORWARD -p tcp --dport 20 -j MARK --set-mark $MARKPRIO3
iptables -t mangle -A OUTPUT -p tcp --dport 20 -j MARK --set-mark $MARKPRIO3
iptables -t mangle -A OUTPUT -p tcp --sport 20 -j MARK --set-mark $MARKPRIO3

#iptables -t nat -A POSTROUTING -s 10.0.0.6 -p tcp --dport 22 -j SNAT --to 172.16.0.4:3456
# Reroute M2 to I-net.

iptables -t nat -A PREROUTING -d 192.168.12.219   -j DNAT --to 192.168.4.221
iptables -t nat -A POSTROUTING -s 192.168.4.221   -j SNAT --to 192.168.12.219
iptables -t nat -A PREROUTING -d 192.168.12.219   -j DNAT --to 192.168.4.223
iptables -t nat -A POSTROUTING -s 192.168.4.223   -j SNAT --to 192.168.12.219
iptables -t nat -A PREROUTING -d 192.168.12.219   -j DNAT --to 192.168.4.224
iptables -t nat -A POSTROUTING -s 192.168.4.224   -j SNAT --to 192.168.12.219


#iptables -t mangle -F

iptables -t mangle -A FORWARD -p icmp -j MARK --set-mark $MARKPRIO1
iptables -t mangle -A OUTPUT -p icmp -j MARK --set-mark $MARKPRIO1

iptables -t mangle -A INPUT -p tcp --dport 20 -j MARK --set-mark $MARKPRIO3
iptables -t mangle -A FORWARD -p tcp --dport 20 -j MARK --set-mark $MARKPRIO3
iptables -t mangle -A OUTPUT -p tcp --dport 20 -j MARK --set-mark $MARKPRIO3
iptables -t mangle -A OUTPUT -p tcp --sport 20 -j MARK --set-mark $MARKPRIO3

iptables -t mangle -A FORWARD -p tcp --sport 20 -j MARK --set-mark $MARKPRIO3
#iptables -t mangle -A P -p tcp --dport 21 -j MARK --set-mark $MARKPRIO3
#iptables -t mangle -A POSTROUTING -p tcp --sport 21 -j MARK --set-mark $MARKPRIO3
#iptables -t mangle -A FORWARD -p tcp --dport 20 -j MARK --set-mark $MARKPRIO3
#iptables -t mangle -A FORWARD -p tcp --dport 20 -j MARK --set-mark $MARKPRIO3
#iptables -t mangle -A OUTPUT -p tcp --dport 20 -j MARK --set-mark $MARKPRIO3

iptables -t mangle -A FORWARD -p tcp --dport 22 -j MARK --set-mark $MARKPRIO3
iptables -t mangle -A OUTPUT -p tcp --dport 22 -j MARK --set-mark $MARKPRIO3

#iptables -t mangle -A FORWARD -p tcp --sport 5901 -j MARK --set-mark $MARKPRIO2
#iptables -t mangle -A FORWARD -p tcp --dport 5901 -j MARK --set-mark $MARKPRIO2

#iptables -t mangle -A FORWARD -p tcp --dport 5900 -j MARK --set-mark $MARKPRIO4
#iptables -t mangle -A FORWARD -p tcp --sport 5900 -j MARK --set-mark $MARKPRIO4

iptables -t mangle -A FORWARD -p tcp --dport 80 -j MARK --set-mark $MARKPRIO3
iptables -t mangle -A OUTPUT -p tcp --dport 80 -j MARK --set-mark $MARKPRIO3




