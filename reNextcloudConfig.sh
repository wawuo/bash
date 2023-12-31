#!/bin/bash
export PATH=$PATH:/sbin
# 定义一个函数，用来获取网卡的IP地址，并格式化为0 =>'ip',的形式
get_ip() {
  # 接收一个参数，表示网卡的名称
  interface=$1
  # 使用ip命令获取网卡的信息，然后使用grep和awk命令提取IP地址
  ip=$(ip addr show $interface | grep "inet " | awk '{print $2}' | cut -d/ -f1)
  # 如果IP地址不为空，就输出0 =>'ip',的形式，否则输出空字符串
  if [ -n "$ip" ]; then
    echo "0 => '$ip',"
  else
    echo "$ip"
  fi
}

# 定义一个函数，用来替换/var/www/html/config/config.php中的由0 => 开始的那一行
replace_ip() {
  # 调用get_ip函数，获取enp4s0网卡的格式化后的IP地址
  ip1=$(get_ip enp4s0)
  # 如果enp4s0网卡没有有效的IP地址，就调用get_ip函数，获取wlp5s0网卡的格式化后的IP地址
  if [ -z "$ip1" ]; then
    ip1=$(get_ip wlp5s0)
  fi
  # 如果ip1不为空，就使用sed命令替换/var/www/html/config/config.php中的那一行
  if [ -n "$ip1" ]; then

sed -i "s/^\s*0 .*,$/$ip1/" /var/www/html/config/config.php


  fi
}

# 使用while循环和sleep命令，每隔10分钟执行一次replace_ip函数
while true; do
  replace_ip
#  echo $ip1
  sleep 600 # 等待10分钟（600秒）
done

