#!/bin/sh
# author: tomagoyaky
# date: 2020-03-10

ssh_host["1"]="zhaopeng@jumpserver.chj.cloud -p50122"
ssh_host["2"]="root@192.168.85.44 -p22"

log(){
    echo "[msec_ptool] $1"
}

usage(){
    log "usage: ./`basename $0` start|stop process name"
    log "  1)./msec_ptool.sh create shell demo   \t#创建基本的shell脚本 [demo.sh]"
    log "  2)./msec_ptool.sh create [ubuntu_x64] \t#创建指定的系统镜像,支持ubuntu_x64|centos_x64|linux_arm64|linux_arm32,默认创建ubuntu_x64"
    log "  3)./msec_ptool.sh build [kmsec]       \t#编译项目工程'kmsec',在kmsec缺省情况下,相当于list功能"
    log "  4)./msec_ptool.sh list                \t#列出当前目录下所有的makefile项目工程"
    log "  5)./msec_ptool.sh ssh [nopassword]    \t#ssh快捷登录，当nopassword被配置时,自动跳到免密登录设置)"
    log "  6)./msec_ptool.sh distory             \t#删除该运行目录下所有的文件"
    log "  -)./msec_ptool.sh lkm list            \t#罗列当前运行目录下的内核驱动项目"
    log "  -)./msec_ptool.sh lkm build           \t#在源码机器上编译内核驱动项目"
}

param_parse(){
    OPT=$1
    case $OPT in
        create|c){
            ACTION=$2
            EXTRA=$3
            case $ACTION in
                shell) log "[param_parse] create->$ACTION"
                    create_shell $EXTRA
                ;;
                ubuntu_x64|centos_x64|linux_arm64|linux_arm32) log "[param_parse] create->$ACTION (support: ubuntu_x64|centos_x64|linux_arm64|linux_arm32)"
                    create_os $ACTION
                ;;
                *)usage
                ;;
            esac
        }
        ;;
        build|b){
            EXTRA=$2
            if [[ ! -n "$EXTRA" ]];then
                list_makefile_project
            else
                build_makefile_project $EXTRA
            fi
        }
        ;;
        list|l){
            list_makefile_project
        }
        ;;
        ssh){
            HOST=$2
            IS_NOPASSWORD=$3
            ssh_jump $HOST $IS_NOPASSWORD
        }
        ;;
        *)usage
        ;;
    esac   
}

list_makefile_project(){
    log "[list_makefile_project] list makefile project ..."
    modelName=
    echo "======================================="
    printf "%-20s %s %-s\n" "Project Name" "|" "Model Name" 
    echo "---------------------------------------"
    for dir in ./*
    do 
        if [ -d $dir ];then
            count=0
            for file in $dir/*
            do
                fileName=$(basename $file)
                fileNameNoExtra=${fileName%%.*}
                if [ "${fileNameNoExtra}" == "Makefile" ];then
                    let count+=1;
                fi
                if [ "${fileNameNoExtra}" == "Kbuild" ];then
                    let count+=1;
                fi
                if [ "${fileNameNoExtra}" == "MODEL" ];then
                    modelName=$(cat ${file})
                    let count+=1;
                fi
            done

            if [ ${count} == 3 ];then
                printf "%-20s %s %-s\n" $(basename $dir)  "|"  ${modelName} 
            fi
        fi
    done
}

build_makefile_project(){
    log "[build_makefile_project] build makefile project '$1'"
}

create_shell(){
    log "[create_shell] create shell '$1' file ..."
}

create_os(){
    log "[create_os] docker build $1 docker-image..."
}
ssh_jump(){
    log "[ssh_jump] ssh jump service host list ..."
    HOST_INDEX=$1 #主机编号
    IS_NOPASSWORD=$2
    HOST_NUMBER=0
    if [[ ! -n "$HOST_INDEX" ]];then
        for key in ${!ssh_host[*]};do
            HOST_NUMBER=$(($HOST_NUMBER+1)) 
            log "($HOST_NUMBER) ${ssh_host[$key]}"
        done
    else
        for key in ${!ssh_host[*]};do
            if [ $key == $HOST_INDEX ];then
                log "login on '${ssh_host[$HOST_INDEX]}'"
                ssh ${ssh_host[$HOST_INDEX]}
            fi
        done
    fi
}
######################################
# main()
######################################
clear
log "#########################################################################################################################################"
log "###"
log "###    【二进制镜像测试环境，用于项目创建和测试的脚本工具】"
log "###"
log "###     > description：通过Docker容器生成各种测试环境，方便快捷的建立工程项目、二进制安全测试"
log "###     > author: tomagoyaky"
log "###     > date: 2020-03-10"
log "###"
for key in ${!ssh_host[*]};do
    HOST_NUMBER=$(($HOST_NUMBER+1)) 
    log "###     > host: $HOST_NUMBER) ${ssh_host[$key]}"
done
log "###"
log "#########################################################################################################################################"
########################################
# usage
if [ $# -eq 0 ]; then
    usage
    exit -1
fi

########################################
# 参数打印
for arg in $@
do
    index=$(($index+1)) 
    log ">> arg_$index=$arg"
done

########################################
# 参数解析
param_parse $@