# INFO:  Azure PowerShell commands to create a RouteTable based on values from a CSV file
# InputFileName:                  AZURE-GLOBAL-IPs.csv or similmar
# FileFormat - first line:        routeName,addressPrefix,nextHopType,nextHopIp
# FileFormat - remaining lines:   label,CIDR,Internet,   (ex: 1001,13.64.0.0/11,Internet,)
#
# THIS CODE-SAMPLE IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED 
# OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR 
# FITNESS FOR A PARTICULAR PURPOSE.
#
# This sample is not supported under any Microsoft standard support program or service. 
# The script is provided AS IS without warranty of any kind. Microsoft further disclaims all
# implied warranties including, without limitation, any implied warranties of merchantability
# or of fitness for a particular purpose. The entire risk arising out of the use or performance
# of the sample and documentation remains with you. In no event shall Microsoft, its authors,
# or anyone else involved in the creation, production, or delivery of the script be liable for 
# any damages whatsoever (including, without limitation, damages for loss of business profits, 
# business interruption, loss of business information, or other pecuniary loss) arising out of 
# the use of or inability to use the sample or documentation, even if Microsoft has been advised 
# of the possibility of such damages.
################################################################################################

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


