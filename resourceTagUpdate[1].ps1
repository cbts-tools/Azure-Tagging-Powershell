param (
    [string]$csvfile = "C:\Users\Mark\OneDrive - Cincinnati Bell Telephone Company, LLC\repos\Azure-Tagging-Powershell\inputRG.csv",
    [string]$folder = "C:\Users\Mark\OneDrive - Cincinnati Bell Telephone Company, LLC\PowerShell Script Outputs\" 
)
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

$dbg = 1

function mydbg ($msg) {
  if ($dbg -eq 1) {
    Write-Host "Dbg - $msg"
  }
}

#################################################################################
# Load a csv file to get your list of "MANAGED" Resource Groups 
# to process for resources
# Managed Resource Groups contain "ManagedBy:Onx/CBTS" tag on the Resource Group
#################################################################################
function loadManagedResourceGroups{
  $combined_resources = Get-Content -Path $csvfile  | ConvertFrom-Csv 
  
  return $combined_resources
  
  }
  
  
# Read input file.  Expected format
# ResourceGroup, ResourceName
$userdata = loadManagedResourceGroups
$tags = @{}
$tags.add($args[1],$args[2]) # {"ManagedBy"="Onx/CBTS"} 

$TotalRows = $userdata.Count
$CurrentRow = 1

ForEach($row in $userdata){ 
    [string]::Format("[Row {0} of {1}] RG={2}, Name={3}",([string] $CurrentRow),([string] $TotalRows),([string] $row.ResourceGroup),([string] $row.Name) )
    $CurrentRow++
    mydbg (" row.id = ( " + $row.id + " )   tags = ( " + $tags + " )")
    # Update-AzTag -ResourceId ([string] $row.id) -Tag $tags -Operation Merge 
} 

