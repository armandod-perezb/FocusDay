@echo off
echo ======================================
echo Limpiando proyecto Flutter...
echo ======================================
call flutter clean

echo.
echo ======================================
echo Obteniendo dependencias actualizadas...
echo ======================================
call flutter pub get

echo.
echo ======================================
echo Ejecutando aplicacion...
echo ======================================
call flutter run

pause

