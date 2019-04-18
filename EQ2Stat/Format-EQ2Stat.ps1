<#
.synopsis
Display formatted EQ2 stats for members of your guild.

"Help .\Get-EQ2Stat.ps1" for more detailed usage and parameter information

Version: 1.0.0

.link
https://github.com/TequilaGold/DBCensus

#>

[CmdletBinding(PositionalBinding=$false)]
param (
  [Parameter(Position=0)]
  [string]$Stat = "stats.combat.resolve",
  [string]$ServiceId = "",
  [long]$GuildId = 0,
  [int[]]$Ranks = @(0, 1, 2, 3),
  [int]$InactiveAfter = 30,
  [long[]]$ExtraIds = @()
  )

# Call Get-EQ2Stat.ps1 passing through all parameters  
$GuildName, $ServerName, $StatName, $NameValue = 
  .\Get-EQ2Stat.ps1 $Stat -ServiceId $ServiceId -GuildId $GuildId -Ranks $Ranks -InactiveAfter $InactiveAfter -ExtraIds $ExtraIds
# Output formatted content 
Write-Host ("`nStat listing for {0} of {1}" -f $GuildName, $ServerName) -ForegroundColor Yellow
$MaxLength = ("{0:n1}" -f ($NameValue | Select-Object Value -First 1).Value).Length
$NameValue | Select-Object @{L="Character";E={$_.Name}}, @{L=$StatName;E={("{0:n1}" -f $_.Value).PadLeft($MaxLength," ")}}