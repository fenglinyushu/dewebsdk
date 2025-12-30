del *.dcu /s
del ~*.* /s

@echo off
setlocal enabledelayedexpansion

echo Searching and deleting...

set "folders=win32 win64 __history __recovery"
for %%f in (%folders%) do (
    echo Looking for %%f directory...
    for /f "delims=" %%d in ('dir /s /b /ad "%%f" 2^>nul') do (
        if exist "%%d" (
            echo Deleting directory: %%d
            rd /s /q "%%d"
            if errorlevel 1 (
                echo Unable to delete directory: %%d
            ) else (
                echo Directory deleted: %%d
            )
        )
    )
)

echo Operation completed!
pause