# azure-vnet-create-udr
Azure PowerShell commands to create an Azure RouteTable based on values from a CSV file.

In the example "viaURI", the script automatically downloads the latest Microsoft Public IP range CSV file.
It also appends an additional sample route in the array before creating the actual UDR

In the example "viaCSV", a CSV file needs to exist in a specific format, as given in this repository. 

