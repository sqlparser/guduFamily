echo "build: Build started"

& dotnet --info
& dotnet --list-sdks

Push-Location $PSScriptRoot

if(Test-Path .\artifacts) {
	echo "build: Cleaning .\artifacts"
	Remove-Item .\artifacts -Force -Recurse
}

& dotnet restore --no-cache


echo "build: Package version suffix is $suffix"
echo "build: Build version suffix is $buildSuffix" 

$src = "person"

Push-Location $src

echo "build: Packaging project in $src"

& dotnet build -c Release --no-incremental

Pop-Location


foreach ($test in ls test/*) {
    Push-Location $test

	echo "build: Testing project in $test"

    & dotnet test -c Release
    if($LASTEXITCODE -ne 0) { exit 3 }

    Pop-Location
}
	
Pop-Location