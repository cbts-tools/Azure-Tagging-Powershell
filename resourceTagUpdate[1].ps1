# Description:
#   Update the tags on a list of resources
# USE:
# .\resourceTagUpdate.ps1 <csvfile> <tag> <value>
# NOTE: 
#   CSV file must contain ResourceGroup, Name (of Resource)
#   CSV file exported directly from Azure tends to have "SEP=," at the beginning line
#   Opening with excel and saving or manually going in and deleting this line will remove it. Causes an issue with reading the headers
# resourcegroup is needed to know where to place a new application insight if one does not already exist. If one already exists it will not
# Check that is is in the same resource group. 

if ($args.length -ne 3) {
  write-host "Expected arguments:"
  write-host ".\resourceTagUpdate.ps1 <csvfile> <tag> <value>"
}

# Read input file.  Expected format
# ResourceGroup, ResourceName
$userdata = Import-CSV $args[0] 
$tags = @{}
$tags.add($args[1],$args[2]) # {"ManagedBy"="CBTS"} 

$TotalRows = $userdata.Count
$CurrentRow = 1

ForEach($row in $userdata){ 
    [string]::Format("[Row {0} of {1}] RG={2}, Name={3}",([string] $CurrentRow),([string] $TotalRows),([string] $row.ResourceGroup),([string] $row.Name) )
    #write-host $row.id
    $CurrentRow++
    Update-AzTag -ResourceId ([string] $row.id) -Tag $tags -Operation Merge 
} 

