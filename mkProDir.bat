@echo off
setlocal enabledelayedexpansion

REM �������Ƿ��ṩ
if "%~1"=="" (
    echo �÷�: %~nx0 [�ļ�·��]
    exit /b 1
)

set "filePath=%~1"
set "parent="
set "parentTmep="

REM ����ļ��Ƿ����
if not exist "%filePath%" (
    echo �ļ� "%filePath%" ������
    exit /b 1
)

REM ��ȡ�ļ��������Կո�ͷ����
for /f "usebackq delims=" %%a in ("%filePath%") do (
    set "countTab=0"
    set "line=%%a"
     
    
    if    "!line:~0,4!"=="    " (
        set /a countTab+=1
        
        if "!line:~4,4!"=="    " ( 
            set /a countTab+=1
            
            if "!line:~8,4!"=="    " (
                set /a countTab+=1

            )
        )

    )
     




        if "!countTab!" == "0" (
            set "parent=!line!"
             
            
        )

        if "!countTab!" == "1" (

            set "parentTmep = !parent!"
            mkdir "!parent!\!line!\"


            echo "!parent!\!line!\"
            set "parent=!line!" 

            
            
            
            
        )
    @REM if "!countTab!" == "2" (
    @REM     @REM  echo "!parent!\!line!\"
          
    @REM )


    @REM if    "!line:~0,4!"=="    " echo !line!
     
)

endlocal


 