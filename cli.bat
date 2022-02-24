@rem
@rem Copyright 2020 the original author jacky.eastmoon
@rem All commad module need 3 method :
@rem [command]        : Command script
@rem [command]-args   : Command script options setting function
@rem [command]-help   : Command description
@rem Basically, CLI will not use "--options" to execute function, "--help, -h" is an exception.
@rem But, if need exception, it will need to thinking is common or individual, and need to change BREADCRUMB variable in [command]-args function.
@rem NOTE, batch call [command]-args it could call correct one or call [command] and "-args" is parameter.
@rem

:: ------------------- batch setting -------------------
@rem setting batch file
@rem ref : https://www.tutorialspoint.com/batch_script/batch_script_if_else_statement.htm
@rem ref : https://poychang.github.io/note-batch/

@echo off
setlocal
setlocal enabledelayedexpansion

:: ------------------- declare CLI file variable -------------------
@rem retrieve project name
@rem Ref : https://www.robvanderwoude.com/ntfor.php
@rem Directory = %~dp0
@rem Object Name With Quotations=%0
@rem Object Name Without Quotes=%~0
@rem Bat File Drive = %~d0
@rem Full File Name = %~n0%~x0
@rem File Name Without Extension = %~n0
@rem File Extension = %~x0

set CLI_DIRECTORY=%~dp0
set CLI_FILE=%~n0%~x0
set CLI_FILENAME=%~n0
set CLI_FILEEXTENSION=%~x0

:: ------------------- declare CLI variable -------------------

set BREADCRUMB=cli
set COMMAND=
set COMMAND_BC_AGRS=
set COMMAND_AC_AGRS=

:: ------------------- declare variable -------------------

for %%a in ("%cd%") do (
    set PROJECT_NAME=%%~na
)
set PROJECT_ENV=dev

:: ------------------- execute script -------------------

call :main %*
goto end

:: ------------------- declare function -------------------

:main (
    set COMMAND=
    set COMMAND_BC_AGRS=
    set COMMAND_AC_AGRS=
    call :argv-parser %*
    call :%BREADCRUMB%-args %COMMAND_BC_AGRS%
    call :common-args %COMMAND_BC_AGRS%
    IF defined COMMAND (
        set BREADCRUMB=%BREADCRUMB%-%COMMAND%
        call :main %COMMAND_AC_AGRS%
    ) else (
        call :%BREADCRUMB%
    )
    goto end
)
:common-args (
    for /f "tokens=1*" %%p in ("%*") do (
        if "%%p"=="-h" (set BREADCRUMB=%BREADCRUMB%-help)
        if "%%p"=="--help" (set BREADCRUMB=%BREADCRUMB%-help)
        call :common-args %%q
    )
    goto end
)
:argv-parser (
    for /f "tokens=1*" %%p in ("%*") do (
        IF NOT defined COMMAND (
            echo %%p | findstr /r "\-" >nul 2>&1
            if errorlevel 1 (
                set COMMAND=%%p
            ) else (
                set COMMAND_BC_AGRS=!COMMAND_BC_AGRS! %%p
            )
        ) else (
            set COMMAND_AC_AGRS=!COMMAND_AC_AGRS! %%p
        )
        call :argv-parser %%q
    )
    goto end
)

:: ------------------- Main mathod -------------------

:cli (
    goto cli-help
)

:cli-args (
    for %%p in (%*) do (
        if "%%p"=="--prod" (set PROJECT_ENV=prod)
    )
    goto end
)

:cli-help (
    echo This is a Command Line Interface with project %PROJECT_NAME%
    echo If not input any command, at default will show HELP
    echo.
    echo Options:
    echo      --help, -h        Show more information with CLI.
    echo      --prod            Setting project environment with "prod", default is "dev"
    echo.
    echo Command:
    echo      up                Startup Server.
    echo      down              Close down Server.
    echo.
    echo Run 'cli [COMMAND] --help' for more information on a command.
    goto end
)

:: ------------------- Command "up" mathod -------------------

set VARNUMBER1=0
set VARNUMBER2=0
set VARTEST=0

:cli-up (
    echo ^> Server UP with %PROJECT_ENV% environment
    echo ^> VARNUMBER1 = %VARNUMBER1%
    echo ^> VARNUMBER2 = %VARNUMBER2%
    echo ^> VARTEST = %VARTEST%
    goto end
)

:cli-up-args (
    for /f "tokens=1*" %%p in ("%*") do (
        for /f "tokens=1,2 delims==" %%i in ("%%p") do (
            if "%%i"=="--var1" (set VARNUMBER1=%%j)
            if "%%i"=="--var2" (set VARNUMBER2=%%j)
            if "%%i"=="--test" (set VARTEST=1)
        )
        call :cli-up-args %%q
    )
    goto end
)

:cli-up-help (
    echo This is a Command Line Interface with project %PROJECT_NAME%
    echo Startup Server
    echo.
    echo Command:
    echo      demo              Show demo info.
    echo Options:
    echo      --help, -h        Show more information with UP Command.
    echo      --var1            Set VARNUMBER1 value.
    echo      --var2            Set VARNUMBER2 value.
    echo      --test            Set VARTEST is True ( 1 ).
    goto end
)

:: ------------------- Command "up"-"demo" mathod -------------------

:cli-up-demo (
    echo ^> SHOW DEMO INFORMATION with %PROJECT_ENV% environment
    goto end
)

:cli-up-demo-args (
    goto end
)

:cli-up-demo-help (
    echo This is a Command Line Interface with project %PROJECT_NAME%
    echo Show demo info
    echo.
    echo Options:
    echo      --help, -h        Show more information with UP Command.
    goto end
)


:: ------------------- Command "down" mathod -------------------

:cli-down (
    echo ^> Server DOWN
    goto end
)

:cli-down-args (
    goto end
)

:cli-down-help (
    echo This is a Command Line Interface with project %PROJECT_NAME%
    echo Close down Server
    echo.
    echo Options:
    echo      --help, -h        Show more information with UP Command.
    goto end
)

:: ------------------- End method-------------------

:end (
    endlocal
)
