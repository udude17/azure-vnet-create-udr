
# E:\SCRIPTS\Create-AzureRmUDR   
# Input Filename:  ip-routes.csv

Login-AzureRMAccount 
$SubID  = "<copy azure subscription id here>" 
# Select-AzureRmSubscription –Subscriptionid $SubID 
Set-AzureRmContext -SubscriptionId $SubID 

Param(
    [parameter(mandatory)][string]$udrName,
    [parameter(mandatory)][string]$resourceGroup,
    [parameter(mandatory)][string]$location,
    [parameter(mandatory)][string]$tagName,
    [parameter(mandatory)][string]$tagValue,
    [parameter(mandatory)][string]$routeCsv
) 

#route array

$routesArray = @()

# ------------------------------------------------------------------

#add routes

$routes = Import-Csv $routeCsv

foreach ($route in $routes)
{
    $udrRoute = New-AzureRmRouteConfig -Name $route.routeName -NextHopType $route.nextHopType -NextHopIpAddress $route.nextHopIp -AddressPrefix $route.addressPrefix
    $routesArray += $udrRoute
}


#create udr
# Tag Names used - i.e. can be removed.

$udr = New-AzureRmRouteTable -Name $udrName `
    -ResourceGroupName $resourceGroup `
    -Location $location `
    -Route $routesArray `
    -Tag @{Name=$tagName;Value=$tagValue}
