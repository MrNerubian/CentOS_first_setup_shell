#!/bin/bash

#启动公告区

echo ""
echo '||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||'
echo '||            欢迎使用el6_first_setup_shell脚本             ||'
echo '||                  当前版本：v1.1正式版                    ||'
echo '||              By:MrNerubian Time：2019-04-21              ||'
echo '||               Email:mrjiangyj@outlook.com                ||'
echo '||功能说明：提供交互式修改selinux,iptables,network,hostname ||'
echo '||                    和repoyum源功能                       ||'
echo '||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||'
echo ""

#By:奈幽写于2019-04-19
#By:MrNerubian Time：2019-04-19
#############################################################

#通用变量定义区

backdir=~/back_first/$(date "+%F_%T")

#函数区

#SELINUX 函数区

se_back(){
mkdir -p $backdir/selinux
cp -f /etc/selinux/config $backdir/selinux &>/dev/null
}
se_status(){		#状态检测
	#sest=$(cat /etc/selinux/config |grep ^SELINUX=|cut -d= -f2)
	sest=$(awk -F"=" '$0~"^SELINUX="{print $2}' /etc/selinux/config)
	if [ $sest = enforcing ];then
		echo 当前状态为：【强制模式】
	elif [ $sest = permissive ];then 
		echo 当前状态为：【警告模式】
	elif [ $sest = disabled ];then
		echo 当前状态为：【关闭模式】
	else
		echo 当前状态设置错误，配置关键词为：$sest
		echo 正确关键词为：enforcing、permissive、disabled
		echo 务必通过本模块设置功能修正此错误，防止出现未知错误
	fi 
}
se_enforcing(){		#启动selinux强制模式
	echo "正在切换至强制模式"
	sed -i '/^SELINUX=/s/=.*/=enforcing/' /etc/selinux/config
	echo "操作执行完毕"
}
se_permissive(){	#启动selinux警告模式
	echo "正在切换至警告模式"
	sed -i '/^SELINUX=/s/=.*/=permissive/' /etc/selinux/config
	echo "操作执行完毕"
}
se_disabled(){		#启动selinux关闭模式
	echo "正在切换至关闭模式"
	sed -i '/^SELINUX=/s/=.*/=disabled/' /etc/selinux/config
	echo "操作执行完毕"
}

