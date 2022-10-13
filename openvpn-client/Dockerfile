FROM alpine

RUN apk update && \
    apk upgrade && \
    apk add --no-cache openvpn iptables && \
    rm -rf /var/cache/apk

COPY ./entry.sh /root/
COPY ./config.ovpn /root/
COPY ./config.pass /root/
RUN chmod +x /root/entry.sh
ENTRYPOINT /root/entry.sh
