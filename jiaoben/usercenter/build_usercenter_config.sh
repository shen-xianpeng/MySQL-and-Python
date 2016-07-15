#!/bin/bash
#Date  2016-7-14
#By  WYB
#Desc Processing configuration file

sour_dir="/opt/webapp/base_architect/user_center/src"
sour_conf="usercenter_dev.cfg"
sour_temp="templates"
des_dir="/home/scripts/usercenter"
des_conf="usercenter_production.cfg"
des_temp="templates"
des_tar="conf.tar.gz"

echo -e "\033[32m Begin to processing configuration file \033[0m"
if [ -d ${des_dir} ]
then
    cd ${des_dir}
    if [ -f ${des_conf} ]
    then
        rm  -f  ${des_conf}
    else
        echo -e "\033[31mNo such file\033[0m"
    fi
    cp  -a  ${sour_dir}/${sour_conf}  ${des_dir}/${des_conf}

    if [ -d ${des_temp} ]
    then
        rm  -rf ${des_temp}
    else
        echo -e "\033[31mNo such directory\033[0m"
    fi
    cp  -a  ${sour_dir}/${sour_temp}    ${des_dir}
 
    if [ -e ${des_tar} ]
    then
        rm -f ${des_tar}
    else
        echo -e "\033[31mNo such tar package\033[0m"
    fi
    tar czvf  ${des_tar}   ./${des_temp} ${des_conf}
else
    echo -e "\033[31mThis is not the target directory.\033[0m"
fi
echo -e "\033[32mProcessing configuration file is completed \033[0m"

