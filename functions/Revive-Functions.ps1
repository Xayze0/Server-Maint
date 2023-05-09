Function Show-Menu{
    #Dynamic Menu Display Starting At 1
    param (
            [Parameter(Mandatory=$true)]
            [string]$Title,
            [Parameter(Mandatory=$true)]
            [string]$Version,
            [Parameter(Mandatory=$true)]
            [System.Collections.Specialized.OrderedDictionary]$RVTools
    )
    Clear-Host
        Write-Host "==============[ $Title ]===============[v$Version]"
        Write-Host "    ____"
        Write-Host " .-'   / "
        Write-Host ".'    /   /`."
        Write-Host "|    /   /  |  " 
        Write-Host "|    \__/   |  "
        Write-Host " .         .'  "
        Write-Host "   .     .'    "
        Write-Host "    | ][ |     " 
        $count = 1
        foreach ($tool in $RVTools.Values) {
        $bar =     "    | ][ |     : Press '$count' to  "+ $tool
        Write-Host $bar
        $count++
        }   
        Write-Host "    | ][ |     : Press 'Q' to Close  "
        Write-Host "  .'  __   ."
        Write-Host "  |  /  \  |"
        Write-Host "  |  \__/  |"
        Write-Host "  `.       '"
        Write-Host "     ----'  "



}


Function ResetUserPasswords {
    ##Test if required modules are installed

    IF (Get-Module -ListAvailable -Name ActiveDirectory){

    }else{
        Write-Host "Unable To Find ActiveDirectory Module" -ForegroundColor Red
        Write-Host "Please Run This Tool On The MDC" -ForegroundColor Red
        Write-Host "Returning To Menu" -ForegroundColor Cyan

        Start-Sleep -Seconds 5
        break
    }
    

    #Collect all OUs with '-' in there name.
    #Can Also be overridden by providing an OU manually
    Try{
        $OUs = Get-ADOrganizationalUnit -Filter '*' | Where-Object {$_.Name -like "-*"} | Sort-Object -Property DistinguishedName
            Write-Host "[Organizational Units]"  -ForegroundColor Cyan

        For ($i = 0 ; $i -lt $OUs.Count ; $i++){
            $echostring = "[$($i+1)]  ["+$OUs[$i].DistinguishedName+"]"
            Write-Host $echostring -ForegroundColor Yellow
        }

        $OUName = Read-Host "Pick an OU or Provide a DistinguishedName"

        ##Test OU
        if ($OUName.length -gt 3){
            #Full DN Provided
            $OU = Get-ADOrganizationalUnit -Filter * | Where-Object DistinguishedName -EQ $OUName


        }else{
            $OU = $OUs | Sort-Object -Property DistinguishedName | Select-Object -First 1 -Skip $($OUName-1)
        }
    
    }catch {
        Write-Host "Unable To Find OU" -ForegroundColor Red
        Write-Host "Returning To Menu" -ForegroundColor Cyan

        Start-Sleep -Seconds 5
        break
    }

    ##Collect users
    try {
        $Users = Get-ADUser -Filter * -SearchBase $OU.DistinguishedName
    }catch{
        Write-Host "Unable To Collect Users" -ForegroundColor Red
        Write-Host "Returning To Menu" -ForegroundColor Cyan

        Start-Sleep -Seconds 5
        break
    }

    ##Collect Password
    try{
        Write-Host "[New Password]"  -ForegroundColor Cyan
        $Password = ""
        $Password = Read-Host "Please Define Password to Set For All Users"
    }catch{
        Write-Host "Unable To Collect Password" -ForegroundColor Red
        Write-Host "Returning To Menu" -ForegroundColor Cyan

        Start-Sleep -Seconds 5
        break
    }

    ##Collect Reset Bool
    Try{
        Write-Host "[Force Reset]"  -ForegroundColor Cyan
        $Reset = ""
        $Reset = Read-Host "Force Users To Reset Password On Next Login (Y\N)" 
    }catch{
        Write-Host "Unable To Collect Reset Bool" -ForegroundColor Red
        Write-Host "Returning To Menu" -ForegroundColor Cyan

        Start-Sleep -Seconds 5
        break
    }

    ##Collect Confirm
    Try {
        $Confirm = "N"
    
        Write-Host "[You are about to reset the password for $($Users.count) Users]" -ForegroundColor Cyan
        $Confirm = Read-Host "Please Confirm (Y\N)" 
    }catch{
        Write-Host "Unable To Collect Confirmation Response" -ForegroundColor Red
        Write-Host "Returning To Menu" -ForegroundColor Cyan

        Start-Sleep -Seconds 5
        break
    }

    if ($Confirm -eq "Y"){
        foreach ($User in $Users){

            if ($Reset){
                $User | Set-ADAccountPassword -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $Password -Force)
                $User | Set-ADUser -ChangePasswordAtLogon $true
            }else{
                $User | Set-ADAccountPassword -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $Password -Force)
            }
        }

    }else{
        Write-Host "Confirmation Not Provided" -ForegroundColor Red
        Write-Host "Returning To Menu" -ForegroundColor Cyan

        Start-Sleep -Seconds 5
        break
    }




}