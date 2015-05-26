import-module WebAdministration
$appPoolName = read-host 'Please enter AppPool name'
$appPoolDotNetVersion = read-host 'Please enter the version of dot net to use (E.G. v4.0)'
$siteName = read-host 'Please enter the site name'
$appName = read-host 'Please enter the application name'
$directoryPath = read-host 'Please enter the directory to use'

cd IIS:\AppPools\
if(!(test-path $appPoolName -pathtype Container))
{
    echo 'Creating specified AppPool'
    $appPool = new-item $appPoolName
    $appPool | set-itemproperty -name 'managedRuntimeVersion' -value $appPoolDotNetVersion
    echo 'Done'
}
else
{
    echo 'The application pool specified already exists... using existing app pool'
}

cd IIS:\Sites\
if(!(test-path $siteName -pathtype Container))
{
    echo 'Creating specified site'
    $site = new-item $siteName -bindings @{protocol='http';bindingInformation=':80:' + $appPoolName} -physicalPath $directoryPath
    $site | set-itemproperty -name 'applicationPool' -value $appPoolName
    echo 'Done'
}
else
{
    echo 'The site namespace already exists... using existing website'
}
if((get-webapplication -name $appName) -eq $null)
{
    echo 'Creating web application'
    new-webapplication -name $appName -applicationpool $appPoolName -site $siteName -physicalPath $directoryPath
    echo 'Done'
}
else
{
    echo 'There is already an application with the name: ' + $appName
}