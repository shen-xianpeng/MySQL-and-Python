############################################################
# Dockerfile to build user_center Installed Containers
# Based on Centos
############################################################
# Set the base image to Centos

FROM docker.io/centos
MAINTAINER Maintaner <wangyinbin@smm.cn>
ADD  supervisord.conf            /etc/supervisord.conf
ADD  user_center                /opt/webapp/usercenter/
ADD  conf.tar.gz           /opt/webapp/usercenter/
EXPOSE   8088
#CMD ["/usr/bin/supervisord"]
#ENTRYPOINT ["/usr/bin/supervisord"]
#CMD  ["-c","/etc/supervisord.conf"]
