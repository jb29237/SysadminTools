function Get-ORGBitlockerVolume([string[]]$computername)
{
    $date = Get-Date
    foreach ($computer in $computername)
    {
        $volume = Get-BitLockerVolume

        $status = [pscustomobject]@{

            Date = $date
            MountPoint = $volume.mountpoint
            CapacityGB = $volume.capacitygb
            'VolumeStatus' = $volume.Volumestatus
            'EncryptionPercentage' = $volume.encryptionpercentage
            'ProtectionStatus' = $volume.protectionstatus

        }

        $status

    }
} 