@echo off&&title Proceso para agilizar cualquier equipo - Creado por: MisterBartra

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo  
	echo   Iniciando los privilegios de Administrador...
    echo  
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
	pushd "%~dp0"
	title Proceso 1: Quitar el detalle de restriction de Internet del QoS
	dir /b %SystemRoot%\servicing\Packages\Microsoft-Windows-GroupPolicy-ClientExtensions-Package~3*.mum >List.txt
	dir /b %SystemRoot%\servicing\Packages\Microsoft-Windows-GroupPolicy-ClientTools-Package~3*.mum >>List.txt
	for /f %%i in ('findstr /i . List.txt 2^>nul') do dism /online /norestart /add-package:"%SystemRoot%\servicing\Packages\%%i"
	echo Configuración de equipo/Plantillas Administrativas/Red/Programador de paquetes QoS
	echo Iniciando el gpedit.msc para hacer el edit del QoS a 100%&&"gpedit.msc"
	title Proceso 2:
	setlocal
	SET /P jumpCCleaner = Instalar CCleaner? (S/N): 
	IF /I "%jumpCCleaner%" NEQ "S" GOTO skipCCleaner
	title Proceso 2: Instalando CCleaner&&echo Instalar el CCleaner, ya está en Descargas&&explorer "https://bits.avcdn.net/productfamily_CCLEANER/insttype_FREE/platform_WIN_PIR/installertype_ONLINE/build_RELEASE/"
	start explorer "%appdata%\..\..\Downloads"
	echo Terminando el proceso de usar CCleaner. Presionar Enter.
	:skipCCleaner
	title Proceso 3: Cosas opcionales
Pause>nul
	title Proceso 3.1: Visor de Windows 7
	setlocal
	SET /P visor= Quieres tener del visualizador de fotos de Windows 7? (S/N): 
	IF /I "%visor%" NEQ "S" GOTO skipVisor
	echo Implementando el Visualizador de fotos del Windows 7 en este Sistema de Windows
	".\assets\Visor de Fotos (Windows 7).exe"
	copy /Y ".\assets\Visor de Fotos (Win 7)\PhotoViewerIcons.dll" "%ProgramFiles(x86)%\Windows Photo Viewer"
	cd ".\assets\Visor de Fotos (Win 7)"
	cmd /K "Visor de Fotos (Win7).cmd"
	cd ..\..
	rd ".\assets\Visor de Fotos (Win 7)" /S /Q
	echo Finalizado el proceso.
	
	:skipVisor

	title Proceso 3.2: Segundos visibles en la barra de tareas
	setlocal
	SET /P seconder= Hacer visibles los segundos en la barra de tareas? (S/N): 
	IF /I "%seconder%" NEQ "S" GOTO skipSeconder
	echo Mostrar segundos en la barra de tareas
	".\assets\ShowSeconds.reg"
	
	:skipSeconder

	title Proceso 3.3: Telemetria de Windows a Microsoft
	setlocal
	SET /P notelemetry= Quisieras ya no mandarle muestras a tiempo real de datos e información que se recopila de toda la sesión actual a Microsoft? (S/N): 
	IF /I "%notelemetry%" NEQ "S" GOTO skipNoTelemetry
	sc config "DiagTrack" start= disabled
	sc config "dmwassetsushservice" start= disabled
	".\assets\notTelemetry.reg"
	echo Desabilitar en Microsoft/Windows/Application Experience
	echo Desabilitar en Microsoft/Windows/Customer Experience Improvement Program
	%windir%\system32\taskschd.msc /s
	
	:skipNoTelemetry

	title Proceso 3.4: Desactivar servicios no tan usados(Se pueden reactivar)
	setlocal
	SET /P noservices= Desabilitar servicios que es muy probable que no uses? (S/N): 
	IF /I "%noservices%" NEQ "S" GOTO skipNoServices
	cmd /K .\assets\disableServices.cmd
	
	:skipNoServices
	
	title Proceso 4: Desinstalar aplicaciones que nunca se usaran
	".\assets\IUninstaller\HiBitPortable.exe"
	::".\assets\IUninstaller\Setup.exe"
	::copy /Y .\assets\IUninstaller\version.dll "%ProgramFiles%\IObit\IObit Uninstaller"
	::copy /Y .\assets\IUninstaller\vcruntime140.dll "%ProgramFiles%\IObit\IObit Uninstaller"
	echo Terminando de usar HiBit Uninstaller. Presionar Enter.
	Pause>nul
	
	title Chequeo de funcionamiento
	echo ===Comprobar si hay errores en el disco===
	chkdsk C: /f
	Pause
	echo ===Comprobar si hay que reparar archivos en Windows===
	sfc /scannow
	Pause
	
	title Proceso 5: Regular programas de auto-startup
	echo Iniciando TaskManager&&"%windir%\system32\taskmgr.exe"
	title Proceso 6: Calibrar detalles no tan necesarios en Rendimiento
	echo Abriendo SystemProperties&&"%windir%\system32\SystemPropertiesAdvanced.exe"
	title Proceso 7: Desactivar características y/o componentes de Windows:
	echo Abriendo OptionalFeatures&&"%windir%\System32\OptionalFeatures.exe"
	setlocal
	SET /P desfrag = Defragmentar disco? (S/N):
	IF /I "%desfrag%" NEQ "S" GOTO skipDefrag
	title Proceso 8: Desfragmentar sistema:&&"%windir%\System32\dfrgui.exe"
	title Proceso 9: Ordenar los sectores del disco
	echo Ahora toca amocodar bien lo escrito en el disco
	echo Si se presentan ven errores en algunos sectores lo consigue solucionar&&explorer "https://files1.majorgeeks.com/10afebdbffcd4742c81a3cb0f6ce4092156b4375/drives/smart-defrag-setup.exe"
	pause
	%appdata%\..\..\Downloads\smart-defrag-setup.exe
	echo Terminando de usar SmartDefrag. Presionar Enter.
	Pause>nul
	:skipDefrag
	".\assets\RAMMap.exe"
	title Proceso 10: Actualizar/Instalar controladores adecuados al computador&&echo Preparando DriverEasy&&".\assets\DriverEasy\DriverEasySetup.exe"
	copy /Y .\assets\DriverEasy\Easeware.Driver.Core.dll "%ProgramFiles%\Easeware\DriverEasy"
	copy /Y .\assets\DriverEasy\DriverEasy.exe "%ProgramFiles%\Easeware\DriverEasy"
	echo Iniciando DriveEasy&&"%ProgramFiles%\Easeware\DriverEasy\DriverEasy.exe"
	title Proceso 11: Removiendo archivos temporales residuales que ya no son usados
	echo --------------------
	echo == Limpiando Local/Temp ==&&rd %appdata%\..\Local\Temp\ /Q /S
	echo --------------------
	echo == Limpiando Windows/Temp ==&&rd %windir%\Temp\ /Q /S
	echo --------------------
	echo == Limpiando Prefetch ==&&rd %windir%\Prefetch\ /Q /S
	bcdedit /set useplatformtick yes
	echo Con esto ya se encuentra mas ligero que antes.
	pause\
	::cmd /K ".\assets\linklist.cmd"
	title Reiniciando...&&echo Reiniciando...&&shutdown /r
	del %appdata%\..\..\Desktop\Optimizador.7z /F /Q
	del %appdata%\..\..\Downloads\Optimizador.7z /F /Q
	cmd /K del ".\" /F /S /Q&&exit
	