# INFO:  Azure PowerShell commands to create a RouteTable based on values from a CSV file
# InputFileName:                  AZURE-GLOBAL-IPs.csv or similmar
# FileFormat - first line:        routeName,addressPrefix,nextHopType,nextHopIp
# FileFormat - remaining lines:   label,CIDR,Internet,   (ex: 1001,13.64.0.0/11,Internet,)

Param(
    [parameter(mandatory)][string]$SubID,
    [parameter(mandatory)][string]$udrName,
    [parameter(mandatory)][string]$resourceGroup,
    [parameter(mandatory)][string]$location,
    [parameter(mandatory)][string]$tagName,
    [parameter(mandatory)][string]$tagValue,
    [parameter(mandatory)][string]$routeCsv
) 

Connect-AzAccount
Set-AzContext -SubscriptionId $SubID 


#route array

$routesArray = @()

# ------------------------------------------------------------------

#add routes
 
$routes = Import-Csv $routeCsv

foreach ($route in $routes)
{
    $udrRoute = New-AzRouteConfig -Name $route.routeName -NextHopType $route.nextHopType -NextHopIpAddress $route.nextHopIp -AddressPrefix $route.addressPrefix
    $routesArray += $udrRoute
}


#create udr

$udr = New-AzRouteTable -Name $udrName `
    -ResourceGroupName $resourceGroup `
    -Location $location `
    -Route $routesArray `
    -Tag @{Name=$tagName;Value=$tagValue}


