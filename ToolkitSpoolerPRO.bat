@echo off
setlocal enabledelayedexpansion

title Toolkit Spooler PRO - Suporte N2/N3
color 0A

:menu
cls
echo ============================================
echo        TOOLKIT SPOOLER PRO v1.0
echo ============================================
echo.
echo [1] Reset Basico do Spooler
echo [2] Reset Avancado (Dependencias + Limpeza)
echo [3] Verificar Integridade (SFC + DISM)
echo [4] Limpar Drivers de Impressao
echo [5] Status do Spooler
echo [6] Sair
echo.
set /p op=Escolha uma opcao: 

if "%op%"=="1" goto basico
if "%op%"=="2" goto avancado
if "%op%"=="3" goto integridade
if "%op%"=="4" goto drivers
if "%op%"=="5" goto status
if "%op%"=="6" exit

goto menu

:: =============================
:basico
cls
echo [RESET BASICO]
net stop spooler >nul 2>&1
del /q /f /s "%systemroot%\System32\spool\PRINTERS\*.*" >nul 2>&1
net start spooler >nul 2>&1
echo Concluido.
pause
goto menu

:: =============================
:avancado
cls
echo [RESET AVANCADO]

echo Parando spooler...
net stop spooler >nul 2>&1

echo Recriando dependencias...
sc config spooler depend= RPCSS >nul 2>&1

echo Limpando fila...
del /q /f /s "%systemroot%\System32\spool\PRINTERS\*.*" >nul 2>&1

echo Limpando cache de drivers...
del /q /f /s "%systemroot%\System32\spool\drivers\x64\3\*.*" >nul 2>&1

echo Subindo spooler...
net start spooler >nul 2>&1

echo Concluido.
pause
goto menu

:: =============================
:integridade
cls
echo [VERIFICACAO DE INTEGRIDADE]

echo Executando SFC...
sfc /scannow

echo Executando DISM...
DISM /Online /Cleanup-Image /RestoreHealth

echo Concluido.
pause
goto menu

:: =============================
:drivers
cls
echo [LIMPEZA DE DRIVERS]

net stop spooler >nul 2>&1

echo Removendo cache de drivers...
del /q /f /s "%systemroot%\System32\spool\drivers\x64\3\*.*" >nul 2>&1

net start spooler >nul 2>&1

echo Drivers limpos. Pode ser necessario reinstalar impressoras.
pause
goto menu

:: =============================
:status
cls
echo [STATUS DO SPOOLER]
sc query spooler
pause
goto menu