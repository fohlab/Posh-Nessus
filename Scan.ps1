#region Scans
####################################################################

<#
.Synops
   Pause a running scan on a Nessus server.
.DESCRIPTION
   Pause a running scan on a Nessus server.
.EXAMPLE
    Suspend-NessusScan -SessionId 0 -ScanId 46


    Name            : Whole Lab
    ScanId          : 46
    Status          : running
    Enabled         : 
    Owner           : carlos
    AlternateTarget : 
    IsPCI           : 
    UserPermission  : 
    CreationDate    : 2/24/2015 6:17:11 AM
    LastModified    : 2/24/2015 6:17:11 AM
    StartTime       : 12/31/1969 8:00:00 PM

    PS C:\> Get-NessusScan -SessionId 0 -Status Paused


    Name           : Whole Lab
    ScanId         : 46
    Status         : paused
    Enabled        : False
    FolderId       : 2
    Owner          : carlos
    UserPermission : 
    Rules          : 
    Shared         : False
    TimeZone       : 
    CreationDate   : 2/24/2015 6:17:11 AM
    LastModified   : 2/24/2015 6:22:17 AM
    StartTime      : 12/31/1969 8:00:00 PM
#>
function Suspend-NessusScan
{
    [CmdletBinding()]
    Param
    (
        # Nessus session Id
        [Parameter(Mandatory=$true,
                   Position=0,
                   ValueFromPipelineByPropertyName=$true)]
        [Alias('Index')]
        [int32[]]
        $SessionId = @(),

        [Parameter(Mandatory=$false,
                   Position=1,
                   ValueFromPipelineByPropertyName=$true)]
        [int32]
        $ScanId 
    )

    Begin
    {
        $origin = New-Object -Type DateTime -ArgumentList 1970, 1, 1, 0, 0, 0, 0
    }
    Process
    {
        $ToProcess = @()

        foreach($i in $SessionId)
        {
            $Connections = $Global:NessusConn
            
            foreach($Connection in $Connections)
            {
                if ($Connection.SessionId -eq $i)
                {
                    $ToProcess += $Connection
                }
            }
        }
        
        foreach($Connection in $ToProcess)
        {
            $Scans =  InvokeNessusRestRequest -SessionObject $Connection -Path "/scans/$($ScanId)/pause" -Method 'Post'

            if ($Scans -is [psobject])
            {
                $scan = $Scans.scan
                $ScanProps = [ordered]@{}
                $ScanProps.add('Name', $scan.name)
                $ScanProps.add('ScanId', $ScanId)
                $ScanProps.add('HistoryId', $scan.id)
                $ScanProps.add('Status', $scan.status)
                $ScanProps.add('Enabled', $scan.enabled)
                $ScanProps.add('Owner', $scan.owner)
                $ScanProps.add('AlternateTarget', $scan.ownalt_targetser)
                $ScanProps.add('IsPCI', $scan.is_pci)
                $ScanProps.add('UserPermission', $PermissionsId2Name[$scan.user_permissions])
                $ScanProps.add('CreationDate', $origin.AddSeconds($scan.creation_date).ToLocalTime())
                $ScanProps.add('LastModified', $origin.AddSeconds($scan.last_modification_date).ToLocalTime())
                $ScanProps.add('StartTime', $origin.AddSeconds($scan.starttime).ToLocalTime())
                $ScanProps.Add('SessionId', $Connection.SessionId)
                $ScanObj = New-Object -TypeName psobject -Property $ScanProps
                $ScanObj.pstypenames[0] = 'Nessus.RunninScan'
                $ScanObj
            }
        }
    }
    End{}
}


<#
.Synopsis
   Resume a paused scan on a Nessus server.
.DESCRIPTION
   Resume a paused scan on a Nessus server.
.EXAMPLE
   Resume-NessusScan -SessionId 0 -ScanId 46


    Name            : Whole Lab
    ScanId          : 46
    Status          : paused
    Enabled         : 
    Owner           : carlos
    AlternateTarget : 
    IsPCI           : 
    UserPermission  : 
    CreationDate    : 2/24/2015 6:17:11 AM
    LastModified    : 2/24/2015 6:17:11 AM
    StartTime       : 12/31/1969 8:00:00 PM




    PS C:\> Get-NessusScan -SessionId 0 -Status Running


    Name           : Whole Lab
    ScanId         : 46
    Status         : running
    Enabled        : False
    FolderId       : 2
    Owner          : carlos
    UserPermission : 
    Rules          : 
    Shared         : False
    TimeZone       : 
    CreationDate   : 2/24/2015 6:17:11 AM
    LastModified   : 2/24/2015 6:25:34 AM
    StartTime      : 12/31/1969 8:00:00 PM
#>
function Resume-NessusScan
{
    [CmdletBinding()]
    Param
    (
        # Nessus session Id
        [Parameter(Mandatory=$true,
                   Position=0,
                   ValueFromPipelineByPropertyName=$true)]
        [Alias('Index')]
        [int32[]]
        $SessionId = @(),

        [Parameter(Mandatory=$true,
                   Position=1,
                   ValueFromPipelineByPropertyName=$true)]
        [int32]
        $ScanId 
    )

    Begin
    {
        $origin = New-Object -Type DateTime -ArgumentList 1970, 1, 1, 0, 0, 0, 0
    }
    Process
    {
        $ToProcess = @()

        foreach($i in $SessionId)
        {
            $Connections = $Global:NessusConn
            
            foreach($Connection in $Connections)
            {
                if ($Connection.SessionId -eq $i)
                {
                    $ToProcess += $Connection
                }
            }
        }
        

        foreach($Connection in $ToProcess)
        {
            $Scans =  InvokeNessusRestRequest -SessionObject $Connection -Path "/scans/$($ScanId)/resume" -Method 'Post'

            if ($Scans -is [psobject])
            {
                $scan = $Scans.scan
                $ScanProps = [ordered]@{}
                $ScanProps.add('Name', $scan.name)
                $ScanProps.add('ScanId', $ScanId)
                $ScanProps.add('HistoryId', $scan.id)
                $ScanProps.add('Status', $scan.status)
                $ScanProps.add('Enabled', $scan.enabled)
                $ScanProps.add('Owner', $scan.owner)
                $ScanProps.add('AlternateTarget', $scan.ownalt_targetser)
                $ScanProps.add('IsPCI', $scan.is_pci)
                $ScanProps.add('UserPermission', $PermissionsId2Name[$scan.user_permissions])
                $ScanProps.add('CreationDate', $origin.AddSeconds($scan.creation_date).ToLocalTime())
                $ScanProps.add('LastModified', $origin.AddSeconds($scan.last_modification_date).ToLocalTime())
                $ScanProps.add('StartTime', $origin.AddSeconds($scan.starttime).ToLocalTime())
                $ScanProps.Add('SessionId', $Connection.SessionId)
                $ScanObj = New-Object -TypeName psobject -Property $ScanProps
                $ScanObj.pstypenames[0] = 'Nessus.RunningScan'
                $ScanObj
            }
        }
    }
    End
    {
    }
}


<#
.Synopsis
   Cancel a scan on a Nessus server.
.DESCRIPTION
   Cancel a scan on a Nessus server.
.EXAMPLE
   Stop-NessusScan -SessionId 0 -ScanId 46


    Name            : Whole Lab
    ScanId          : 46
    Status          : running
    Enabled         : 
    Owner           : carlos
    AlternateTarget : 
    IsPCI           : 
    UserPermission  : 
    CreationDate    : 2/24/2015 6:17:11 AM
    LastModified    : 2/24/2015 6:17:11 AM
    StartTime       : 12/31/1969 8:00:00 PM




    PS C:\> Get-NessusScan -SessionId 0 


    Name           : Whole Lab
    ScanId         : 46
    Status         : canceled
    Enabled        : False
    FolderId       : 2
    Owner          : carlos
    UserPermission : 
    Rules          : 
    Shared         : False
    TimeZone       : 
    CreationDate   : 2/24/2015 6:17:11 AM
    LastModified   : 2/24/2015 6:27:20 AM
    StartTime      : 12/31/1969 8:00:00 PM

