@ECHO off

git submodule update --init
mkdir artifacts\win32-x86-64
cd argon2
"%ProgramFiles(x86)%\Microsoft Visual Studio\2019\Enterprise\MSBuild\Current\Bin\MSbuild.exe" Argon2.sln /p:Configuration=Release /p:Platform=x64 /m
copy vs2015\build\Argon2OptDll.dll ..\artifacts\win32-x86-64\libargon2.dll
cd ..
