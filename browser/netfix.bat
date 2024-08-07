@echo off
cls & echo.
echo               __       ___     
echo              /\ \__  /'___\ __
echo   ___      __\ \ ,_\/\ \__//\_\   __  _  
echo /' _ `\  /'__`\ \ \/\ \ ,__\/\ \ /\ \/'\ 
echo /\ \/\ \/\  __/\ \ \_\ \ \_/\ \ \\/^>  ^</
echo \ \_\ \_\ \____\\ \__\\ \_\  \ \_\/\_/\_\
echo  \/_/\/_/\/____/ \/__/ \/_/   \/_/\//\/_/
echo.
echo NetFix v2.0c by Giovanni Heward (g@utahjrs.com)
echo.
echo Performs actions similiar to the network repair option and more!
echo See: http://support.microsoft.com/kb/289256
echo.
echo [Optional Switches]
echo /t   - tcp/ip reset  (http://support.microsoft.com/kb/299357) - requires reboot
echo /d   - debug mode
echo.
if [%1]==[/?] goto :eof
openfiles >nul 2>&1
if not %errorlevel% equ 0 (
echo Note: This script requires ADMINISTRATOR privileges to operate properly.
goto :paused
)
for /f %%d in ('date/t') do set d=%%d & for /f %%t in ('time/t') do set t=%%t
echo ---[NetFix runtime: %d% %t%]--->%userprofile%\desktop\netfix.log

set p=Releasing IP address
if exist %windir%\system32\ipconfig.exe (
echo %p% & title %p% & echo ---[%p%]--- >>%userprofile%\desktop\netfix.log
%windir%\system32\ipconfig.exe /release 1>>%userprofile%\desktop\netfix.log 2>>&1
if [%1]==[/d] echo errorlevel: %errorlevel%
if %errorlevel%==0 echo Successfully released IP...
if %errorlevel%==1 echo ERROR: Failed to release IP... check netfix.log
if %errorlevel%==3 echo NOTE: An IP address has not yet been associated with the network endpoint.
) else (echo ERROR: failed to release ip address - unable to locate %windir%\system32\ipconfig.exe)
if [%1]==[/d] pause

set p=Flushing ARP cache
if exist %windir%\system32\netsh.exe (
echo. & echo %p% & title %p% & echo ---[%p%]--- >>%userprofile%\desktop\netfix.log
%windir%\system32\netsh.exe interface ip delete arpcache 1>>%userprofile%\desktop\netfix.log 2>>&1
if [%1]==[/d] echo errorlevel: %errorlevel%
if %errorlevel%==0 echo Successfully flushed ARP cache...
if %errorlevel%==1 (echo ERROR: Failed to flush ARP cache... check netfix.log)
) else (
if exist %windir%\system32\arp.exe (
%windir%\system32\arp.exe -d * 1>>%userprofile%\desktop\netfix.log 2>>&1
if [%1]==[/d] echo errorlevel: %errorlevel%
if %errorlevel%==0 echo Successfully flushed ARP cache...
if %errorlevel%==1 (echo ERROR: Failed to flush ARP cache... check netfix.log)
) else (echo ERROR: failed to flush arp cache - unable to locate %windir%\system32\netsh.exe or %windir%\system32\arp.exe))
if [%1]==[/d] pause

set p=Reloading NetBIOS name cache
if exist %windir%\system32\nbtstat.exe (
echo. & echo %p% & title %p% & echo ---[%p%]--- >>%userprofile%\desktop\netfix.log
%windir%\system32\nbtstat.exe -R 1>>%userprofile%\desktop\netfix.log 2>>&1
if [%1]==[/d] echo errorlevel: %errorlevel%
if %errorlevel%==0 echo Successfully reloaded NetBIOS name cache...
if %errorlevel%==1 (echo ERROR: Failed to reload NetBIOS name cache... check netfix.log)
) else (
echo ERROR: Failed to reload netbios name cache - unable to locate %windir%\system32\nbtstat.exe)
if [%1]==[/d] pause

set p=Sending NetBIOS name update
if exist %windir%\system32\nbtstat.exe (
echo. & echo %p% & title %p% & echo ---[%p%]--- >>%userprofile%\desktop\netfix.log
%windir%\system32\nbtstat.exe -RR 1>>%userprofile%\desktop\netfix.log 2>>&1
if [%1]==[/d] echo errorlevel: %errorlevel%
) else (echo ERROR: Failed to send netbios name update - unable to locate %windir%\system32\nbtstat.exe)
if [%1]==[/d] pause

set p=Flushing DNS cache
if exist %windir%\system32\ipconfig.exe (
echo. & echo %p% & title %p% & echo ---[%p%]--- >>%userprofile%\desktop\netfix.log
%windir%\system32\ipconfig.exe /flushdns 1>>%userprofile%\desktop\netfix.log 2>>&1
if [%1]==[/d] echo errorlevel: %errorlevel%
) else (echo ERROR: Failed to flush dns cache - unable to locate %windir%\system32\ipconfig.exe)
if [%1]==[/d] pause

set needrestart=0
if [%1]==[/t] goto :ipreset
if not exist %windir%\system32\netsh.exe (goto :cont)
echo.
(call )
choice /t 10 /d n /m "Do you want to reset Winsock (this may cause your VPN and proxy software to fail, you may need to reconfigure them.)"
@rem set doresetwinsock=n
@rem set /p doresetwinsock=Do you want to reset Winsock? This may cause your VPN and proxy software to fail, you may need to reconfigure them. [y/n] [default - %doresetwinsock%]:
if %errorlevel%==1 (
(call )
goto :winsock
)
(call )
goto :cont

:ipreset
set p=Resetting TCP/IP
if exist %windir%\system32\netsh.exe (
echo. & echo %p% & title %p% & echo ---[%p%]--- >>%userprofile%\desktop\netfix.log
%windir%\system32\netsh.exe int ip reset %userprofile%\desktop\netreset.log 1>>%userprofile%\desktop\netfix.log 2>>&1
if [%1]==[/d] echo errorlevel: %errorlevel%
if %errorlevel%==0 (
echo Successfully reset TCP/IP
echo Note: This fix requires a system restart.
set needrestart=1
)
if %errorlevel%==1 (echo ERROR: Failed to reset tcp/ip... check netfix.log)
) else (echo ERROR: Failed to reset tcp/ip - unable to locate %windir%\system32\netsh.exe)
goto :end

:winsock
set p=Resetting Winsock
if exist %windir%\system32\netsh.exe (
echo. & echo %p% & title %p% & echo ---[%p%]--- >>%userprofile%\desktop\netfix.log
%windir%\system32\netsh.exe winsock reset 1>>%userprofile%\desktop\netfix.log 2>>&1
if [%1]==[/d] echo errorlevel: %errorlevel%
if %errorlevel%==0 (
echo Successfully reset winsock
echo Note: This fix requires a system restart.
set needrestart=1
)
if %errorlevel%==1 (echo Failed to reset winsock... check netfix.log)
) else (echo ERROR: Failed to reset winsock - unable to locate %windir%\system32\netsh.exe)
if [%1]==[/d] pause

:cont
set p=Renewing IP address
if exist %windir%\system32\ipconfig.exe (
echo. & echo %p% & title %p% & echo ---[%p%]--- >>%userprofile%\desktop\netfix.log
%windir%\system32\ipconfig.exe /renew 1>>%userprofile%\desktop\netfix.log 2>>&1
if [%1]==[/d] echo errorlevel: %errorlevel%
) else (echo ERROR: Failed to renew IP address - unable to locate %windir%\system32\ipconfig.exe)
if [%1]==[/d] pause

set p=Registering DNS name
if exist %windir%\system32\ipconfig.exe (
echo. & echo %p% & title %p% & echo ---[%p%]--- >>%userprofile%\desktop\netfix.log
%windir%\system32\ipconfig.exe /registerdns 1>>%userprofile%\desktop\netfix.log 2>>&1
if [%1]==[/d] echo errorlevel: %errorlevel%
) else (echo ERROR: Failed to register DNS name - unable to locate %windir%\system32\ipconfig.exe)

:end
if exist %windir%\system32\ipconfig.exe (
echo ---[ip configuration]--- >>%userprofile%\desktop\netfix.log
%windir%\system32\ipconfig.exe /all >>%userprofile%\desktop\netfix.log 2>>&1
)
echo. & echo Network Repair Complete! & echo ---[Finished: %d% %t%]--->>%userprofile%\desktop\netfix.log

if not [%needrestart%]==[1] (goto :paused)
echo.
(call )
choice /t 10 /d n /m "Restart the computer now"
if %errorlevel%==1 (
if exist %windir%\system32\shutdown.exe (
%windir%\system32\shutdown.exe /r /t 30
goto :cancelreboot
))
goto :paused

:cancelreboot
echo.
echo | set /p="System will restart in 30 seconds ... press any key to abort:"
pause >nul 2>nul
%windir%\system32\shutdown.exe /a
echo.
echo System restart aborted

:paused
echo.
pause