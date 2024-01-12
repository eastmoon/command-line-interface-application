@rem ------------------- batch setting -------------------

@rem ------------------- declare variable -------------------
if not defined VARNUMBER1 ( set VARNUMBER1=0 )
if not defined VARNUMBER2 ( set VARNUMBER2=0 )
if not defined VARTEST ( set VARTEST=0 )

@rem ------------------- execute script -------------------
call :%*
goto end

@rem ------------------- declare function -------------------

:action
    echo ^> Server UP with %PROJECT_ENV% environment
    echo ^> VARNUMBER1 = %VARNUMBER1%
    echo ^> VARNUMBER2 = %VARNUMBER2%
    echo ^> VARTEST = %VARTEST%
    goto end

:args
    set KEY=%1
    set VALUE=%2
    if "%KEY%"=="--var1" (set VARNUMBER1=%VALUE%)
    if "%KEY%"=="--var2" (set VARNUMBER2=%VALUE%)
    if "%KEY%"=="--test" (set VARTEST=1)
    goto end

:short
    echo Startup Server
    goto end

:help
    echo This is a Command Line Interface with project %PROJECT_NAME%
    echo Startup Server
    echo.
    echo Options:
    echo      --help, -h        Show more information with UP Command.
    echo      --var1            Set VARNUMBER1 value.
    echo      --var2            Set VARNUMBER2 value.
    echo      --test            Set VARTEST is True ( 1 ).
    call %CLI_SHELL_DIRECTORY%\utils\tools.bat command-description %~n0
    goto end

:end
