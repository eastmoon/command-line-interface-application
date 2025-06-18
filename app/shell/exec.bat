@rem ------------------- batch setting -------------------
@echo off

@rem ------------------- declare script attribute -------------------
::@STOP-CLI-PARSER
::@VALUE=123
::@BOOLEAN-TRUE
::@BOOLEAN-FALSE=

@rem ------------------- declare variable -------------------

@rem ------------------- execute script -------------------

call :%*
goto end

@rem ------------------- declare function -------------------

:action
    echo ^> Exec : %*
    echo ATTR_STOP_CLI_PARSER : %ATTR_STOP_CLI_PARSER%
    echo VALUE : %ATTR_VALUE%
    if defined ATTR_BOOLEAN_TRUE (echo BOOLEAN-TRUE exist) else (echo BOOLEAN-TRUE not exist)
    if defined ATTR_BOOLEAN_FALSE (echo BOOLEAN-FALSE exist) else (echo BOOLEAN-FALSE not exist)
    goto end

:args
    goto end

:short
    echo Execute some action
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
