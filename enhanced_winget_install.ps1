# [[Winget_Bulk_Installer_Script_v4_HARDENED_WITH_EXTENSIONS]]
# Obsidian Tagging Comments
# Tags: #PowerShell #Winget #Installer #Automation #SystemUtility #DevelopmentTools #Fonts #Terminal #Virtualization #WindowsFeatures #VSCode #GodMode #Enhanced #Backup #Logging #ErrorHandling #Profiles #ParallelInstalls #HardwareDetection #SelectAll #ViewAll #MultiColumn #CustomAssets #ConfigFile #Hardened #ChromeExtensions #BrowserAutomation #ExtensionManagement #Claude

<#
.SYNOPSIS
    A two-stage, configuration-driven PowerShell script to bootstrap package managers, then elevate to bulk install and configure a Windows system with Chrome extensions support.
    This hardened version uses a `config.json` file, validates prerequisites, and features a robust multi-column UI with automated Chrome extension installation.

.DESCRIPTION
    This script performs several key functions in a staged execution flow:
    1.  **Stage 1 (User Mode - Bootstrap)**:
        -   Installs Scoop and Chocolatey if they are not already present.
        -   Once bootstrapping is complete, it automatically attempts to re-launch itself with Administrator privileges.
    2.  **Stage 2 (Administrator Mode - Deployment)**:
        -   **Configuration Driven**: Loads all settings from a `config.json` file, creating it with defaults on first run.
        -   **Prerequisite Validation**: Checks for Winget, PowerShell version, and write permissions before proceeding.
        -   **Defaults to All Selected**: All compatible software is pre-selected on startup.
        -   **Master Selection View**: A single, multi-column screen displays all software.
        -   **Critical Prompts**: Important software (drivers, runtimes) is handled via direct prompts during deployment.
        -   **Bulk Installation**: Installs all selected software and fonts in parallel.
        -   **Chrome Extension Automation**: Automatically installs Chrome extensions from a predefined list.
        -   **Post-Install Tasks**: After main installation, it runs all configuration subroutines (VSCode extensions, cursors, Chrome extensions, etc.).

.NOTES
    Author: Enhanced by Claude for Ice-ninja (Based on user specifications and diagnostics by the Gnnnome)
    Version: 4.0.5 (Chrome Extensions Integration)
    Date: 2025-01-16
    Requires: PowerShell 5.1+, Windows 10/11. Start as a standard user.
    Illegal software installation is not supported.
#>

# ---[ CONFIGURATION AND INITIALIZATION ]---

function Get-ScriptConfiguration {
    param([string]$ScriptRoot)
    $configPath = Join-Path $ScriptRoot "config.json"
    $defaultConfig = @{
        CreateRestorePoint = $true
        ParallelInstalls = $true
        MaxConcurrentJobs = 4
        ProfilePath = "$env:USERPROFILE\Documents\WingetProfiles"
        CustomCursorDirectory = "AAA stuff-pdanet\mouse cursors"
        BusyCursorFile = "dinosaur.ani"
        WorkingInBackgroundCursorFile = "dinosaur2.ani"
        MasterViewColumnCount = 4
        InstallChromeExtensions = $true
        ChromeExtensionTimeout = 30
    }

    if (-not (Test-Path $configPath)) {
        Write-EnhancedLog "Configuration file not found. Creating default 'config.json'." -Level WARNING -Component "CONFIG"
        try {
            $defaultConfig | ConvertTo-Json -Depth 5 | Set-Content -Path $configPath -Encoding UTF8
        } catch {
            Write-EnhancedLog "Failed to create config file: $($_.Exception.Message). Using internal defaults." -Level ERROR -Component "CONFIG"
            return $defaultConfig
        }
    }

    try {
        $config = Get-Content -Path $configPath | ConvertFrom-Json
        foreach ($key in $defaultConfig.Keys) {
            if (-not $config.PSObject.Properties.Name.Contains($key)) {
                $config | Add-Member -MemberType NoteProperty -Name $key -Value $defaultConfig[$key]
            }
        }
        Write-EnhancedLog "Configuration loaded successfully from 'config.json'." -Level SUCCESS -Component "CONFIG"
        return $config
    } catch {
        Write-EnhancedLog "Failed to read or parse 'config.json': $($_.Exception.Message). Using internal defaults." -Level ERROR -Component "CONFIG"
        return $defaultConfig
    }
}

function Test-Prerequisites {
    Write-EnhancedLog "Running prerequisite checks..." -Level INFO -Component "VALIDATION"
    $errors = @()

    if ($PSVersionTable.PSVersion.Major -lt 5) {
        $errors += "This script requires PowerShell version 5.1 or newer. Your version is $($PSVersionTable.PSVersion)."
    }
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        $errors += "Winget command not found. Please ensure the 'App Installer' from the Microsoft Store is installed and up to date."
    }
    try {
        $testFile = Join-Path $PSScriptRoot "write_test.tmp"
        [System.IO.File]::WriteAllText($testFile, "test")
        [System.IO.File]::Delete($testFile)
    } catch {
        $errors += "Cannot write to the script directory '$PSScriptRoot'. Please check permissions or run from a different location."
    }
    
    if ($errors.Count -gt 0) {
        Write-EnhancedLog "Prerequisite checks failed." -Level ERROR -Component "VALIDATION"
        foreach($error in $errors) { Write-Host "- $error" -ForegroundColor Red }
        Read-Host "Press Enter to exit."
        exit
    } else {
        Write-EnhancedLog "All prerequisite checks passed." -Level SUCCESS -Component "VALIDATION"
    }
}

# ---[ CORE FUNCTIONS ]---

function Write-EnhancedLog {
    param(
        [string]$Message,
        [ValidateSet('INFO', 'WARNING', 'ERROR', 'SUCCESS', 'DEBUG')]
        [string]$Level = 'INFO',
        [string]$Component = 'MAIN'
    )
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss.fff'
    $logEntry = "[$timestamp] [$Level] [$Component] $Message"
    $color = switch ($Level) {
        'INFO' { 'White' }
        'WARNING' { 'Yellow' }
        'ERROR' { 'Red' }
        'SUCCESS' { 'Green' }
        'DEBUG' { 'Gray' }
    }
    Write-Host $logEntry -ForegroundColor $color
}

function New-SystemBackup {
    Write-EnhancedLog "Creating system restore point..." -Level INFO -Component "BACKUP"
    if ($Global:ScriptConfig.CreateRestorePoint) {
        try {
            Enable-ComputerRestore -Drive "$env:SystemDrive" -ErrorAction Stop | Out-Null
            $restorePointName = "Winget Bulk Installer - $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
            Checkpoint-Computer -Description $restorePointName -RestorePointType "MODIFY_SETTINGS" -ErrorAction Stop
            Write-EnhancedLog "System restore point created: $restorePointName" -Level SUCCESS -Component "BACKUP"
        } catch {
            Write-EnhancedLog ("Failed to create system restore point: " + $_.Exception.Message) -Level ERROR -Component "BACKUP"
        }
    } else {
        Write-EnhancedLog "System restore point creation skipped as per configuration." -Level INFO -Component "BACKUP"
    }
}

function Get-EnhancedHardwareInfo {
    Write-EnhancedLog "Performing comprehensive hardware scan..." -Level INFO -Component "HARDWARE"
    $hardware = [PSCustomObject]@{
        HasAMDGraphics = $false; HasIntelGraphics = $false; HasNVIDIAGraphics = $false; GraphicsCards = @()
        HasAMDProcessor = $false; HasIntelProcessor = $false; ProcessorInfo = $null
        Manufacturer = ""; Model = ""; IsLaptop = $false; HasTouchscreen = $false
        TotalRAM = 0; StorageDevices = @(); HasWiFi = $false; HasBluetooth = $false; NetworkAdapters = @()
        IsGamingPC = $false; HasGamingGPU = $false; IsDeveloperMachine = $false
    }
    try {
        $gpuInfo = Get-CimInstance -ClassName Win32_VideoController -ErrorAction SilentlyContinue
        foreach ($gpu in $gpuInfo) {
            $gpuName = $gpu.Name
            $hardware.GraphicsCards += $gpuName
            if ($gpuName -match 'AMD|Radeon') { $hardware.HasAMDGraphics = $true }
            if ($gpuName -match 'Intel') { $hardware.HasIntelGraphics = $true }
            if ($gpuName -match 'NVIDIA|GeForce|Quadro|Tesla') { $hardware.HasNVIDIAGraphics = $true }
            if ($gpuName -match 'RTX|GTX|RX \d{3,4}|Arc A\d{3}|Radeon \d{4} Series|GeForce \d{4} Series') {
                $hardware.HasGamingGPU = $true; $hardware.IsGamingPC = $true
            }
        }
        $cpuInfo = Get-CimInstance -ClassName Win32_Processor -ErrorAction SilentlyContinue | Select-Object -First 1
        $hardware.ProcessorInfo = $cpuInfo
        if ($cpuInfo.Manufacturer -match 'AMD') { $hardware.HasAMDProcessor = $true }
        if ($cpuInfo.Manufacturer -match 'Intel') { $hardware.HasIntelProcessor = $true }
        $computerSystem = Get-CimInstance -ClassName Win32_ComputerSystem -ErrorAction SilentlyContinue
        $hardware.Manufacturer = $computerSystem.Manufacturer; $hardware.Model = $computerSystem.Model
        $hardware.TotalRAM = [math]::Round($computerSystem.TotalPhysicalMemory / 1GB, 2)
        $hardware.IsLaptop = ($null -ne (Get-CimInstance -ClassName Win32_Battery -ErrorAction SilentlyContinue))
        $hardware.HasTouchscreen = ($null -ne (Get-CimInstance -ClassName Win32_PnPEntity -ErrorAction SilentlyContinue | Where-Object { $_.Name -match 'touch' -and $_.Status -eq 'OK' }))
        $networkAdapters = Get-CimInstance -ClassName Win32_NetworkAdapter -ErrorAction SilentlyContinue | Where-Object { $_.NetEnabled -eq $true }
        foreach ($adapter in $networkAdapters) {
            if ($adapter.Name -match 'Wi-Fi|Wireless|802.11') { $hardware.HasWiFi = $true }
            if ($adapter.Name -match 'Bluetooth') { $hardware.HasBluetooth = $true }
        }
        $devIndicators = @( (Get-Command git -ErrorAction SilentlyContinue), (Get-Command node -ErrorAction SilentlyContinue), (Get-Command python -ErrorAction SilentlyContinue), (Test-Path "$env:USERPROFILE\.vscode"), (Test-Path "$env:ProgramFiles\Microsoft Visual Studio"), (Test-Path "$env:ProgramFiles\JetBrains") )
        $hardware.IsDeveloperMachine = ($devIndicators | Where-Object { $_ }).Count -ge 2
        Write-EnhancedLog "Hardware scan complete: $($hardware.GraphicsCards.Count) GPU(s), $($hardware.TotalRAM)GB RAM, Laptop: $($hardware.IsLaptop)" -Level SUCCESS -Component "HARDWARE"
    } catch { Write-EnhancedLog "Hardware detection error: $($_.Exception.Message)" -Level ERROR -Component "HARDWARE" }
    return $hardware
}

