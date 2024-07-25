#!/bin/bash
echo "$(date)" >>/root/timerun 
# 定义两个 IP 地址
IP1="192.168.191.37"
IP2="192.168.191.90"
# 定义 ping 的次数
COUNT=10
# 定义 ping 的成功率阈值
THRESHOLD=6
# 定义一个函数，用来检查 ping 的结果
check_ping() {
  # 初始化成功次数为 0
  success=0
  # 循环 ping 指定的次数
  for i in $(seq 1 $COUNT)
  do
    # 如果 ping 成功，成功次数加 1
    if ping -c 1  $1 ; then
      success=$((success + 1))
    fi
  done
  # 返回成功次数
  return $success
}
# 先 ping 第一个 IP 地址
check_ping $IP1
# 获取 ping 的结果
result1=$?
# 如果 ping 通大于阈值，退出脚本
if [ $result1 -gt $THRESHOLD ]; then
  echo "Ping to $IP1 was successful." >>216
  exit 0
else
  # 如果 ping 不通或小于阈值，继续 ping 第二个 IP 地址
  echo "Ping to $IP1 failed." >>216
  check_ping $IP2
  # 获取 ping 的结果
  result2=$?
  # 如果 ping 通大于阈值，退出脚本
  if [ $result2 -gt $THRESHOLD ]; then
    echo "Ping to $IP2 was successful." >>90
    exit 0
  else
    # 如果 ping 不通或小于阈值，运行 resetZT.bash 脚本
    echo "Ping to $IP2 failed." >>90
    echo "Running resetZT.bash script."
    /bash/resetZT.sh
  fi
fi
