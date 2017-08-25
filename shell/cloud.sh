# 以下Spring Cloud项目启动脚本开始
surl="http://192.168.100.137:8101/info"
sjar="/home/SpringCloudService/deploy/registry-center-1.0.0.jar"
stips="注册中心"

nohup java -jar $sjar >/dev/null 2>&1 &

echo -n "Starting the $stips "

tcount=0

while true
do
  tcount=$[tcount+2]
  echo -e "·\c"
  sleep 2s
  info=$(curl -s "$surl")
  if [ "$info" == "{}" ];then
        break;
  fi
done

echo ^Z
echo -e "\033[35mStarted $stips successfully($tcount s). \033[0m"
# 以下Spring Cloud项目启动脚本结束

# 通过端口停止服务，例端口8101
kill `lsof -t -i:8101`
# shell执行睡眠2秒
sleep 2s
# 生效环境变量
source /etc/profile
# 暂停执行=Ctrl+Z
echo ^Z