$Global:PackageInfoCache = @{}
function Get-EnhancedWingetPackageInfo {
    param([string]$PackageId)
    
    function Parse-WingetProperty {
        param($wingetOutput, $pattern)
        $match = $wingetOutput | Select-String -Pattern $pattern
        if ($match) { return $match.Matches.Groups[1].Value.Trim() }
        return ""
    }

    if ($Global:PackageInfoCache.ContainsKey($PackageId)) {
        $cacheEntry = $Global:PackageInfoCache[$PackageId]
        if ($cacheEntry.LastChecked -ge (Get-Date).AddMinutes(-15)) {
            return $cacheEntry
        }
    }
    try {
        $wingetOutput = winget show $PackageId --source winget --accept-source-agreements 2>&1 | Out-String
        if ($LASTEXITCODE -ne 0 -or $wingetOutput -like "*An unexpected error occurred*") {
            if ($wingetOutput -like "*No package found matching the input criteria*") {} else {
                throw "Winget command failed for ID $PackageId. Output: $wingetOutput"
            }
        }
        
        $installedVersion = Parse-WingetProperty -wingetOutput $wingetOutput -pattern "Installed Version:\s*(.*)"
        $availableVersion = Parse-WingetProperty -wingetOutput $wingetOutput -pattern "Available Version:\s*(.*)"
        
        if (-not $installedVersion) { $installedVersion = "Not Installed" }
        if (-not $availableVersion) { $availableVersion = "Unknown" }
        
        $status = if ($installedVersion -eq "Not Installed") { "Not Installed" } 
                  elseif ($availableVersion -ne "Unknown" -and $installedVersion -ne $availableVersion) { "Update Available" } 
                  else { "Installed" }
                  
        $packageInfo = [PSCustomObject]@{
            Id = $PackageId; InstalledVersion = $installedVersion; AvailableVersion = $availableVersion; Status = $status
            Publisher = Parse-WingetProperty -wingetOutput $wingetOutput -pattern "Publisher:\s*(.*)"
            Homepage = Parse-WingetProperty -wingetOutput $wingetOutput -pattern "Homepage:\s*(.*)"
            LastChecked = Get-Date; ErrorMessage = $null
        }
        $Global:PackageInfoCache[$PackageId] = $packageInfo
        return $packageInfo
    } catch {
        $errorMessage = $_.Exception.Message.Split([System.Environment]::NewLine)[0]
        Write-EnhancedLog ("Failed to get package info for ${PackageId}: " + $errorMessage) -Level WARNING -Component "WINGET"
        $errorInfo = [PSCustomObject]@{
            Id = $PackageId; InstalledVersion = "Error"; AvailableVersion = "Error"; Status = "Error"; Publisher = "Unknown"; Homepage = ""; LastChecked = Get-Date; ErrorMessage = $errorMessage
        }
        $Global:PackageInfoCache[$PackageId] = $errorInfo
        return $errorInfo
    }
}

function Start-ParallelInstallation {
    param([array]$PackageInstallCommands, [int]$MaxConcurrentJobs)
    Write-EnhancedLog "Starting parallel installation of $($PackageInstallCommands.Count) packages with $MaxConcurrentJobs concurrent jobs" -Level INFO -Component "INSTALL"
    $jobs = @(); $completed = 0; $failedPackages = @(); $totalPackages = $PackageInstallCommands.Count; $allPackageIds = $PackageInstallCommands | ForEach-Object { ($_ -split ' ')[2] }
    foreach ($command in $PackageInstallCommands) {
        $packageId = ($command -split ' ')[2]
        while ((Get-Job -State Running).Count -ge $MaxConcurrentJobs) {
            Start-Sleep -Milliseconds 500
            $completedJobs = Get-Job -State Completed
            foreach ($job in $completedJobs) {
                $result = Receive-Job -Job $job; Remove-Job -Job $job -Force; $completed++
                if ($result.Success) { Write-EnhancedLog "Successfully installed: $($result.PackageId)" -Level SUCCESS -Component "INSTALL" } 
                else { Write-EnhancedLog "Failed to install: $($result.PackageId) - $($result.Error)" -Level ERROR -Component "INSTALL"; $failedPackages += $result.PackageId }
                $progress = [math]::Round(($completed / $totalPackages) * 100, 1)
                Write-Progress -Activity "Installing Software" -Status "$completed of $totalPackages completed ($progress%)" -PercentComplete $progress
            }
        }
        $job = Start-Job -ScriptBlock {
            param($cmd, $pkgId)
            try {
                $output = Invoke-Expression $cmd 2>&1
                return @{ PackageId = $pkgId; Success = $LASTEXITCODE -eq 0; Error = if ($LASTEXITCODE -ne 0) { $output | Out-String } else { $null } }
            } catch { return @{ PackageId = $pkgId; Success = $false; Error = $_.Exception.Message } }
        } -ArgumentList $command, $packageId
        $jobs += $job
    }
    while ((Get-Job -State Running).Count -gt 0) {
        Start-Sleep -Milliseconds 500
        $completedJobs = Get-Job -State Completed
        foreach ($job in $completedJobs) {
            $result = Receive-Job -Job $job; Remove-Job -Job $job -Force; $completed++
            if ($result.Success) { Write-EnhancedLog "Successfully installed: $($result.PackageId)" -Level SUCCESS -Component "INSTALL" } 
            else { Write-EnhancedLog "Failed to install: $($result.PackageId) - $($result.Error)" -Level ERROR -Component "INSTALL"; $failedPackages += $result.PackageId }
            $progress = [math]::Round(($completed / $totalPackages) * 100, 1)
            Write-Progress -Activity "Installing Software" -Status "$completed of $totalPackages completed ($progress%)" -PercentComplete $progress
        }
    }
    Write-Progress -Activity "Installing Software" -Completed
    $successfulPackages = $allPackageIds | Where-Object { $_ -notin $failedPackages }
    return @{ TotalPackages = $totalPackages; Successful = $successfulPackages.Count; Failed = $failedPackages.Count; FailedPackages = $failedPackages; SuccessfulPackages = $successfulPackages }
}

# ---[ CHROME EXTENSION FUNCTIONS ]---

