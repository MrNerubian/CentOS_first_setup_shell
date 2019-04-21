|| 欢迎使用el6_first_setup脚本

|| 作者：奈幽/MrNerubian

|| 时间：2019年4月19日

|| 电子邮件：mrjiangyj@outlook.com

|| 功能说明：提供交互式修改selinux，iptables，网络，主机名和repoyum源功能,并提供了调试时上传的单独的功能脚本

# el6_first_setup

## 发布日志

v1.1版本

发布时间：2019年4月21日

1.发布说明

1. 更新了备份功能
   - 添加了目录自定义功能
   - 改善了默认备份目录路径，现在会以 ~/back_first/2019-04-21_15:21:25/*的方式存储，防止多次操作备份文件覆盖，导致原始备份消失的问题
   - 有考虑过增加备份跳过功能，但是在详细思考过后，还是没有添加，原因是需要备份的文件非常小，并不会占用多大空间，对于恢复重要配置来说，我认为这点空间是值得牺牲的。

2. 添加了设置完成时的系统操作选项，包括重启，关机，和跳过功能

3. README.md完善
   - 在此完善一下脚本内区域说明，以方便用户自定义部分功能的效率
     1. 第一部分为启动公告区，此区域是启动欢迎语，修改不会对程序执行造成影响
     2. 第二部分为通用变量定义区，定义一些通用与整个脚本的不常变换变量，例如，备份路径变量
     3. 第三部分为函数区，这部分是程序运行的根基，绝大部分的功能都是在函数区实现的，如果想添加功能，只需要在函数区添加相应的函数块，并在运行模块区域调用即可
     4. 第四部分为功能模块区。此区域使用while死循环嵌套+循环控制语句来实现了严谨的交互菜单功能，减少bug产生几率。通过调用函数区的函数，实现了简单易改的菜单功能
     5. 第五部分就是执行区了，通过调用不同的功能模块顺序来达到控制功能添加的目的，方便修改。

### v1.0版本

发布时间：2019年4月19日

#### 1.说明

针对centos6.9系统，交互式进行第一次系统配置，并备份原始配置，并提供了调试时上传的单独的功能脚本
Interactively perform the first system configuration and back up the original configuration for the centos6.9 system.And provides a separate function script that is uploaded during debugging.

#### 2.功能包括：

关闭防火墙，关闭selinux，配置IP地址，主机名等，操作使用交互式方式来实现，并加入检测功能和自动备份，防止误操作造成不可逆后果
Features include:
Turn off the firewall, turn off selinux, configure the IP address, host name, etc. The operation is implemented in an interactive manner, and the detection function and automatic backup are added to prevent irreversible consequences caused by misoperation.

#### 3.目录说明

备份目录：~/back_first/

Directory description
Backup directory：~/back_first/
