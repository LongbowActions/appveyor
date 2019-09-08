function packProj () {   
    $branch = $($env:APPVEYOR_REPO_BRANCH)
    $config = "Debug"
    if ($branch -eq "master") {
        $config = "Release"
    }

	# download link files
	downloadFiles

	$packVersion = $env:APPVEYOR_BUILD_VERSION
    if ($env:APPVEYOR_REPO_BRANCH -ne "master") {
        $packVersion += "-beta"
    }

	$projName = "src\$($env:APPVEYOR_PROJECT_NAME)"

    write-host "dotnet pack $projName -c $config" -ForegroundColor Cyan
    dotnet pack $projName -c $config -p:Version=$packVersion
}

function downloadFiles () {
	$projectName = $($env:APPVEYOR_PROJECT_NAME)
    $longbow = ("Longbow.Logging","Longbow.Web","Longbow.Data")
	if ($longbow -contains $projectName) {
		downloadFromLongbow
	}
}

function downloadFromLongbow ($file) {
    $repoUrl = "https://github.com/LongbowGroup/Longbow.git"
    write-host "git clone $repoUrl" -ForegroundColor Cyan
	git clone -q --depth=1 --branch=master $repoUrl c:\projects\Longbow
}

function testProj ($target) {
	$projName = "test\$($env:APPVEYOR_PROJECT_NAME).Test"
    write-host "dotnet test $projName -f $target" -ForegroundColor Cyan
    dotnet test $projName -f $target
}

function runUniTest () {
	$branch = $($env:APPVEYOR_REPO_BRANCH)
	if ($branch -eq "master") {
		testProj net472
		testProj netcoreapp2.2
	}
	else {
		write-host """$($env:APPVEYOR_REPO_PROVIDER)"" UnitTest has been skipped as environment variable has not matched (""APPVEYOR_REPO_BRANCH"" is ""$($env:APPVEYOR_REPO_BRANCH)"", should be ""master"")" -BackgroundColor yellow -ForegroundColor black
	}
}

$action = $args[0]

if ($action -eq "UnitTest") {
	runUniTest
}
else {
	packProj
}