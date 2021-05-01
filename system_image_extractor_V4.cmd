@echo off
##########################################################################
#                                                                        #
# Copyright (c) 2016 - chiragkrishna   (@xda devs)                       #
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

mkdir "%cd%\temp_files"
mkdir "%cd%\extracted_files"

:Check_zip
if not exist "%cd%\*zip" goto no_rom
cls
goto extract_rom

:no_rom
echo no rom zip detected, please place the zip file in the folder
pause
goto check_zip

:extract_rom
"%cd%\tools\7z.exe" e *zip -o%cd%\temp_files\rom -y

cls
if not exist "%cd%\temp_files\rom\file_contexts.bin" goto check_list
echo

echo converting file_contexts.bin to file_contexts
"%cd%\tools\fct.exe" -o file_contexts -e "%cd%\temp_files\rom\file_contexts.bin"
echo 
copy "%cd%\temp_files\rom\file_contexts" "%cd%\extracted_files\file_contexts"

:check_list
if not exist "%cd%\temp_files\rom\system.new.dat" goto check1
echo
if not exist "%cd%\temp_files\rom\system.transfer.list" goto stop2
echo

goto :find_python

:check1
if not exist "%cd%\temp_files\rom\system.new.dat.br" goto check2
echo 

goto brotli

:check2
if not exist "%cd%\temp_files\rom\payload.bin" goto stop1
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
mkdir "%cd%\payload_input"
mkdir "%cd%\payload_output"
cls
echo copying payload.bin please wait
copy "%cd%\temp_files\rom\payload.bin" "%cd%\payload_input\payload.bin"
cls
echo extracting payload.bin please wait!! system.img will take time!! please be patient!!
"%cd%\tools\payload_dumper.exe"
cls
goto endalt


:brotli
echo converting system.new.dat.br to system.new.dat
"%cd%\tools\brotli.exe" -d "%cd%\temp_files\rom\system.new.dat.br" -o "%cd%\temp_files\rom\system.new.dat"
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
"%cd%\tools\sdat2img.py" "%cd%\temp_files\rom\system.transfer.list" "%cd%\temp_files\rom\system.new.dat" "%cd%\temp_files\rom\system.img"

:endalt
if exist "%cd%\payload_output" goto payload_last
"%cd%\tools\Imgextractor.exe" "%cd%\temp_files\rom\system.img" "%cd%\extracted_files" -i
start %cd%\extracted_files
start %cd%\temp_files\rom
exit

: payload_last
"%cd%\tools\Imgextractor.exe" "%cd%\payload_output\system.img" "%cd%\extracted_files" -i
start %cd%\extracted_files
start %cd%\payload_output
exit