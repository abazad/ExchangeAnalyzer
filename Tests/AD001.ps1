#requires -Modules ExchangeAnalyzer
#requires -Modules ActiveDirectory

#This function verifies the Active Directory Domain level is Windows 2008 or greater
Function Run-AD001()
{
    [CmdletBinding()]
    param()

    $TestID = "AD001"
    Write-Verbose "----- Starting test $TestID"

    $PassedList = @()
    $FailedList = @()
    $ErrorList = @()

    $domaindnsname = ($addomain).dnsroot
    $domainmode = ($addomain).domainmode

    foreach ($server in $exchangeservers) { 
        $admin = $server.admindisplayversion
        [string]$ver=[string]$admin.major+'.'+[string]$admin.minor
        if ($Ver -like "15.0") {$Ex2013 = $true}
        if ($Ver -like "15.1") {$Ex2016 = $true}
    }
    
    if ($ex2013 -eq $true) {
        # All Exchange 2013 servers, no Exchange 2016 servers found
        if ($ex2016 -eq $null) {
            if (($domainmode -like "*2012*") -or ($domainmode -like "*2008*") -or ($domainmode -like "2003*")) {
                $PassedList += $($domaindnsname)
            } else {
                $FailedList += $($domaindnsname)
            }
        }
    }
  
    if ($ex2016 -eq $true) {
        # Exchange 2016 servers found
        if (($domainmode -like "*2012*") -or ($domainmode -like "*2008*")) {
            $PassedList += $($domaindnsname)
        } else {
            $FailedList += $($domaindnsname)
        }   
    }

    #Roll the object to be returned to the results
    $ReportObj = Get-TestResultObject -ExchangeAnalyzerTests $ExchangeAnalyzerTests `
                                      -TestId $TestID `
                                      -PassedList $PassedList `
                                      -FailedList $FailedList `
                                      -ErrorList $ErrorList `
                                      -Verbose:($PSBoundParameters['Verbose'] -eq $true)

    return $ReportObj
}

Run-AD001