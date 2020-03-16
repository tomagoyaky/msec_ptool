#!/bin/sh
# author: tomagoyaky
# date: 2020-03-10
base_path=$(cd `dirname $0`; pwd)
ssh_host["1"]="zhaopeng@jumpserver.chj.cloud -p50122"
ssh_host["2"]="root@192.168.85.44 -p22"

log(){
    echo "[msec_ptool] $1"
}

usage(){
    log "usage: ./`basename $0` start|stop process name"
    log "  1)./msec_ptool.sh create shell demo          #创建基本的shell脚本 [demo.sh]"
    log "  2)./msec_ptool.sh create ubuntu_x64          #创建指定的系统镜像,支持ubuntu_x64|centos_x64|linux_arm64|linux_arm32,默认创建ubuntu_x64"
    log "  1)./msec_ptool.sh create lkm demo_x64        #创建内核模块 [demo_x64]"
    log "  3)./msec_ptool.sh build demo_x64 ubuntu_x64  #编译项目工程'kmsec'"
    log "  4)./msec_ptool.sh list                       #列出当前目录下所有的makefile项目工程"
    log "  5)./msec_ptool.sh ssh [nopassword]           #ssh快捷登录，当nopassword被配置时,自动跳到免密登录设置)"
    log "  6)./msec_ptool.sh distory                    #删除该运行目录下所有的文件"
    log "  -)./msec_ptool.sh lkm list                   #罗列当前运行目录下的内核驱动项目"
    log "  -)./msec_ptool.sh lkm build                  #在源码机器上编译内核驱动项目"
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
                lkm) log "[param_parse] create->$ACTION"
                    create_lkm $ACTION $EXTRA
                ;;
                *)usage
                ;;
            esac
        }
        ;;
        build|b){
            EXTRA1=$2
            EXTRA2=$3
            if [[ ! -n "$EXTRA1" ]];then
                list_makefile_project
            else
                build_makefile_project $EXTRA1 $EXTRA2
            fi
        }
        ;;
        list|l){
            list_makefile_project
            log "\n"
            list_docker_container
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
    modelName=
    echo "============================================================="
    printf "%-20s %s %-s\n" "Project Name" "|" "Model Name" 
    echo "-------------------------------------------------------------"
    cd ${base_path}/lkm_projects
    for dir in ./*
    do 
        log ">>> $dir"
        # if [ -d $dir ];then
        #     count=0
        #     for file in $dir/*
        #     do
        #         fileName=$(basename $file)
        #         fileNameNoExtra=${fileName%%.*}
        #         if [ "${fileNameNoExtra}" == "Makefile" ];then
        #             let count+=1;
        #         fi
        #         if [ "${fileNameNoExtra}" == "Kbuild" ];then
        #             let count+=1;
        #         fi
        #         if [ "${fileNameNoExtra}" == "MODEL" ];then
        #             modelName=$(cat ${file})
        #             let count+=1;
        #         fi
        #     done

        #     if [ ${count} == 3 ];then
        #         printf "%-20s %s %-s\n" $(basename $dir)  "|"  ${modelName} 
        #     fi
        # fi
    done
    cd ${base_path}
}
list_docker_container(){
    echo "============================================================="
    printf "%-20s %s %-s\n" "Project Name" "|" "Docker Name" 
    echo "-------------------------------------------------------------"
    docker ps -a
}
build_makefile_project(){
    PROJECT_NAME=$1
    DOCKER_HOST_NAME=$2

    cd ${base_path}/lkm_projects
    # build demo_x64 ubuntu_x64
    log "[build_makefile_project] build makefile project '$PROJECT_NAME' '$DOCKER_HOST_NAME'"

    if [[ -n "$DOCKER_HOST_NAME" ]];then
        log "docker容器中编译..."
        log "-=>>> ${base_path}"
        cd ${base_path}/lkm_projects/${PROJECT_NAME}

        CONTAINER_ID=`docker ps -a | grep "${DOCKER_HOST_NAME}" | awk '{ print $1 }'`
        echo "[build_makefile_project]正在像容器'$CONTAINER_ID'同步源码..."
        #cp -r ${base_path}/lkm_projects/${PROJECT_NAME} ${base_path}/docker-local/${PROJECT_NAME} && \
        docker exec -it ${CONTAINER_ID} /bin/sh -c "ls -la /var/docker-local/${PROJECT_NAME}"

        ANDROID_BUILD_TOP=/var/docker-local/
        KERNEL_CROSS_COMPILE=gcc
        docker exec -it ${CONTAINER_ID} /bin/sh -c "/var/docker-local/${PROJECT_NAME}/build.sh"
    else
        log "本地环境下编译..."
        cd ${base_path}/lkm_projects/${PROJECT_NAME}
        ./build.sh
    fi
    cd ${base_path}
}

create_shell(){
    log "[create_shell] create shell '$1' file ..."
}

create_os(){
    OS_NAME=$1
    OS=$1
    OS_TYPE=$1
    eabi="x64"
    osType="ubuntu"
    
    if [[ "${OS}" == *"x64" ]];then
        eabi="x64"
    elif [[ "${OS}" == *"x86" ]];then
        eabi="x86"
    elif [[ "${OS}" == *"arm64" ]];then
        eabi="arm64"
    else
        echo "not support ${OS}"
    fi

    if [[ "${OS_TYPE}" == *"ubuntu" ]];then
        osType="ubuntu"
    elif [[ "${OS_TYPE}" == *"centos" ]];then
        osType="centos"
    else
        osType "not support ${OS_TYPE}"
    fi

    log "[create_os] docker build msec_$osType.${eabi} docker-image..."
    docker ps -a | grep "/bin/sh" | awk '{ print $1 }' | xargs docker container rm -f 
    docker image list | grep none | awk '{print $3}' | xargs docker image rm

    mkdir ${base_path}/docker-local
    docker build -t "${OS_NAME}" -f pwn.${osType}.${eabi}.Dockerfile .
    docker run -d "${OS_NAME}" -v ${base_path}/docker-local:/var/docker-local /bin/sh
    docker ps -a

    CONTAINER_ID=`docker ps -a | grep "${OS_NAME}" | awk '{ print $1 }'`
    IMAGE_ID=`docker ps -a | grep "${OS_NAME}" | awk '{ print $2 }'`
    log ">>> OS_NAME=${OS_NAME}, IMAGE_ID=${IMAGE_ID}, CONTAINER_ID=${CONTAINER_ID}"
    docker exec -it ${CONTAINER_ID} /bin/sh -c "ls -la ."
    #docker exec -it ${CONTAINER_ID} /bin/sh
}
create_lkm(){
    eabi="x64"
    defualt_model_name="demo_${eabi}"
    if [ -n "$2" ]; then
        defualt_model_name=$2
        log ${defualt_model_name}
    else 
        log ${defualt_model_name}
    fi

    if [[ "${defualt_model_name}" == *"x64" ]];then
        eabi="x64"
    elif [[ "${defualt_model_name}" == *"x64" ]];then
        eabi="x86"
    elif [[ "${defualt_model_name}" == *"x64" ]];then
        eabi="arm64"
    else
        echo "not support ${defualt_model_name}"
    fi

    project_path=${base_path}/lkm_projects/${defualt_model_name}
    log "create => 项目: ${defualt_model_name}"
    mkdir -p ${project_path}

    cp ${base_path}/extra/lkm/${eabi}/hello_world.c ${project_path}
    cp ${base_path}/extra/lkm/${eabi}/build.sh ${project_path}
    cp ${base_path}/extra/lkm/${eabi}/signature.sh ${project_path}
    cp ${base_path}/extra/lkm/${eabi}/Kbuild ${project_path}
    cp ${base_path}/extra/lkm/${eabi}/Makefile ${project_path}
    # 更新文件名
    mv ${project_path}/hello_world.c ${project_path}/${defualt_model_name}.c
    touch ${project_path}/README.MD
    echo ${defualt_model_name} > ${project_path}/MODEL
    # 替换代码
    sed -i "" "s/hello/${defualt_model_name}/g" ${project_path}/${defualt_model_name}.c 
    sed -i "" "s/hello_world/${defualt_model_name}/g" ${project_path}/Makefile
    sed -i "" "s/hello_world/${defualt_model_name}/g" ${project_path}/Kbuild
    echo "----------------------------------------------"
    echo "[OK] project '${defualt_model_name}' create completion"
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