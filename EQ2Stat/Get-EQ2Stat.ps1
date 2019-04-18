<#
.synopsis
Get EQ2 stats for members of your guild

.description
This powershell cmdlet will poll the EverQuest 2 census database
for a specific statistic and return a sorted list of values for 
all the members in your guild.

Version: 1.0.0

.parameter Stat
Specifies the statistic to list for each character

Examples include:
  stats.combat.resolve
  resists.arcane.effective
  skills.focus.totalvalue

For a more detailed listing of what is available see:

  https://census.daybreakgames.com/xml/get/eq2/character/476741691100?c:show=stats,resists,ascension_list,skills

.parameter ServiceId
The Daybreak Census ID to perform your queries through. If you
are going to use this script more than a few time you should 
create your own service ID to help Daybreak track usage. You can
set up your own service ID for free at:

  https://census.daybreakgames.com/#devSignup

.parameter GuildId
This is the Census ID number of your guild.  To find out your guild's 
ID use the following link and use the number at the end of the
returned URL (will be something like 3883992933):

  https://u.eq2wire.com/soe/guild_search

.parameter Ranks
This is an array of rank values from 0 to 7 for the eight ranks
in your guild that you want to include in the output.  Rank 0
is the leader position and rank 7 is the lower rank.  The
format should be as follows to include ranks 0, 1, 3, and 4 and
exclude ranks 2, 5, 6, and 7:

  @(0, 1, 3, 4)

.parameter InactiveAfter
Since a lot of guild ranks for members that haven't logged in
for a while are not updated, this value allows you to set a
window to exclude characters that haven't been logged in
since a specified number of days.

.parameter ExtraIds
This parameter will allow you to add any extra character IDs
to the output. This can be used for out of guild characters
or characters that do not match the specified guild/rank 
combination for whatever reason. For example, the format
should be as follows to include 3 extra characters:

  @(92888192, 909012290, 929991999)

To find out a character's ID use the following link and use
the number at the end of the returned URL:

  https://u.eq2wire.com/soe/character_search

.outputs
  Guild Name string
  Server Name string
  Stat Name string
  CharacterNameStatValue table

.example

.\Get-EQ2Stat.ps1 stat.combat.fervor -GuildId 9812938798 -Ranks @(0, 2, 3)

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

function Get-GuildStats {
  Param($aStat, $aUrl, $aServiceId, $aGuildId, $aRanks, $aInactiveAfter)
  $Json = Invoke-RestMethod -Uri ($aUrl -f $aServiceId, "guild", $aGuildId, 
   "c:resolve=members(last_update,guild.rank,$aStat)")
  $InactiveDate = (Get-Date).AddDays(-$aInactiveAfter)
  $NameValue = [ordered]@{}
  foreach ($Member in $Json.guild_list.member_list) {
    $LoginDate = (Get-Date 01.01.1970).AddSeconds($Member.last_update)
    if (($Member.guild.rank -in $aRanks) -and ($LoginDate -gt $InactiveDate)) {
      $NameValue += @{$Member.Name = [single](Invoke-Expression "`$Member.$aStat")}
    }
  } 
  return $Json.guild_list.name, $Json.guild_list.world, $NameValue
}

function Get-CharacterStat {
  Param($aStat, $aUrl, $aServiceId, $aCharacterId)
  $Json = Invoke-RestMethod -Uri ($aUrl -f $aServiceId, "character", $aCharacterId, "c:show=name.first,$aStat")
  return @{ ($Json.character_list.name.first + " (*)") = [single](Invoke-Expression "`$Json.character_list.$aStat") }
}

# Retrieve and return the list of stat values for the guild and any extra characters
if ($ServiceId) { $ServiceId = '/s:' + $ServiceId }
$BaseUrl = "http://census.daybreakgames.com{0}/json/get/eq2/{1}/{2}?{3}"
$GuildName, $ServerName, $NameValue = Get-GuildStats $Stat $BaseUrl $ServiceId $GuildId $Ranks $InactiveAfter
foreach ($Id in $ExtraIds) { $NameValue += (Get-CharacterStat $Stat $BaseUrl $ServiceId $Id) }
$SortedNameValue = $NameValue.GetEnumerator() | Sort-Object -Property Value -Descending
return $GuildName, $ServerName, $Stat, $SortedNameValue