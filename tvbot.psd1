﻿#
# Module manifest for module 'tvbot'
#
# Generated by: Chrissy LeMaire
#

@{

    # Script module or binary module file associated with this manifest.
    RootModule         = 'tvbot.psm1'

    # Version number of this module.
    ModuleVersion      = '0.0.4'

    # ID used to uniquely identify this module
    GUID               = 'd6a499b1-fafd-4911-9b4c-cabd00c11546'

    # Author of this module
    Author             = 'Chrissy LeMaire'

    # Company or vendor of this module
    CompanyName        = ''

    # Copyright statement for this module
    Copyright          = 'Copyright (c) 2020, licensed under MIT'

    # Description of the functionality provided by this module
    Description        = "A pi-friendly bot for your Twitch channel"

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion  = '5.1'

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules    = @("PoshNotify")

    # Assemblies that must be loaded prior to importing this module
    RequiredAssemblies = @()

    # Format files (.ps1xml) to be loaded when importing this module
    FormatsToProcess   = @()

    # Functions to export from this module
    FunctionsToExport  = @(
        'Connect-TvServer',
        'Disconnect-TvServer',
        'Get-TvStatusList',
        'Invoke-TvCommand',
        'Invoke-TvRequest',
        'Join-TvChannel',
        'Send-TvMessage',
        'Split-TvChannel',
        'Start-TvBot',
        'Wait-TvResponse',
        'Watch-TvViewCount'
    )

    # Cmdlets to export from this module
    CmdletsToExport    = @()

    # Variables to export from this module
    VariablesToExport  = @()

    # Aliases to export from this module
    AliasesToExport    = @()

    PrivateData        = @{
        # PSData is module packaging and gallery metadata embedded in PrivateData
        # It's for rebuilding PowerShellGet (and PoshCode) NuGet-style packages
        # We had to do this because it's the only place we're allowed to extend the manifest
        # https://connect.microsoft.com/PowerShell/feedback/details/421837
        PSData = @{
            # The primary categorization of this module (from the TechNet Gallery tech tree).
            Category     = "Messaging & Communication"

            # Keyword tags to help users find this module via navigations and search.
            Tags         = @('twitch', 'bot', 'irc')

            # The web address of an icon which can be used in galleries to represent this module
            IconUri      = "https://user-images.githubusercontent.com/8278033/95674723-6c0fef80-0bb2-11eb-8156-fbb026255c94.png"

            # The web address of this module's project or support homepage.
            ProjectUri   = "https://github.com/potatoqualitee/tvbot"

            # The web address of this module's license. Points to a page that's embeddable and linkable.
            LicenseUri   = "https://opensource.org/licenses/MIT"

            # Release notes for this particular version of the module
            ReleaseNotes = ""

            # If true, the LicenseUrl points to an end-user license (not just a source license) which requires the user agreement before use.
            # RequireLicenseAcceptance = ""

            # Indicates this is a pre-release/testing version of the module.
            IsPrerelease = 'False'
        }
    }
}

