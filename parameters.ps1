# Script Parameters for Revive-ToolBox.ps1
<#
    Author             : Bryant Bennett
    Last Edit          : BB - 05/09/2023
#>

@{
    #-- Revive Image.exe Command Args
        #RVImageCmdArg1 = "qp"
        #RVImageCmdArg3 = 'd=$n'
        
        #RVTools = [ordered]@{ RTCollectBackupSizes = "Collect Backup Sizes"; RTSPXErrors = "Find SPX Errors in logs"; RTRemoveOldInc = "Move unrequired .SPI Files" ; RTVerifyChain = "Verify Chains"}

        #RVToolsIM = [ordered]@{RTIMUsageReport = "IM Usage Report (Under Construction)"}

        Title = "Eclipse Onboard ToolBox"

        Version = "1.0.1"  

        #Exclusions = "Old Chains","spf.tmp","bitmap","OldChains","Incrementals"
           
        #IMLogQuerry = "Collapse Daily Exception: Monthly collapse aborted due to verification status of the following files: ReverifyQueued :"

       
}