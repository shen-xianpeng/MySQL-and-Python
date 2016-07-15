#!/bin/bash
#Date
#By
#Desc
echo -e "\033[32mStart producing a new image\033[0m"

docker info >/dev/null 2>&1
if [ $? -eq 0 ]
then
    #ip="172.16.5.117"
    registry_address="172.16.5.117:5000"
    container_name="/smm/usercenter"
    image_tag="v2.0"
    local_registry="/opt/my_registry"
    container_registry="/tmp/registry" 
    registry_name="registry"
    registry_verison="docker.io/registry"
    docker_registry_status=`docker ps | grep  172.16.5.117:5000|wc -l`
    old_images=`docker images | grep 172.16.5.117:5000/smm/usercenter|wc -l`
    WORKSPACE="/home/scripts/usercenter/"
    if [ ${docker_registry_status} -eq 1 ]
    then
        echo -e "\033[32mDocker registry is running\033[0m"
        echo    "                                         "
    else
        docker run -d -p  5000:5000 --name="${registry_name}" -v ${local_registry}:${container_registry}  ${registry_verison}
        if [ $? -eq 0 ]
        then 
            echo -e "\033[32mDocker build registry success!\033[0m"
        else
            echo -e "\033[31mDocker build registry failed!\033[0m"
            exit 1
        fi
    fi    
    
    if [ ${old_images} -eq 1 ]
    then 
        docker rmi  ${registry_address}${container_name}:${image_tag}
        if [ $? -ne 0 ]
        then
            docker rmi  ${registry_address}${container_name}:${image_tag}    
            echo "                     "
        else
            echo "                     "
            echo -e "\033[32mRemove old images successfully\033[0m"
        fi
    else 
        echo -e "\033[32mThe image does not exist, we can continue to the next step\033[0m"
    fi
    echo -e "\033[32mStart build Dockerfile file\033[0m"
    echo    "                                          "
    docker build -t ${registry_address}${container_name}:${image_tag}  $WORKSPACE
    if [ $? -eq 0 ]
    then
        echo "                     "
        echo -e  "\033[32mBuild Dockerfile for images sucess!\033[0m"
        echo "                     "
        echo -e  "\033[32mBegin to push the image to the private registry!\033[0m"
        echo "                     "
        docker push     ${registry_address}${container_name}
        if [ $? -eq 0 ]
        then
            echo -e  "\033[32mPush the image to  private registry success!\033[0m"
            echo "                     "
        else
            echo -e "\033[31mPush the image to  private registry failed!\033[0m"
            exit 1 
        fi
    else 
        echo -e "\033[31mBuild Dockerfile for images failed,please check try again\033[0m"
        exit 1
    fi   
    echo "---------------------------------------------------"
    echo -e "\033[32m[root@localhost ~]# docker images\033[0m"
    echo "                                                   "   
    docker images
    echo "---------------------------------------------------"
    echo -e "\033[32m[root@localhost ~]# docker ps\033[0m"
    echo "                                                   "   
    docker ps 
    echo "---------------------------------------------------"
else  
    echo -e "\033[31mDocker daemon  is not running\033[0m"
    exit 1
fi 
echo -e "\033[32mStart producing a new image end!\033[0m"
