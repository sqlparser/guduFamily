properties {
  $zipFileName = "Json120r2.zip"
  $majorVersion = "12.0"
  $majorWithReleaseVersion = "12.0.2"
  $nugetPrerelease = $null
  $version = GetVersion $majorWithReleaseVersion
  $packageId = "Newtonsoft.Json"
  $signAssemblies = $false
  $signKeyPath = "C:\Development\Releases\newtonsoft.snk"
  $buildDocumentation = $false
  $buildNuGet = $true
  $msbuildVerbosity = 'minimal'
  $treatWarningsAsErrors = $false
  $workingName = if ($workingName) {$workingName} else {"Working"}
  $assemblyVersion = if ($assemblyVersion) {$assemblyVersion} else {$majorVersion + '.0.0'}
  $netCliChannel = "2.0"
  $netCliVersion = "3.0.100-preview9-013927"
  $nugetUrl = "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe"

  $baseDir  = resolve-path .
  $buildDir = "$baseDir\Build"
  $sourceDir = "$baseDir\person"
  $docDir = "$baseDir\Doc"
  $releaseDir = "$baseDir\Release"
  $workingDir = "$baseDir\$workingName"

  $nugetPath = "$buildDir\Temp\nuget.exe"
  $vswhereVersion = "2.3.2"
  $vswherePath = "$buildDir\Temp\vswhere.$vswhereVersion"
  $nunitConsoleVersion = "3.8.0"
  $nunitConsolePath = "$buildDir\Temp\NUnit.ConsoleRunner.$nunitConsoleVersion"

}

# Ensure a clean working directory
task Clean {
  Write-Host "Setting location to $baseDir"
  Set-Location $baseDir

  if (Test-Path -path $workingDir)
  {
    Write-Host "Deleting existing working directory $workingDir"

    Execute-Command -command { del $workingDir -Recurse -Force }
  }

  Write-Host "Creating working directory $workingDir"
  New-Item -Path $workingDir -ItemType Directory

}

task Build -depends Clean {

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


	Push-Location $sourceDir

	echo "build: Packaging project in $sourceDir"

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
	
}

