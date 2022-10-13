#!/bin/sh
set -x

/usr/sbin/openvpn --config /root/config.ovpn &
until ip l sh tap0 >/dev/null 2>&1; do sleep 1; done
sysctl -w net.ipv4.ip_forward=1
/sbin/iptables -t nat -A POSTROUTING -o tap0 -j MASQUERADE
/sbin/iptables -A FORWARD -i tap0 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
/sbin/iptables -A FORWARD -i eth0 -o tap0 -j ACCEPT

while sleep 50; do
  t=$(ping -c 10 service.company.internal.net | grep -o -E '[0-9]+ packets r' | grep -o -E '[0-9]+')
  if [ "$t" -eq 0 ]; then
    pkill -f openvpn
    /usr/sbin/openvpn --config /root/config.ovpn &
  fi
done
