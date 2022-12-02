# Declare function
function action {
    echo "> Server DOWN"
}

function args {
    return 0
}

function short {
    echo "Close down Server"
}

function help {
    echo "This is a Command Line Interface with project ${PROJECT_NAME}"
    echo "Close down Server"
    echo ""
    echo "Options:"
    echo "    --help, -h        Show more information with UP Command."
    command-description ${BASH_SOURCE##*/}
}

# Execute script
"$@"