function Get-ChromeExtensionList {
    # Chrome Extensions from the provided paste.txt file
    $chromeExtensions = @(
        @{ Name = "Adblock for Youtube™"; Id = "cmedhionkhpnakcndndgjdbohmhepckk"; Category = "Ad Blocking" },
        @{ Name = "AdGuard Extra"; Id = "gkeojjjcdcopjkbelgbcpckplegclfeg"; Category = "Ad Blocking" },
        @{ Name = "AnythingLLM Browser Companion"; Id = "pncmdlebcopjodenlllcomedphdmeogm"; Category = "AI Tools" },
        @{ Name = "Ask Gemini"; Id = "daeaddalijienfjkhigbifmbdckbohjg"; Category = "AI Tools" },
        @{ Name = "Axiom Browser Automation & Web Scraping"; Id = "cpgamigjcbffkaiciiepndmonbfdimbb"; Category = "Development" },
        @{ Name = "Bitwarden Password Manager"; Id = "nngceckbapebfimnlniiiahkandclblb"; Category = "Security" },
        @{ Name = "Bookmark Shortcuts Extension"; Id = "fncelbkbpljhacojmfbcajibgdkaegjf"; Category = "Productivity" },
        @{ Name = "Bookmarks clean up"; Id = "oncbjlgldmiagjophlhobkogeladjijl"; Category = "Productivity" },
        @{ Name = "Buster: Captcha Solver for Humans"; Id = "mpbjkejclgfgadiemmefgebjfooflfhl"; Category = "Productivity" },
        @{ Name = "Bye Bye, Google AI"; Id = "imllolhfajlbkpheaapjocclpppchggc"; Category = "Privacy" },
        @{ Name = "Cardboard Market"; Id = "gfonbedaflaggkpgobfcibgimnflalbk"; Category = "Shopping" },
        @{ Name = "ChatGPT Session Exporter"; Id = "obljmfemfmmhlcodmcenihjoahemllnl"; Category = "AI Tools" },
        @{ Name = "Chrome Remote Desktop"; Id = "inomeogfingihgjfjlpeplalcfajhgai"; Category = "Remote Access" },
        @{ Name = "Cookie Remover"; Id = "kcgpggonjhmeaejebeoeomdlohicfhce"; Category = "Privacy" },
        @{ Name = "Cookie-Editor"; Id = "hlkenndednhfkekhgcdicdfddnkalmdm"; Category = "Development" },
        @{ Name = "Dark Reader"; Id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; Category = "Accessibility" },
        @{ Name = "DeArrow - Better Titles and Thumbnails"; Id = "enamippconapkdmgfgjchkhakpfinmaj"; Category = "YouTube" },
        @{ Name = "Disable All Extensions"; Id = "ailfldpmpboolaihojfagmmfbhcgohne"; Category = "Extension Management" },
        @{ Name = "Discordmate - Discord Chat Exporter"; Id = "ofjlibelpafmdhigfgggickpejfomamk"; Category = "Social Media" },
        @{ Name = "Enhancer for YouTube™"; Id = "ponfpcnoihfmfllpaingbgckeeldkhle"; Category = "YouTube" },
        @{ Name = "Extension Auditor"; Id = "gjfdlpdedlbiokokikmhjcelbkaljbep"; Category = "Security" },
        @{ Name = "Extensity"; Id = "jjmflmamggggndanpgfnpelongoepncg"; Category = "Extension Management" },
        @{ Name = "GitZip for github"; Id = "ffabmkklhbepgcgfonabamgnfafbdlkn"; Category = "Development" },
        @{ Name = "Go To Playing Tab"; Id = "hmbhamadknmmkapmhbldodoajkcggcml"; Category = "Tab Management" },
        @{ Name = "Google Docs Offline"; Id = "ghbmnnjooekpmoecnnnilnnbdlolhkhi"; Category = "Productivity" },
        @{ Name = "Grammarly"; Id = "kbfnbcaeplbcioakkpcpgfkobkghlhen"; Category = "Writing" },
        @{ Name = "h264ify"; Id = "aleakchihdccplidncghkekgioiakgal"; Category = "YouTube" },
        @{ Name = "iCloud Passwords"; Id = "pejdijmoenmkgeppbflobdenhhabjlaj"; Category = "Password Management" },
        @{ Name = "Images ON/OFF"; Id = "nfmlhilnjccdggifdbhnhkffmjgalbgg"; Category = "Performance" },
        @{ Name = "JSON Formatter"; Id = "bcjindcccaagfpapjjmafapmmgkkhgoa"; Category = "Development" },
        @{ Name = "Keepa - Amazon Price Tracker"; Id = "neebplgakaahbhdphmkckjjcegoiijjo"; Category = "Shopping" },
        @{ Name = "Keyboard Shortcuts"; Id = "lplcmnhgijkkmflbmhabnccgelffpnog"; Category = "Productivity" },
        @{ Name = "Malwarebytes Browser Guard"; Id = "ihcjicgdanjaechkgeegckofjjedodee"; Category = "Security" },
        @{ Name = "Merge Windows"; Id = "mmpokgfcmbkfdeibafoafkiijdbfblfg"; Category = "Tab Management" },
        @{ Name = "MetaMask"; Id = "nkbihfbeogaeaoehlefnkodbefgpgknn"; Category = "Crypto" },
        @{ Name = "Microsoft Power Automate"; Id = "ljglajjnnkapghbckkcmodicjhacbfhk"; Category = "Automation" },
        @{ Name = "New tab page by start.me"; Id = "cfmnkhhioonhiehehedmnjibmampjiab"; Category = "New Tab" },
        @{ Name = "Nighthawk by PhishFort"; Id = "bdiohckpogchppdldbckcdjlklanhkfc"; Category = "Security" },
        @{ Name = "NopeCHA: CAPTCHA Solver"; Id = "dknlfmjaanfblgfdfebhijalfmhmjjjo"; Category = "Productivity" },
        @{ Name = "NoScript"; Id = "doojmbjmlfjjnbmnoijecmcbfeoakpjm"; Category = "Security" },
        @{ Name = "Obsidian Web Clipper"; Id = "cnjifjpddelmedmihgijeibhnjfabmlf"; Category = "Note Taking" },
        @{ Name = "OneTab"; Id = "chphlpgkkbolifaimnlloiipkdnihall"; Category = "Tab Management" },
        @{ Name = "Perplexity - AI Companion"; Id = "hlgbcneanomplepojfcnclggenpcoldo"; Category = "AI Tools" },
        @{ Name = "Perplexity Shortcut"; Id = "cjamlgjlglelokhjeageobmpmpldlmib"; Category = "AI Tools" },
        @{ Name = "PocketTube: Youtube Subscription Manager"; Id = "kdmnjgijlmjgmimahnillepgcgeemffb"; Category = "YouTube" },
        @{ Name = "Postlight Reader"; Id = "oknpjjbmpnndlpmnhmekjpocelpnlfdi"; Category = "Reading" },
        @{ Name = "Postman Interceptor"; Id = "aicmkgpgakddgnaphhhpliifpcfhicfo"; Category = "Development" },
        @{ Name = "Privacy Badger"; Id = "pkehgijcmpdhfbdbbnkijodmdjhbjlgp"; Category = "Privacy" },
        @{ Name = "Privacy Sandbox Analysis Tool"; Id = "ehbnpceebmgpanbbfckhoefhdibijkef"; Category = "Development" },
        @{ Name = "Project Mariner Companion"; Id = "kadmollpgjhjcclemeliidekkajnjaih"; Category = "AI Tools" },
        @{ Name = "Raycast Companion"; Id = "fgacdjnoljjfikkadhogeofgjoglooma"; Category = "Productivity" },
        @{ Name = "React Developer Tools"; Id = "fmkadmapgofadopljbjfkapdkoienihi"; Category = "Development" },
        @{ Name = "Save my Chatbot - AI Conversation Exporter"; Id = "agklnagmfeooogcppjccdnoallkhgkod"; Category = "AI Tools" },
        @{ Name = "Screencastify - Screen Video Recorder"; Id = "mmeijimgabbpbgpdklnllpncmdofkcpn"; Category = "Recording" },
        @{ Name = "Session Buddy"; Id = "edacconmaakjimmfgnblocblbcdcpbko"; Category = "Session Management" },
        @{ Name = "Shadertoy unofficial plugin"; Id = "ohicbclhdmkhoabobgppffepcopomhgl"; Category = "Development" },
        @{ Name = "ShareGPT"; Id = "daiacboceoaocpibfodeljbdfacokfjb"; Category = "AI Tools" },
        @{ Name = "SponsorBlock for YouTube"; Id = "mnjggcdmjocbbbhaepdhchncahnbgone"; Category = "YouTube" },
        @{ Name = "Stylus"; Id = "clngdbkpkpeebahjckkjfobafhncgmne"; Category = "Customization" },
        @{ Name = "Tab Session Manager"; Id = "iaiomicjabeggjcfkbimgmglanimpnae"; Category = "Session Management" },
        @{ Name = "Tabbie Updated"; Id = "eiigehbpamofgandbmmokoahhkhbmbld"; Category = "Tab Management" },
        @{ Name = "tabExtend - Easy Tab manager"; Id = "ffikidnnejmibopbgbelephlpigeniph"; Category = "Tab Management" },
        @{ Name = "Tabliss - A Beautiful New Tab"; Id = "hipekcciheckooncpjeljhnekcoolahp"; Category = "New Tab" },
        @{ Name = "Tampermonkey"; Id = "dhdgffkkebhmkfjojejmpbldmpobfkfo"; Category = "Scripting" },
        @{ Name = "Textarea Cache"; Id = "chpphekfimlabghbdankokcohcmnbmab"; Category = "Productivity" },
        @{ Name = "TokenPocket - Web3 & Crypto Wallet"; Id = "mfgccjchihfkkindfppnaooecgfneiii"; Category = "Crypto" },
        @{ Name = "uBlock Origin Lite"; Id = "ddkjiahejlhfcafbddmgiahcphecmpfh"; Category = "Ad Blocking" },
        @{ Name = "WebRTC Network Limiter"; Id = "npeicpdbkakmehahjeeohfdhnlpdklia"; Category = "Privacy" },
        @{ Name = "YouTube Ad Auto-skipper"; Id = "lokpenepehfdekijkebhpnpcjjpngpnd"; Category = "YouTube" },
        @{ Name = "Youtube-shorts block"; Id = "jiaopdjbehhjgokpphdfgmapkobbnmjp"; Category = "YouTube" }
    )
    
    return $chromeExtensions
}

