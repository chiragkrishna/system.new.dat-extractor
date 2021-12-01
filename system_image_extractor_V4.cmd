@echo off

pushd "%CD%"
CD /D "%~dp0" 
cls
##########################################################################
#                                                                        #
# Copyright (c) 2016 - chiragkrishna   (@xda devs)                       #
#                                                                        #
# Fixed by LizenzFass78851                                               #
#                                                                        #
# This script is free you can edit modify and make it better as you wish #
# This script file is intended for personal and/or educational use only. # 
# It may not be duplicated for monetary benefit or any other purpose     #  
# without the permission of the creater.                                 #
# Binaries copyright all right reserved                                  #
##########################################################################
cls

echo please make sure you have deleted all the previous files in the temp_files and extracted_files folders.
echo make sure you have placed the rom zip file in the folder.
echo then proceed.
pause
cls

mkdir ".\temp_files"
mkdir ".\extracted_files"

:Check_zip
if not exist ".\*.zip" goto no_rom
cls
goto extract_rom

:no_rom
echo no rom zip detected, please place the zip file in the folder
pause
goto check_zip

:extract_rom
".\tools\7z.exe" e ".\*.zip" -o".\temp_files\rom" -y

cls
if not exist ".\temp_files\rom\file_contexts.bin" goto check_list
echo

echo converting file_contexts.bin to file_contexts
".\tools\fct.exe" -o file_contexts -e ".\temp_files\rom\file_contexts.bin"
echo 
copy ".\temp_files\rom\file_contexts" ".\extracted_files\file_contexts"

:check_list
if not exist ".\temp_files\rom\system.new.dat" goto check1
echo
if not exist ".\temp_files\rom\system.transfer.list" goto stop2
echo

goto :find_python

:check1
if not exist ".\temp_files\rom\system.new.dat.br" goto check2
echo 

goto brotli

:check2
if not exist ".\temp_files\rom\payload.bin" goto stop1
echo .

goto payload_exctract


:stop1
echo WARNING!!!
echo system.new.dat nor system.new.dat.br nor payload.bin not found!! 
echo make sure you are using the correct zip file
echo closing...
pause
exit

:stop2
echo WARNING!!!
echo system.transfer.list not found!!
echo make sure you are using the correct zip file
echo closing...
pause
exit

:payload_exctract
mkdir ".\payload_input"
mkdir ".\payload_output"
cls
echo copying payload.bin please wait
copy ".\temp_files\rom\payload.bin" ".\payload_input\payload.bin"
cls
echo extracting payload.bin please wait!! system.img will take time!! please be patient!!
".\tools\payload_dumper.exe"
cls
goto endalt


:brotli
echo converting system.new.dat.br to system.new.dat
".\tools\brotli.exe" -d ".\temp_files\rom\system.new.dat.br" -o ".\temp_files\rom\system.new.dat"
echo converting vendor.new.dat.br to vendor.new.dat
if exist ".\temp_files\rom\vendor.new.dat.br" ".\tools\brotli.exe" -d ".\temp_files\rom\vendor.new.dat.br" -o ".\temp_files\rom\vendor.new.dat"
cls

:find_python
python --version 3>NUL
 if %ERRORLEVEL% ==0 (goto :python) else (goto :nopython)
 
:nopython
echo please download python v3.x
echo https://www.python.org/downloads/
echo make sure your environment variable path is set
pause
exit

:python
python ".\tools\sdat2img.py" ".\temp_files\rom\system.transfer.list" ".\temp_files\rom\system.new.dat" ".\temp_files\rom\system.img"
if exist ".\temp_files\rom\vendor.new.dat" python ".\tools\sdat2img.py" ".\temp_files\rom\vendor.transfer.list" ".\temp_files\rom\vendor.new.dat" ".\temp_files\rom\vendor.img"

:endalt
if exist ".\payload_output" goto payload_last
".\tools\Imgextractor.exe" ".\temp_files\rom\system.img" ".\extracted_files\system" -i
if exist ".\temp_files\rom\vendor.img" ".\tools\Imgextractor.exe" ".\temp_files\rom\vendor.img" ".\extracted_files\vendor" -i
start .\extracted_files
start .\temp_files\rom
exit

: payload_last
".\tools\Imgextractor.exe" ".\payload_output\system.img" ".\extracted_files" -i
start .\extracted_files
start .\payload_output
exit