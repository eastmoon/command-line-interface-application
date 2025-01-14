#
# Copyright 2020 the original author jacky.eastmoon
#
# All commad module need 3 method :
# [command]        : Command script
# [command]-args   : Command script options setting function
# [command]-help   : Command description
# Basically, CLI will not use "--options" to execute function, "--help, -h" is an exception.
# But, if need exception, it will need to thinking is common or individual, and need to change BREADCRUMB variable in [command]-args function.
#
# Ref : https://www.cyberciti.biz/faq/category/bash-shell/
# Ref : https://tldp.org/LDP/abs/html/string-manipulation.html
# Ref : https://blog.longwin.com.tw/2017/04/bash-shell-script-get-self-file-name-2017/

# ------------------- shell setting -------------------

#!/bin/bash
set -e

# ------------------- declare CLI file variable -------------------

CLI_DIRECTORY=${PWD}
CLI_FILE=${BASH_SOURCE}
CLI_FILENAME=${BASH_SOURCE%.*}
CLI_FILEEXTENSION=${BASH_SOURCE##*.}

# ------------------- declare CLI variable -------------------

BREADCRUMB="cli"
COMMAND=""
COMMAND_BC_AGRS=()
COMMAND_AC_AGRS=()

# ------------------- declare variable -------------------

PROJECT_NAME=${PWD##*/}
PROJECT_ENV="dev"

# ------------------- declare function -------------------

# Command Parser
function main() {
    argv-parser ${@}
    for arg in ${COMMAND_BC_AGRS[@]}
    do
        IFS='=' read -ra ADDR <<< "${arg}"
        key=${ADDR[0]}
        value=${ADDR[1]}
        eval ${BREADCRUMB}-args ${key} ${value}
        common-args ${key} ${value}
    done
    # Execute command
    if [ ! -z ${COMMAND} ];
    then
        BREADCRUMB=${BREADCRUMB}-${COMMAND}
        IS_FUNCTION=
        if [ -z ${ZSH_NAME} ]; then
            [ "$(type -t ${BREADCRUMB})" = "function" ] && IS_FUNCTION=1 || true
        else
            [ "$(whence -w ${BREADCRUMB} | awk '{print $2}')" = "function" ] && IS_FUNCTION=1 || true
        fi
        if [ ! -z IS_FUNCTION ]; then
            main ${COMMAND_AC_AGRS[@]}
        else
            cli-help
        fi
    else
        eval ${BREADCRUMB}
    fi
}

function common-args() {
    key=${1}
    value=${2}
    case ${key} in
        "--help")
            BREADCRUMB="${BREADCRUMB}-help"
            ;;
        "-h")
            BREADCRUMB="${BREADCRUMB}-help"
            ;;
    esac
}

function argv-parser() {
    COMMAND=""
    COMMAND_BC_AGRS=()
    COMMAND_AC_AGRS=()
    is_find_cmd=0
    for arg in ${@}
    do
        if [ ${is_find_cmd} -eq 0 ]
        then
            if [[ ${arg} =~ -+[a-zA-Z1-9]* ]]
            then
                COMMAND_BC_AGRS+=(${arg})
            else
                COMMAND=${arg}
                is_find_cmd=1
            fi
        else
            COMMAND_AC_AGRS+=(${arg})
        fi
    done
}


# ------------------- Main method -------------------

function cli() {
    cli-help
}

function cli-args() {
    key=${1}
    value=${2}
    case ${key} in
        "--prod")
            PROJECT_ENV="prod"
            ;;
    esac
}

function cli-help() {
    echo "This is a docker control script with project ${PROJECT_NAME}"
    echo "If not input any command, at default will show HELP"
    echo "Options:"
    echo "    --help, -h        Show more information with CLI."
    echo "    --prod            Setting project environment with "prod", default is "dev""
    echo ""
    echo "Command:"
    echo "    up                Startup Server."
    echo "    down              Close down Server."
    echo ""
    echo "Run 'cli [COMMAND] --help' for more information on a command."
}

# ------------------- Common Command method -------------------



# ------------------- Command "up" method -------------------

VARNUMBER1=0
VARNUMBER2=0
VARTEST=0

function cli-up {
    echo "> Server UP with ${PROJECT_ENV} environment"
    echo "> VARNUMBER1 = ${VARNUMBER1}"
    echo "> VARNUMBER2 = ${VARNUMBER2}"
    echo "> VARTEST = ${VARTEST}"
}

function cli-up-args {
    key=${1}
    value=${2}
    case ${key} in
        "--var1")
            VARNUMBER1=${value}
            ;;
        "--var2")
            VARNUMBER2=${value}
            ;;
        "--test")
            VARTEST=1
            ;;
    esac
}

function cli-up-help {
    echo "This is a Command Line Interface with project ${PROJECT_NAME}"
    echo "Startup Server"
    echo ""
    echo "Options:"
    echo "    --help, -h        Show more information with UP Command."
    echo "Command:"
    echo "    demo              Show demo info."
    echo "Options:"
    echo "    --help, -h        Show more information with UP Command."
    echo "    --var1            Set VARNUMBER1 value."
    echo "    --var2            Set VARNUMBER2 value."
    echo "    --test            Set VARTEST is True ( 1 )."
}

# ------------------- Command "up"-"demo" method -------------------

function cli-up-demo {
    echo "> SHOW DEMO INFORMATION with ${PROJECT_ENV} environment"
}

function cli-up-demo-args {
    return 0
}

function cli-up-demo-help {
    echo "This is a Command Line Interface with project ${PROJECT_NAME}"
    echo "Show demo info"
    echo ""
    echo "Options:"
    echo "    --help, -h        Show more information with UP Command."
}

# ------------------- Command "down" method -------------------

function cli-down {
    echo "> Server DOWN"
}

function cli-down-args {
    return 0
}

function cli-down-help {
    echo "This is a Command Line Interface with project ${PROJECT_NAME}"
    echo "Close down Server"
    echo ""
    echo "Options:"
    echo "    --help, -h        Show more information with UP Command."
}

# ------------------- execute script -------------------

main ${@}