#>
function Stop-NessusScan
{
    [CmdletBinding()]
    Param
    (
        # Nessus session Id
        [Parameter(Mandatory=$true,
                   Position=0,
                   ValueFromPipelineByPropertyName=$true)]
        [Alias('Index')]
        [int32[]]
        $SessionId = @(),

        [Parameter(Mandatory=$true,
                   Position=1,
                   ValueFromPipelineByPropertyName=$true)]
        [int32]
        $ScanId 
    )

    Begin
    {
        $origin = New-Object -Type DateTime -ArgumentList 1970, 1, 1, 0, 0, 0, 0
    }
    Process
    {
        $ToProcess = @()

        foreach($i in $SessionId)
        {
            $Connections = $Global:NessusConn
            
            foreach($Connection in $Connections)
            {
                if ($Connection.SessionId -eq $i)
                {
                    $ToProcess += $Connection
                }
            }
        }
        

        foreach($Connection in $ToProcess)
        {
            $Scans =  InvokeNessusRestRequest -SessionObject $Connection -Path "/scans/$($ScanId)/stop" -Method 'Post'

            if ($Scans -is [psobject])
            {
                $scan = $Scans.scan
                $ScanProps = [ordered]@{}
                $ScanProps.add('Name', $scan.name)
                $ScanProps.add('ScanId', $ScanId)
                $ScanProps.add('HistoryId', $scan.id)
                $ScanProps.add('Status', $scan.status)
                $ScanProps.add('Enabled', $scan.enabled)
                $ScanProps.add('Owner', $scan.owner)
                $ScanProps.add('AlternateTarget', $scan.ownalt_targetser)
                $ScanProps.add('IsPCI', $scan.is_pci)
                $ScanProps.add('UserPermission', $PermissionsId2Name[$scan.user_permissions])
                $ScanProps.add('CreationDate', $origin.AddSeconds($scan.creation_date).ToLocalTime())
                $ScanProps.add('LastModified', $origin.AddSeconds($scan.last_modification_date).ToLocalTime())
                $ScanProps.add('StartTime', $origin.AddSeconds($scan.starttime).ToLocalTime())
                $ScanProps.Add('SessionId', $Connection.SessionId)
                $ScanObj = New-Object -TypeName psobject -Property $ScanProps
                $ScanObj.pstypenames[0] = 'Nessus.RunningScan'
                $ScanObj
            }
        }
    }
    End
    {
    }
}


<#
.Synopsis
   Launch a scan on a Nessus server.
.DESCRIPTION
   Launch a scan on a Nessus server.
.EXAMPLE
   Start-NessusScan -SessionId 0 -ScanId 15 -AlternateTarget 192.168.11.11,192.168.11.12

    ScanUUID                                                                                                                                                                 
    --------                                                                                                                                                                 
    70aff007-3e61-242f-e90c-ee96ace62ca57ea8eb669c32205a                                                                                                                     



    PS C:\> Get-NessusScan -SessionId 0 -Status Running


    Name           : Lab1
    ScanId         : 15
    Status         : running
    Enabled        : True
    FolderId       : 2
    Owner          : carlos
    UserPermission : Sysadmin
    Rules          : 
    Shared         : False
    TimeZone       : 
    CreationDate   : 2/25/2015 7:39:49 PM
    LastModified   : 2/25/2015 7:40:28 PM
    StartTime      : 12/31/1969 8:00:00 PM
#>
function Start-NessusScan
{
    [CmdletBinding()]
    Param
    (
        # Nessus session Id
        [Parameter(Mandatory=$true,
                   Position=0,
                   ValueFromPipelineByPropertyName=$true)]
        [Alias('Index')]
        [int32[]]
        $SessionId = @(),

        [Parameter(Mandatory=$true,
                   Position=1,
                   ValueFromPipelineByPropertyName=$true)]
        [int32]
        $ScanId,

        [Parameter(Mandatory=$false,
                   Position=2,
                   ValueFromPipelineByPropertyName=$true)]
        [string[]]
        $AlternateTarget 
    )

    Begin
    {
        $origin = New-Object -Type DateTime -ArgumentList 1970, 1, 1, 0, 0, 0, 0
    }
    Process
    {
        $ToProcess = @()

        foreach($i in $SessionId)
        {
            $Connections = $Global:NessusConn
            
            foreach($Connection in $Connections)
            {
                if ($Connection.SessionId -eq $i)
                {
                    $ToProcess += $Connection
                }
            }
        }
        $Params = @{}

        if($AlternateTarget)
        {
            $Params.Add('alt_targets', $AlternateTarget)
        }
        $paramJson = ConvertTo-Json -InputObject $params -Compress

        foreach($Connection in $ToProcess)
        {
            $Scans =  InvokeNessusRestRequest -SessionObject $Connection -Path "/scans/$($ScanId)/launch" -Method 'Post' -Parameter $paramJson

            if ($Scans -is [psobject])
            {

                $ScanProps = [ordered]@{}
                $ScanProps.add('ScanUUID', $scans.scan_uuid)
                $ScanProps.add('ScanId', $ScanId)
                $ScanProps.add('SessionId', $Connection.SessionId)
                $ScanObj = New-Object -TypeName psobject -Property $ScanProps
                $ScanObj.pstypenames[0] = 'Nessus.LaunchedScan'
                $ScanObj
            }
        }
    }
    End
    {
    }
}


<#
.Synopsis
   Get scans present on a Nessus server.
.DESCRIPTION
   Get scans present on a Nessus server.
.EXAMPLE
    Get-NessusScan -SessionId 0 -Status Completed


    Name           : Lab Domain Controller Audit
    ScanId         : 61
    Status         : completed
    Enabled        : False
    FolderId       : 2
    Owner          : carlos
    UserPermission : Sysadmin
    Rules          : 
    Shared         : False
    TimeZone       : 
    CreationDate   : 2/25/2015 2:45:53 PM
    LastModified   : 2/25/2015 2:46:34 PM
    StartTime      : 12/31/1969 8:00:00 PM

    Name           : Whole Lab
    ScanId         : 46
    Status         : completed
    Enabled        : False
    FolderId       : 2
    Owner          : carlos
    UserPermission : Sysadmin
    Rules          : 
    Shared         : False
    TimeZone       : 
    CreationDate   : 2/24/2015 6:32:45 AM
    LastModified   : 2/24/2015 6:46:20 AM
    StartTime      : 12/31/1969 8:00:00 PM

    Name           : Lab1
    ScanId         : 15
    Status         : completed
    Enabled        : True
    FolderId       : 2
    Owner          : carlos
    UserPermission : Sysadmin
    Rules          : 
    Shared         : False
    TimeZone       : 
    CreationDate   : 2/18/2015 5:40:54 PM
    LastModified   : 2/18/2015 5:41:01 PM
    StartTime      : 12/31/1969 8:00:00 PM

    Name           : Lab2
    ScanId         : 17
    Status         : completed
    Enabled        : False
    FolderId       : 2
    Owner          : carlos
    UserPermission : Sysadmin
    Rules          : 
    Shared         : False
    TimeZone       : 
    CreationDate   : 2/13/2015 9:12:31 PM
    LastModified   : 2/13/2015 9:19:04 PM
    StartTime      : 12/31/1969 8:00:00 PM
