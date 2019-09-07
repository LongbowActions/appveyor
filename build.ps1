function packProj () {   
    $branch = $($env:APPVEYOR_REPO_BRANCH)
    $config = "Debug"
    if ($branch -eq "master") {
        $config = "Release"
    }

	$packVersion = $env:APPVEYOR_BUILD_VERSION
    if ($env:APPVEYOR_REPO_BRANCH -ne "master") {
        $packVersion += "-beta"
    }

	$projName = "src\$($env:APPVEYOR_PROJECT_NAME)"

    write-host "dotnet pack $projName -c $config" -ForegroundColor Cyan
    dotnet pack $projName -c $config -p:Version=$packVersion
}

packProj