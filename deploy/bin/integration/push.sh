#! /bin/bash

#======================================================================
# 1、打包
# 2、构建镜像
#
# example: 'sh push.sh [<local>|<dev>|<test>|<prod>]'
#
# local - 本地（默认）
# dev   - 开发
# test  - 测试
# prod  - 生产
#
# author: chenlong
# date: 2020-08-07
#======================================================================

# ----------------------- params <---------------------------
# 仓库名
DOCKER_REPOSITORY_NAME=$1
# 镜像名
DOCKER_IMAGE_NAME=$2
# tag
DOCKER_IMAGE_TAG=$3
# 环境标志
PROFILE=$4
if [ -z "$PROFILE" ]; then
    PROFILE=local
fi
# ----------------------- params >---------------------------

# integration目录绝对路径
INTEGRATION_PATH=$(cd `dirname $0`; pwd) && cd `dirname $0` && cd .. && cd .. && cd .. && BASE_PATH=`pwd`

# push
function push() {
  str="Push"
  echo "${str}."
  docker push ${DOCKER_REPOSITORY_NAME}/${DOCKER_IMAGE_NAME}-${PROFILE}:${DOCKER_IMAGE_TAG}
  if [[ $? -eq 0 ]]
  then
    echo "${str} Success."
  else
    echo "${str} Failure."
    exit 1
  fi
}

push
