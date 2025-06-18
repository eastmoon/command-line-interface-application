# Declare function
function action {
    echo "> SHOW DEMO INFORMATION with ${PROJECT_ENV} environment"
}

function args {
    return 0
}

function short {
    echo "Show demo info"
}

function help {
    echo "This is a Command Line Interface with project ${PROJECT_NAME}"
    echo "Show demo info"
    echo ""
    echo "Options:"
    echo "    --help, -h        Show more command information."
    command-description ${BASH_SOURCE##*/}
}

# Execute script
"$@"
