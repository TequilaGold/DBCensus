# EQ2Stat

These PowerShell cmdlets will poll the EverQuest 2 Census database for a specific statistic and return a sorted list of values for all the members in your guild.  There isn't a lot (or any) error checking in these scripts.  The default error messages returned by PowerShell are quite detailed and usually the problem will be incorrect parameter values or temporary disruption in the Census API availability.

**Get-EQ2Stat.ps1** - This script will perform the Census API query using the defined parameters and return raw data values.  This script is most useful if you want to pipe the data to additional scripts or commands to convert the data to other, more useful formats.

**Format-EQ2Stat.ps1** - This script calls Get-EQ2Stat.ps1 and returns a nicely formatted view of the data.

## Sample Output
```
PS> .\Format-EQ2Stat.ps1 resists.noxious.effective

Stat listing for Advocati Diaboli of Maj'Dul   
                                               
Character    resists.noxious.effective         
---------    -------------------------         
Makya        885,879.0                         
Echoless     883,122.0                         
Itsey        881,389.0                         
Skorchyr     878,356.0                         
Catronia     869,862.0                         
Headbustaz   867,099.0                         
Issolde      863,264.0                         
Liev         860,500.0                         
Sirbuffsalot 853,116.0                         
Nizard       853,099.0                         
Nerotica     844,093.0                         
Zabimaruu    842,885.0                         
Mindripper   841,725.0                         
Deelat       840,474.0                         
Jawlenz      840,292.0                         
Dethstic     835,197.0                         
Kuulei       829,648.0                         
Shikanah     829,513.0                         
Docdoyo      824,779.0                         
Ladaa        823,125.0                         
Ching        821,367.0                         
Gigglicious  819,124.0                         
Eleeviah (*) 812,191.0                         
```

## Parameter: Stat
Specifies the statistic to list for each character. Examples include:
* stats.combat.resolve
* resists.arcane.effective
* skills.focus.totalvalue

You can view a more detailed listing of what is available in this sample [XML Census query](https://census.daybreakgames.com/xml/get/eq2/character/476741691100?c:show=stats,resists,ascension_list,skills).

## Parameter: ServiceId
The Daybreak Census ID to perform your queries through. If you
are going to use this script more than a few time you should 
create your own service ID to help Daybreak track usage. You can
set up your own service ID for free at: https://census.daybreakgames.com/#devSignup

## Parameter: GuildId
This is the Census ID number of your guild.  To find out your guild's 
ID use [EQ2U Guild Search](https://u.eq2wire.com/soe/guild_search) and copy the number at the end of the returned URL (e.g. 3883992933). 

## Parameter: Ranks
This is an array of rank values from 0 to 7 for the eight ranks
in your guild that you want to include in the output.  Rank 0
is the leader position and rank 7 is the lower rank.  The
format should be as follows to include ranks 0, 1, 3, and 4 and
exclude ranks 2, 5, 6, and 7:

    -Ranks @(0, 1, 3, 4)

## Parameter: InactiveAfter
Since a lot of guild ranks for members that haven't logged in
for a while are not updated, this value allows you to set a
window to exclude characters that haven't been logged in
since a specified number of days.

## Parameter: ExtraIds
This parameter will allow you to add any extra character IDs
to the output. This can be used for out of guild characters
or characters that do not match the specified guild/rank 
combination for whatever reason. For example, the format
should be as follows to include 3 extra characters:

    -ExtraIds @(92888192, 909012290, 929991999)

To find out a character's ID use [EQ2U Character Search](https://u.eq2wire.com/soe/character_search) and copy the number at the end of the returned URL.  Characters included with this parameter will have the (*) marker appended to their name in the output.

# Outputs

Get-EQ2Stat will output the following results:

* Guild Name string (e.g. Your Guild Name)
* Server Name string (e.g. Maj'Dul)
* Stat Name string (e.g. stats.combat.resolve)
* CharacterNameStatValue table (sorted IEnumerator() of Name:Value pairs)

Format-EQ2Stat only returns formatted string results for viewing.

# Example

    .\Get-EQ2Stat.ps1 stat.combat.fervor -GuildId 9812938798 -Ranks @(0, 2, 3)

