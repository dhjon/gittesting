clear-host
$execDir = Split-Path -parent $PSCommandPath

$filesToDeploy = $(ls $(join-path $execDir "\dllsToDeploy")).FullName
$nl = [Environment]::Newline

$promptHelper = $filesToDeploy | %{
    return $($_ + $nl)
}

$ans = read-host "Deploy these files to GAC? $nl $promptHelper (y/n)"

if($ans.ToLower() -eq "y" -or $ans.ToLower() -eq "yes"){
    $filesToDeploy | %{
        $output = .\gacutil.exe -i $_
        
        if($output.Contains("Assembly successfully added to the cache")){
            write-host -fore green -back black Successfully added $_
        }
        else{
            write-host -fore red -back black "Error adding $_"
        }
    }
}
else{
    write-host -fore red -back black "Aborting..."
}