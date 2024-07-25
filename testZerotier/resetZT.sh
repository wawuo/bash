 systemctl restart zerotier-one.service
 sleep 30
 IP="192.168.191.31"
 COUNT=200
 check_ping() {
 if ping -c $COUNT $1; then
	 return 0
 else
	 return 1
 fi
 }
# while true
# do
	 check_ping $IP
#	 result=$?
# if [ $result -eq 0 ];then
#	echo "ping to $IP was successful." >>90
#	exit 0
# else
#	echo "ping to $IP failed." >>90
# fi
# done
# ping -c 10 192.168.191.216
