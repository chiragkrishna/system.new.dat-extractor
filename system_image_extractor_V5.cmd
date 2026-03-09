@echo off
setlocal enabledelayedexpansion
title Android ROM Extractor Pro
color 0B

:: --- Configuration ---
set "TOOLS_DIR=.\tools"
set "TEMP_DIR=.\temp_files"
set "EXTRACT_DIR=.\extracted_files"
set "ROM_TEMP=%TEMP_DIR%\rom"

:: --- Initialization ---
pushd "%~dp0"
cls

echo ===========================================================
echo   Android ROM Extractor - Enhanced Edition
echo ===========================================================
echo.
echo [!] This will clear existing temp and extracted folders.
echo [!] Ensure your ROM .zip is in this directory.
echo.
pause

:: Create/Clean directories
if exist "%TEMP_DIR%" rd /s /q "%TEMP_DIR%"
if exist "%EXTRACT_DIR%" rd /s /q "%EXTRACT_DIR%"
mkdir "%ROM_TEMP%"
mkdir "%EXTRACT_DIR%"

:: --- File Validation ---
:Check_zip
if not exist "*.zip" (
    echo [ERROR] No ROM .zip detected in the current folder.
    echo Please place the file here and...
    pause
    goto Check_zip
)

echo [*] Extracting ROM structure...
"%TOOLS_DIR%\7z.exe" e "*.zip" -o"%ROM_TEMP%" -y >nul

:: --- Processing file_contexts ---
if exist "%ROM_TEMP%\file_contexts.bin" (
    echo [*] Converting file_contexts.bin...
    "%TOOLS_DIR%\fct.exe" -o "%ROM_TEMP%\file_contexts" -e "%ROM_TEMP%\file_contexts.bin"
    copy /y "%ROM_TEMP%\file_contexts" "%EXTRACT_DIR%\file_contexts" >nul
)

:: --- Branching Logic (Brotli vs Dat vs Payload) ---
if exist "%ROM_TEMP%\payload.bin" goto :handle_payload
if exist "%ROM_TEMP%\system.new.dat.br" goto :handle_brotli
if exist "%ROM_TEMP%\system.new.dat" goto :handle_sdat

:error_no_files
echo [FATAL] Supported system files (payload.bin, .dat, or .dat.br) not found.
pause
exit /b

:: --- Handlers ---

:handle_payload
echo [*] Payload detected. Extracting...
if not exist ".\payload_input" mkdir ".\payload_input"
copy /y "%ROM_TEMP%\payload.bin" ".\payload_input\" >nul
"%TOOLS_DIR%\payload_dumper.exe"
:: Assuming dumper outputs to payload_output
set "FINAL_IMG_DIR=.\payload_output"
goto :final_extract

:handle_brotli
echo [*] Brotli compressed files detected. Decompressing...
"%TOOLS_DIR%\brotli.exe" -d "%ROM_TEMP%\system.new.dat.br" -o "%ROM_TEMP%\system.new.dat"
if exist "%ROM_TEMP%\vendor.new.dat.br" (
    "%TOOLS_DIR%\brotli.exe" -d "%ROM_TEMP%\vendor.new.dat.br" -o "%ROM_TEMP%\vendor.new.dat"
)
:: Fall through to sdat

:handle_sdat
echo [*] Converting .dat to .img...
call :check_python
if %ERRORLEVEL% neq 0 exit /b

if not exist "%ROM_TEMP%\system.transfer.list" (
    echo [ERROR] system.transfer.list missing!
    pause
    exit /b
)

python "%TOOLS_DIR%\sdat2img.py" "%ROM_TEMP%\system.transfer.list" "%ROM_TEMP%\system.new.dat" "%ROM_TEMP%\system.img"
if exist "%ROM_TEMP%\vendor.new.dat" (
    python "%TOOLS_DIR%\sdat2img.py" "%ROM_TEMP%\vendor.transfer.list" "%ROM_TEMP%\vendor.new.dat" "%ROM_TEMP%\vendor.img"
)
set "FINAL_IMG_DIR=%ROM_TEMP%"
goto :final_extract

:: --- Final Processing ---

:final_extract
echo [*] Extracting filesystem images...
"%TOOLS_DIR%\Imgextractor.exe" "%FINAL_IMG_DIR%\system.img" "%EXTRACT_DIR%\system" -i
if exist "%FINAL_IMG_DIR%\vendor.img" (
    "%TOOLS_DIR%\Imgextractor.exe" "%FINAL_IMG_DIR%\vendor.img" "%EXTRACT_DIR%\vendor" -i
)

echo.
echo ===========================================================
echo   PROCESS COMPLETE!
echo ===========================================================
start "" "%EXTRACT_DIR%"
exit /b

:: --- Helper Subroutines ---

:check_python
python --version >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Python 3 is not installed or not in PATH.
    echo Please visit: https://www.python.org/downloads/
    pause
    exit /b 1
)
exit /b 0