#yum 函数区
yumst1(){			#yum状态检测
	echo "开始检测当前状态"
	st41=$(ls /etc/yum.repos.d/|grep CentOS-|wc -l)
	if [ $st41 -eq 5 ];then
		echo "当前yum源处于【初始状态】"
	else
		echo "当前yum源处于【已更改状态】"
	fi
}
rm_centyum(){		#清空yum及备份配置前yum
echo "开始备份现有所有yum源文件"
mkdir -p $backdir/yum
cp -f /etc/yum.repos.d/* $backdir/yum &>/dev/null
echo "开始删除现有所有yum源文件"
rm -f /etc/yum.repos.d/*
echo "清理yum源缓存"
yum clean all &>/dev/null
echo "操作执行完毕"
}
yum_local(){		#本地yum源
while true
do
srst=$(lsblk|grep sr0|tr -s " "|cut -d' ' -f4)
if [ $srst = 1024M ];then
	echo "本地光盘映像未连接，无法完成操作"
	break
fi

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
break
done
}
yum_aliyun(){		#阿里源
ping -c 3 119.29.29.29  &> /dev/null
if [ $? -eq 0 ];then
cat > /etc/yum.repos.d/aliyun.repo <<EOF
[aliyun]
name=aliyun network yum
baseurl=http://mirrors.aliyun.com/centos/6/os/x86_64/
enabled=1
gpgcheck=1
gpgkey=http://mirrors.aliyun.com/centos/6/os/x86_64/RPM-GPG-KEY-CentOS-6
EOF
	echo "正在刷新yum源，校验时间较长请稍等"
	yum clean all &>/dev/null
	yum makecache &>/dev/null
	echo "操作执行完毕"
else
	echo "网络故障，请检查网络连接"
	echo "操作未执行"
fi

}
yum_163(){			#网易源
ping -c 3 119.29.29.29  &> /dev/null
if [ $? -eq 0 ];then
cat > /etc/yum.repos.d/163.repo <<EOF
[163]
name=163 network yum
baseurl=http://mirrors.163.com/centos/6/os/x86_64/
enabled=1
gpgcheck=1
gpgkey=http://mirrors.163.com/centos/6/os/x86_64/RPM-GPG-KEY-CentOS-6
EOF
	echo "正在刷新yum源，校验时间较长请稍等"
	yum clean all &>/dev/null
	yum makecache &>/dev/null
	echo "操作执行完毕"
else
	echo "网络故障，请检查网络连接"
	echo "操作未执行"
fi
}

#network 函数区
eth_back(){
mkdir -p $backdir/eth
cp -f /etc/sysconfig/network-scripts/ifcfg-eth0 $backdir/eth &>/dev/null
cp -f /etc/sysconfig/network-scripts/ifcfg-eth1 $backdir/eth &>/dev/null
}
eth0(){				#$eth0配置
echo "输入网卡"$eth0"新的ip地址"
read -p "：" ip1
ip11=$(echo $ip1|sed -r 's/(.*)\.(.*)\.(.*)\.(.*)/\1.\2.\3./')
cat > /etc/sysconfig/network-scripts/ifcfg-eth0 <<EOF
DEVICE=eth0
TYPE=Ethernet
ONBOOT=yes
BOOTPROTO=static
IPADDR=${ip1}
NETMASK=255.255.255.0
GATEWAY=${ip11}2
DNS1=119.29.29.29
EOF

echo "当前【"$eth0"】IP为【"$(grep IPADDR /etc/sysconfig/network-scripts/ifcfg-"$eth0"|cut -d= -f2)"】"
}
eth1(){				#$eth1配置
echo "输入网卡"$eth1"新的ip地址" 
read -p ": " ip2
ip22=$(echo $ip2|sed -r 's/(.*)\.(.*)\.(.*)\.(.*)/\1.\2.\3./')
cat > /etc/sysconfig/network-scripts/ifcfg-eth1 <<EOF
DEVICE=eth0
TYPE=Ethernet
ONBOOT=yes
BOOTPROTO=static
IPADDR=${ip2}
NETMASK=255.255.255.0
GATEWAY=${ip22}2
DNS1=119.29.29.29
EOF

echo "当前【"$eth1"】IP为【"$(grep IPADDR /etc/sysconfig/network-scripts/ifcfg-"$eth1"|cut -d= -f2)"】"
}
eth_rest(){
while true
do
echo "是否重启网络(重启-1/跳过-2)" 
read -p ":" ne1
if [ $ne1 -eq 1 ];then
	echo "正在重启网络"
	rm -f /etc/udev/rules.d/70-persistent-net.rules &>/dev/null
	sevice network restart &>/dev/null
	break
elif [ $ne1 -eq 2 ];then
	echo "正在结束此项设置功能"
	break
else
	echo "输入有误，请重试"
	continue
fi
done
}

#iptables函数区
iptab_status(){		#防火墙状态检测
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

#hostname函数区
hostname_back(){
mkdir -p $backdir/hostname
cp -f /etc/sysconfig/network $backdir/hostname &>/dev/null
}
hostna1(){			#当前主机名检测
	echo 当前主机名称为：
	grep HOSTNAME /etc/sysconfig/network|cut -d= -f2
}
hostna2(){			#更改主机名
	echo "输入新的主机名"
	read -p ":" hostname
	echo "正在更改主机名"
	sed -i '/^HOSTNAME=/s/=.*/='$hostname'/' /etc/sysconfig/network
	echo "操作执行完毕"
}

#hosts 函数区
hosts_back(){
mkdir -p $backdir/hosts
cp -f /etc/hosts $backdir/hosts &>/dev/null
}
hosts(){
echo "开始绑定主机名与ip"
echo $ip1 $hostname >> /etc/hosts
echo $ip2 $hostname >> /etc/hosts
echo "程序执行完毕"
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
sleep 2s
}

 
########################################################################

#function module
module_repo(){
echo "开始执行YUM源设置功能"
	yumst1								#状态检测
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
echo "当前模块执行完毕"
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
sleep 2s
}

module_selinux(){
echo "开始执行selinux设置功能"
	se_status							#状态检测
	se_back
while true
do
	echo "输入操作选项序号（强制模式-1/警告模式-2/关闭模式-3/结束程序-4）"
	read -p ":" se1
	if [ $se1 -eq 1 ];then			#强制模式
		se_enforcing
		break
	elif [ $se1 -eq 2 ];then		#警告模式
		se_permissive
		break
	elif [ $se1 -eq 3 ];then		#结束程序
		se_disabled
		break
	elif [ $se1 -eq 4 ];then
		echo "正在结束程序此项设置功能"
		break
	else
		echo "输入有误，请重试"
		continue
	fi
done
se_status							#状态检测
echo "当前模块执行完毕"
echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
sleep 2s
}

