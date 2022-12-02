# Declare variable
[ -z ${VARNUMBER1} ] && export VARNUMBER1=0
[ -z ${VARNUMBER2} ] && export VARNUMBER2=0
[ -z ${VARTEST} ] && export VARTEST=0

# Declare function
function action {
    echo "> Server UP with ${PROJECT_ENV} environment"
    echo "> VARNUMBER1 = ${VARNUMBER1}"
    echo "> VARNUMBER2 = ${VARNUMBER2}"
    echo "> VARTEST = ${VARTEST}"
}

function args {
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

function short {
    echo "Startup Server"
}

function help {
    echo "This is a Command Line Interface with project ${PROJECT_NAME}"
    echo "Startup Server"
    echo ""
    echo "Options:"
    echo "    --help, -h        Show more information with UP Command."
    echo "    --var1            Set VARNUMBER1 value."
    echo "    --var2            Set VARNUMBER2 value."
    echo "    --test            Set VARTEST is True ( 1 )."
    command-description ${BASH_SOURCE##*/}
}

# Execute script
"$@"
