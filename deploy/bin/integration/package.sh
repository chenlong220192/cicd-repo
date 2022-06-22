#! /bin/bash

#======================================================================
# mvn package script
#
# example: sh package.sh local
#
# local - 本地（默认）
# dev   - 开发
# test  - 测试
# prod  - 生产
#
# author: chenlong
# date: 2020-08-10
#======================================================================

# ----------------------- params <---------------------------
PROFILE=$1
if [ -z "$PROFILE" ]; then
    PROFILE=local
fi
# ----------------------- params >---------------------------

# integration目录绝对路径
INTEGRATION_PATH=$(cd `dirname $0`; pwd) && cd `dirname $0` && cd .. && cd .. && cd ..&& BASE_PATH=`pwd`

# package
function package() {
  str="Package Target Profile ${PROFILE}"
  echo "${str}"
  ${BASE_PATH}/mvnw -f ${BASE_PATH}/pom.xml clean package -P ${PROFILE} -Dmaven.test.skip=true
  if [[ $? -eq 0 ]]
  then
    echo "${str} Success."
  else
    echo "${str} Failure."
    exit 1
  fi
}

# uncompress
function uncompress() {
  str="Uncompress"
  echo "${str}"
  mkdir -p ${BASE_PATH}/target/app && tar -zxvf ${BASE_PATH}/target/*.tar.gz -C ${BASE_PATH}/target/app --strip-components 1
  if [[ $? -eq 0 ]]
  then
    echo "${str} Success."
  else
    echo "${str} Failure."
    exit 1
  fi
}

package
uncompress
