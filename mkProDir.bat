@echo off
setlocal enabledelayedexpansion

REM 检查参数是否提供
if "%~1"=="" (
    echo 用法: %~nx0 [文件路径]
    exit /b 1
)

set "filePath=%~1"
set "parent="
set "parentTmep="

REM 检查文件是否存在
if not exist "%filePath%" (
    echo 文件 "%filePath%" 不存在
    exit /b 1
)

REM 读取文件并处理以空格开头的行
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


 