#>
function Get-NessusScan
{
    [CmdletBinding()]
    Param
    (
        # Nessus session Id
        [Parameter(Mandatory=$true,
                   Position=0,
                   ValueFromPipelineByPropertyName=$true)]
        [Alias('Index')]
        [int32[]]
        $SessionId = @(),

        [Parameter(Mandatory=$false,
                   Position=1,
                   ValueFromPipelineByPropertyName=$true)]
        [int32]
        $FolderId,

        [Parameter(Mandatory=$false,
                   Position=2,
                   ValueFromPipelineByPropertyName=$true)]
        [string]
        $Name,

        [Parameter(Mandatory=$false,
                   Position=3,
                   ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('Completed', 'Imported', 'Running', 'Paused', 'Canceled')]
        [string]
        $Status
    )

    Begin
    {
        $origin = New-Object -Type DateTime -ArgumentList 1970, 1, 1, 0, 0, 0, 0
    }
    Process
    {
        $ToProcess = @()

        foreach($i in $SessionId)
        {
            $Connections = $Global:NessusConn
            
            foreach($Connection in $Connections)
            {
                if ($Connection.SessionId -eq $i)
                {
                    $ToProcess += $Connection
                }
            }
        }
        $Params = @{}

        if($FolderId)
        {
            $Params.Add('folder_id', $FolderId)
        }

        foreach($Connection in $ToProcess)
        {
            $Scans =  InvokeNessusRestRequest -SessionObject $Connection -Path '/scans' -Method 'Get' -Parameter $Params

            if ($Scans -is [psobject])
            {
                
                if($Status.length -gt 0)
                {
                    $Scans2Process = $Scans.scans | Where-Object {$_.status -eq $Status.ToLower()}
                }
                else
                {
                    $Scans2Process = $Scans.scans
                }

                if ($Name.Length -gt 0)
                {
                    $Scans2Process = $Scans2Process | Where-Object {$_.name -eq $Name}
                }

                foreach ($scan in $Scans2Process)
                {
                    $ScanProps = [ordered]@{}
                    $ScanProps.add('Name', $scan.name)
                    $ScanProps.add('ScanId', $scan.id)
                    $ScanProps.add('Status', $scan.status)
                    $ScanProps.add('Enabled', $scan.enabled)
                    $ScanProps.add('FolderId', $scan.folder_id)
                    $ScanProps.add('Owner', $scan.owner)
                    $ScanProps.add('UserPermission', $PermissionsId2Name[$scan.user_permissions])
                    $ScanProps.add('Rules', $scan.rrules)
                    $ScanProps.add('Shared', $scan.shared)
                    $ScanProps.add('TimeZone', $scan.timezone)
                    $ScanProps.add('Scheduled', $scan.control)
                    $ScanProps.add('DashboardEnabled', $scan.use_dashboard)
                    $ScanProps.Add('SessionId', $Connection.SessionId)                 
                    $ScanProps.add('CreationDate', $origin.AddSeconds($scan.creation_date).ToLocalTime())
                    $ScanProps.add('LastModified', $origin.AddSeconds($scan.last_modification_date).ToLocalTime())

                    if ($scan.starttime -cnotlike "*T*")
                    {
                        $ScanProps.add('StartTime', $origin.AddSeconds($scan.starttime).ToLocalTime())
                    }
                    else
                    {
                        $StartTime = [datetime]::ParseExact($scan.starttime,"yyyyMMddTHHmmss",
                                     [System.Globalization.CultureInfo]::InvariantCulture,
                                     [System.Globalization.DateTimeStyles]::None)
                        $ScanProps.add('StartTime', $StartTime)
                    }
                    $ScanObj = New-Object -TypeName psobject -Property $ScanProps
                    $ScanObj.pstypenames[0] = 'Nessus.Scan'
                    $ScanObj
                }
            }
        }
    }
    End
    {
    }
}


<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Export-NessusScan
{
    [CmdletBinding()]
    Param
    (
       # Nessus session Id
        [Parameter(Mandatory=$true,
                   Position=0,
                   ValueFromPipelineByPropertyName=$true)]
        [Alias('Index')]
        [int32[]]
        $SessionId = @(),

        [Parameter(Mandatory=$true,
                   Position=1,
                   ValueFromPipelineByPropertyName=$true)]
        [int32]
        $ScanId,

        [Parameter(Mandatory=$true,
                   Position=2,
                   ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('Nessus', 'HTML', 'PDF', 'CSV', 'DB')]
        [string]
        $Format,

        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [String]
        $OutFile,

        [Parameter(Mandatory=$false,
                   Position=3,
                   ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('Vuln_Hosts_Summary', 'Vuln_By_Host', 
                     'Compliance_Exec', 'Remediations', 
                     'Vuln_By_Plugin', 'Compliance', 'All')]
        [string[]]
        $Chapters,

        [Parameter(Mandatory=$false,
                   Position=4,
                   ValueFromPipelineByPropertyName=$true)]
        [Int32]
        $HistoryID,

        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true)]
        [securestring]
        $Password

    )

    Begin
    {
    }
    Process
    {
        $ToProcess = @()

        foreach($i in $SessionId)
        {
            $Connections = $Global:NessusConn
            
            foreach($Connection in $Connections)
            {
                if ($Connection.SessionId -eq $i)
                {
                    $ToProcess += $Connection
                }
            }
        }

        $ExportParams = @{}

        if($Format -eq 'DB' -and $Password)
        {
            $Credentials = New-Object System.Management.Automation.PSCredential -ArgumentList 'user', $Password
            $ExportParams.Add('password', $Credentials.GetNetworkCredential().Password)
        }

        if($Format)
        {
            $ExportParams.Add('format', $Format.ToLower())
        }

        if($Chapters)
        {
            if ($Chapters -contains 'All') 
            {
                $ExportParams.Add('chapters', 'vuln_hosts_summary;vuln_by_host;compliance_exec;remediations;vuln_by_plugin;compliance')
            }
            else
            {           
                $ExportParams.Add('chapters',$Chapters.ToLower())
            }       
        }

        foreach($Connection in $ToProcess)
        {
            $path =  "/scans/$($ScanId)/export"
            Write-Verbose -Message "Exporting scan with Id of $($ScanId) in $($Format) format."
            $FileID = InvokeNessusRestRequest -SessionObject $Connection -Path $path  -Method 'Post' -Parameter $ExportParams
            if ($FileID -is [psobject])
            {
                $FileStatus = ''
                while ($FileStatus.status -ne 'ready')
                {
                    try
                    {
                        $FileStatus = InvokeNessusRestRequest -SessionObject $Connection -Path "/scans/$($ScanId)/export/$($FileID.file)/status"  -Method 'Get'
                        Write-Verbose -Message "Status of export is $($FileStatus.status)"
                    }
                    catch
                    {
                        break
                    }
                    Start-Sleep -Seconds 1
                }
                if ($FileStatus.status -eq 'ready')
                {
                    Write-Verbose -Message "Downloading report to $($OutFile)"
                    InvokeNessusRestRequest -SessionObject $Connection -Path "/scans/$($ScanId)/export/$($FileID.file)/download" -Method 'Get' -OutFile $OutFile
                }
            }
        }
    }
    End
    {
    }
}


<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Show-NessusScanDetail
{
    [CmdletBinding()]
    Param
    (
        # Nessus session Id
        [Parameter(Mandatory=$true,
                   Position=0,
                   ValueFromPipelineByPropertyName=$true)]
        [Alias('Index')]
        [int32[]]
        $SessionId = @(),

        [Parameter(Mandatory=$true,
                   Position=1,
                   ValueFromPipelineByPropertyName=$true)]
        [int32]
        $ScanId,

        [Parameter(Mandatory=$false,
                   Position=2,
                   ValueFromPipelineByPropertyName=$true)]
        [Int32]
        $HistoryId 
    )

    Begin
    {
        $origin = New-Object -Type DateTime -ArgumentList 1970, 1, 1, 0, 0, 0, 0
    }
    Process
    {
        $ToProcess = @()

        foreach($i in $SessionId)
        {
            $Connections = $Global:NessusConn
            
            foreach($Connection in $Connections)
            {
                if ($Connection.SessionId -eq $i)
                {
                    $ToProcess += $Connection
                }
            }
        }
        $Params = @{}

        if($HistoryId)
        {
            $Params.Add('history_id', $HistoryId)
        }

        foreach($Connection in $ToProcess)
        {
            $ScanDetails =  InvokeNessusRestRequest -SessionObject $Connection -Path "/scans/$($ScanId)" -Method 'Get' -Parameter $Params

            if ($ScanDetails -is [psobject])
            {
                
                $ScanDetailProps = [ordered]@{}
                $hosts = @()
                $history = @()

                # Process Scan Info
                $ScanInfo = [ordered]@{}
                $ScanInfo.add('Name', $ScanDetails.info.name)
                $ScanInfo.add('ScanId', $ScanDetails.info.object_id)
                $ScanInfo.add('Status', $ScanDetails.info.status)
                $ScanInfo.add('UUID', $ScanDetails.info.uuid)
                $ScanInfo.add('Policy', $ScanDetails.info.policy)
                $ScanInfo.add('FolderId', $ScanDetails.info.folder_id)
                $ScanInfo.add('ScannerName', $ScanDetails.info.scanner_name)
                $ScanInfo.add('HostCount', $ScanDetails.info.hostcount)
                $ScanInfo.add('Targets', $ScanDetails.info.targets)
                $ScanInfo.add('AlternetTargetsUsed', $ScanDetails.info.alt_targets_used)
                $ScanInfo.add('HasAuditTrail', $ScanDetails.info.hasaudittrail)
                $ScanInfo.add('HasKb', $ScanDetails.info.haskb)
                $ScanInfo.add('ACL', $ScanDetails.info.acls)
                $ScanInfo.add('Permission', $PermissionsId2Name[$ScanDetails.info.user_permissions])
                $ScanInfo.add('EditAllowed', $ScanDetails.info.edit_allowed)
                $ScanInfo.add('LastModified', $origin.AddSeconds($ScanDetails.info.timestamp).ToLocalTime())
                $ScanInfo.add('ScanStart', $origin.AddSeconds($ScanDetails.info.scan_start).ToLocalTime())
                $ScanInfo.Add('SessionId', $Connection.SessionId)
                $InfoObj = New-Object -TypeName psobject -Property $ScanInfo
                $InfoObj.pstypenames[0] = 'Nessus.Scan.Info'


                # Process host info.
                foreach ($Host in $ScanDetails.hosts)
                {
                    $HostProps = [ordered]@{}
                    $HostProps.Add('HostName', $Host.hostname)
                    $HostProps.Add('HostId', $Host.host_id)
                    $HostProps.Add('Critical', $Host.critical)
                    $HostProps.Add('High',  $Host.high)
                    $HostProps.Add('Medium', $Host.medium)
                    $HostProps.Add('Low', $Host.low)
                    $HostProps.Add('Info', $Host.info)
                    $HostObj = New-Object -TypeName psobject -Property $HostProps
                    $HostObj.pstypenames[0] = 'Nessus.Scan.Host'
                    $hosts += $HostObj
                } 

                # Process hostory info.
                foreach ($History in $ScanDetails.history)
                {
                    $HistoryProps = [ordered]@{}
                    $HistoryProps['HistoryId'] = $History.history_id
                    $HistoryProps['UUID'] = $History.uuid
                    $HistoryProps['Status'] = $History.status
                    $HistoryProps['Type'] = $History.type
                    $HistoryProps['CreationDate'] = $origin.AddSeconds($History.creation_date).ToLocalTime()
                    $HistoryProps['LastModifiedDate'] = $origin.AddSeconds($History.last_modification_date).ToLocalTime()
                    $HistObj = New-Object -TypeName psobject -Property $HistoryProps
                    $HistObj.pstypenames[0] = 'Nessus.Scan.History'
                    $history += $HistObj
                }

                $ScanDetails
            }
        }
    }
    End{}
}


<#
.Synopsis
   Show details of a speific host on a scan in a Nessus server.
.DESCRIPTION
   Long description
.EXAMPLE
   Show-NessusScanHostDetail -SessionId 0 -ScanId 46 -HostId 31 | fl


    Info            : @{host_start=Tue Feb 24 06:32:45 2015; host-fqdn=fw1.darkoperator.com; 
                       host_end=Tue Feb 24 06:35:52 2015; operating-system=FreeBSD 8.3-RELEASE-p16 
                      (i386); host-ip=192.168.1.1}
    Vulnerabilities : {@{count=1; hostname=192.168.1.1; plugin_name=Nessus Scan Information; vuln_index=0; 
                      severity=0; plugin_id=19506; severity_index=0; plugin_family=Settings; host_id=31}, 
                      @{count=3; hostname=192.168.1.1; plugin_name=Nessus SYN scanner; vuln_index=1; severity=0; 
                      plugin_id=11219; 
                      severity_index=1; plugin_family=Port scanners; host_id=31}, @{count=1;
                      hostname=192.168.1.1; plugin_name=Unsupported Unix Operating System; 
                      vuln_index=2; severity=4; plugin_id=33850; severity_index=2; 
                      plugin_family=General; host_id=31}}
    Compliance      : {}
#>
function Show-NessusScanHostDetail
{
    [CmdletBinding()]
    Param
    (
        # Nessus session Id
        [Parameter(Mandatory=$true,
                   Position=0,
                   ValueFromPipelineByPropertyName=$true)]
        [Alias('Index')]
        [int32[]]
        $SessionId = @(),

        [Parameter(Mandatory=$true,
                   Position=1,
                   ValueFromPipelineByPropertyName=$true)]
        [int32]
        $ScanId,

        [Parameter(Mandatory=$true,
                   Position=2,
                   ValueFromPipelineByPropertyName=$true)]
        [int32]
        $HostId,

        [Parameter(Mandatory=$false,
                   Position=3,
                   ValueFromPipelineByPropertyName=$true)]
        [Int32]
        $HistoryId 
    )

    Begin{}
    Process
    {
        $ToProcess = @()

        foreach($i in $SessionId)
        {
            $Connections = $Global:NessusConn
            
            foreach($Connection in $Connections)
            {
                if ($Connection.SessionId -eq $i)
                {
                    $ToProcess += $Connection
                }
            }
        }
        $Params = @{}

        if($HistoryId)
        {
            $Params.Add('history_id', $HistoryId)
        }

        foreach($Connection in $ToProcess)
        {
            $ScanDetails =  InvokeNessusRestRequest -SessionObject $Connection -Path "/scans/$($ScanId)/hosts/$($HostId)" -Method 'Get' -Parameter $Params

            if ($ScanDetails -is [psobject])
            {                
                $HostProps = [ordered]@{}
                $HostProps.Add('Info', $ScanDetails.info)
                $HostProps.Add('Vulnerabilities', $ScanDetails.vulnerabilities)
                $HostProps.Add('Compliance', $ScanDetails.compliance)
                $HostProps.Add('ScanId', $ScanId)
                $HostProps.Add('SessionId', $Connection.SessionId)
                $HostObj = New-Object -TypeName psobject -Property $HostProps
                $HostObj.pstypenames[0] = 'Nessus.Scan.HostDetails'
                $HostObj             
            }
        }
    }
    End{}
}


<#
.Synopsis
   Show the hosts present in a specific scan on a Nessus server.
.DESCRIPTION
   Show the hosts present in a specific scan on a Nessus server. The number
   of vulnerabilities found per severity.
.EXAMPLE
   Show-NessusScanHost -SessionId 0 -ScanId 46


    HostName : 192.168.1.253
    HostId   : 252
    Critical : 0
    High     : 1
    Medium   : 0
    Low      : 0
    Info     : 3

    HostName : 192.168.1.250
    HostId   : 251
    Critical : 0
    High     : 2
    Medium   : 0
    Low      : 0
    Info     : 3

    HostName : 192.168.1.242
    HostId   : 244
    Critical : 0
    High     : 0
    Medium   : 1
    Low      : 0
    Info     : 40

    HostName : 192.168.1.223
    HostId   : 225
    Critical : 0
    High     : 0
    Medium   : 0
    Low      : 0
    Info     : 6

    HostName : 192.168.1.218
    HostId   : 219
    Critical : 0
    High     : 0
    Medium   : 0
    Low      : 0
    Info     : 2

    HostName : 192.168.1.217
    HostId   : 221
    Critical : 0
    High     : 0
    Medium   : 0
    Low      : 0
    Info     : 4
#>
function Show-NessusScanHost
{
    [CmdletBinding()]
    Param
    (
        # Nessus session Id
        [Parameter(Mandatory=$true,
                   Position=0,
                   ValueFromPipelineByPropertyName=$true)]
        [Alias('Index')]
        [int32[]]
        $SessionId = @(),

        [Parameter(Mandatory=$true,
                   Position=1,
                   ValueFromPipelineByPropertyName=$true)]
        [int32]
        $ScanId,

        [Parameter(Mandatory=$false,
                   Position=2,
                   ValueFromPipelineByPropertyName=$true)]
        [Int32]
        $HistoryId 
    )

    Begin{}
    Process
    {
        $ToProcess = @()

        foreach($i in $SessionId)
        {
            $Connections = $Global:NessusConn
            
            foreach($Connection in $Connections)
            {
                if ($Connection.SessionId -eq $i)
                {
                    $ToProcess += $Connection
                }
            }
        }
        $Params = @{}

        if($HistoryId)
        {
            $Params.Add('history_id', $HistoryId)
        }

        foreach($Connection in $ToProcess)
        {
            $ScanDetails =  InvokeNessusRestRequest -SessionObject $Connection -Path "/scans/$($ScanId)" -Method 'Get' -Parameter $Params

            if ($ScanDetails -is [psobject])
            {
                foreach ($Host in $ScanDetails.hosts)
                {
                    $HostProps = [ordered]@{}
                    $HostProps.Add('HostName', $Host.hostname)
                    $HostProps.Add('HostId', $Host.host_id)
                    $HostProps.Add('Critical', $Host.critical)
                    $HostProps.Add('High',  $Host.high)
                    $HostProps.Add('Medium', $Host.medium)
                    $HostProps.Add('Low', $Host.low)
                    $HostProps.Add('Info', $Host.info)
                    $HostProps.Add('ScanId', $ScanId)
                    $HostProps.Add('SessionId', $Connection.SessionId)
                    $HostObj = New-Object -TypeName psobject -Property $HostProps
                    $HostObj.pstypenames[0] = 'Nessus.Scan.Host'
                    $HostObj
                } 
            }
        }
    }
    End{}
}


<#
.Synopsis
   Shows the history of times ran for a specific scan in a Nessus server.
.DESCRIPTION
   Shows the history of times ran for a specific scan in a Nessus server.
.EXAMPLE
   Show-NessusScanHistory -SessionId 0 -ScanId 46


    HistoryId        : 47
    UUID             : 909d61c2-5f6d-605d-6e4d-79739bbe1477dd85043154a6077f
    Status           : completed
    Type             : local
    CreationDate     : 2/24/2015 2:52:35 AM
    LastModifiedDate : 2/24/2015 5:57:33 AM

    HistoryId        : 48
    UUID             : e8df16c4-390c-b4d8-0ae5-ea7c48867bd57618d7bd96b32122
    Status           : canceled
    Type             : local
    CreationDate     : 2/24/2015 6:17:11 AM
    LastModifiedDate : 2/24/2015 6:27:20 AM

    HistoryId        : 49
    UUID             : e933c0be-3b16-5a44-be32-b17e32f2a2e6f7be26c34082817a
    Status           : canceled
    Type             : local
    CreationDate     : 2/24/2015 6:31:52 AM
    LastModifiedDate : 2/24/2015 6:32:43 AM

    HistoryId        : 50
    UUID             : 484d03b9-3196-4cc7-6567-4e99d8cc0e949924ccfb6ce4af3d
    Status           : completed
    Type             : local
    CreationDate     : 2/24/2015 6:32:45 AM
    LastModifiedDate : 2/24/2015 6:46:20 AM
#>
function Show-NessusScanHistory
{
    [CmdletBinding()]
    Param
    (
        # Nessus session Id
        [Parameter(Mandatory=$true,
                   Position=0,
                   ValueFromPipelineByPropertyName=$true)]
        [Alias('Index')]
        [int32[]]
        $SessionId = @(),

        [Parameter(Mandatory=$true,
                   Position=1,
                   ValueFromPipelineByPropertyName=$true)]
        [int32]
        $ScanId
    )

    Begin
    {
        $origin = New-Object -Type DateTime -ArgumentList 1970, 1, 1, 0, 0, 0, 0
    }
    Process
    {
        $ToProcess = @()

        foreach($i in $SessionId)
        {
            $Connections = $Global:NessusConn
            
            foreach($Connection in $Connections)
            {
                if ($Connection.SessionId -eq $i)
                {
                    $ToProcess += $Connection
                }
            }
        }
        $Params = @{}

        if($HistoryId)
        {
            $Params.Add('history_id', $HistoryId)
        }

        foreach($Connection in $ToProcess)
        {
            $ScanDetails =  InvokeNessusRestRequest -SessionObject $Connection -Path "/scans/$($ScanId)" -Method 'Get' -Parameter $Params

            if ($ScanDetails -is [psobject])
            {
                foreach ($History in $ScanDetails.history)
                {
                    $HistoryProps = [ordered]@{}
                    $HistoryProps['HistoryId'] = $History.history_id
                    $HistoryProps['UUID'] = $History.uuid
                    $HistoryProps['Status'] = $History.status
                    $HistoryProps['Type'] = $History.type
                    $HistoryProps['CreationDate'] = $origin.AddSeconds($History.creation_date).ToLocalTime()
                    $HistoryProps['LastModifiedDate'] = $origin.AddSeconds($History.last_modification_date).ToLocalTime()
                    $HistoryProps['SessionId'] = $Connection.SessionId
                    $HistObj = New-Object -TypeName psobject -Property $HistoryProps
                    $HistObj.pstypenames[0] = 'Nessus.Scan.History'
                    $HistObj
                } 
            }
        }
    }
    End{}
}


<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function New-NessusScan
{
    [CmdletBinding(DefaultParameterSetName='Name')]
    Param
    (
        # Nessus session Id
        [Parameter(Mandatory=$true,
                   Position=0,
                   ValueFromPipelineByPropertyName=$true)]
        [Alias('Index')]
        [int32]
        $SessionId = @(),

        [Parameter(Mandatory=$true,
                   Position=1,
                   ValueFromPipelineByPropertyName=$true)]
        [string]
        $Name,

        [Parameter(Mandatory=$true,
                   Position=2,
                   ParameterSetName = 'Template',
                   ValueFromPipelineByPropertyName=$true)]
        [string]
        $PolicyUUID,

        [Parameter(Mandatory=$true,
                   Position=2,
                   ParameterSetName = 'Policy',
                   ValueFromPipelineByPropertyName=$true)]
        [int]
        $PolicyId,

        [Parameter(Mandatory=$true,
                   Position=3,
                   ValueFromPipelineByPropertyName=$true)]
        [string[]]
        $Target,

        [Parameter(Mandatory=$true,
                   Position=4,
                   ValueFromPipelineByPropertyName=$true)]
        [bool]
        $Enabled,

        [Parameter(Mandatory=$False,
                   ValueFromPipelineByPropertyName=$true)]
        [string]
        $Description,

        [Parameter(Mandatory=$False,
                   ValueFromPipelineByPropertyName=$true)]
        [Int]
        $FolderId,

        [Parameter(Mandatory=$False,
                   ValueFromPipelineByPropertyName=$true)]
        [Int]
        $ScannerId,

        [Parameter(Mandatory=$False,
                   ValueFromPipelineByPropertyName=$true)]
        [string[]]
        $Email,

        [Parameter(Mandatory=$False,
                   ValueFromPipelineByPropertyName=$true)]
        [switch]
        $CreateDashboard

    )

    DynamicParam {
        if ($SessionId -ge 0)
        {
            $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

            # FolderName
            $FNameParameterName = 'FolderName'
            $FNameAttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
            $FNameParameterAttributeTemplate = New-Object System.Management.Automation.ParameterAttribute
            $FNameParameterAttributePolicy= New-Object System.Management.Automation.ParameterAttribute
            $FNameParameterAttributePolName= New-Object System.Management.Automation.ParameterAttribute
            $FNameParameterAttributeTmplName= New-Object System.Management.Automation.ParameterAttribute
            $FNameParameterAttributeTemplate.ParameterSetName = 'Policy'
            $FNameParameterAttributePolicy.ParameterSetName = 'Template'
            $FNameParameterAttributePolName.ParameterSetName = 'Name'
            $FNameParameterAttributeTmplName.ParameterSetName = 'TemplateName'
            $FNameAttributeCollection.Add($FNameParameterAttributeTemplate)
            $FNameAttributeCollection.Add($FNameParameterAttributePolicy)
            $FNameAttributeCollection.Add($FNameParameterAttributePolName)
            $FNameAttributeCollection.Add($FNameParameterAttributeTmplName)
            $FolderNames = Get-NessusFolder -SessionId $SessionId | Select-Object -ExpandProperty Name
            $FnameValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($FolderNames)
            $FNameAttributeCollection.Add($FnameValidateSetAttribute)
            $FNameRuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($FNameParameterName, [string], $FNameAttributeCollection)
            $RuntimeParameterDictionary.Add($FNameParameterName, $FNameRuntimeParameter)

            # Policy Name
            $PolNameParameterName = 'PolicyName'
            $PolNameAttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
            $PolNameParameterAttributeName= New-Object System.Management.Automation.ParameterAttribute
            $PolNameParameterAttributeName.ParameterSetName = 'Name'
            $PolNameAttributeCollection.Add($PolNameParameterAttributeName)
            $PolNames = Get-NessusPolicy -SessionId $SessionId | Select-Object -ExpandProperty Name
            $PolNameValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($PolNames)
            $PolNameAttributeCollection.Add($PolNameValidateSetAttribute)
            $PolNameRuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($PolNameParameterName, [string], $PolNameAttributeCollection)
            $RuntimeParameterDictionary.Add($PolNameParameterName, $PolNameRuntimeParameter)

            
            # Template Name

            $TmpNameParameterName = 'TemplateName'
            $TmpNameAttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
            $TmpNameParameterAttributeName = New-Object System.Management.Automation.ParameterAttribute
            $TmpNameParameterAttributeName.ParameterSetName = 'TemplateName'
            $TmpNameAttributeCollection.Add($TmpNameParameterAttributeName)
            $TmpNames = Get-NessusPolicyTemplate -SessionId $SessionId | Select-Object -ExpandProperty Name
            $TmpNameValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($TmpNames)
            $TmpNameAttributeCollection.Add($TmpNameValidateSetAttribute)
            $TmpNameRuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($TmpNameParameterName, [string], $TmpNameAttributeCollection)
            $RuntimeParameterDictionary.Add($TmpNameParameterName, $TmpNameRuntimeParameter)
            
            
            return $RuntimeParameterDictionary
        }
    }

    Begin
    {
        $ToProcess = Get-NessusSession -SessionId $SessionId
        $origin = New-Object -Type DateTime -ArgumentList 1970, 1, 1, 0, 0, 0, 0
        $PolicyName
        return

    }
    Process
    {

        # Join emails as a single comma separated string.
        $emails = $email -join ","

        # Join targets as a single comma separated string.
        $Targets = $target -join ","

        # Build Scan JSON
        $settings = @{
            'name' = $Name
            'text_targets' = $Targets
        }

        if ($FolderId -or $FolderName)
        {
            if($FolderId -and $PSBoundParameters.FolderName)
            {
                Write-Warning -Message 'Both FolderId and FolderName where specified. Using FolderName value.'
                $FId = (Get-NessusFolder -SessionId $SessionId -Name $PSBoundParameters.FolderName).FolderId
                $settings.Add('folder_id',$FolderId)
            }
            else
            {
                if ($FolderId) {$settings.Add('folder_id',$FId)}
                if ($PSBoundParameters.FolderName) {$settings.Add('folder_id',(Get-NessusFolder -SessionId $SessionId -Name $PSBoundParameters.$FolderName).FolderId)}
            }
        }
        if ($ScannerId) {$settings.Add('scanner_id', $ScannerId)}
        if ($Email.Length -gt 0) {$settings.Add('emails', $emails)}
        if ($Description.Length -gt 0) {$settings.Add('description', $Description)}
        if ($CreateDashboard) {$settings.Add('use_dashboard',$true)}
        $PSCmdlet.ParameterSetName
        switch($PSCmdlet.ParameterSetName)
        {
            'Template'{
                Write-Verbose -Message "Using Template with UUID of $($PolicyUUID)"
                $scanhash = [ordered]@{ 
                    'uuid' = $PolicyUUID
                    'settings' = $settings
                }
            }

            'Policy'{
                $polUUID = $null
                $Policies = Get-NessusPolicy -SessionId $SessionId 
                foreach($Policy in $Policies)
                {
                    if ($Policy.PolicyId -eq $PolicyId)
                    {
                        Write-Verbose -Message "Uising Poicy with UUID of $($Policy.PolicyUUID)"
                        $polUUID = $Policy.PolicyUUID
                    }
                }

                if ($polUUID -eq $null)
                {
                    Write-Error -message 'Policy specified does not exist in session.'
                    return
                }
                else
                {
                    $scanhash = [ordered]@{ 
                        'uuid' = $polUUID
                        'settings' = $settings
                    }                      
                }
            }

            'Name'{
                $TemplObj = Get-NessusPolicy -SessionId $SessionId -Name $PSBoundParameters.PolicyName
                $scanhash = [ordered]@{ 
                    'uuid' = $TemplObj.PolicyUUID
                    'settings' = $settings
                }
            }

            'TemplateName'{
                $TemplObj = Get-NessusPolicyTemplate -SessionId $SessionId -Name $PSBoundParameters.TemplateName
                $scanhash = [ordered]@{ 
                    'uuid' = $TemplObj.PolicyUUID
                    'settings' = $settings
                }
            }
        }

        $ScanJson = ConvertTo-Json -InputObject $scanhash -Compress

        $ServerTypeParams = @{
            'SessionObject' = $ToProcess
            'Path' = '/scans'
            'Method' = 'POST'
            'ContentType' = 'application/json'
            'Parameter' = $ScanJson
        }

        $NewScan =  InvokeNessusRestRequest @ServerTypeParams
            
        foreach ($scan in $NewScan.scan)
        {
            $ScanProps = [ordered]@{}
            $ScanProps.add('Name', $scan.name)
            $ScanProps.add('ScanId', $scan.id)
            $ScanProps.add('Status', $scan.status)
            $ScanProps.add('Enabled', $scan.enabled)
            $ScanProps.add('FolderId', $scan.folder_id)
            $ScanProps.add('Owner', $scan.owner)
            $ScanProps.add('UserPermission', $PermissionsId2Name[$scan.user_permissions])
            $ScanProps.add('Rules', $scan.rrules)
            $ScanProps.add('Shared', $scan.shared)
            $ScanProps.add('TimeZone', $scan.timezone)
            $ScanProps.add('CreationDate', $origin.AddSeconds($scan.creation_date).ToLocalTime())
            $ScanProps.add('LastModified', $origin.AddSeconds($scan.last_modification_date).ToLocalTime())
            $ScanProps.add('StartTime', $origin.AddSeconds($scan.starttime).ToLocalTime())
            $ScanProps.add('Scheduled', $scan.control)
            $ScanProps.add('DashboardEnabled', $scan.use_dashboard)
            $ScanProps.Add('SessionId', $Connection.SessionId)
                    
            $ScanObj = New-Object -TypeName psobject -Property $ScanProps
            $ScanObj.pstypenames[0] = 'Nessus.Scan'
            $ScanObj
        }
        
    }
    End
    {
    }
}


<#
.Synopsis
   Deletes a scan result from a Nessus server.
.DESCRIPTION
   Deletes a scan result from a Nessus server.
.EXAMPLE
    Get-NessusScan -SessionId 0 -Status Imported | Remove-NessusScan -SessionId 0 -Verbose
    VERBOSE: Removing scan with Id 45
    VERBOSE: DELETE https://192.168.1.211:8834/scans/45 with 0-byte payload
    VERBOSE: received 4-byte response of content type application/json
    VERBOSE: Scan Removed
    VERBOSE: Removing scan with Id 41
    VERBOSE: DELETE https://192.168.1.211:8834/scans/41 with 0-byte payload
    VERBOSE: received 4-byte response of content type application/json
    VERBOSE: Scan Removed
    VERBOSE: Removing scan with Id 39
    VERBOSE: DELETE https://192.168.1.211:8834/scans/39 with 0-byte payload
    VERBOSE: received 4-byte response of content type application/json
    VERBOSE: Scan Removed
    VERBOSE: Removing scan with Id 37
    VERBOSE: DELETE https://192.168.1.211:8834/scans/37 with 0-byte payload
    VERBOSE: received 4-byte response of content type application/json
    VERBOSE: Scan Removed
    VERBOSE: Removing scan with Id 7
    VERBOSE: DELETE https://192.168.1.211:8834/scans/7 with 0-byte payload
    VERBOSE: received 4-byte response of content type application/json
    VERBOSE: Scan Removed
    VERBOSE: Removing scan with Id 5
    VERBOSE: DELETE https://192.168.1.211:8834/scans/5 with 0-byte payload
    VERBOSE: received 4-byte response of content type application/json
    VERBOSE: Scan Removed
#>
function Remove-NessusScan
{
    [CmdletBinding()]
    Param
    (
        # Nessus session Id
        [Parameter(Mandatory=$true,
                   Position=0,
                   ValueFromPipelineByPropertyName=$true)]
        [Alias('Index')]
        [int32[]]
        $SessionId = @(),

        [Parameter(Mandatory=$true,
                   Position=1,
                   ValueFromPipelineByPropertyName=$true)]
        [int32]
        $ScanId
    )

    Begin{}
    Process
    {
        $ToProcess = @()

        foreach($i in $SessionId)
        {
            $Connections = $Global:NessusConn
            
            foreach($Connection in $Connections)
            {
                if ($Connection.SessionId -eq $i)
                {
                    $ToProcess += $Connection
                }
            }
        }

        foreach($Connection in $ToProcess)
        {
            Write-Verbose -Message "Removing scan with Id $($ScanId)"
            
            $ScanDetails =  InvokeNessusRestRequest -SessionObject $Connection -Path "/scans/$($ScanId)" -Method 'Delete' -Parameter $Params
            if ($ScanDetails -eq 'null')
            {
                Write-Verbose -Message 'Scan Removed'
            }
            
            
        }
    }
    End{}
}


<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Import-NessusScan
{
    [CmdletBinding()]
    Param
    (
        # Nessus session Id
        [Parameter(Mandatory=$true,
                   Position=0,
                   ValueFromPipelineByPropertyName=$true)]
        [Alias('Index')]
        [int32[]]
        $SessionId = @(),

        [Parameter(Mandatory=$true,
                   Position=1,
                   ValueFromPipelineByPropertyName=$true)]
        [ValidateScript({Test-Path -Path $_})]
        [string]
        $File,

        [Parameter(Mandatory=$false,
                   Position=2,
                   ValueFromPipelineByPropertyName=$true)]
        [switch]
        $Encrypted,

        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true)]
        [securestring]
        $Password
    )

    Begin
    {
        if($Encrypted)
        {
            $ContentType = 'application/octet-stream'
            $URIPath = 'file/upload?no_enc=1'
        }
        else
        {
            $ContentType = 'application/octet-stream'
            $URIPath = 'file/upload'
        }

        $netAssembly = [Reflection.Assembly]::GetAssembly([System.Net.Configuration.SettingsSection])

        if($netAssembly)
        {
            $bindingFlags = [Reflection.BindingFlags] "Static,GetProperty,NonPublic"
            $settingsType = $netAssembly.GetType("System.Net.Configuration.SettingsSectionInternal")

            $instance = $settingsType.InvokeMember("Section", $bindingFlags, $null, $null, @())

            if($instance)
            {
                $bindingFlags = "NonPublic","Instance"
                $useUnsafeHeaderParsingField = $settingsType.GetField("useUnsafeHeaderParsing", $bindingFlags)

                if($useUnsafeHeaderParsingField)
                {
                  $useUnsafeHeaderParsingField.SetValue($instance, $true)
                }
            }
        }

        $origin = New-Object -Type DateTime -ArgumentList 1970, 1, 1, 0, 0, 0, 0
    }
    Process
    {
        $ToProcess = @()

        foreach($i in $SessionId)
        {
            $Connections = $Global:NessusConn
            
            foreach($Connection in $Connections)
            {
                if ($Connection.SessionId -eq $i)
                {
                    $ToProcess += $Connection
                }
            }
        }

        foreach($Conn in $ToProcess)
        {
            $fileinfo = Get-ItemProperty -Path $File
            $FilePath = $fileinfo.FullName
            $RestClient = New-Object RestSharp.RestClient
            $RestRequest = New-Object RestSharp.RestRequest
            $RestClient.UserAgent = 'Posh-SSH'
            $RestClient.BaseUrl = $Conn.uri
            $RestRequest.Method = [RestSharp.Method]::POST
            $RestRequest.Resource = $URIPath
            
            [void]$RestRequest.AddFile('Filedata',$FilePath, 'application/octet-stream')
            [void]$RestRequest.AddHeader('X-Cookie', "token=$($Connection.Token)")
            $result = $RestClient.Execute($RestRequest)
            if ($result.ErrorMessage.Length -gt 0)
            {
                Write-Error -Message $result.ErrorMessage
            }
            else
            {
                $RestParams = New-Object -TypeName System.Collections.Specialized.OrderedDictionary
                $RestParams.add('file', "$($fileinfo.name)")
                if ($Encrypted)
                {
                    $Credentials = New-Object System.Management.Automation.PSCredential -ArgumentList 'user', $Password
                    $RestParams.Add('password', $Credentials.GetNetworkCredential().Password)
                }

                $impParams = @{ 'Body' = $RestParams }
                $ImportResult = Invoke-RestMethod -Method Post -Uri "$($Conn.URI)/scans/import" -header @{'X-Cookie' = "token=$($Conn.Token)"} -Body (ConvertTo-Json @{'file' = $fileinfo.name;} -Compress) -ContentType 'application/json'
                if ($ImportResult.scan -ne $null)
                {
                    $scan = $ImportResult.scan
                    $ScanProps = [ordered]@{}
                    $ScanProps.add('Name', $scan.name)
                    $ScanProps.add('ScanId', $scan.id)
                    $ScanProps.add('Status', $scan.status)
                    $ScanProps.add('Enabled', $scan.enabled)
                    $ScanProps.add('FolderId', $scan.folder_id)
                    $ScanProps.add('Owner', $scan.owner)
                    $ScanProps.add('UserPermission', $PermissionsId2Name[$scan.user_permissions])
                    $ScanProps.add('Rules', $scan.rrules)
                    $ScanProps.add('Shared', $scan.shared)
                    $ScanProps.add('TimeZone', $scan.timezone)
                    $ScanProps.add('CreationDate', $origin.AddSeconds($scan.creation_date).ToLocalTime())
                    $ScanProps.add('LastModified', $origin.AddSeconds($scan.last_modification_date).ToLocalTime())
                    $ScanProps.add('StartTime', $origin.AddSeconds($scan.starttime).ToLocalTime())
                    $ScanProps.add('Scheduled', $scan.control)
                    $ScanProps.add('DashboardEnabled', $scan.use_dashboard)
                    $ScanProps.Add('SessionId', $Conn.SessionId)
                    
                    $ScanObj = New-Object -TypeName psobject -Property $ScanProps
                    $ScanObj.pstypenames[0] = 'Nessus.Scan'
                    $ScanObj
               }
            }
        }
    }
    End{}
}


