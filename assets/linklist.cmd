explorer "https://mirror.cedia.org.ec/videolan/vlc/3.0.18/win32/vlc-3.0.18-win32.exe"
explorer "https://download.oracle.com/java/17/archive/jdk-17.0.6_windows-x64_bin.exe"

echo Los archivos autodescargados se abrirán si se presiona una tecla.
Pause>nul
"%appdata%\..\..\Downloads\vlc-3.0.18-win32.exe"
"%appdata%\..\..\Downloads\jdk-17.0.6_windows-x64_bin.exe"
exit