module_network(){
echo "开始执行网络设置功能"
echo "检测机制尚处于完善中，请在设置前收集相关网络信息"
echo "需要收集的信息：当前系统所处网段，一个未被占用的ip地址"
echo "如果本脚本提供的功能不足以满足要求，请使用【setup】工具"
eth0=$(ip a|grep ^2:|cut -c4-7)
eth1=$(ip a|grep ^3:|cut -c4-7)
eth_back
while true
do
	echo "输入操作选项序号（设置"$eth0"-1/设置"$eth1"-2/结束程序-3）"
	read -p ":" net1
	if [ $net1 -eq 1 ];then			#更改[$eth0]ip
		eth0
	elif [ $net1 -eq 2 ];then		#更改[$eth1]ip
		eth1
	elif [ $net1 -eq 3 ];then		#结束程序
		echo "正在结束此项设置功能"
		break
	else
		echo "输入有误，请重试"
		continue
	fi
done
eth_rest
echo "当前模块执行完毕"
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
sleep 2s
}

module_iptables(){
echo "开始执行防火墙设置功能"
iptab_status                        #防火墙状态检测
while true
do
	echo "输入操作选项序号（开启-1/关闭-2/结束程序-3）"
	read -p ":" zt1
	if [ $zt1 -eq 1 ];then			#开启防火墙
		echo "正在开启防火墙"
		iptab_start
		iptab_status
		echo "操作执行完毕"
	elif [ $zt1 -eq 2 ];then
		echo "正在关闭防火墙"		#关闭防火墙
		iptab_stop
		iptab_status
		echo "操作执行完毕"
	elif [ $zt1 -eq 3 ];then		#结束程序
		echo "正在结束程序此项设置功能"
		break
	else							#错误提示
		echo "输入有误，请重试"
		continue
	fi
done
iptab_status                        #防火墙状态检测
echo "当前模块执行完毕"
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
sleep 2s
}

module_chk_iptables(){
echo "开始执行防火墙开机启动项设置功能"
iptab_status2						#防火墙开机启动项状态检测
while true
do
	echo "输入操作选项（开启-1/关闭-2/结束程序-3）"
	read -p ":" zt2
	if [ $zt2 -eq 1 ];then			#开启自启动
		iptab_on
		break
	elif [ $zt2 -eq 2 ];then		#关闭自启动
	iptab_off
		break
	elif [ $zt2 -eq 3 ];then		#结束程序
		echo "正在结束程序此项设置功能"
		break
	else
		echo "输入有误，请重试"		#错误提示
		continue
	fi
done
iptab_status2						#防火墙开机启动项状态检测
echo "当前模块执行完毕"
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
sleep 2s
}

module_hostname(){
echo "开始执行主机名设置功能"
hostna1								#状态检测
hostname_back
while true
do
	echo "输入操作选项序号（更改-1/结束程序-2）"
	read -p ":" zt0
	if [ $zt0 -eq 1 ];then			#更改主机名
		hostna2
		break
	elif [ $zt0 -eq 2 ];then		#结束程序
		echo "正在结束程序此项设置功能"
		break
	else
		echo "输入有误，请重试"
		continue
	fi
done
hostna1								#状态检测
echo "当前模块执行完毕"
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
sleep 2s
}

module_hosts(){
while true
do
echo "是否绑定ip和主机名（确定-1/跳过-2）"
read -p ":" ho
if [ $ho -eq 1 ];then
	echo "正在绑定"
	hosts_back
    hosts
	break
elif [ $ho -eq 2 ];then
	echo "正在结束此项设置功能"
	break
else
	echo "输入有误，请重试"
	continue
fi
echo "当前模块执行完毕"
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
sleep 2s
done
}

module_shutdown(){
while true
do
echo "开始执行重启或关闭计算机功能"
echo "是否重启或关闭计算机（重启-1/关机-2/跳过-3）"
read -p ":" shdn
if [ $shdn -eq 1 ];then
	echo "正在重启系统"
	shutdown -r now
	break
elif [ $shdn -eq 2 ];then
	echo "正在关闭系统"
	shutdown -h now
	break
elif [ $shdn -eq 3 ];then
	echo "正在结束此项设置功能"
	break
else
	echo "输入有误，请重试"
	continue
fi
done
echo "当前模块执行完毕"
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
sleep 2s
}

module_backdirctory(){
while true
do
echo "开始执行自定义备份目录功能"
echo "当前备份路径为$backdir"
echo "是否自定义备份目录路径（自定义-1/跳过-2）"
read -p ":" shdn
if [ $shdn -eq 1 ];then
	echo "输入自定义备份路径(推荐使用绝对路径)"
	read -p ":" backdir
	echo "自定义备份路径为：$backdir"
	break
elif [ $shdn -eq 2 ];then
	echo "正在结束此项设置功能"
	break
else
	echo "输入有误，请重试"
	continue
fi
done
echo "当前备份路径为$backdir"
echo "当前模块执行完毕"
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
sleep 2s
}

#执行区域
while true
do

module_backdirctory

module_hostname

module_network

module_hosts

module_iptables

module_chk_iptables

module_selinux

module_repo

module_shutdown

echo "程序执行完毕,感谢您的使用，再见！"
exit 0
done


