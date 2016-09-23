@echo off
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::                                                                        ::
:: Copyright (c) 2016 - chiragkrishna   (@xda devs)                       ::
::                                                                        ::
:: This script is free you can edit modify and make it better as you wish ::
:: This script file is intended for personal and/or educational use only. :: 
:: It may not be duplicated for monetary benefit or any other purpose     ::  
:: without the permission of the creater.                                 ::
:: Binaries copyright all right reserved                                  ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:check_files
RD /S /Q %cd%\system
del %cd%\system.img
del %cd%\system.img.ext4
del %cd%\system_statfile.txt
cls
if not exist %cd%\system.new.dat goto stop1
echo.
if not exist %cd%\system.transfer.list goto stop2
echo.
if not exist %cd%\file_contexts goto stop3
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
echo please download python 3.x
echo https://www.python.org/downloads/
pause
exit

:python
sdat2img.py %cd%\system.transfer.list %cd%\system.new.dat %cd%\system.img.ext4
 IF EXIST system.img.ext4 goto convert
  
:convert
RD /S /Q %cd%\system
cls
echo converting "system.img.ext4" to "system"
REN system.img.ext4 system.img 
Imgextractor.exe system.img %cd%\system -i
del %cd%\system.img
pause
exit