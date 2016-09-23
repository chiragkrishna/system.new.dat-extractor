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
echo please select the rom zip file
ping 127.0.0.1 -n 2 > nul

#VBS start
cls
echo please select the rom zip file
:Dim objShell
:Dim strFileName
:Dim strFilePath
:Dim objFile
:Set objShell = CreateObject("Shell.Application")
:Set objFile = objShell.BrowseForFolder(0, "Choose a file:", &H4000)
:strFileName = objFile.Title
:strFilePath = objFile.self.Path
:Set objFSO = CreateObject("Scripting.FileSystemObject")
:Set obj1 = objFSO.CreateTextFile("temp1.txt", True)
:obj1.WriteLine strFilePath
:Set objFSO = CreateObject("Scripting.FileSystemObject")
:Set obj2 = objFSO.CreateTextFile("temp2.txt", True)
:obj2.WriteLine strFileName
:WScript.Quit
findstr "^:" "%~sf0">temp.vbs & cscript //nologo temp.vbs
del temp.vbs
set /p text1=< temp1.txt  
set /p text2=< temp2.txt  
cls

#find 7-zip
cls
7z -- version > temp3.txt
find /c "Igor Pavlov" %cd%\temp3.txt
if %errorlevel% equ 0 goto :zip 
goto nozip

:zip
cls
echo extracting files
7z e %text1% -o%cd%\%text2% -y
del temp1.txt
del temp2.txt
del temp3.txt
cls
goto :check_files

:nozip
echo please download 7-Zip v16.x
echo http://www.7-zip.org/download.html
echo make sure your environment variable path is set
pause
exit


:check_files
RD /S /Q %cd%\%text2%\system
del %cd%\%text2%\system.img
del %cd%\%text2%\system.img.ext4
del %cd%\%text2%\system_statfile.txt
cls
if not exist %cd%\%text2%\system.new.dat goto stop1
echo.
if not exist %cd%\%text2%\system.transfer.list goto stop2
echo.
if not exist %cd%\%text2%\file_contexts goto stop3
echo.

goto :find_python

:stop1
echo WARNING!!!
echo system.new.dat not found!! 
pause
goto :check_files

:stop2
echo WARNING!!!
echo system.transfer.list not found!!
pause
goto :check_files

:stop3
echo WARNING!!!
echo file_contexts not found!!
pause
goto :check_files


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
sdat2img.py %cd%\%text2%\system.transfer.list %cd%\%text2%\system.new.dat %cd%\%text2%\system.img.ext4
 IF EXIST %cd%\%text2%\system.img.ext4 goto convert
  
:convert
RD /S /Q %cd%\%text2%\system
cls
echo converting "system.img.ext4" to "system"
cd %text2%
REN system.img.ext4 system.img 
cd..
Imgextractor.exe %cd%\%text2%\system.img %cd%\system -i
RD /S /Q %cd%\%text2%
start %cd%\system
exit