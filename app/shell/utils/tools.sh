#!/bin/bash
set -e

# ------------------- Common Command method -------------------

function command-description() {
    TARGET_FILE_PATTERN=".*/[^-]*\.sh"
    [ ! -z ${1} ] && TARGET_FILE_PATTERN=".*/${1%.*}-[^-]*\.sh"
    if [ $(find ${CLI_SHELL_DIRECTORY} -maxdepth 1 -type f -regex "${TARGET_FILE_PATTERN}" | wc -l) -gt 0 ];
    then
        echo ""
        echo "Command: "
        for file in $(find ${CLI_SHELL_DIRECTORY} -maxdepth 1 -type f -regex "${TARGET_FILE_PATTERN}")
        do
            COMMAND_NAME=${file##*/}
            COMMAND_NAME=${COMMAND_NAME##*-}
            COMMAND_NAME=${COMMAND_NAME%.*}
            printf "    %-10s        %-40s\n" "${COMMAND_NAME}" "$(source ${file} short)"
        done
        echo ""
        echo "Run '${CLI_FILENAME##*/} [COMMAND] --help' for more information on a command."
    fi
}
