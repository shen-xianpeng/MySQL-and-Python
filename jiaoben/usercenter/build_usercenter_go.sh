#!/bin/bash 
#Date 2016-7-14
#By:wyb
#Desc:build go code
version=$1
product_name="user_center"
product_dir="/home/scripts/usercenter/"  
code_name="main.go"
code_dir="/opt/webapp/base_architect/user_center/src/"
vendor_dir="/opt/webapp/base_architect/user_center/src/usercenter/"
echo -e "\033[32mStart producing go build a binary file\033[0m"
if [  -d ${vendor_dir} ]
then
    cd   ${vendor_dir}
    git  checkout $version
    if [ $? -eq 0 ]
    then
        echo -e "\033[32mCheckout  $verison  success\033[0m"
    else
        echo -e "\033[31mCheckout  $version  failed\033[0m"
        exit 1
    fi
    govendor fetch   -v +e
    govendor fetch   -v +m
    govendor remove     +u
    govendor update     +v
    git      stash
    govendor sync
    if [ $? -eq 0 ]
    then
        echo -e "\033[32mGovendor sync success!\033[0m"
    else
        echo -e "\033[31mGovendor sync failed!\033[0m"
        exit 1
    fi 
    if [ -d $code_dir ]
    then
        cd  ${code_dir}
        go build -o   ${product_dir}${product_name}  ${vendor_dir}/${code_name} 
        if [ $? -eq 0 ]
        then 
            echo -e "\033[32mGo build ${code_name} success\033[0m"
        else
            echo -e "\033[31mGo build ${code_name} failed\033[0m"
            exit 1
        fi
    else
         echo -e "\033[31mNo such directory\033[0m"
         exit 1
    fi 
else
    echo -e "\033[31mNo such directory\033[0m"
    exit 1
fi
echo -e "\033[32mStart producing go build a binary file end\033[0m"