function Test-ChromeInstalled {
    $chromePaths = @(
        "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
        "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe",
        "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe"
    )
    
    foreach ($path in $chromePaths) {
        if (Test-Path $path) {
            Write-EnhancedLog "Chrome detected at: $path" -Level SUCCESS -Component "CHROME"
            return $true
        }
    }
    Write-EnhancedLog "Chrome browser not found in standard locations" -Level WARNING -Component "CHROME"
    return $false
}

function Get-ChromeUserDataPath {
    $possiblePaths = @(
        "$env:LOCALAPPDATA\Google\Chrome\User Data",
        "$env:USERPROFILE\AppData\Local\Google\Chrome\User Data"
    )
    
    foreach ($path in $possiblePaths) {
        if (Test-Path $path) {
            return $path
        }
    }
    return $null
}

function Install-ChromeExtensionsAutomated {
    Write-Host "`n`n$('-' * 60)" -ForegroundColor DarkMagenta
    Write-Host ">>> [ DEPLOYMENT: CHROME EXTENSIONS ] <<<" -ForegroundColor Magenta
    Write-Host "$('-' * 60)`n" -ForegroundColor DarkMagenta
    
    if (-not $Global:ScriptConfig.InstallChromeExtensions) {
        Write-EnhancedLog "Chrome extension installation disabled in configuration." -Level INFO -Component "CHROME"
        return
    }
    
    if (-not (Test-ChromeInstalled)) {
        Write-EnhancedLog "Chrome not installed - skipping extension deployment." -Level WARNING -Component "CHROME"
        return
    }
    
    $chromeExtensions = Get-ChromeExtensionList
    
    # Group extensions by category for user selection
    $extensionsByCategory = $chromeExtensions | Group-Object Category
    $selectedExtensions = @()
    
    Write-Host "Chrome Extension Categories Available:" -ForegroundColor Cyan
    $categoryIndex = 1
    $categoryMap = @{}
    
    foreach ($category in $extensionsByCategory) {
        Write-Host "  $categoryIndex. $($category.Name) ($($category.Count) extensions)" -ForegroundColor White
        $categoryMap[$categoryIndex] = $category
        $categoryIndex++
    }
    
    Write-Host "  A. Install ALL extensions (Power User Mode)" -ForegroundColor Yellow
    Write-Host "  S. Skip Chrome extensions" -ForegroundColor Red
    
    $userChoice = Read-Host "`n[INPUT]: Select categories by number (space-separated), 'A' for all, or 'S' to skip"
    
    if ($userChoice.ToLower() -eq 's') {
        Write-EnhancedLog "Chrome extension installation skipped by user choice." -Level INFO -Component "CHROME"
        return
    }
    elseif ($userChoice.ToLower() -eq 'a') {
        $selectedExtensions = $chromeExtensions
        Write-EnhancedLog "All $($selectedExtensions.Count) Chrome extensions selected for installation." -Level INFO -Component "CHROME"
    }
    else {
        $selections = $userChoice -split ' ' | Where-Object { $_ -match '^\d+ } | ForEach-Object { [int]$_ }
        foreach ($selection in $selections) {
            if ($categoryMap.ContainsKey($selection)) {
                $selectedExtensions += $categoryMap[$selection].Group
            }
        }
        Write-EnhancedLog "Selected $($selectedExtensions.Count) Chrome extensions from $($selections.Count) categories." -Level INFO -Component "CHROME"
    }
    
    if ($selectedExtensions.Count -eq 0) {
        Write-EnhancedLog "No extensions selected for installation." -Level WARNING -Component "CHROME"
        return
    }
    
    # Create extension installation registry entries
    $extPolicyPath = "HKLM:\SOFTWARE\Policies\Google\Chrome\ExtensionInstallForcelist"
    
    try {
        if (-not (Test-Path "HKLM:\SOFTWARE\Policies\Google")) {
            New-Item -Path "HKLM:\SOFTWARE\Policies\Google" -Force | Out-Null
        }
        if (-not (Test-Path "HKLM:\SOFTWARE\Policies\Google\Chrome")) {
            New-Item -Path "HKLM:\SOFTWARE\Policies\Google\Chrome" -Force | Out-Null
        }
        if (-not (Test-Path $extPolicyPath)) {
            New-Item -Path $extPolicyPath -Force | Out-Null
        }
        
        Write-EnhancedLog "Chrome extension policy registry path created." -Level SUCCESS -Component "CHROME"
    } catch {
        Write-EnhancedLog "Failed to create Chrome extension policy registry path: $($_.Exception.Message)" -Level ERROR -Component "CHROME"
        return
    }
    
    # Install extensions via registry policy (forced installation)
    $extensionIndex = 1
    $installedCount = 0
    $failedCount = 0
    
    foreach ($extension in $selectedExtensions) {
        try {
            $extValue = "$($extension.Id);https://clients2.google.com/service/update2/crx"
            Set-ItemProperty -Path $extPolicyPath -Name $extensionIndex -Value $extValue -Type String -ErrorAction Stop
            Write-EnhancedLog "Registered extension for auto-install: $($extension.Name)" -Level SUCCESS -Component "CHROME"
            $installedCount++
            $extensionIndex++
        } catch {
            Write-EnhancedLog "Failed to register extension $($extension.Name): $($_.Exception.Message)" -Level ERROR -Component "CHROME"
            $failedCount++
        }
    }
    
    Write-Host "`n---[ Chrome Extension Installation Summary ]---" -ForegroundColor Green
    Write-Host "  Registered: $installedCount extensions" -ForegroundColor Green
    Write-Host "  Failed: $failedCount extensions" -ForegroundColor Red
    
    Write-Host "`n[IMPORTANT]: Extensions will be automatically installed when Chrome is next launched." -ForegroundColor Yellow
    Write-Host "[NOTE]: Some extensions may require user permissions on first run." -ForegroundColor Cyan
    
    # Optional: Launch Chrome to trigger extension installation
    if ($installedCount -gt 0) {
        $launchChoice = Read-Host "`n[OPTIONAL]: Launch Chrome now to trigger extension installation? (Y/N)"
        if ($launchChoice.ToLower() -eq 'y') {
            try {
                $chromePath = Get-ChildItem -Path "$env:ProgramFiles\Google\Chrome\Application\chrome.exe", "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe", "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe" -ErrorAction SilentlyContinue | Select-Object -First 1
                if ($chromePath) {
                    Start-Process $chromePath.FullName -ArgumentList "--no-first-run", "--disable-default-browser-check"
                    Write-EnhancedLog "Chrome launched to trigger extension installation." -Level SUCCESS -Component "CHROME"
                    Start-Sleep -Seconds 5
                } else {
                    Write-EnhancedLog "Could not locate Chrome executable for launch." -Level ERROR -Component "CHROME"
                }
            } catch {
                Write-EnhancedLog "Failed to launch Chrome: $($_.Exception.Message)" -Level ERROR -Component "CHROME"
            }
        }
    }
}

function Enable-WindowsFeatures {
    $features = @(
        @{ Name="Windows Subsystem for Linux (WSL)"; Id="Microsoft-Windows-Subsystem-Linux"; Status="" },
        @{ Name="Virtual Machine Platform"; Id="VirtualMachinePlatform"; Status="" },
        @{ Name="Windows Hypervisor Platform"; Id="HypervisorPlatform"; Status="" },
        @{ Name="Windows Sandbox"; Id="Containers-DisposableClientVM"; Status="" },
        @{ Name="OpenSSH Client"; Id="OpenSSH-Client-Package"; Status="" },
        @{ Name="Telnet Client"; Id="TelnetClient"; Status="" },
        @{ Name="Create 'God Mode' Icon on Desktop"; Id="GodMode"; Status="" }
    )
    $pendingChanges = @{}
    while ($true) {
        Clear-Host
        Write-Host "===================================================" -ForegroundColor Cyan; Write-Host "===        WINDOWS FEATURES & TWEAKS          ===" -ForegroundColor Cyan; Write-Host "===================================================" -ForegroundColor Cyan
        for ($i = 0; $i -lt $features.Count; $i++) {
            $feature = $features[$i]; $statusText = ""; $color = "DarkGray"
            $godModePath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath('Desktop'), 'GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}')
            if ($feature.Id -eq "GodMode") {
                if (Test-Path $godModePath) { $statusText = "[ENABLED]"; $color = "Green" }
                else { $statusText = "[NOT CREATED]"; $color = "Yellow" }
            } else {
                try {
                    $featureState = (Get-WindowsOptionalFeature -Online -FeatureName $feature.Id).State
                    if ($featureState -eq 'Enabled') { $statusText = "[ENABLED]"; $color = "Green" } else { $statusText = "[DISABLED]"; $color = "Yellow" }
                } catch { $statusText = "[ERROR CHECKING]"; $color = "Red" }
            }
            if ($pendingChanges.ContainsKey($feature.Id)) { $statusText = "[PENDING ENABLE]"; $color = "Magenta" }
            $features[$i].Status = $statusText
            Write-Host ("  " + ($i+1) + ". " + $feature.Name).PadRight(45) -NoNewline; Write-Host "$statusText" -ForegroundColor $color
        }
        Write-Host "`n  A. Apply Selections and Return" -ForegroundColor Green; Write-Host "  B. Back to Main Menu (No Changes)" -ForegroundColor Red
        $input = Read-Host "`n[INPUT]: Enter numbers of disabled features to ENABLE, 'A' to apply, or 'B' to go back: "
        if ($input.ToLower() -eq "b") { return }; if ($input.ToLower() -eq "a") { break }
        $selections = $input -split ' ' | Where-Object { $_ -match '^\d+ } | ForEach-Object { [int]$_ }
        foreach ($selection in $selections) {
            if ($selection -ge 1 -and $selection -le $features.Count) {
                $featureToToggle = $features[$selection - 1]
                if ($featureToToggle.Status -like "*ENABLED*") {
                    Write-Host "`n  [INFO]: '$($featureToToggle.Name)' is already enabled." -ForegroundColor Yellow; Start-Sleep -Seconds 2
                } else {
                    $pendingChanges[$featureToToggle.Id] = $true
                    Write-Host "`n  [PENDING]: '$($featureToToggle.Name)' queued for activation." -ForegroundColor Magenta; Start-Sleep -Seconds 1
                }
            }
        }
    }
    if ($pendingChanges.Count -eq 0) { Write-EnhancedLog "No features were selected for enabling." -Level INFO; return }
    $restartNeeded = $false
    foreach ($id in $pendingChanges.Keys) {
        $feature = $features | Where-Object { $_.Id -eq $id }
        Write-EnhancedLog "Processing feature: $($feature.Name)" -Level INFO -Component "WINFEATURES"
        if ($feature.Id -eq "GodMode") {
            try { New-Item -Path ([System.IO.Path]::Combine([System.Environment]::GetFolderPath('Desktop'), 'GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}')) -ItemType Directory -Force | Out-Null; Write-EnhancedLog "God Mode icon created." -Level SUCCESS } 
            catch { Write-EnhancedLog "Failed to create God Mode icon: $($_.Exception.Message)" -Level ERROR -Component "WINFEATURES" }
        } else {
            Write-EnhancedLog "Enabling Windows feature: $($feature.Id)" -Level INFO -Component "WINFEATURES"
            try {
                $result = Enable-WindowsOptionalFeature -Online -FeatureName $feature.Id -All -NoRestart -ErrorAction Stop
                Write-EnhancedLog "Enabled feature: $($feature.Name)." -Level SUCCESS; if ($result.RestartNeeded) { $restartNeeded = $true }
            } catch { Write-EnhancedLog "Failed to enable feature '$($feature.Name)': $($_.Exception.Message)" -Level ERROR -Component "WINFEATURES" }
        }
    }
    if ($restartNeeded) { Write-Host "`n[ALERT]: Some features require a system restart to complete." -ForegroundColor Yellow }
    Write-Host "`nFeature configuration complete. Press any key to return..." -ForegroundColor Green; $null = Read-Host
}

function Manage-Profiles {
    param([ref]$selectedSoftwareRef)
    while ($true) {
        Clear-Host
        Write-Host "===================================================" -ForegroundColor Yellow; Write-Host "===        PROFILE MANAGEMENT INTERFACE       ===" -ForegroundColor Yellow; Write-Host "===================================================" -ForegroundColor Yellow
        Write-Host "  1. [ACTION]: Export Current Selection as Profile" -ForegroundColor Green
        Write-Host "  2. [ACTION]: Import Profile to Load Selection" -ForegroundColor Cyan
        Write-Host "  3. [ACTION]: View Existing Profiles" -ForegroundColor DarkCyan
        Write-Host "  B. [ACTION]: Back to Main Menu" -ForegroundColor Red
        $choice = (Read-Host "`n[INPUT]: Enter your choice: ").ToLower()
        switch ($choice) {
            "1" { $profileName = Read-Host "`n[INPUT]: Enter a name for the profile: "; if ($profileName) { Export-InstallationProfile -SelectedSoftware $selectedSoftwareRef.Value -ProfileName $profileName } else { Write-EnhancedLog "Profile name cannot be empty." -Level WARNING }; Start-Sleep -Seconds 2 }
            "2" {
                $profilePath = $Global:ScriptConfig.ProfilePath
                $profiles = Get-ChildItem -Path $profilePath -Filter "*.json" -ErrorAction SilentlyContinue
                if (-not $profiles) { Write-EnhancedLog "No profiles found in '$profilePath'." -Level INFO; Start-Sleep -Seconds 2; continue }
                $profileIndex = 1; foreach ($profileFile in $profiles) { Write-Host "  $profileIndex. $($profileFile.BaseName)" -ForegroundColor White; $profileIndex++ }
                $profileChoice = Read-Host "`n[INPUT]: Enter the number of the profile to import: "
                if ($profileChoice -match '^\d+ } -and [int]$profileChoice -ge 1 -and [int]$profileChoice -le $profiles.Count) {
                    $selectedProfileFile = $profiles[[int]$profileChoice - 1]
                    $importedSelection = Import-InstallationProfile -ProfilePath $selectedProfileFile.FullName
                    if ($importedSelection) { $selectedSoftwareRef.Value = $importedSelection; Write-EnhancedLog "Profile '$($selectedProfileFile.BaseName)' imported." -Level SUCCESS }
                } else { Write-EnhancedLog "Invalid profile selection." -Level WARNING }
                Start-Sleep -Seconds 2
            }
            "3" {
                $profilePath = $Global:ScriptConfig.ProfilePath
                $profiles = Get-ChildItem -Path $profilePath -Filter "*.json" -ErrorAction SilentlyContinue
                if (-not $profiles) { Write-EnhancedLog "No profiles found in '$profilePath'." -Level INFO; Start-Sleep -Seconds 2; continue }
                Write-Host "`n[EXISTING PROFILES]:" -ForegroundColor DarkCyan
                foreach ($profileFile in $profiles) {
                    try {
                        $profileData = Get-Content $profileFile.FullName | ConvertFrom-Json
                        Write-Host "  - Name: $($profileData.ProfileName), Created: $($profileData.CreatedDate), Packages: $($profileData.SelectedSoftware.Keys.Count)" -ForegroundColor White
                    } catch { Write-Warning "Could not read profile file: $($profileFile.BaseName)" }
                }
                Read-Host "`nPress any key to return..." | Out-Null
            }
            'b' { return }
            default { Write-EnhancedLog "Invalid choice." -Level WARNING; Start-Sleep -Seconds 2 }
        }
    }
}

function Show-MasterSelectionMenu {
    param([ref]$selectedSoftwareRef, $softwareList)
    Clear-Host
    Write-Host "===================================================" -ForegroundColor Cyan; Write-Host "===  WINGET BULK INSTALLER: MASTER SELECTION V4.0.5 ===" -ForegroundColor Cyan; Write-Host "===================================================" -ForegroundColor Cyan
    if ($selectedSoftwareRef.Value.Count -gt 0) {
        Write-Host "`n---[ Current Selections: $($selectedSoftwareRef.Value.Count) items ]---" -ForegroundColor Green
    } else {
        Write-Host "`n---[ No items selected ]---" -ForegroundColor Yellow
    }

    $itemsToDisplay = $softwareList | Where-Object { $_.Id }
    $indexMap = @{}
    $numColumns = $Global:ScriptConfig.MasterViewColumnCount
    $colWidth = [math]::Floor(($Host.UI.RawUI.WindowSize.Width - ($numColumns * 2)) / $numColumns)
    if ($colWidth -lt 20) { $colWidth = 20 }
    $numRows = [math]::Ceiling($itemsToDisplay.Count / $numColumns)
    
    Write-Host ""
    for ($i = 0; $i -lt $numRows; $i++) {
        $lineItems = for ($j = 0; $j -lt $numColumns; $j++) {
            $index = $i + ($j * $numRows)
            if ($index -lt $itemsToDisplay.Count) {
                $item = $itemsToDisplay[$index]
                $currentIndex = $i + ($j * $numRows) + 1
                $indexMap[$currentIndex] = $item.Id

                $checkbox = if ($selectedSoftwareRef.Value.ContainsKey($item.Id)) { "[X]" } else { "[ ]" }
                $displayText = "$checkbox $($currentIndex.ToString().PadLeft(2)). $($item.Name)"
                if ($displayText.Length -gt ($colWidth - 2)) { $displayText = $displayText.Substring(0, $colWidth - 5) + "..." }
                
                $displayText.PadRight($colWidth)
            }
        }
        Write-Host ($lineItems -join "  ")
    }

    Write-Host "`n" + ("-" * $Host.UI.RawUI.WindowSize.Width)
    Write-Host "(D)eploy Selections | (P)rofiles | (F)eatures | Deselect (A)ll | (S)elect All | (Q)uit" -ForegroundColor Yellow
    $choice = Read-Host "[INPUT]: Enter numbers to toggle, or an action letter"
    
    $selections = $choice -split ' ' | Where-Object { $_ -match '^\d+ } | ForEach-Object { [int]$_ }
    if ($selections.Count -gt 0) {
        foreach ($selection in $selections) {
            if ($indexMap.ContainsKey($selection)) {
                $idToToggle = $indexMap[$selection]
                if ($selectedSoftwareRef.Value.ContainsKey($idToToggle)) { $selectedSoftwareRef.Value.Remove($idToToggle) }
                else { $selectedSoftwareRef.Value[$idToToggle] = $true }
            }
        }
        return "CONTINUE"
    } else {
        return $choice
    }
}

function Generate-InstallScript {
    param([hashtable]$selectedSoftware, $softwareList, $criticalSoftware, $OptionalSoftwarePacks)
    Clear-Host
    Write-Host "===================================================" -ForegroundColor Magenta; Write-Host "===  DEPLOYMENT PREPARATION: PROGRAM ROLLOUT  ===" -ForegroundColor Magenta; Write-Host "===================================================" -ForegroundColor Magenta
    $wingetInstallCommands = @()

    # Handle critical software first
    Write-EnhancedLog "Prompting for critical software..." -Component "DEPLOY"
    foreach($item in $criticalSoftware) {
        if ($item.PSObject.Properties['Condition'] -ne $null -and $item.Condition.Invoke()) {
            if ((Read-Host "`n[CRITICAL]: Your system supports '$($item.Name)'. Install? (Y/N):").ToLower() -eq 'y') {
                $wingetInstallCommands += [PSCustomObject]@{ Id = $item.Id; Command = "winget install $($item.Id) --accept-source-agreements --silent --scope machine" }
            }
        }
    }

    # Add regularly selected software
    foreach ($id in $selectedSoftware.Keys) {
        $item = $softwareList | Where-Object { $_.Id -eq $id }
        if ($item) { $wingetInstallCommands += [PSCustomObject]@{ Id = $item.Id; Command = "winget install $($item.Id) --accept-source-agreements --silent --scope machine" } }
    }
    
    # Handle optional packs
    if ($OptionalSoftwarePacks.Count -gt 0) {
        Write-Host "`n---[ Optional Software Packs Available ]---" -ForegroundColor Yellow
        foreach ($pack in $OptionalSoftwarePacks) {
            Write-Host "  Pack: $($pack.Name)" -ForegroundColor Cyan
            Write-Host "    Contains: $($pack.PackageIds -join ', ')" -ForegroundColor DarkGray
        }
        if ((Read-Host "`n[INPUT]: Authorize ALL optional software packs (Gaming, Dev Suite, etc.)? (Y/N): ").ToLower() -eq "y") {
            foreach ($pack in $OptionalSoftwarePacks) {
                foreach ($packageId in $pack.PackageIds) {
                    $packageInfo = Get-EnhancedWingetPackageInfo $packageId
                    if ($packageInfo.Status -eq "Not Installed" -or $packageInfo.Status -eq "Update Available") { $wingetInstallCommands += [PSCustomObject]@{ Id = $packageId; Command = "winget install $($packageId) --accept-source-agreements --silent --scope machine" } }
                }
            }
        }
    }
    
    if ($wingetInstallCommands.Count -eq 0) {
        Write-EnhancedLog "No programs authorized for installation." -Level WARNING
        Read-Host "No software was selected or approved for installation. Press Enter to return."
        return
    }
    
    Write-Host "`n---[ FINAL DEPLOYMENT MANIFEST ]---" -ForegroundColor Green
    $wingetInstallCommands.Id | ForEach-Object { Write-Host "- $_" -ForegroundColor White }
    
    if ((Read-Host "`n[INITIATE]: Proceed with the installation of $($wingetInstallCommands.Count) programs? (Y/N): ").ToLower() -eq "y") {
        $commandsToRun = $wingetInstallCommands.Command
        $installResult = if ($Global:ScriptConfig.ParallelInstalls) {
            Start-ParallelInstallation -PackageInstallCommands $commandsToRun -MaxConcurrentJobs $Global:ScriptConfig.MaxConcurrentJobs
        } else {
            # Sequential installation logic
            $failedPackages = @(); $allPackageIds = $wingetInstallCommands.Id; $i = 1
            foreach ($cmdObj in $wingetInstallCommands) {
                Write-Progress -Activity "Installing Software" -Status "Installing $($cmdObj.Id) ($i of $($wingetInstallCommands.Count))" -PercentComplete (($i / $wingetInstallCommands.Count) * 100)
                try { Invoke-Expression $cmdObj.Command 2>&1 | Out-Null; if ($LASTEXITCODE -ne 0) { $failedPackages += $cmdObj.Id }
                } catch { $failedPackages += $cmdObj.Id }
                $i++
            }
            Write-Progress -Activity "Installing Software" -Completed
            $successfulPackages = $allPackageIds | Where-Object { $_ -notin $failedPackages }
            @{ TotalPackages = $wingetInstallCommands.Count; Successful = $successfulPackages.Count; Failed = $failedPackages.Count; FailedPackages = $failedPackages; SuccessfulPackages = $successfulPackages }
        }
        Write-Host "`nDeployment Summary:`n  Attempted: $($installResult.TotalPackages)`n  Successful: $($installResult.Successful)`n  Failed: $($installResult.Failed)" -ForegroundColor Green
        if ($installResult.Failed -gt 0) { Write-Host "  Failed Packages: $($installResult.FailedPackages -join ', ')" -ForegroundColor Red }

        Write-EnhancedLog "Starting post-installation tasks..." -Level INFO -Component "POST-INSTALL"
        
        # Install Chrome extensions if Chrome was installed
        if ("Google.Chrome" -in $installResult.SuccessfulPackages -or (Test-ChromeInstalled)) {
            Write-EnhancedLog "Chrome detected. Deploying Chrome extensions..." -Level INFO -Component "POST-INSTALL"
            Install-ChromeExtensionsAutomated
        }
        
        if ("Microsoft.VisualStudioCode" -in $installResult.SuccessfulPackages) {
            Write-EnhancedLog "Visual Studio Code was installed. Now deploying extensions..." -Level INFO -Component "POST-INSTALL"
            Install-VSCodeExtensions
        }
        Install-PowerShellModules
        Install-AdditionalFonts
        Set-TerminalFont -FontName "Hack NF"
        Set-CustomMouseCursors
        Guide-VoiceInstallation
        Read-Host "`nAll operations complete. Press Enter to exit..." | Out-Null
    } else { Write-EnhancedLog "Deployment cancelled by user." -Level INFO; Read-Host "Press Enter to return..." | Out-Null }
}

function Install-AdditionalFonts {
    Write-Host "`n`n$('-' * 60)" -ForegroundColor DarkMagenta; Write-Host ">>> [ DEPLOYMENT: CUSTOM FONT PACK ] <<<" -ForegroundColor Magenta; Write-Host "$('-' * 60)`n" -ForegroundColor DarkMagenta
    $fonts = @( "SorkinType.Literata", "Google.Lora", "ParaType.PTSerif", "Mozilla.FiraSans", "Google.NotoSans", "Omnibus-Type.Rambla", "RedHat.Sen", "Google.Lexend" )
    $fontCommands = $fonts | ForEach-Object { "winget install --id $_ --accept-package-agreements --accept-source-agreements --silent" }
    Write-EnhancedLog "Adding $($fonts.Count) custom fonts to the installation queue." -Level INFO -Component "FONT"
    try {
        $installResult = Start-ParallelInstallation -PackageInstallCommands $fontCommands -MaxConcurrentJobs $Global:ScriptConfig.MaxConcurrentJobs
        Write-EnhancedLog "Font installation complete. Successful: $($installResult.Successful), Failed: $($installResult.Failed)" -Level INFO -Component "FONT"
    } catch {
        Write-EnhancedLog "A critical error occurred during font installation: $($_.Exception.Message)" -Level ERROR -Component "FONT"
    }
}

function Set-CustomMouseCursors {
    Write-Host "`n`n$('-' * 60)" -ForegroundColor DarkMagenta; Write-Host ">>> [ CONFIGURATION: CUSTOM MOUSE CURSORS ] <<<" -ForegroundColor Magenta; Write-Host "$('-' * 60)`n" -ForegroundColor DarkMagenta
    
    $cursorBasePath = $null
    $drives = Get-PSDrive -PSProvider FileSystem
    foreach($drive in $drives){
        try {
            $path = Join-Path $drive.Root $Global:ScriptConfig.CustomCursorDirectory -ErrorAction Stop
            if(Test-Path $path){
                $cursorBasePath = $path
                Write-EnhancedLog "Found custom cursor directory at: $cursorBasePath" -Level SUCCESS -Component "CURSOR"
                break
            }
        } catch {}
    }

    if (-not $cursorBasePath) {
        Write-EnhancedLog "Custom cursor directory '$($Global:ScriptConfig.CustomCursorDirectory)' not found on any drive. Skipping." -Level WARNING -Component "CURSOR"
        return
    }

    $cursorRegPath = "HKCU:\Control Panel\Cursors"
    $workingCursorFile = Join-Path $cursorBasePath $Global:ScriptConfig.WorkingInBackgroundCursorFile
    $busyCursorFile = Join-Path $cursorBasePath $Global:ScriptConfig.BusyCursorFile

    try {
        if (Test-Path $workingCursorFile) {
            Write-EnhancedLog "Setting 'Working in Background' cursor to $workingCursorFile..." -Level INFO -Component "CURSOR"
            Set-ItemProperty -Path $cursorRegPath -Name "AppStarting" -Value $workingCursorFile -ErrorAction Stop
        } else {
            Write-EnhancedLog "Cursor file not found, skipping: $workingCursorFile" -Level WARNING -Component "CURSOR"
        }

        if (Test-Path $busyCursorFile) {
            Write-EnhancedLog "Setting 'Busy' cursor to $busyCursorFile..." -Level INFO -Component "CURSOR"
            Set-ItemProperty -Path $cursorRegPath -Name "Wait" -Value $busyCursorFile -ErrorAction Stop
        } else {
            Write-EnhancedLog "Cursor file not found, skipping: $busyCursorFile" -Level WARNING -Component "CURSOR"
        }
    } catch {
        Write-EnhancedLog "Failed to set cursor registry keys: $($_.Exception.Message)" -Level ERROR -Component "CURSOR"
    }
}

function Install-PowerShellModules {
    Write-Host "`n`n$('-' * 60)" -ForegroundColor DarkMagenta; Write-Host ">>> [ DEPLOYMENT: POWERSHELL MODULES ] <<<" -ForegroundColor Magenta; Write-Host "$('-' * 60)`n" -ForegroundColor DarkMagenta
    try {
        Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -ErrorAction Stop | Out-Null
    } catch { Write-EnhancedLog "Failed to install NuGet provider: $($_.Exception.Message)" -Level ERROR -Component "PSMODULES" }
    $modules = @("PSWindowsUpdate", "Posh-Git", "Oh-My-Posh", "Terminal-Icons")
    foreach ($module in $modules) {
        if (-not (Get-Module -ListAvailable -Name $module)) {
            Write-EnhancedLog "Installing PowerShell module: $module..." -Level INFO -Component "PSMODULES"
            try {
                Install-Module -Name $module -Scope CurrentUser -Repository PSGallery -Force -Confirm:$false -ErrorAction Stop
                Write-EnhancedLog "Successfully installed module '$module'." -Level SUCCESS -Component "PSMODULES"
            } catch { Write-EnhancedLog "Failed to install module '$module': $($_.Exception.Message)" -Level ERROR -Component "PSMODULES" }
        } else { Write-EnhancedLog "Module '$module' is already installed." -Level INFO -Component "PSMODULES" }
    }
}

function Install-VSCodeExtensions {
    Write-Host "`n`n$('-' * 60)" -ForegroundColor DarkMagenta; Write-Host ">>> [ DEPLOYMENT: VS CODE EXTENSIONS ] <<<" -ForegroundColor Magenta; Write-Host "$('-' * 60)`n" -ForegroundColor DarkMagenta
    if (-not (Get-Command code -ErrorAction SilentlyContinue)) {
        Write-EnhancedLog "VS Code command 'code' not found in PATH. Skipping." -Level WARNING -Component "VSCODE"
        Write-Host "  [ALERT]: VS Code not in PATH. Ensure it was installed with 'Add to PATH' enabled." -ForegroundColor Yellow
        Start-Sleep -Seconds 4; return
    }
    $extensions = @( "ms-vscode.powershell", "eamodio.gitlens", "dbaeumer.vscode-eslint", "esbenp.prettier-vscode", "VisualStudioExptTeam.vscodeintellicode", "streetsidesoftware.code-spell-checker", "ms-azuretools.vscode-docker", "pkief.material-icon-theme" )
    foreach ($ext in $extensions) {
        Write-EnhancedLog "Installing VS Code extension: $ext..." -Level INFO -Component "VSCODE"
        try {
            code --install-extension $ext --force 2>&1 | Out-Null
            if($LASTEXITCODE -eq 0) { Write-EnhancedLog "Successfully installed extension '$ext'." -Level SUCCESS -Component "VSCODE" }
            else { Write-EnhancedLog "Failed to install extension '$ext'. It may already exist." -Level WARNING -Component "VSCODE" }
        } catch { Write-EnhancedLog "Exception installing extension '$ext': $($_.Exception.Message)" -Level ERROR -Component "VSCODE" }
    }
}

function Set-TerminalFont {
    param([string]$FontName)
    Write-EnhancedLog "Attempting to configure Windows Terminal font to '$FontName'..." -Level INFO -Component "FONT"
    $wtSettingsPath = Join-Path $env:LOCALAPPDATA "Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    if (-not (Test-Path $wtSettingsPath)) {
        Write-EnhancedLog "Windows Terminal settings.json not found. Skipping font configuration." -Level WARNING -Component "FONT"
        return
    }
    try {
        $originalContent = Get-Content $wtSettingsPath -Raw
        $sanitizedContent = $originalContent -replace '(?m)//.*?\*/' -replace '(?m)//.*'
        $settings = $sanitizedContent | ConvertFrom-Json
        if (-not $settings.profiles.defaults.font) { $settings.profiles.defaults | Add-Member -MemberType NoteProperty -Name 'font' -Value (New-Object PSObject) }
        $settings.profiles.defaults.font.face = $FontName
        foreach ($profile in $settings.profiles.list) {
            if (-not $profile.font) { $profile | Add-Member -MemberType NoteProperty -Name 'font' -Value (New-Object PSObject) }
            $profile.font.face = $FontName
        }
        $settings | ConvertTo-Json -Depth 10 | Set-Content $wtSettingsPath -Encoding utf8
        Write-EnhancedLog "Successfully configured Windows Terminal profiles to use font '$FontName'." -Level SUCCESS -Component "FONT"
    } catch { Write-EnhancedLog "Failed to configure Windows Terminal font: $($_.Exception.Message)" -Level ERROR -Component "FONT" }
}

function Guide-VoiceInstallation {
    Write-Host "`n`n$('-' * 60)" -ForegroundColor DarkCyan; Write-Host ">>> [ GUIDE: INSTALL HIGH-QUALITY TTS VOICES ] <<<" -ForegroundColor Cyan; Write-Host "$('-' * 60)`n" -ForegroundColor DarkCyan
    Write-Host "  To improve Text-to-Speech quality, install Microsoft's 'Natural' voices via Windows Settings." -ForegroundColor White
    Write-Host "`n  [INSTRUCTIONS]: Settings > Time & language > Speech > Add voices" -ForegroundColor Green
    Write-EnhancedLog "Displayed guide for manual installation of Natural TTS voices." -Level INFO -Component "VOICE"
    Write-Host "`nPress any key to continue..." -ForegroundColor Yellow; $null = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp")
}

# ---[ DATA DEFINITIONS ]---

$criticalSoftware = @(
    [PSCustomObject]@{ Name = "VC++ Runtimes (2015+)"; Id = "Microsoft.VCRedist.2015+"; Condition = { $true } },
    [PSCustomObject]@{ Name = "AMD Radeon Software"; Id = "AdvancedMicroDevices.AMDRadeonSoftware"; Condition = { $Global:hardwareInfo.HasAMDGraphics } },
    [PSCustomObject]@{ Name = "Intel Graphics Command Center"; Id = "9PBLGZ52FNL3"; Condition = { $Global:hardwareInfo.HasIntelGraphics } },
    [PSCustomObject]@{ Name = "NVIDIA App"; Id = "NVIDIA.NVIDIAApp"; Condition = { $Global:hardwareInfo.HasNVIDIAGraphics } }
)

$softwareList = @(
    [PSCustomObject]@{ Name = "7-Zip"; Id = "7zip.7zip" }, [PSCustomObject]@{ Name = "CPU-Z"; Id = "CPUID.CPU-Z" },
    [PSCustomObject]@{ Name = "CrystalDiskInfo"; Id = "CrystalDewWorld.CrystalDiskInfo" }, [PSCustomObject]@{ Name = "CrystalDiskMark"; Id = "CrystalDewWorld.CrystalDiskMark" },
    [PSCustomObject]@{ Name = "HWiNFO64"; Id = "REALiX.HWiNFO" }, [PSCustomObject]@{ Name = "System Informer"; Id = "WinsiderSS.SystemInformer" },
    [PSCustomObject]@{ Name = "Everything"; Id = "voidtools.everything" }, [PSCustomObject]@{ Name = "WinDirStat"; Id = "WinDirStat.WinDirStat" },
    [PSCustomObject]@{ Name = "PowerToys"; Id = "Microsoft.PowerToys" }, [PSCustomObject]@{ Name = "WizFile"; Id = "AntibodySoftware.WizFile" },
    [PSCustomObject]@{ Name = "LockHunter"; Id = "CrystalRich.LockHunter" }, [PSCustomObject]@{ Name = "btop"; Id = "aristocratos.btop4win" },
    [PSCustomObject]@{ Name = "Python 3.12"; Id = "Python.Python.3.12" }, [PSCustomObject]@{ Name = "Git"; Id = "Git.Git" },
    [PSCustomObject]@{ Name = "Git LFS"; Id = "Git.GitLFS" }, [PSCustomObject]@{ Name = "Node.js (LTS)"; Id = "OpenJS.NodeJS.LTS" },
    [PSCustomObject]@{ Name = "JDK (Temurin 17)"; Id = "EclipseAdoptium.Temurin.17" }, [PSCustomObject]@{ Name = "Rust (rustup)"; Id = "Rustlang.Rustup" },
    [PSCustomObject]@{ Name = "Go"; Id = "GoLang.Go" }, [PSCustomObject]@{ Name = "PowerShell"; Id = "Microsoft.PowerShell" },
    [PSCustomObject]@{ Name = "cURL"; Id = "curl.curl" }, [PSCustomObject]@{ Name = "Wget"; Id = "jemmy.wget" },
    [PSCustomObject]@{ Name = "tldr"; Id = "tldr-pages.tldr" }, [PSCustomObject]@{ Name = "jq"; Id = "jqlang.jq" },
    [PSCustomObject]@{ Name = "kubectl"; Id = "Kubernetes.kubectl" }, [PSCustomObject]@{ Name = "Notepad++"; Id = "Notepad++.Notepad++" },
    [PSCustomObject]@{ Name = "Visual Studio Code"; Id = "Microsoft.VisualStudioCode" }, [PSCustomObject]@{ Name = "VSCodium"; Id = "VSCodium.VSCodium" },
    [PSCustomObject]@{ Name = "Sublime Text 4"; Id = "SublimeHQ.SublimeText.4" }, [PSCustomObject]@{ Name = "SumatraPDF"; Id = "SumatraPDF.SumatraPDF" },
    [PSCustomObject]@{ Name = "WinMerge"; Id = "WinMerge.WinMerge" }, [PSCustomObject]@{ Name = "HxD Hex Editor"; Id = "MHNexus.HxD" },
    [PSCustomObject]@{ Name = "fzf"; Id = "junegunn.fzf" }, [PSCustomObject]@{ Name = "tree"; Id = "microsoft.tree" },
    [PSCustomObject]@{ Name = "tmux"; Id = "PowerShell.tmux" }, [PSCustomObject]@{ Name = "Windows Terminal"; Id = "Microsoft.WindowsTerminal" },
    [PSCustomObject]@{ Name = "WSL"; Id = "Microsoft.WSL" }, [PSCustomObject]@{ Name = "WSA"; Id = "Microsoft.WSAPackageManagerPreview" },
    [PSCustomObject]@{ Name = "Sandboxie Plus"; Id = "sandboxie-plus.sandboxie-plus" }, [PSCustomObject]@{ Name = "Oracle VM VirtualBox"; Id = "Oracle.VirtualBox" },
    [PSCustomObject]@{ Name = "VMware Player"; Id = "VMware.WorkstationPlayer" }, [PSCustomObject]@{ Name = "AnythingLLM"; Id = "Mintplex-Labs.AnythingLLM" },
    [PSCustomObject]@{ Name = "LM Studio"; Id = "LMStudio.LMStudio" }, [PSCustomObject]@{ Name = "VirtualCloneDrive"; Id = "ElaborateBytes.VirtualCloneDrive" },
    [PSCustomObject]@{ Name = "Google Chrome"; Id = "Google.Chrome" }, [PSCustomObject]@{ Name = "Mozilla Firefox"; Id = "Mozilla.Firefox" },
    [PSCustomObject]@{ Name = "Discord"; Id = "Discord.Discord" }, [PSCustomObject]@{ Name = "qBittorrent"; Id = "qBittorrent.qBittorrent" },
    [PSCustomObject]@{ Name = "Rainmeter"; Id = "Rainmeter.Rainmeter" }, [PSCustomObject]@{ Name = "yt-dlp"; Id = "yt-dlp.yt-dlp" },
    [PSCustomObject]@{ Name = "CinebenchR23"; Id = "Maxon.CinebenchR23" }, [PSCustomObject]@{ Name = "SQLite"; Id = "SQLite.SQLite" },
    [PSCustomObject]@{ Name = "Microsoft OneDrive"; Id = "Microsoft.OneDrive" }, [PSCustomObject]@{ Name = "Google Drive"; Id = "Google.Drive" },
    [PSCustomObject]@{ Name = "Dropbox"; Id = "Dropbox.Dropbox" }, [PSCustomObject]@{ Name = "Hack Font"; Id = "SourceFoundry.Hack" }
)

$OptionalSoftwarePacks = @(
    @{ Name = "Gaming & Streaming Suite"; PackageIds = @( "Valve.Steam", "EpicGames.EpicGamesLauncher", "GOG.Galaxy", "Blizzard.BattleNet", "ElectronicArts.EAAp", "Ubisoft.Connect", "Microsoft.XboxApp", "MSI.Afterburner", "Razer.Synapse3", "Logitech.GHUB", "Corsair.iCUE.4", "SteelSeries.SteelSeriesEngine", "OBSProject.OBSStudio", "Streamlabs.StreamlabsDesktop", "SplitmediaLabs.XSplit", "Parsec.Parsec", "MoonlightGameStreamingProject.Moonlight", "Unwinder.RTSS", "CXWorld.CapFrameX" ) },
    @{ Name = "Advanced Dev & Creative Suite"; PackageIds = @( "Microsoft.VisualStudio.2022.Community", "JetBrains.IntelliJIDEA.Community", "JetBrains.PyCharm.Community", "JetBrains.WebStorm", "Google.AndroidStudio", "Unity.UnityHub", "EpicGames.UnrealEngine", "BlenderFoundation.Blender", "GitHub.GitHubDesktop", "Atlassian.Sourcetree", "Postman.Postman", "Kong.Insomnia", "dbeaver.dbeaver", "TablePlus.TablePlus", "uglide.RedisDesktopManager", "MongoDB.Compass.Full", "3T.Robo3T", "Figma.Figma" ) },
    @{ Name = "System & Security Analyst Tools"; PackageIds = @( "Hashcat.Hashcat", "Microsoft.ProcessMonitor", "Microsoft.ProcessExplorer", "Microsoft.Autoruns", "Microsoft.TCPView", "Microsoft.Sysmon", "Microsoft.Disk2vhd", "Microsoft.RootkitRevealer" ) }
)

# ================================
# === MAIN SCRIPT EXECUTION START ===
# ================================
try {
    Start-Transcript -Path (Join-Path $PSScriptRoot "WingetBulkInstaller_$(Get-Date -Format 'yyyyMMdd_HHmmss').log") -Append -Force -ErrorAction Stop
} catch { Write-Host "CRITICAL ERROR: Failed to start transcript. Error: $($_.Exception.Message)" -ForegroundColor Red }

$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    # STAGE 1: NON-ADMINISTRATOR BOOTSTRAP
    Clear-Host
    Write-EnhancedLog "Running in User Mode. Bootstrapping package managers..." -Component "STAGE-1"
    Install-Chocolatey
    Install-Scoop
    Write-EnhancedLog "Bootstrap complete. Elevation is required to continue." -Component "STAGE-1"
    Write-Host "`nPackage managers are ready. The script will now request Administrator access to continue." -ForegroundColor Yellow
    try {
        $scriptPath = $MyInvocation.MyCommand.Path
        Start-Process PowerShell -ArgumentList "-ExecutionPolicy Bypass -File `"$scriptPath`"" -Verb RunAs
        Write-EnhancedLog "Elevation request sent. Terminating user-mode script." -Component "STAGE-1"
    } catch {
        Write-EnhancedLog "Failed to elevate: $($_.Exception.Message)" -Level ERROR -Component "STAGE-1"
        Read-Host "Automatic elevation failed. Please re-run this script as an Administrator manually. Press Enter to exit."
    }
    exit
}
else {
    # STAGE 2: ADMINISTRATOR DEPLOYMENT
    $Global:ScriptConfig = Get-ScriptConfiguration -ScriptRoot $PSScriptRoot
    Test-Prerequisites
    Write-EnhancedLog "Running in Administrator Mode." -Component "STAGE-2"
    if ($Global:ScriptConfig.CreateRestorePoint) { New-SystemBackup }
    $Global:hardwareInfo = Get-EnhancedHardwareInfo
    $Global:PackageInfoCache.Clear()
    
    $selectedSoftware = @{}
    foreach ($item in $softwareList) { $selectedSoftware[$item.Id] = $true }
    Write-EnhancedLog "Defaulted to selecting all compatible programs." -Level INFO
    
    $selectedSoftwareRef = [ref]$selectedSoftware 
    while ($true) {
        $choice = Show-MasterSelectionMenu -selectedSoftwareRef $selectedSoftwareRef -softwareList $softwareList
        $action = $choice.ToLower()
        if ($action -eq "q") { break }
        elseif ($action -eq "s") { foreach ($item in $softwareList) { if ($item.Id) { $selectedSoftwareRef.Value[$item.Id] = $true } } }
        elseif ($action -eq "a") { $selectedSoftwareRef.Value.Clear() }
        elseif ($action -eq "d") { Generate-InstallScript $selectedSoftwareRef.Value $softwareList $criticalSoftware $OptionalSoftwarePacks; break } 
        elseif ($action -eq "f") { Enable-WindowsFeatures } 
        elseif ($action -eq "p") { Manage-Profiles $selectedSoftwareRef }
    }
    
    Write-Host "`n===================================================" -ForegroundColor Cyan
    Write-Host "===  OPERATION COMPLETE: SYSTEM RECALIBRATED  ===" -ForegroundColor Cyan
    Write-Host "===================================================" -ForegroundColor Cyan
    Write-Host "`nExiting Winget Bulk Installer with Chrome Extensions. Goodbye, Ice-ninja!" -ForegroundColor Cyan
    Stop-Transcript
}