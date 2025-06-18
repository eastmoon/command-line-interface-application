# Declare script attribute
#@STOP-CLI-PARSER
#@VALUE=123
#@BOOLEAN-TRUE
#@BOOLEAN-FALSE=

# Declare function
function action {
    echo "> Exec : ${@}"
    echo ATTR_STOP_CLI_PARSER : ${ATTR_STOP_CLI_PARSER}
    echo VALUE : ${ATTR_VALUE}
    [ ! -z ${ATTR_BOOLEAN_TRUE} ] && echo "BOOLEAN-TRUE exist" || echo "BOOLEAN-TRUE not exist"
    [ ! -z ${ATTR_BOOLEAN_FALSE} ] && echo "BOOLEAN-FALSE exist" || echo "BOOLEAN-FALSE not exist"
}

function args {
    return 0
}

function short {
    echo "Execute some action"
}

function help {
    echo "This is a Command Line Interface with project ${PROJECT_NAME}"
    echo "Execute some action"
    echo ""
    echo "Options:"
    echo "    --help, -h        Show more command information."
    command-description ${BASH_SOURCE##*/}
}

# Execute script
"$@"