<#
.Synopsis
   Get all scan templates available on a Nessus server.
.DESCRIPTION
   Get all scan templates available on a Nessus server.
.EXAMPLE
   Get-NessusScanTemplate -SessionId 0
#>
function Get-NessusScanTemplate
{
    [CmdletBinding()]
    Param
    (
        # Nessus session Id
        [Parameter(Mandatory=$true,
                   Position=0,
                   ValueFromPipelineByPropertyName=$true)]
        [Alias('Index')]
        [int32[]]
        $SessionId = @()

    )

    Begin
    {
        $ToProcess = @()

        foreach($i in $SessionId)
        {
            $Connections = $Global:NessusConn
            
            foreach($Connection in $Connections)
            {
                if ($Connection.SessionId -eq $i)
                {
                    $ToProcess += $Connection
                }
            }
        }
    }
    Process
    {
        

        foreach($Connection in $ToProcess)
        {
            $Templates =  InvokeNessusRestRequest -SessionObject $Connection -Path '/editor/scan/templates' -Method 'Get'

            if ($Templates -is [psobject])
            {
                foreach($Template in $Templates.templates)
                {
                    $TmplProps = [ordered]@{}
                    $TmplProps.add('Name', $Template.name)
                    $TmplProps.add('Title', $Template.title)
                    $TmplProps.add('Description', $Template.desc)
                    $TmplProps.add('UUID', $Template.uuid)
                    $TmplProps.add('CloudOnly', $Template.cloud_only)
                    $TmplProps.add('SubscriptionOnly', $Template.subscription_only)
                    $TmplProps.add('SessionId', $Connection.SessionId)
                    $Tmplobj = New-Object -TypeName psobject -Property $TmplProps
                    $Tmplobj.pstypenames[0] = 'Nessus.ScanTemplate'
                    $Tmplobj
                }
            }
        }
    }
    End
    {
    }
}


