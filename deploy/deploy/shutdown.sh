#! /bin/bash

#======================================================================
# 项目停服shell脚本
# 通过项目名称查找到PID
# 然后kill -9 pid
#
# author: chenlong
# date: 2020-06-03
#======================================================================

# 项目名称
APPLICATION=cicd-repo
# 项目启动jar包名称
APPLICATION_JAR=cicd-repo-boot-0.0.1-SNAPSHOT.jar

PID=$(ps -eo user,pid,tty,args | grep "${APPLICATION_JAR}" | grep -v grep | awk '{ print $2 }')
if [[ -z "$PID" ]]
then
    echo ${APPLICATION} is already stopped
else
    echo "kill -9 ${PID}"
    kill -9 ${PID}
    if [[ $? -eq 0 ]]
  	then
    	echo "${APPLICATION} stopped successfully"
  	else
    	echo "${APPLICATION} stopped Failure"
    	exit 1
  	fi
fi
