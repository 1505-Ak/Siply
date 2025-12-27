@echo off
set DIR=%~dp0
set APP_HOME=%DIR:~0,-1%

set CLASSPATH=%APP_HOME%\gradle\wrapper\gradle-wrapper.jar

if "%JAVA_HOME%" == "" (
    set JAVA_EXE=java
) else (
    set JAVA_EXE=%JAVA_HOME%\bin\java.exe
)

if not exist "%JAVA_EXE%" (
    echo ERROR: JAVA_HOME is not set and no 'java' command could be found in your PATH.>&2
    exit /b 1
)

"%JAVA_EXE%" %DEFAULT_JVM_OPTS% %JAVA_OPTS% -cp "%CLASSPATH%" org.gradle.wrapper.GradleWrapperMain %*


