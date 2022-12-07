#
# Copyright 2022 the original author jacky.eastmoon
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
CLI_FILE=${BASH_SOURCE##*/}
CLI_FILENAME=${CLI_FILE%.*}
CLI_FILEEXTENSION=${CLI_FILE##*.}
CLI_SHELL_DIRECTORY=${PWD}/shell
SHELL_FILE=

# ------------------- declare CLI variable -------------------

BREADCRUMB="cli"
COMMAND=""
COMMAND_BC_AGRS=()
COMMAND_AC_AGRS=()
SHOW_HELP=

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
        [ -z ${SHELL_FILE} ] && eval ${BREADCRUMB}-args ${key} ${value} || source ${SHELL_FILE} args ${key} ${value}
        common-args ${key} ${value}
    done
    # Execute command
    if [ ! -z ${COMMAND} ];
    then
        BREADCRUMB=${BREADCRUMB}-${COMMAND}
        if [ $(find ${CLI_SHELL_DIRECTORY} -type f -iname "${BREADCRUMB#*-}.sh" | wc -l) -gt 0 ];
        then
            SHELL_FILE=${CLI_SHELL_DIRECTORY}/${BREADCRUMB#*-}.sh
            main ${COMMAND_AC_AGRS[@]}
        else
            [ -z ${SHELL_FILE} ] &&  cli-help || source ${SHELL_FILE} help
        fi
    else
        if [ -z ${SHELL_FILE} ];
        then
            [ -z ${SHOW_HELP} ] && eval ${BREADCRUMB}-help || eval ${BREADCRUMB}
        else
            [ ! -z ${SHOW_HELP} ] && source ${SHELL_FILE} help || source ${SHELL_FILE} action
        fi
    fi
}

function common-args() {
    key=${1}
    value=${2}
    case ${key} in
        "--help")
            SHOW_HELP=1
            ;;
        "-h")
            SHOW_HELP=1
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
    echo ""
    echo "Options:"
    echo "    --help, -h        Show more information with CLI."
    echo "    --prod            Setting project environment with "prod", default is "dev""
    command-description
}

# ------------------- Common Command method -------------------

function command-description() {
    TARGET_FILE_PATTERN=".*/[^-]*\.sh"
    [ ! -z ${1} ] && TARGET_FILE_PATTERN=".*/${1%.*}-[^-]*\.sh"
    if [ $(find ${CLI_SHELL_DIRECTORY} -type f -regex "${TARGET_FILE_PATTERN}" | wc -l) -gt 0 ];
    then
        echo ""
        echo "Command: "
        for file in $(find ${CLI_SHELL_DIRECTORY} -type f -regex "${TARGET_FILE_PATTERN}")
        do
            COMMAND_NAME=${file##*/}
            COMMAND_NAME=${COMMAND_NAME##*-}
            COMMAND_NAME=${COMMAND_NAME%.*}
            printf "    %-10s        %-40s\n" "${COMMAND_NAME}" "$(source ${file} short)"
        done
        echo ""
        echo "Run '${CLI_FILENAME} [COMMAND] --help' for more information on a command."
    fi
}

# ------------------- execute script -------------------

main ${@}
