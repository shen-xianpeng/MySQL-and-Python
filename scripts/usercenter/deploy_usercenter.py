#!/usr/bin/env   python 
#coding:utf-8
#Created on 2016-7-14
#@author: WYB

'''
This script is used to automatically publish programm

'''
import os
import sys
import datetime
import paramiko
import time

def build_go(version):
        ret = os.system('sh /home/scripts/usercenter/build_usercenter_go.sh'+' '+version)
        if ret!=0:
              print "\033[31m%s scripts has a error\033[0m" % ("build_usercenter_go.sh") 
              return False
        return  True
def build_config():
       res = os.system('sh /home/scripts/usercenter/build_usercenter_config.sh')
       if res!=0:
                print "\033[31m%s scripts has a error\033[0m" % ("build_usercenter_config.sh")
                return False
       return True 

def build_images():
        ret = os.system('sh /home/scripts/usercenter/build_usercenter_images.sh')
        print ret
	if ret !=0:
                  print  "\033[31m%s scripts  has a error\033[0m" % ("build_usercenter_images.sh") 
        	  return False
        return True
def build_container():
    host='172.16.5.111'
    username='root'
    password='123456'
    #paramiko.util.log_to_file('paramiko.log')
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    try:
        ssh.connect(host,22,username,password)
    except Exception,e:
        print e,"\033[31m*Username or password incorrect!\033[0m"
        return False 
    
    stdin,stdout,stderr =ssh.exec_command('sh /home/scripts/usercenter/deploy_container.sh')
    out = stdout.readlines()
    err = stderr.readlines()
    if  out:
        for line in out:
            print str(line).strip()
    else:
        print '\033[31mExcute %s scripts failed \033[0m'  % ("deploy_container.sh")
        print "\033[31mRemote to containers  server  failed\033[0m"

    ssh.close()
    return True

if  __name__ == '__main__':
         print "-----------------------华丽的分割线-----------------------" 
	 if build_go(sys.argv[1]):
                print "-----------------------华丽的分割线-----------------------" 
                var = build_config()
                if var: 
                     print "-----------------------华丽的分割线-----------------------" 
                     foo = build_images()
                     if foo:
                         print "-----------------------华丽的分割线-----------------------" 
                         build_container()



