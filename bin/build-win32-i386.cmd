@ECHO off

git submodule update --init
mkdir artifacts\win32-i386
cd argon2
"%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Enterprise\MSBuild\15.0\Bin\MSbuild.exe" Argon2.sln /p:Configuration=Release /p:Platform=x86 /m
copy vs2015\build\Argon2RefDll.dll ..\artifacts\win32-i386\libargon2.dll
cd ..
