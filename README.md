# Documentation for EQ2 Census PowerShell Scripts

## What's Inside

[EQ2Stat](https://github.com/TequilaGold/DBCensus/tree/master/EQ2Stat) - Ever wanted a sorted listing of a specific statistic for all the raiders in your guild?  The EQ2Stat scripts let you do that with several options to filter based on guild, guild ranks, and last login date.  You can also add individual characters that may not be in guild or otherwise do not meet the normal criteria.

## PowerShell Information

These scripts were tested with the latest version of PowerShell Core (6.2) but should work with most versions of PowerShell back to version 3.0.  If you do not have PowerShell Core installed it can be downloaded from https://github.com/PowerShell/PowerShell.

These scripts use quite a few parameters to configure what you are searching for.  It can save you a lot of time to define default values specific to your needs in your PowerShell profile.  To find out where this file is located type "$Profile" and you'll get something like the following back:

    PS> C:\User\YourName> $Profile
    C:\Users\YourName\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
    PS> C:\User\YourName>

Then you can define default values for your parameters that will be set every time you start up a new PowerShell command prompt.  Make sure to restart PowerShell after editing this script for the changes to take effect.

```PowerShell
# Example default parameter defines
$PSDefaultParameterValues.Add(@{ '*-EQ2Stat.ps1:ServiceId' = "YourServiceId" })
$PSDefaultParameterValues.Add(@{ '*-EQ2Stat.ps1:GuildId' = 987654321 })
$PSDefaultParameterValues.Add(@{ '*-EQ2Stat.ps1:Ranks' = @(0, 1, 3, 4) })
$PSDefaultParameterValues.Add(@{ '*-EQ2Stat.ps1:ExtraIds' = @(123456789012) })
```

## Daybreak Census

Census is Daybreak Game's free service that they offer their gaming communities to access a lot of in-game data from out-of-game applications.  If you are going to use any of these scripts more than a few times you'll need to [apply for a Census API Service Id](https://census.daybreakgames.com/#devSignup) and then use that value for the ServiceId parameter in all of the above scripts.  It's quick, easy and free.

### Limitations of the Census API

* The Census API will not return any data for characters that have their data hidden in their in-game character options.
* Data for characters is usually only updated when a character zones or logs out.  Any changes done to stats (i.e. gear swapping) will not show up while the character is in the same zone.

## Community Census Websites

Census is also used by a few community websites that provide much more detailed (and pretty) information than these scripts can ever hope to provide.

### [EQ2U](https://u.eq2wire.com/)

EQ2U is the go to site if you want to look at any and every detail of characters, guilds, or items.  They also have extensive information on the Census API in their [forums](https://forums.eq2wire.com/forums/census-everquest-ii.268/) that was invaluable in writing these scripts.  Thank you to all that contributed to this community effort to document things.

### [Dragon's Armory](http://www.dragonsarmory.com)

Dragon's Armory provides information in a manner that is aimed more at analyzing and optimizing stats for your characters.

