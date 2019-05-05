echo "欢迎使el7_network设置脚本"
echo "请按照提示进行操作"

#network 函数区
ens_back(){
mkdir -p $backdir/eth
cp -f /etc/sysconfig/network-scripts/ifcfg-ens* $backdir/eth &>/dev/null
}
ens33set(){				#$ens33配置
echo "输入网卡"$ens01"新的ip地址"
read -p "：" ip1
ip11=$(echo $ip1|sed -r 's/(.*)\.(.*)\.(.*)\.(.*)/\1.\2.\3./')
cat > /etc/sysconfig/network-scripts/ifcfg-ens33 <<EOF
DEVICE=ens33
TYPE=Ethernet
ONBOOT=yes
BOOTPROTO=static
IPADDR=${ip1}
NETMASK=255.255.255.0
GATEWAY=${ip11}2
DNS1=119.29.29.29
EOF

echo "当前【"$ens01"】IP为【"$(grep IPADDR /etc/sysconfig/network-scripts/ifcfg-"$ens01"|cut -d= -f2)"】"
}
ens34set(){				#$ens34配置
echo "输入网卡"$ens02"新的ip地址"
read -p "：" ip2
ip22=$(echo $ip2|sed -r 's/(.*)\.(.*)\.(.*)\.(.*)/\1.\2.\3./')
cat > /etc/sysconfig/network-scripts/ifcfg-ens34 <<EOF
DEVICE=eth0
TYPE=Ethernet
ONBOOT=yes
BOOTPROTO=static
IPADDR=${ip2}
NETMASK=255.255.255.0
GATEWAY=${ip22}2
DNS1=119.29.29.29
EOF

echo "当前【"$ens02"】IP为【"$(grep IPADDR /etc/sysconfig/network-scripts/ifcfg-"$ens02"|cut -d= -f2)"】"
}
ens_rest(){
while true
do
echo "是否重启网络(重启-1/跳过-2)" 
read -p ":" ne1
if [ $ne1 -eq 1 ];then
	echo "正在重启网络"
	rm -f /etc/udev/rules.d/70-persistent-net.rules &>/dev/null
	systemctl restart network.service &>/dev/null
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
ensstatus(){
echo "检测机制尚处于完善中，请在设置前收集相关网络信息"
echo "需要收集的信息：当前系统所处网段，一个未被占用的ip地址"
echo "本脚本已屏蔽virbr虚拟网卡，最大支持2张物理网卡"
echo "如果本脚本提供的功能不足以满足要求，请使用【setup】工具"
ens01=$(ip a|grep -v virbr |grep ^2:|awk -F"[ :]+" '{print $2}')
ens02=$(ip a|grep -v virbr |grep ^3:|awk -F"[ :]+" '{print $2}')
}


#模块
module_network(){				#网络设置模块
echo "开始执行网络设置功能"
ensstatus
ens_back
while true
do
	echo "输入操作选项序号（设置"$ens01"-1/设置"$ens02"-2/结束程序-3）"
	read -p ":" net1
	if [ $net1 -eq 1 ];then			#更改[$ens33]ip
		ens33set
	elif [ $net1 -eq 2 ];then		#更改[$ens34]ip
		ens34set
	elif [ $net1 -eq 3 ];then		#结束程序
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

module_netrestart(){			#网络重启模块
echo "开始执行网络重启功能"
echo -e  "\033[43;1;31m警告：重启网络会导致服务断开，可能会导致连接不上的问题出现，请谨慎操作\033[0m"
ens_rest
echo "当前模块执行完毕"
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
sleep 2s
}

#执行区
module_network
module_netrestart