<#
.Synopsis
   Get all TimeZones for the specific Nessus Server.
.DESCRIPTION
   Get all TimeZones for the specific Nessus Server. Depending on the OS where Nessus is installed the Time Zones
   available will vary. 
.EXAMPLE
   Get-NessusTimeZones -SessionId 0
#>
function Get-NessusTimeZones
{
    [CmdletBinding()]
    Param
    (
        # Nessus session Id
        [Parameter(Mandatory=$true,
                   Position=0,
                   ValueFromPipelineByPropertyName=$true)]
        [Alias('Index')]
        [int32]
        $SessionId = @()

    )

    Begin
    {
        $ToProcess = $null
        $Connections = $Global:NessusConn
            
        foreach($Connection in $Connections)
        {
            if ($Connection.SessionId -eq $SessionId)
            {
                $ToProcess = $Connection
            }
        }
    }
    Process
    {
        

        if ($ToProcess -ne $null)
        {
            $Zones =  InvokeNessusRestRequest -SessionObject $ToProcess -Path '/scans/timezones' -Method 'Get'

            if ($Zones -is [psobject])
            {
                foreach($Zone in $Zones.timezones)
                {
                    $ZoneProps = [ordered]@{}
                    $ZoneProps.add('Zone', $Zone.value)
                    $Zoneobj = New-Object -TypeName psobject -Property $ZoneProps
                    $Zoneobj.pstypenames[0] = 'Nessus.TimeZone'
                    $Zoneobj
                }
            }
        }
    }
    End
    {
    }
}


