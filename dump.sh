#!/bin/bash
#set -ex
NAMESPACE=$1
OUTPUTDIR=$2
# 需要导出的资源类型 仅支持deployment和service类型的资源
KINDS="deployment service"

printHelp() {
  echo "Usage:"
  echo "  $0 <namespace> <output_dir>"
  echo
  echo "Options:"
  echo "  namespace  命名空间"
  echo "  outputdir  目标目录"
  echo
  echo "Examples:"
  echo "  $0 default ./outputdir"
  echo
}

if [ $# -ne 2 ];then
    printHelp
    exit 1
fi

if [ ! -d "${OUTPUTDIR}" ]; then
  echo "文件输出目录不存在，自动创建'${OUTPUTDIR}'"
  mkdir -p "${OUTPUTDIR}"
fi

confirmKind() {
  local KIND="$1"
  if [ "${KIND}" != "deployment"  -a  "${KIND}" != "service" ]; then
    echo "仅支持Deployment和Service类型的资源导出"
    printHelp
    exit 1
  fi
}

get_resources() {
  NAMESPACE=$1
  KIND=$2
  RESOURCE_LIST=`kubectl get ${KIND} -n ${NAMESPACE} -o custom-columns='NAME:metadata.name' --no-headers`
  echo "${RESOURCE_LIST}"
}

download() {
  NAMESPACE=$1
  KIND=$2
  OUTPUTDIR=$3
  TARGETDIR="${OUTPUTDIR}/${NAMESPACE}/${KIND}"
  if [ ! -d "${TARGETDIR}" ]; then
    mkdir -p "${TARGETDIR}"
  fi
  RESOURCE_LIST=`get_resources ${NAMESPACE} ${KIND}`
  for RESOURCE in ${RESOURCE_LIST}
  do
    FULLPATH=${TARGETDIR}/${RESOURCE}.yaml
    echo "正在导出 ${FULLPATH}"
    kubectl get ${KIND} -n ${NAMESPACE} ${RESOURCE} -o go-template-file=templates/${KIND}.tpl > "${FULLPATH}" 
  done
}

main() {
  for KIND in ${KINDS}
  do
    confirmKind ${KIND}
    download ${NAMESPACE} ${KIND} ${OUTPUTDIR}
  done
}

main
