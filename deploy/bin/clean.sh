#! /bin/bash

#======================================================================
#
# example: sh clean.sh
#
# author: chenlong
# date: 2020-08-05
#======================================================================

# bin目录绝对路径
BIN_PATH=$(cd `dirname $0`; pwd) && cd `dirname $0` && cd .. && BASE_PATH=`pwd`

# clean
function clean() {
  str="Clean Files"
  echo "${str}"
  ${BASE_PATH}/mvnw -f ${BASE_PATH}/pom.xml --batch-mode --errors clean
  find ${BASE_PATH} \( -name "*.iml" -or -name ".flattened-pom.xml" -or -name ".DS_Store" -or -name "*.log" \) -print | xargs rm -r
  if [[ $? -eq 0 ]]
  then
    echo "${str} Success."
  else
    echo "${str} Failure."
  fi
}

clean