<#
.Synopsis
   Set a schedule for a existing scan.
.DESCRIPTION
   Set a schedule for a existing scan. So that it runs:
   * Once
   * Daily
   * Weekly
   * Monthly
   * Yearly
.EXAMPLE
   Run scan once a day at noon

   Set-NessusScanSchedule -SessionId 0 -TimeZone America/Puerto_Rico -ScanName test1 -Launch Daily -StartTime "12:00pm" -Enabled $true -Interval 1

.EXAMPLE
   Run scan weekly on monday, wednesday and fridays at midnigh.

   Set-NessusScanSchedule -SessionId 0 -TimeZone America/Puerto_Rico -ScanName test1 -Launch Weekly -DayOfWeek Monday,Wednesday,Friday -StartTime 12:00am  -Interval 1

.EXAMPLE
   Run scan every month on the wednesday of the second week of the month.

   Set-NessusScanSchedule -SessionId 0 -TimeZone America/Puerto_Rico -ScanName test1 -Launch Monthly -WeekOfMonth 2 -DayOfWeek Wednesday -Interval 1

.EXAMPLE
   Run scan every month on the 15th.

   Set-NessusScanSchedule -SessionId 0 -TimeZone America/Puerto_Rico -ScanName test1 -Launch Monthly -DayOfMonth 15 -Interval 1
