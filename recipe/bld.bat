@echo on

mkdir %LIBRARY_BIN%

:: Windows ARM64 only exists on Windows 10+, where UCRT is always part of the OS.
:: Copy from system to ensure packages can find it in the environment rather than searching PATH.
if "%target_platform%" == "win-arm64" (
    echo ARM64 target detected - copying system UCRT to prevent PATH issues during bootstrapping.
    xcopy "%SystemRoot%\System32\ucrtbase.dll" "%PREFIX%\" || exit /b 1
    xcopy "%SystemRoot%\System32\ucrtbase.dll" "%LIBRARY_BIN%\" || exit /b 1
    exit /b 0
)

%BUILD_PREFIX%/Library/usr/lib/p7zip/7z.exe x 22621.1.220506-1250.ni_release_WindowsSDK.iso -aoa
if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%

msiexec /a "%SRC_DIR%\Installers\Universal CRT Redistributable-x86_en-us.msi" /qb TARGETDIR="%SRC_DIR%\tmp"
if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%

xcopy "tmp\Windows Kits\10\Redist\%PKG_VERSION%\ucrt\DLLs\x64\"* "%PREFIX%"
if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%

xcopy "tmp\Windows Kits\10\Redist\%PKG_VERSION%\ucrt\DLLs\x64\"* "%LIBRARY_BIN%"
if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%
