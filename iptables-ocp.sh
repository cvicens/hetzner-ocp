INPUT_CHAIN=INPUT

IP_FRONT=148.251.77.169

NIC_FRONT=eno1
NIC_BACK=virbr0
NETWORK=192.168.122.0
DESTINATION_80=192.168.122.159
DESTINATION_443=192.168.122.159
DESTINATION_8443=192.168.122.30

# Forward
iptables -I FORWARD -m state -d ${NETWORK}/24 --state NEW,RELATED,ESTABLISHED -j ACCEPT

iptables -t nat -A PREROUTING -i ${NIC_FRONT} -p tcp --dport 80   -d ${IP_FRONT} -j DNAT --to-destination ${DESTINATION_80}:80
iptables -t nat -A PREROUTING -i ${NIC_FRONT} -p tcp --dport 443  -d ${IP_FRONT} -j DNAT --to-destination ${DESTINATION_443}:443
iptables -t nat -A PREROUTING -i ${NIC_FRONT} -p tcp --dport 8443 -d ${IP_FRONT} -j DNAT --to-destination ${DESTINATION_8443}:8443

iptables -t nat -A POSTROUTING -o ${NIC_BACK} -p tcp --dport 80   -s ${DESTINATION_80}   -j SNAT --to-source ${IP_FRONT}:80
iptables -t nat -A POSTROUTING -o ${NIC_BACK} -p tcp --dport 443  -s ${DESTINATION_443}  -j SNAT --to-source ${IP_FRONT}:443
iptables -t nat -A POSTROUTING -o ${NIC_BACK} -p tcp --dport 8443 -s ${DESTINATION_8443} -j SNAT --to-source ${IP_FRONT}:8443