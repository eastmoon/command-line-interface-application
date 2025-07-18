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
CLI_SHELL_DIRECTORY=${CLI_DIRECTORY}
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

# Command-line-interface main entrypoint.
function main() {
    # Parse assign variable which input into main function
    # It will parse input assign variable and stop at first command ( COMMAND ), and re-group two list variable, option list before command ( COMMAND_BC_AGRS ), option list after command ( COMMAND_AC_AGRS ).
    argv-parser ${@}
    # Run main function option, which option control come from "option list before command" ( COMMAND_BC_AGRS ).
    main-args ${COMMAND_BC_AGRS[@]}
    # Execute command
    if [[ -n ${COMMAND} && "${COMMAND}" != "" ]];
    then
        # If exist command, then re-group breadcrumb that is a string struct by command.
        BREADCRUMB=${BREADCRUMB}-${COMMAND}
        # And if exist a shell file has a name same with breadcrumb, then it is a target file we need to run.
        if [ $(find ${CLI_SHELL_DIRECTORY} -type f -iname "${BREADCRUMB#*-}.sh" | wc -l) -gt 0 ];
        then
            # Generate shell file full path.
            SHELL_FILE=${CLI_SHELL_DIRECTORY}/${BREADCRUMB#*-}.sh
            # Run main function attribute option, which option control come from shell file attribute ( #@ATTRIBUTE=VALUE ).
            main-attr
            # If attribute ( stop-cli-parser ) not exist, then run main function with "option list after command" ( COMMAND_AC_AGRS ).
            # Main function will run at nested structure, it will search full command breadcrumb come from use input assign variable.
            #
            # If attribute ( stop-cli-parser ) exist, it mean stop search full command breadcrumb,
            # and execute current shell file, and "option list after command" ( COMMAND_AC_AGRS ) become shell file assign variable .
            if [ -z ${ATTR_STOP_CLI_PARSER} ];
            then
                main ${COMMAND_AC_AGRS[@]}
            else
                FULL_COMMAND=${COMMAND_AC_AGRS[@]}
                argv-parser ${FULL_COMMAND}
                main-args ${COMMAND_BC_AGRS[@]}
                main-exec ${FULL_COMMAND}
            fi
        else
            # If not exist a shell file, then show help content which in cli file or current shell file
            [ -z ${SHELL_FILE} ] &&  cli-help || source ${SHELL_FILE} help
        fi
    else
        # If not exist command, it mean current main function input assign variable only have option, current breadcrumb variable was struct by full command,
        # then execute function ( in cli or shell file ) with breadcrumb variable.
        main-exec
    fi
}

# Main function, args running function.
function main-args() {
    for arg in ${@}
    do
        IFS='=' read -ra ADDR <<< "${arg}"
        key=${ADDR[0]}
        value=${ADDR[1]}
        [ -z ${SHELL_FILE} ] && eval ${BREADCRUMB}-args ${key} ${value} || source ${SHELL_FILE} args ${key} ${value}
        common-args ${key} ${value}
    done
}

# Main function, attribute running function.
function main-attr() {
    if [[ -n ${SHELL_FILE} && -e ${SHELL_FILE} ]];
    then
        if [ $(grep "#@" ${SHELL_FILE} | wc -l) -gt 0 ];
        then
            for attr in $(grep "#@" ${SHELL_FILE})
            do
                IFS='=' read -ra ADDR <<< "${attr//#@/}"
                key=${ADDR[0]}
                value=${ADDR[1]}
                [[ ! ${attr} =~ "=" ]] && value=1 || true
                export ATTR_${key//-/_}="${value}"
            done
        fi
    fi
}

# Main function, target function execute.
function main-exec() {
    if [ -z ${SHELL_FILE} ];
    then
        [ -z ${SHOW_HELP} ] && eval ${BREADCRUMB}-help || eval ${BREADCRUMB}
    else
        [ ! -z ${SHOW_HELP} ] && source ${SHELL_FILE} help || source ${SHELL_FILE} action ${@}
    fi
}

# Parse args variable
# it will search input assign variable, then find first command ( COMMAND ), option list before command ( COMMAND_BC_AGRS ), and option list after command ( COMMAND_AC_AGRS ).
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

# Parse ini configuration file
# A variable in ini configuration file, will setting variable by common-ini function.
function ini-parser() {
    if [ -e ${CLI_DIRECTORY}/${CLI_FILENAME}.ini ];
    then
        while read -r line; do
            IFS='=' read -ra ADDR <<< "${line%\;*}"
            key=${ADDR[0]}
            value=${ADDR[1]}
            common-ini ${key} ${value}
        done < ${CLI_DIRECTORY}/${CLI_FILENAME}.ini
    fi
}

# Parse runtime configuration file
# A variable in runtime configuration file, will all setting in global variable, before main action execute.
function rc-parser() {
    RC_FILENAME=${CLI_DIRECTORY}/${CLI_FILENAME}.rc
    [ ! -z ${1} ] && RC_FILENAME=${1}
    if [ -e ${RC_FILENAME} ];
    then
        while read -r line; do
            if [[ ! ${line} =~ ^# ]];
            then
                IFS='=' read -ra ADDR <<< "${line}"
                key=${ADDR[0]}
                value=${ADDR[1]}
                if [ "${key}" != "" ];
                then
                    export RC_${key}="${value}"
                fi
            fi
        done < ${RC_FILENAME}
    fi
}

# ------------------- command-line-interface common args and attribute method -------------------

# Common - ini configuration process
function common-ini() {
    key=${1}
    value=${2}
    case ${key} in
        "COMMAND_SCRIPT_DIR")
            CLI_SHELL_DIRECTORY=${CLI_DIRECTORY}/${value//\\/\/}
            ;;
    esac
}

# Common - args process
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
        "--rc")
            rc-parser ${value}
            ;;
    esac
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

# ------------------- execute script -------------------

# .ini file parser
ini-parser
# .rc file parser
rc-parser
# Import library
source ${CLI_SHELL_DIRECTORY}/utils/tools.sh
# Execute entrypoint function
main ${@}
