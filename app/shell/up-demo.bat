@rem ------------------- batch setting -------------------

@rem ------------------- declare variable -------------------

@rem ------------------- execute script -------------------
call :%*
goto end

@rem ------------------- declare function -------------------

:action
    echo ^> SHOW DEMO INFORMATION with %PROJECT_ENV% environment
    goto end

:args
    goto end

:short
    echo Show demo info
    goto end

:help
    echo This is a Command Line Interface with project %PROJECT_NAME%
    echo Show demo info
    echo.
    echo Options:
    echo      --help, -h        Show more information with UP Command.
    call %CLI_SHELL_DIRECTORY%\utils\tools.bat command-description %~n0
    goto end

:end
