INPUT_CHAIN=INPUT

NIC_FRONT=eno1
NETWORK=192.168.122.0
DESTINATION_80=192.168.122.49
DESTINATION_443=192.168.122.49
DESTINATION_8443=192.168.122.181

# allows established and related incoming traffic
#iptables -A ${INPUT_CHAIN} -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
# allows outgoing traffic of all established connection
#iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED -j ACCEPT

# Allow
iptables -A ${INPUT_CHAIN}  -p tcp --dport 22 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --sport 22 -m conntrack --ctstate ESTABLISHED -j ACCEPT

iptables -A ${INPUT_CHAIN}  -p tcp --dport 80 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --sport 80 -m conntrack --ctstate ESTABLISHED -j ACCEPT
iptables -A ${INPUT_CHAIN}  -p tcp --dport 443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --sport 443 -m conntrack --ctstate ESTABLISHED -j ACCEPT
iptables -A ${INPUT_CHAIN}  -p tcp --dport 8443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --sport 8443 -m conntrack --ctstate ESTABLISHED -j ACCEPT

iptables -t nat -A PREROUTING  -p tcp --dport 80   -i ${NIC_FRONT} -j DNAT --to-destination ${DESTINATION_80}:80
iptables -t nat -A PREROUTING  -p tcp --dport 443  -i ${NIC_FRONT} -j DNAT --to-destination ${DESTINATION_443}:443
iptables -t nat -A PREROUTING  -p tcp --dport 8443 -i ${NIC_FRONT} -j DNAT --to-destination ${DESTINATION_8443}:8443

iptables -t nat -A POSTROUTING -p tcp --dport 80   --destination ${DESTINATION_80}   -o ${NIC_FRONT} -j MASQUERADE
iptables -t nat -A POSTROUTING -p tcp --dport 443  --destination ${DESTINATION_443}  -o ${NIC_FRONT} -j MASQUERADE
iptables -t nat -A POSTROUTING -p tcp --dport 8443 --destination ${DESTINATION_8443} -o ${NIC_FRONT} -j MASQUERADE

iptables -I FORWARD -m state -d ${NETWORK}/24 --state NEW,RELATED,ESTABLISHED -j ACCEPT
