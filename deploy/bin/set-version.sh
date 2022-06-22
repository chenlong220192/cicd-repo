#! /bin/bash

#======================================================================
# $0 版本号
# example 'sh set-version.sh 1.0.0'
#
# author: chenlong
# date: 2020-08-10
#======================================================================

# ----------------------- params <---------------------------
NEW_VERSION=$1
# ----------------------- params >---------------------------

# bin目录绝对路径
BIN_PATH=$(cd `dirname $0`; pwd) && cd `dirname $0` && cd .. && BASE_PATH=`pwd`

# set maven version
function set_maven_version() {
  str="Set project to new version ${NEW_VERSION}"
  echo "${str}"
  cat ${BASE_PATH}/pom.xml\
      | sed "s/<revision>[^<]*<\/revision>/<revision>${NEW_VERSION}<\/revision>/1" > ${BASE_PATH}/pom.xml.newVersion\
      && mv ${BASE_PATH}/pom.xml.newVersion ${BASE_PATH}/pom.xml
  if [[ $? -eq 0 ]]
  then
    echo "${str} Success."
  else
    echo "${str} Failure."
    exit 1
  fi
}

# set app version
function replace_app_version() {
  str="Replace app version ${NEW_VERSION}"
  echo "${str}"
  cat ${BASE_PATH}/config/app.properties\
      | sed "s/app.version[^<]*/app.version = ${NEW_VERSION}/1" > ${BASE_PATH}/config/app.properties.newAppProperties\
      && mv ${BASE_PATH}/config/app.properties.newAppProperties ${BASE_PATH}/config/app.properties
  if [[ $? -eq 0 ]]
  then
    echo "${str} Success."
  else
    echo "${str} Failure."
    exit 1
  fi
}

set_maven_version
replace_app_version
