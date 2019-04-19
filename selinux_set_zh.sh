#!/bin/bash
#交互式设置selinux

#函数区
se_status(){			#状态检测
	sest=$(cat /etc/selinux/config |grep ^SELINUX=|cut -d= -f2)
	if [ $sest = enforcing ];then
		echo 当前状态为：【强制模式】
	elif [ $sest = permissive ];then
		echo 当前状态为：【警告模式】
	elif [ $sest = disabled ];then
		echo 当前状态为：【关闭模式】
	fi 
}


se_enforcing(){			#启动selinux强制模式
	echo "正在切换至强制模式"
	sed -i '/^SELINUX=/s/=.*/=enforcing/' /etc/selinux/config
	echo "操作执行完毕"
}
se_permissive(){		#启动selinux警告模式
	echo "正在切换至警告模式"
	sed -i '/^SELINUX=/s/=.*/=permissive/' /etc/selinux/config
	echo "操作执行完毕"
}
se_disabled(){			#启动selinux关闭模式
	echo "正在切换至关闭模式"
	sed -i '/^SELINUX=/s/=.*/=disabled/' /etc/selinux/config
	echo "操作执行完毕"
}


	echo "开始执行selinux设置功能"
	se_status							#状态检测
	while true
	do
		echo "输入操作选项序号（强制模式-1/警告模式-2/关闭模式-3/跳过-4）"
		read -p ":" se1
		if [ $se1 -eq 1 ];then
			se_enforcing				#强制模式
			break
		elif [ $se1 -eq 2 ];then
			se_permissive				#警告模式
			break
		elif [ $se1 -eq 3 ];then
			se_disabled					#关闭模式
			break
		elif [ $se1 -eq 4 ];then
			echo "正在跳过此项设置功能"
			break
		else
			echo "输入有误，请重试"
			continue
		fi
	done
	se_status							#状态检测
	echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	sleep 2s

