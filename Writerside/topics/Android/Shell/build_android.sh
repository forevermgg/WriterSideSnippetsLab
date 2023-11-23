PROJECT_ROOT="$(readlink -f $0)"
PROJECT_ROOT="${PROJECT_ROOT%/*}/"
readonly PROJECT_ROOT="$(readlink -f ${PROJECT_ROOT})"
readonly BUILD_DIR_ROOT=${PROJECT_ROOT}/build_android
readonly SRC_DIR=${PROJECT_ROOT}
readonly BUILD_TYPE=(Debug Release)

for build in "${BUILD_TYPE[@]}"
do
    BUILD_DIR=${BUILD_DIR_ROOT}/${build}
    mkdir -p ${BUILD_DIR}
    pushd ${BUILD_DIR}
    echo "SRC_DIR " ${SRC_DIR}
    echo "current dir " `pwd`
done