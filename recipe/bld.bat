@echo on

mkdir %LIBRARY_BIN%


%BUILD_PREFIX%/Library/usr/lib/p7zip/7z.exe x 22621.1.220506-1250.ni_release_WindowsSDK.iso -aoa
if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%

:: Despite the name, this is the universal CRT redistributable for x86, x64, and arm64
msiexec /a "%SRC_DIR%\Installers\Universal CRT Redistributable-x86_en-us.msi" /qb TARGETDIR="%SRC_DIR%\tmp"
if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%

if "%target_platform%" == "win-arm64" (
    xcopy "tmp\Windows Kits\10\Redist\%PKG_VERSION%\ucrt\DLLs\arm64\"* "%PREFIX%"
    if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%

    xcopy "tmp\Windows Kits\10\Redist\%PKG_VERSION%\ucrt\DLLs\arm64\"* "%LIBRARY_BIN%"
    if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%

) else (

    xcopy "tmp\Windows Kits\10\Redist\%PKG_VERSION%\ucrt\DLLs\x64\"* "%PREFIX%"
    if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%

    xcopy "tmp\Windows Kits\10\Redist\%PKG_VERSION%\ucrt\DLLs\x64\"* "%LIBRARY_BIN%"
    if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%
)


