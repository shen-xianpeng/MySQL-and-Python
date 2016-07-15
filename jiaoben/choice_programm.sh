#!/bin/bash
#Date:2016-7-14
#By:wyb
#Desc:choice your programm
version=$2
if [ "$1" == "usercenter" ]  
then
    python /home/scripts/usercenter/deploy_usercenter.py $version
     
elif [ "$1" == "news_center" ]
then
    python /home/scripts/news_center/deploy_news_center.py

elif [ "$1" == "spotcenter" ]
then
    python /home/scripts/spotcenter/deploy_spotcenter.py

else
    echo "The project you are deploying does not exist"
    echo -e "\033[31mUsage: sh $0 your_programm_name your_programm_version\033[0m"
fi 

