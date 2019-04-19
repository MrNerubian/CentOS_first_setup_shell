#!/bin/bash
#更改主机名称

#hostname函数区
hostna1(){
	echo 当前主机名称为：
	grep HOSTNAME /etc/sysconfig/network|cut -d= -f2
}
hostna2(){
	echo "输入新的主机名"
	read -p ":" hostname
	echo "正在更改主机名"
	sed -i '/^HOSTNAME=/s/=.*/='$hostname'/' /etc/sysconfig/network
	echo "操作执行完毕"
}

#菜单区

	echo "开始执行主机名设置功能"
	hostna1								#状态检测
	while true
	do
		echo "输入操作选项序号（更改-1/跳过-2）"
		read -p ":" zt0
		if [ $zt0 -eq 1 ];then			#更改主机名
			hostna2
			break
		elif [ $zt0 -eq 2 ];then		#跳过选项
			echo "正在跳过此项设置功能"
			break
		else
			echo "输入有误，请重试"
			continue
		fi
	done
	hostna1								#状态检测


