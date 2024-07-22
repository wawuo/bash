#!/bin/bash
myfile="/list/"
iceterTime="`date '+%Y%m%d%H%M%S'`"
echo "$iceterTime" >>/tmp/运行记录
if [ ! -f "$myfile" ]; then
cp /ilist /list
fi
chmod 777 /list
chmod 777 /ilist
cat /ilist >> /list
cat /dev/null >/ilist
sed -i 's/\ MOVED_TO\ //g' /list #将多的 ” MOVED_TO“ 处理掉
# sudo -u www-data php /var/www/html/occ app:disable files_automatedtagging
while read LINE0
 do
        touch "$LINE0"  #更新文件到当前时间
#        sudo -u www-data php /var/www/html/occ files:scan --path="${LINE0#*data/}"
        
        echo $LINE0 >> /tmp/更新记录.1
        sed -i '1d' /list
done </list
sed -i 's/\/var\/www\/html\/data/\//g' /tmp/更新记录.1
sudo -u www-data php /var/www/html/occ app:disable files_automatedtagging

while read LINE1
	
 do
	 sum=1
# sudo -u www-data php /var/www/html/occ files:scan admin
sudo -u www-data php /var/www/html/occ files:scan --path="${LINE1}"
echo "$sum" 
sum=$((sum + 1))
# cp /list /ilist
done <//tmp/更新记录.1

echo ""  > /tmp/更新记录.1
sudo -u www-data php /var/www/html/occ app:enable  files_automatedtagging

#判断inotifywait 进程是否存在，如果不存在就启动它
PIDS=`ps -ef |grep inotifywait |grep -v grep | awk '{print $2}'`
if [ "$PIDS" != "" ]; then
echo "inotifywait is runing!"
else
cd /root/
#运行进程
sudo inotifywait -r -m -e 'moved_to' -o /ilist /var/www/html/data/admin/files/
fi
