FROM centos:latest

#Install sshd net-tools
RUN yum install openssh-server net-tools -y && yum -y update && yum clean all
RUN mkdir /var/run/sshd
 
 
#Set history record
ENV HISTTIMEFORMAT "%F %T "
 
#Fix sshd service:Read from socket failed: Connection reset by peer?
RUN ssh-keygen -A
 
#Change timezone CST
RUN \cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

#中文编码
#COPY zh_CN /usr/share/locale/zh_CN

#RUN localedef  -f UTF-8 -i zh_CN zh_CN.UTF8

#ENV LANG zh_CN.utf8

#ENV LC_ALL zh_CN.UTF-8
 
#Auto running sshd service

ENV SSH_PORT=22

EXPOSE $SSH_PORT

CMD /usr/sbin/sshd -D -p $SSH_PORT
