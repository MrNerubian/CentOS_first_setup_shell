#!/bin/bash
#交互式设置防火墙

#函数区
iptab_status(){    #防火墙状态检测函数
	echo '正在检测当前防火墙状态'
	service iptables status &>/dev/null
	aa1=$(echo $?)
	if [ $aa1 -eq 3 ];then
		echo "当前防火墙状态为：【 关闭 】"
	elif [ $aa1 -eq 0 ] ;then
		echo "当前防火墙状态为：【 开启 】"
	fi
}
iptab_stop(){		#关闭防火墙
	service iptables stop &> /dev/null
}
iptab_start(){		#开启防火墙
	service iptables start &> /dev/null
}
iptab_status2(){	#检测启动项状态
	echo '当前防火墙启动项状态：'
	chkconfig --list|grep iptables
}
iptab_off(){		#关闭自启动
	echo "正在关闭防火墙开机启动项"
	chkconfig iptables off &> /dev/null
	echo "操作执行完毕"
}
iptab_on(){			#开启自启动
	echo "正在开启防火墙开机启动项"
	chkconfig iptables on &> /dev/null
	echo "操作执行完毕"
}

#防火墙设置区域
	echo "开始执行防火墙设置功能"
	iptab_status                        #防火墙状态检测
 	while true
	do
		echo "输入操作选项序号（开启-1/关闭-2/跳过-3）"
		read -p ":" zt1
		if [ $zt1 -eq 1 ];then			#开启防火墙
			echo "正在开启防火墙"
			iptab_start
			iptab_status
			echo "操作执行完毕"
			break
		elif [ $zt1 -eq 2 ];then
			echo "正在关闭防火墙"		#关闭防火墙
			iptab_stop
			iptab_status
			echo "操作执行完毕"
			break
		elif [ $zt1 -eq 3 ];then		#跳过此项
			echo "正在跳过此项设置功能"
			break
		else							#错误提示
			echo "输入有误，请重试"
			continue
		fi
	done
	iptab_status                        #防火墙状态检测
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
sleep 2s		

#chkconfig iptables off
	iptab_status2						#防火墙开机启动项状态检测
	while true
	do
		echo "输入操作选项（开启-1/关闭-2/跳过-3）"
		read -p ":" zt2
		if [ $zt2 -eq 1 ];then			#开启自启动
			iptab_on
			break
		elif [ $zt2 -eq 2 ];then		#关闭自启动
			iptab_off
			break
		elif [ $zt2 -eq 3 ];then		#跳过此项
			echo "正在跳过此项设置功能"
			break
		else
			echo "输入有误，请重试"		#错误提示
			continue
		fi
	done
	iptab_status2						#防火墙开机启动项状态检测
