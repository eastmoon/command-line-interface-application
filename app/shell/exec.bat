@rem ------------------- batch setting -------------------
::@STOP-CLI-PARSER
::@ATTRIBUTE=1

@rem ------------------- declare variable -------------------

@rem ------------------- execute script -------------------

call :%*
goto end

@rem ------------------- declare function -------------------

:action
    echo ^> Exec : %*
    goto end

:args
    goto end

:short
    echo "Execute some action"
    goto end

:help
    echo This is a Command Line Interface with project %PROJECT_NAME%
    echo Execute some action
    echo.
    echo Options:
    echo     --help, -h        Show more information with UP Command.
    call %CLI_SHELL_DIRECTORY%\utils\tools.bat command-description %~n0
    goto end

:end
