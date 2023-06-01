#@STOP-CLI-PARSER

# Declare function
function action {
    echo "> Exec : ${@}"
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
    echo "    --help, -h        Show more information with UP Command."
    command-description ${BASH_SOURCE##*/}
}

# Execute script
"$@"
