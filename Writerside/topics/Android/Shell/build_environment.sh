echo "This script is intended to run in a CI environment and may modify your current environment."
echo "Please refer to BUILDING.md for more information."


function ensure_android_build {
    if [[ "${ANDROID_HOME}" == "" ]]; then
        echo "Error: ANDROID_HOME is not set, exiting"
        exit 1
    fi
    echo "ANDROID_HOME = ${ANDROID_HOME}"

    NDK_VERSION=${FILAMENT_NDK_VERSION:-$(cat $(dirname $0)/ndk.version)}
    echo "$NDK_VERSION"
    # shellcheck disable=SC2012
    if [[ -z $(ls "${ANDROID_HOME}/ndk/" | sort -V | grep "^${NDK_VERSION}") ]]; then
        echo "Error: Android NDK side-by-side version ${NDK_VERSION} or compatible must be installed, exiting"
        exit 1
    fi

    local cmake_version=$(cmake --version)
    echo "cmake_version = ${cmake_version}"
    if [[ "${cmake_version}" =~ ([0-9]+)\.([0-9]+)\.[0-9]+ ]]; then
        if [[ "${BASH_REMATCH[1]}" -lt "${CMAKE_MAJOR}" ]] || \
           [[ "${BASH_REMATCH[2]}" -lt "${CMAKE_MINOR}" ]]; then
            echo "Error: cmake version ${CMAKE_MAJOR}.${CMAKE_MINOR}+ is required," \
                 "${BASH_REMATCH[1]}.${BASH_REMATCH[2]} installed, exiting"
            exit 1
        fi
    fi
}

ensure_android_build

read -r -p "Do you wish to proceed (y/n)? " choice
case "${choice}" in
y | Y)
  echo "Build will proceed..."
  ;;
n | N)
  exit 0
  ;;
*)
  exit 0
  ;;
esac

# OS specific support (must be 'true' or 'false').
cygwin=false
msys=false
darwin=false
nonstop=false
case "`uname`" in
  CYGWIN* )
    cygwin=true
    ;;
  Darwin* )
    darwin=true
    ;;
  MINGW* )
    msys=true
    ;;
  NONSTOP* )
    nonstop=true
    ;;
esac
echo "cygwin = $cygwin; darwin = $darwin; msys = $msys; nonstop = $nonstop"

case "$(uname -s)" in
    Darwin*) IS_DARWIN=1;;
    *) ;;
esac
echo "IS_DARWIN = $IS_DARWIN;"

UNAME=$(uname)
LC_UNAME=$(echo "${UNAME}" | tr '[:upper:]' '[:lower:]')
echo "LC_UNAME = $LC_UNAME;"

# Unless explicitly specified, NDK version will be set to match exactly the required one
NDK_VERSION=${FILAMENT_NDK_VERSION:-$(cat $(dirname $0)/ndk.version)}
echo "$NDK_VERSION"
# $ANDROID_HOME/tools/bin/sdkmanager --install "ndk;25.2.9519653"
# 坑：archlinux 需要 sudo archlinux-java set java-8-openjdk
# Install the required NDK version specifically (if not present)
if [[ ! -d "${ANDROID_HOME}/ndk/$NDK_VERSION" ]]; then
    ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager "ndk;$FILAMENT_NDK_VERSION" > /dev/null
fi


# Determine the Java command to use to start the JVM.
if [ -n "$JAVA_HOME" ] ; then
    if [ -x "$JAVA_HOME/jre/sh/java" ] ; then
        # IBM's JDK on AIX uses strange locations for the executables
        JAVACMD="$JAVA_HOME/jre/sh/java"
    else
        JAVACMD="$JAVA_HOME/bin/java"
    fi
    if [ ! -x "$JAVACMD" ] ; then
        die "ERROR: JAVA_HOME is set to an invalid directory: $JAVA_HOME

Please set the JAVA_HOME variable in your environment to match the
location of your Java installation."
    fi
else
    JAVACMD="java"
    which java >/dev/null 2>&1 || die "ERROR: JAVA_HOME is not set and no 'java' command could be found in your PATH.

Please set the JAVA_HOME variable in your environment to match the
location of your Java installation."
fi

java_version=$(java -version 2>&1 | head -1 | cut -d'"' -f2 | sed '/^1\./s///' | cut -d'.' -f1)
if [[ "$java_version" < 17 ]] ; then
  echo "Android builds require Java 17, found version ${java_version} instead"
  exit 0
fi
