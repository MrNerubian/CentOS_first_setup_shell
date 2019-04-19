#!/bin/bash

eth0(){
read -p "输入网卡"$eth0"新的ip地址" ip1
ip11=$(echo $ip1|sed -r 's/(.*)\.(.*)\.(.*)\.(.*)/\1.\2.\3./')
cat > /etc/sysconfig/network-scripts/ifcfg-eth0 <<EOF
DEVICE=eth0
TYPE=Ethernet
ONBOOT=yes
BOOTPROTO=static
IPADDR=${ip1}
NETMASK=255.255.255.0
GATEWAY=${ip11}2
EOF

echo "当前【"$eth0"】IP为【"$(grep IPADDR /etc/sysconfig/network-scripts/ifcfg-"$eth0"|cut -d= -f2)"】"
}
eth1(){
read -p "输入网卡"$eth1"新的ip地址" ip2
ip22=$(echo $ip2|sed -r 's/(.*)\.(.*)\.(.*)\.(.*)/\1.\2.\3./')
cat > /etc/sysconfig/network-scripts/ifcfg-eth1 <<EOF
DEVICE=eth0
TYPE=Ethernet
ONBOOT=yes
BOOTPROTO=static
IPADDR=${ip2}
NETMASK=255.255.255.0
GATEWAY=${ip22}2
EOF

echo "当前【"$eth1"】IP为【"$(grep IPADDR /etc/sysconfig/network-scripts/ifcfg-"$eth1"|cut -d= -f2)"】"
}

#菜单区
echo "开始执行网络设置功能"
echo "检测机制尚处于完善中，请在设置前收集相关网络信息"
echo "需要收集的信息：当前系统所处网段，一个未被占用的ip地址"
echo "如果本脚本提供的功能不足以满足要求，请使用【setup】工具"
eth0=$(ip a|grep ^2:|cut -c4-7)
eth1=$(ip a|grep ^3:|cut -c4-7)
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
echo "正在重启网络"
rm -f /etc/udev/rules.d/70-persistent-net.rules &>/dev/null
sevice network restart &>/dev/null
echo "程序执行完毕"
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
sleep 2s

