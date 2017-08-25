# 登录服务器执行远程脚本
#注：$1 $6 $11 $9 $12 $7 $10都是service.sh脚本的顺序参数
login_ip=192.168.1.230
login_user=admin
login_passwd=123456
warmtips=Execute service.sh
service_cmd_remote_pwd=/home/service/deploy/
sshpass -p $login_passwd ssh -p22 -o StrictHostKeyChecking=no -tt $login_user@$login_ip <<sshaccess
  "$service_cmd_remote_pwd"service.sh $1 $6 $11 $9 $12 $7 $10
exit  
sshaccess
echo "$warmtips successful."
exit 0