#>
function Set-NessusScanSchedule
{
    [CmdletBinding(DefaultParameterSetName = 'Once')]
    Param
    (
        # Nessus session Id
        [Parameter(Mandatory=$true,
                   Position=0,
                   ValueFromPipelineByPropertyName=$true)]
        [Alias('Index')]
        [int32]
        $SessionId = @(),

        # Enable the scheduled action.
        [bool]
        $Enabled = $true,


        # When to launch the scan.
        [Parameter(Mandatory=$true)]
        [ValidateSet('Once', 'Daily', 'Weekly','Monthly', 'Yearly')]
        [string]
        $Launch,
        

        # Interval to execute the task. Value from 1 to 20.
        [ValidateRange(1,20)]
        [Int]
        $Interval,

        # Specify the day of the week o run weekly or monthly schedules.
        [string[]]
        [ValidateSet('Sunday', 'Monday', 'Tuesday', 'Wednesday',
                     'Thursday', 'Friday', 'Saturday')]
        $DayOfWeek,

        # The starting time and date for the scan. Default 30min after command.
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [datetime]
        $StartTime = (Get-Date).AddMinutes(30),

        # Day of the month to run on monthly schedule.
        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName = $true,
                   ParameterSetName = 'MonthlyByDay')]
        [ValidateRange(1,31)]
        [Int]
        $DayOfMonth,

        # Week of the month to run on monthly schedule.
        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName = $true,
                   ParameterSetName = 'MonthlyByWeek')]
        [ValidateRange(1,5)]
        [Int]
        $WeekOfMonth
    )
    DynamicParam {
        if ($SessionId -ge 0)
        {
            $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

            # Time Zone
            $ZoneParameterName = 'TimeZone'
            $ZoneAttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
            $ZoneParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
            $ZoneParameterAttribute.Mandatory = $true
            $ZoneAttributeCollection.Add($ZoneParameterAttribute)
            $zones = Get-NessusTimeZones -SessionId $SessionId | Select-Object -ExpandProperty Zone
            $ZoneValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($zones)
            $ZoneAttributeCollection.Add($ZoneValidateSetAttribute)
            $ZoneRuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ZoneParameterName, [string], $ZoneAttributeCollection)
            $RuntimeParameterDictionary.Add($ZoneParameterName, $ZoneRuntimeParameter)

            $ScanNameParameterName = 'ScanName'
            $ScanNameAttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
            $ScanNameParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
            $ScanNameParameterAttribute.Mandatory = $true
            $ScanNameAttributeCollection.Add($ScanNameParameterAttribute)
            $scans = Get-NessusScan -SessionId $SessionId | Select-Object -ExpandProperty name
            $ScanNameValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($scans)
            $ScanNameAttributeCollection.Add($ScanNameValidateSetAttribute)
            $ScanNameRuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ScanNameParameterName, [string], $ScanNameAttributeCollection)
            $RuntimeParameterDictionary.Add($ScanNameParameterName, $ScanNameRuntimeParameter)

            return $RuntimeParameterDictionary
        }
    }
    Begin
    {
        $origin = New-Object -Type DateTime -ArgumentList 1970, 1, 1, 0, 0, 0, 0  
    }
    Process
    {
        $ScanId = (Get-NessusScan -SessionId $SessionId -Name $PSBoundParameters.ScanName).ScanId

        $EditorRequestParams = @{
                'SessionObject' = (Get-NessusSession -SessionId 0)
                'Path' = "/editor/scan/$($ScanId)"
                'Method' = 'GET'
                'ContentType' = 'application/json'
        }

        $scanObj =InvokeNessusRestRequest @EditorRequestParams

        $Targets = $scanObj.settings.basic.inputs | Where-Object {$_.id -eq "text_targets" } | Select-Object -ExpandProperty default

        $UpdateHash = @{'uuid' = $scanObj.uuid}

        $SettingsHash = @{
            'launch_now' = $LaunchNow
            'enabled' = $Enabled
            'text_targets' = $Targets
            'file_targets' = ''
            'timezone' = $PSBoundParameters.TimeZone
            'starttime' = $StartTime.ToString('yyyyMMddTHHmmss')
        }

        if ($Launch.Length -gt 0){ $SettingsHash.Add('launch', ($Launch.ToUpper())) }
        $Rule = ''
        # Configure the rules
        switch ($Launch)
        {
            # Create a rule when the interval is daily or yearly
            {$_ -in 'Daily','Yearly'} {
                if ($Interval -ge 1)
                {
                    $Rule = "FREQ=$($Launch.ToUpper());INTERVAL=$($Interval)"
                }
                else
                {
                    Write-Error -Message 'For launching a task daily or yearly a interval must me specified'
                    return
                }
            }
            
            # Create a rule when the interval is weekly.
            'Weekly'{
                if (($DayOfWeek.Length -gt 0) -and ($Interval -ge 1))
                {
                    $EachDay = $DayOfWeek | Select-Object -Unique
                    $WeekRule = 'BYDAY='
                    if ($EachDay.length -gt 1)
                    {
                        $DayList = @()
                        foreach($day in $EachDay)
                        {
                            $DayList += $day.Substring(0,2).ToUpper() 
                        }
                        $WeekRule = $WeekRule + $DayList -join ','
                    }
                    else
                    {
                        $WeekRule = $WeekRule + $EachDay[0].Substring(0,2).ToUpper()
                    }
                    $Rule = $WeekRule + "FREQ=WEEKLY;INTERVAL=$($Interval);"
                }
                else
                {
                    Write-Error -Message 'For launching a task weekly a day of the week and a interval must be specified.'
                    return
                }
            }

            'Monthly'{
                $monthlyRule = "FREQ=MONTHLY;INTERVAL=$($Interval);"
                switch($PSCmdlet.ParameterSetName)
                {
                    'MonthlyByDay' {
                        if (($Interval -gt 0) -and ($DayOfMonth -gt 0))
                        {
                           $Rule = "FREQ=MONTHLY;INTERVAL=$($Interval);BYMONTHDAY=$($DayOfMonth)"
                        }
                        else
                        {
                            Write-Error -Message 'You need to specify an interval and day of the month'
                            return
                        }
                    
                    } 
                    
                    'MonthlyByWeek' {
                        if (($Interval -gt 0) -and ($DayOfWeek -gt 0) -and ($WeekOfMonth -gt 0))
                        {
                            $Rule = "FREQ=MONTHLY;INTERVAL=$($Interval);BYDAY=$($WeekOfMonth)$($DayOfWeek[0].Substring(0,2).ToUpper())"
                            
                        }
                    }
                }
            }

            'Once' {
                $Rule = 'FREQ=ONETIME'
            }
        }
        $SettingsHash.Add('rrules',$Rule)
        $UpdateHash.Add('settings',$SettingsHash)
        $jsonstr = ConvertTo-Json -InputObject $UpdateHash -Compress

        $RequestParams = @{
            'SessionObject' = (Get-NessusSession -SessionId 0)
            'Path' = "/scans/$($ScanId)"
            'Method' = 'PUT'
            'ContentType' = 'application/json'
            'Parameter'= $jsonstr
        }
        $scan = invokenessusrestrequest @RequestParams

        $ScanProps = [ordered]@{}
        $ScanProps.add('Name', $scan.name)
        $ScanProps.add('ScanId', $scan.id)
        $ScanProps.add('Enabled', $scan.enabled)
        $ScanProps.add('Owner', $scan.owner)
        $ScanProps.add('UserPermission', $PermissionsId2Name[$scan.user_permissions])
        $ScanProps.add('Rules', $scan.rrules)
        $ScanProps.add('Shared', $scan.shared)
        $ScanProps.add('TimeZone', $scan.timezone)
        $ScanProps.add('DashboardEnabled', $scan.use_dashboard)             
        $ScanProps.add('CreationDate', $origin.AddSeconds($scan.creation_date).ToLocalTime())
        $ScanProps.add('LastModified', $origin.AddSeconds($scan.last_modification_date).ToLocalTime())

        if ($scan.starttime -cnotlike "*T*")
        {
            $ScanProps.add('StartTime', $origin.AddSeconds($scan.starttime).ToLocalTime())
        }
        else
        {
            $StartTime = [datetime]::ParseExact($scan.starttime,"yyyyMMddTHHmmss",
                            [System.Globalization.CultureInfo]::InvariantCulture,
                            [System.Globalization.DateTimeStyles]::None)
            $ScanProps.add('StartTime', $StartTime)
        }
        $ScanObj = New-Object -TypeName psobject -Property $ScanProps
        $ScanObj.pstypenames[0] = 'Nessus.Scan'
        $ScanObj
                    
    }
    End
    {
    }
}
#endregion