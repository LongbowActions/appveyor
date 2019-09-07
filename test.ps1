function testProj ($target) {
	$projName = "test\$($env:APPVEYOR_PROJECT_NAME).Test"
    write-host "dotnet test $projName -f $target" -ForegroundColor Cyan
    dotnet test $projName -f $target
}

$branch = $($env:APPVEYOR_REPO_BRANCH)
if ($branch -eq "master") {
	testProj net472
	testProj netcoreapp2.2
}
else {
    write-host """$($env:APPVEYOR_REPO_PROVIDER)"" UnitTest has been skipped as environment variable has not matched (""APPVEYOR_REPO_BRANCH"" is ""$($env:APPVEYOR_REPO_BRANCH)"", should be ""master"")" -BackgroundColor yellow -ForegroundColor black
}