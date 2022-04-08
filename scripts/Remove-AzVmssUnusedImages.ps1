[CmdletBinding()]
Param(
  [Parameter(Mandatory=$true)]
  [String]$ResourceGroupName,

  [Parameter(Mandatory=$true)]
  [String]$VMScaleSetName,

  [Parameter(Mandatory=$true)]
  [Int]$ExpireDays,

  [Parameter(Mandatory=$true)]
  [Bool]$FailBuildOnError,

  [Parameter(Mandatory=$false)]
  [Switch]$WhatIf
)

Try {
  # Find the name of the image used by the VM Scale Set
  $AgentPool = Get-AzVmss -ResourceGroupName $ResourceGroupName -VMScaleSetName $VMScaleSetName
  $ImageName = ($AgentPool.VirtualMachineProfile.StorageProfile.ImageReference.Id).Split('/')[-1]
  Write-Host "$VMScaleSetName is currently using image $ImageName"

  # Get all Images in the resource group
  $Images = Get-AzImage -ResourceGroupName $ResourceGroupName
  Write-Host "Found $($Images.Count) images"

  If ($Images.Count -lt 2) {
    Write-Host "Nothing to do!"
    Exit 0
  }

} Catch {
  Write-Host "##vso[task.LogIssue type=error;]$($_.Exception.Message)"
  Exit [Int]$FailBuildOnError
}

# Get todays date for image date comparison
$Today = Get-Date

Foreach ($Image in $Images) {
  # Convert the datestamp in the image name to a DateTime object
  $DateString = ($Image.Name).Split('-')[2]
  $ImageDate = [DateTime]::ParseExact($DateString, 'yyyyMMddHHmmss', $null)

  # Remove any images not in-use by the VM Scale Set and >=24 hours old
  $RemovedCount = 0
  If ( !($Image.Name -eq $ImageName) -and ($ImageDate -le $Today.AddDays(-$ExpireDays)) ) {
    Try {
      If ($WhatIf) {
        Write-Host "Removing image: $($Image.Name)"
        Remove-AzImage -ResourceGroupName $ResourceGroupName -ImageName $Image.Name -Force
        $RemovedCount++

      } Else {
        Write-Host "[WhatIf] Would have removed image: $($Image.Name)"
        $RemovedCount++
      }

    } Catch {
      Write-Host "##vso[task.LogIssue type=warning;]$($_.Exception.Message)"
      Continue
    }
  }
}

If ($WhatIf) {
  Write-Host "Task complete: Removed $RemovedCount images"

} Else {
  Write-Host "[WhatIf] Would have removed $RemovedCount images"
}

Exit 0
