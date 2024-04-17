@echo off
setlocal enabledelayedexpansion

set "CRLM_PLUGIN_VERSION=1.0.0"
set "CRLM_PLUGIN_URL=https://github.com/pageuplt/CRLMPlugin/releases/latest/download/CRLM.dll"

if not exist "CRLM.dll" (
    echo "Downloading CRLM.dll"
    powershell -Command "Invoke-WebRequest -Uri '%CRLM_PLUGIN_URL%' -OutFile 'CRLM.dll'"

    if not exist "CRLM.dll" (
        echo "Failed to download CRLM.dll"
        exit /b 1
    )

    echo "CRLM.dll downloaded successfully"
)

@REM find the BakkesMod directory
set "BMM_DIR=%APPDATA%\bakkesmod\bakkesmod\"

if not exist "%BMM_DIR%" (
    echo "BakkesMod directory not found"
    exit /b 1
)

echo "BakkesMod directory found: %BMM_DIR%"

@REM copy to \plugins
copy /y "CRLM.dll" "%BMM_DIR%plugins"

echo "CRLM.dll copied to %BMM_DIR%plugins"

@REM check if \cfg\plugins.cfg exists
if not exist "%BMM_DIR%cfg\plugins.cfg" (
    echo "Creating %BMM_DIR%cfg\plugins.cfg"
    echo "plugin load crlm" > "%BMM_DIR%cfg\plugins.cfg"
) else (
    @REM check if CRLM is already loaded
    findstr /C:"plugin load crlm" "%BMM_DIR%cfg\plugins.cfg" >nul
    if errorlevel 1 (
        echo "Adding 'plugin load crlm' to %BMM_DIR%cfg\plugins.cfg"
        echo "plugin load crlm" >> "%BMM_DIR%cfg\plugins.cfg"
    ) else (
        echo "CRLM is already loaded in %BMM_DIR%cfg\plugins.cfg"
    )
)

echo "Installation complete"

exit /b 0