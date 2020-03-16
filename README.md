项目已脱敏，仅供作者自己使用，无编号的usage项，并不通用。

```console
[msec_ptool] #########################################################################################################################################
[msec_ptool] ###
[msec_ptool] ###    【二进制镜像测试环境，用于项目创建和测试的脚本工具】
[msec_ptool] ###
[msec_ptool] ###     > description：通过Docker容器生成各种测试环境，方便快捷的建立工程项目、二进制安全测试
[msec_ptool] ###     > author: tomagoyaky
[msec_ptool] ###     > date: 2020-03-10
[msec_ptool] ###
[msec_ptool] ###     > host: 1) zhaopeng@jumpserver.chj.cloud -p50122
[msec_ptool] ###     > host: 2) root@192.168.85.44 -p22
[msec_ptool] ###
[msec_ptool] #########################################################################################################################################
[msec_ptool] usage: ./msec_ptool.sh start|stop process name
[msec_ptool]   1)./msec_ptool.sh create shell demo      #创建基本的shell脚本 [demo.sh]
[msec_ptool]   2)./msec_ptool.sh create ubuntu_x64      #创建指定的系统镜像,支持ubuntu_x64|centos_x64|linux_arm64|linux_arm32,默认创建ubuntu_x64
[msec_ptool]   3)./msec_ptool.sh build ids              #编译项目工程'ids',在kmsec缺省情况下,相当于list功能
[msec_ptool]   4)./msec_ptool.sh list                   #列出当前目录下所有的makefile项目工程
[msec_ptool]   5)./msec_ptool.sh ssh [nopassword]       #ssh快捷登录，当nopassword被配置时,自动跳到免密登录设置)
[msec_ptool]   6)./msec_ptool.sh distory                #删除该运行目录下所有的文件
[msec_ptool]   -)./msec_ptool.sh lkm list               #罗列当前运行目录下的内核驱动项目
[msec_ptool]   -)./msec_ptool.sh lkm build              #在源码机器上编译内核驱动项目
```


./msec_ptool.sh create ubuntu_x64 && ./msec_ptool.sh create lkm idps_x64 && ./msec_ptool.sh build idps_x64 ubuntu_x64