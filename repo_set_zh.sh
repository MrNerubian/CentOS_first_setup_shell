#!/bin/bash
#yum交互式配置脚本
#############################################################

yumst1(){
	echo "开始检测当前状态"
	st41=$(ls /etc/yum.repos.d/|grep CentOS-|wc -l)
	if [ $st41 -eq 5 ];then
		echo "当前yum源处于【初始状态】"
	else
		echo "当前yum源处于【已更改状态】"
	fi
}

rm_centyum(){
	echo "开始备份现有所有yum源文件"
	mkdir -p ~/back_first/yum
	cp /etc/yum.repos.d/* ~/back_first/yum &>/dev/null
	echo "开始删除现有所有yum源文件"
	rm -f /etc/yum.repos.d/*
	echo "清理yum源缓存"
	yum clean all 
	echo "操作执行完毕"
}

yum_local(){
mkdir -p /yum
mount -o ro /dev/sr0 /yum
echo 'mount -o ro /dev/sr0 /yum' >> /etc/rc.local
cat > /etc/yum.repos.d/nest_local.repo <<EOF
[nestlocal]
name=nest_local
baseurl=file:///yum
gpgcheck=0
enabled=1
EOF

yum clean all &>/dev/null
yum makecache &>/dev/null
echo "操作执行完毕"
}

yum_aliyun(){
cat > /etc/yum.repos.d/aliyun.repo <<EOF
[aliyun]
name=aliyun network yum
baseurl=http://mirrors.aliyun.com/centos/6/os/x86_64/
enabled=1
gpgcheck=1
gpgkey=http://mirrors.aliyun.com/centos/6/os/x86_64/RPM-GPG-KEY-CentOS-6
EOF

echo "正在刷新yum源，校验时间较长请稍等"
ping -c 3 www.baidu.com  &> /dev/null
if [ $? -eq 0 ];then
	echo "正在刷新yum源，请稍等"
	yum clean all &>/dev/null
	yum makecache &>/dev/null
else
	echo "网络故障，请检查网络连接"
fi
echo "操作执行完毕"
}

yum_163(){
cat > /etc/yum.repos.d/163.repo <<EOF
[163]
name=163 network yum
baseurl=http://mirrors.163.com/centos/6/os/x86_64/
enabled=1
gpgcheck=1
gpgkey=http://mirrors.163.com/centos/6/os/x86_64/RPM-GPG-KEY-CentOS-6
EOF

echo "正在刷新yum源，校验时间较长请稍等"
ping -c 3 www.baidu.com  &> /dev/null
if [ $? -eq 0 ];then
	echo "正在刷新yum源，请稍等"
	yum clean all &>/dev/null
	yum makecache &>/dev/null
else
	echo "网络故障，请检查网络连接"
fi
echo "操作执行完毕"
}


########################################################################

echo "开始执行YUM源设置功能"
	yumst1				#状态检测
while true
do
	echo "输入操作选项序号（清空现有yum源-1/光盘yum源-2/国内网络yum源-3/结束程序-4）"
	read -p ":" yum1
	if [ $yum1 -eq 1 ];then
		rm_centyum
	elif [ $yum1 -eq 2 ];then			#光盘yum源
		yum_local				
	elif [ $yum1 -eq 3 ];then			#国内网络yum源
		while true
		do
			echo "输入操作选项序号（阿里源-1/163源-2/返回上级-3）"
			read -p ":" yum2

			if [ $yum2 -eq 1 ];then			#阿里源				
				yum_aliyun
			elif [ $yum2 -eq 2 ];then		#163源
				yum_163	
			elif [ $yum2 -eq 3 ];then		#返回上级
				echo "正在返回上级"
				break
			else
				echo "输入有误，请重试"
				continue
			fi
		done
	elif [ $yum1 -eq 4 ];then			#结束程序
		echo "正在结束此项设置功能"
		break
	else
		echo "输入有误，请重试"
		continue
	fi
done
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
