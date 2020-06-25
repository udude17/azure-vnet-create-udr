# INFO:  Azure PowerShell commands to create a RouteTable based on values from a CSV file
# InputCsvFileName:         none needed - will now create CSV from download uri
#
# URL / URI for cloud environment:
#  - Microsoft Public IP - https://www.microsoft.com/en-us/download/details.aspx?id=53602  https://www.microsoft.com/en-us/download/confirmation.aspx?id=53602
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
) 

Connect-AzAccount
Set-AzContext -SubscriptionId $SubID 

# Download the latest file with the Microsoft global IP ranges
$downloadUrl = "https://www.microsoft.com/en-us/download/confirmation.aspx?id=53602"
$downloadPage = Invoke-WebRequest -Uri $downloadUrl;
$downloadUri = ($downloadPage.RawContent.Split('"') -like "https://*/msft-public-ips.csv")[0];
$downloadfile = Invoke-WebRequest -Uri $downloadUri -OutFile ./msft-public-ips.csv
$CSVfilepath = "./msft-public-ips.csv"
   
# create route array
$routesArray = @()

# ------------------------------------------------------------------
# add routes
#  OLD:  $routes = Import-Csv $routeCsv
$routes = Import-Csv $CSVfilepath
$routename = 1000

foreach ($route in $routes)
{
    $udrRoute = New-AzRouteConfig -Name $routename -NextHopType Internet -AddressPrefix $route.Prefix
    $routesArray += $udrRoute
    $routename = $routename + 1 
}

# Add additional routes as needed
    $udrRoute = New-AzRouteConfig -Name "Proxy-MUC" -NextHopType Internet -NextHopIpAddress $route.nextHopIp -AddressPrefix 160.46.252.0/24
    $routesArray += $udrRoute

# create udr
$udr = New-AzRouteTable -Name $udrName `
    -ResourceGroupName $resourceGroup `
    -Location $location `
    -Route $routesArray

