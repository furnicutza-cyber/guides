@echo off 

echo [%date% %time%] Install.bat started >> C:\GPO_Install_Log.txt
\\DC17\Falcon\FalconSensor_Windows.exe /quiet /norestart CID=xxxxxxxxxxxxxxxxxxxxxxxx

echo [%date% %time%] Install.bat finished >> C:\GPO_Install_Log.txt
