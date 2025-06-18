@rem ------------------- batch setting -------------------
@echo off

@rem ------------------- declare script attribute -------------------
::@VALUE=123

@rem ------------------- declare variable -------------------

@rem ------------------- execute script -------------------
call :%*
goto end

@rem ------------------- declare function -------------------

:action
    for /f "tokens=1*" %%p in ('SET') do (
        set ln=%%p
        if "!ln:~0,4!"=="CLI_" (echo !ln!)
        if "!ln:~0,5!"=="ATTR_" (echo !ln!)
        if "!ln:~0,3!"=="RC_" (echo !ln!)
    )
    goto end

:args
    goto end

:short
    echo Show environment variable
    goto end

:help
    echo This is a Command Line Interface with project %PROJECT_NAME%
    echo Show environment variable
    echo.
    echo Options:
    echo      --help, -h        Show more command information.
    call %CLI_SHELL_DIRECTORY%\utils\tools.bat command-description %~n0
    goto end

:end
