# Declare script attribute
#@VALUE=123

# Declare variable

# Declare function
function action {
    for ln in `compgen -v`
    do
        [[ ${ln:0:4} == 'CLI_' ]] && echo ${ln}=${!ln} || true
        [[ ${ln:0:5} == 'ATTR_' ]] && echo ${ln}=${!ln} || true
        [[ ${ln:0:3} == 'RC_' ]] && echo ${ln}=${!ln} || true
    done
}

function args {
    return 0
}

function short {
    echo "Show environment variable"
}

function help {
    echo "This is a Command Line Interface with project ${PROJECT_NAME}"
    echo "Show environment variable"
    echo ""
    echo "Options:"
    echo "    --help, -h        Show more command information."
    command-description ${BASH_SOURCE##*/}
}

# Execute script
"$@"
