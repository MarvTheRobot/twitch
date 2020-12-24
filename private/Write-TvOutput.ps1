function Write-TvOutput {
    <#
    .SYNOPSIS
        This command parses output from the server and writes it to console

    .DESCRIPTION
        This command parses output from the server and writes it to console

    .PARAMETER InputObject
        The data from the server

    .PARAMETER Channel
        The channel to post to

    .PARAMETER Owner
        The admins of the bot

    .EXAMPLE
        PS> Wait-TvInput
    #>
    [CmdletBinding()]
    Param (
        [parameter(Mandatory)]
        [string]$InputObject,
        [string]$Channel = $script:Channel,
        [string[]]$Owner = $script:Owner,
        [ValidateSet("chat", "leave", "join")]
        [string[]]$Notify
    )
    process {
        if (-not $writer.BaseStream) {
            throw "Have you connected to a server using Connect-TvServer?"
        }

        $irctagregex = [Regex]::new('^(?:@([^ ]+) )?(?:[:]((?:(\w+)!)?\S+) )?(\S+)(?: (?!:)(.+?))?(?: [:](.+))?$')
        $match = $irctagregex.Match($InputObject) #tags = 1
        $prefix = $match.Groups[2].Value
        $user = $match.Groups[3].Value
        $command = $match.Groups[4].Value
        $params = $match.Groups[5].Value
        $message = $match.Groups[6].Value

        Write-Verbose $InputObject
        # format it
        switch ($command) {
            "PRIVMSG" {
                if ($message) {
                    if ($user) {
                        $hash = @{}
                        $InputObject.split(';') | ForEach-Object {
                            $split = $PSItem.Split('=')
                            $key = $split[0]
                            $value = $split[1]
                            $hash.Add($key,$value)
                        }
                        $displayname = $hash["display-name"]
                        Write-Verbose "Display name: $displayname"
                        Write-Output "[$(Get-Date)] <$user> $message"

                        if ($Notify -contains "chat") {
                            if ($message) {
                                try {
                                    # THANK YOU @vexx32!
                                    $string = ($message -replace '\x01').Replace("ACTION ", "")
                                    $id = "tvbot"
                                    $image = (Resolve-Path "$script:ModuleRoot\icon.png")

                                    if ($script:burnt) {
                                        if ($script:cache[$user]) {
                                            $image = $script:cache[$user]
                                        } else {
                                            $avatar = Invoke-TvRequest -Path /users?login=$user
                                            $image = $avatar.data.profile_image_url
                                            $script:cache[$user] = $image
                                        }
                                        $existingtoast = Get-BTHistory -UniqueIdentifier $id
                                        if ($existingtoast) {
                                            Remove-BTNotification -Tag $id -Group $id
                                        }
                                        New-BurntToastNotification -AppLogo $image -Text $displayname, $string -UniqueIdentifier $id
                                    } else {
                                        $string = [System.Security.SecurityElement]::Escape($message)
                                        Send-OSNotification -Title $user -Body $string -Icon $image -ErrorAction Stop
                                    }
                                } catch {
                                    $_
                                }
                            }
                        }
                    } else {
                        Write-Output "[$(Get-Date)] > $message"
                    }
                    Invoke-TvCommand -InputObject $message -Channel $script:Channel -Owner $Owner -User $user
                }
            }
            "JOIN" {
                Write-Output "[$(Get-Date)] *** $user has joined #$script:Channel"

                if ($Notify -contains "join") {
                    Send-OSNotification -Title $user -Body "$user has joined" -Icon (Resolve-Path "$script:ModuleRoot\icon.png")
                }
            }
            "PART" {
                Write-Output "[$(Get-Date)] *** $user has left #$script:Channel"

                if ($Notify -contains "leave") {
                    Send-OSNotification -Title $user -Body "$user has has left" -Icon (Resolve-Path "$script:ModuleRoot\icon.png")
                }
            }
            "PING" {
                $script:ping = [DateTime]::Now
                Send-Server -Message "PONG"
            }
            353 {
                $members = $message.Split(" ")
                if ($members.Count -le 100) {
                    Write-Output "[$(Get-Date)] > Current user list:"
                    foreach ($member in $members) {
                        Write-Output "  $member"
                    }
                } else {
                    Write-Verbose "[$(Get-Date)] > Current user list:"
                    foreach ($member in $members) {
                        Write-Verbose "  $member"
                    }
                }
            }
            { $psitem.Trim() -in 001, 002, 003, 372 } {
                Write-Output "[$(Get-Date)] > $message"
            }
            default {
                Write-Verbose "[$(Get-Date)] command: $command"
                Write-Verbose "[$(Get-Date)] message: $message"
                Write-Verbose "[$(Get-Date)] params: $params"
                Write-Verbose "[$(Get-Date)] prefix: $prefix"
                Write-Verbose "[$(Get-Date)] user: $user"
            }
        }
    }
}