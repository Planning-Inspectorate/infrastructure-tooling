[CmdletBinding()]
Param(
  [Parameter(Mandatory=$true)]
  [String]$ResourceGroupName,

  [Parameter(Mandatory=$true)]
  [String]$VMScaleSetName,

  [Parameter(Mandatory=$false)]
  [Int]$ExpireHours = 12,

  [Parameter(Mandatory=$false)]
  [Switch]$WhatIf
)

$ScriptName = $MyInvocation.MyCommand.Name
$StartTime = Get-Date

If ($WhatIf) {
  Write-Host "[$ScriptName] WhatIf switch enabled: No changes will be made"
}

Try {
  # Find the name of the image used by the VM Scale Set
  $AgentPool = Get-AzVmss -ResourceGroupName $ResourceGroupName -VMScaleSetName $VMScaleSetName
  $ImageName = ($AgentPool.VirtualMachineProfile.StorageProfile.ImageReference.Id).Split('/')[-1]
  Write-Host "[$ScriptName] VM Scale Set $VMScaleSetName is currently using image $ImageName"

  # Get all Images in the resource group
  $Images = Get-AzImage -ResourceGroupName $ResourceGroupName
  Write-Host "[$ScriptName] Found $($Images.Count) images"

  If ($Images.Count -lt 2) {
    Write-Host "[$ScriptName] Exiting: Nothing to do!"
    Exit 0
  }

} Catch {
  Write-Host "##vso[task.LogIssue type=error;]$($_.Exception.Message)"
  Exit 1
}

$RemovedCount = 0
Foreach ($Image in $Images) {
  # Convert the datestamp in the image name to a DateTime object
  $DateString = ($Image.Name).Split('-')[2]
  $ImageDate = [DateTime]::ParseExact($DateString, 'yyyyMMddHHmmss', $null)

  # Remove any images not in-use by the VM Scale Set and >=24 hours old
  If (!($Image.Name -eq $ImageName) -and ($ImageDate -le $StartTime.AddHours(-$ExpireHours))) {
    Try {
      If ($WhatIf) {
        Write-Host "[$ScriptName] [WhatIf] Would have removed image: $($Image.Name)"
        $RemovedCount++

      } Else {
        Write-Host "Removing image: $($Image.Name)"
        Remove-AzImage -ResourceGroupName $ResourceGroupName -ImageName $Image.Name -Force
        $RemovedCount++
      }

    } Catch {
      Write-Host "##vso[task.LogIssue type=warning;]$($_.Exception.Message)"
      Continue
    }

  } Else {
    Write-Host "[$ScriptName] Skipping image: $($Image.Name)"
  }
}

If ($WhatIf) {
  Write-Host "[$ScriptName] [WhatIf] Would have removed $RemovedCount images"

} Else {
  $RunTime = New-TimeSpan -Start $StartTime -End (Get-Date)
  Write-Host "[$ScriptName] Removed $RemovedCount images"
  Write-Host "[$ScriptName] Script completed in $($RunTime.Minutes) minutes and $($RunTime.Seconds) seconds"
}

Exit 0
