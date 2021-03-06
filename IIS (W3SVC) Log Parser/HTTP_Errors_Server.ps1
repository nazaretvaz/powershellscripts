
$serverfolder = "\IISWEB\logs\logfiles"


foreach ($site in (Get-ChildItem $serverfolder -filter W3SVC*) | Sort-Object { [regex]::Replace($_.Name, '\d+', { $args[0].Value.PadLeft(20) }) })
    {
    $day = 10
    $columns = 20
    $array_http = New-Object 'object[,]' ($day+1),($columns+2)
    
    write-host $serverfolder\$site
    write-host (200).tostring().padleft(20),(206).tostring().padleft(9),(301).tostring().padleft(9),(302).tostring().padleft(9),(304).tostring().padleft(9) -nonewline; 
    write-host (400).tostring().padleft(10),(401).tostring().padleft(9),(403).tostring().padleft(9),(404).tostring().padleft(9),(500).tostring().padleft(9) -NoNewline; 
    write-host "OTHER".padleft(9) -NoNewline; 
    write-host "TOTAL".padleft(10)

    foreach ($file in (Get-ChildItem $serverfolder\$site | select -skip 1 -last $day | sort-object ($_.LastWriteTime) -descending))
        {
        $array_http[$day,0]=(get-item $serverfolder\$site\$file).creationtime
        $200=0;$206=0;$301=0;$302=0;$304=0;$400=0;$401=0;$403=0;$404=0;$500=0;$oth=0;$tot=0
        $obj = new-object System.IO.StreamReader("$serverfolder\$site\$file")
        $line = $obj.ReadLine()
        #Write-host Collecting Data from $file
        while ($line -ne $null)
        {
        if ($line.split(" ")[10] -eq 200) {$200++}
        elseif ($line.split(" ")[10] -eq 206) {$206++}
        elseif ($line.split(" ")[10] -eq 301) {$301++}
        elseif ($line.split(" ")[10] -eq 302) {$302++}
        elseif ($line.split(" ")[10] -eq 304) {$304++}  
        elseif ($line.split(" ")[10] -eq 400) {$400++}
        elseif ($line.split(" ")[10] -eq 401) {$401++}
        elseif ($line.split(" ")[10] -eq 403) {$403++}
        elseif ($line.split(" ")[10] -eq 404) {$404++}  
        elseif ($line.split(" ")[10] -eq 500) {$500++}
        elseif ($line -like "#*") {}
        else{$oth++} 
        $tot++
        $line=$obj.ReadLine()
        }

        $array_http[$day,1]=$200
        $array_http[$day,2]=$206
        $array_http[$day,3]=$301
        $array_http[$day,4]=$302
        $array_http[$day,5]=$304
        $array_http[$day,6]=$400
        $array_http[$day,7]=$401
        $array_http[$day,8]=$403
        $array_http[$day,9]=$404
        $array_http[$day,10]=$500
        $array_http[$day,11]=$oth
        $array_http[$day,12]=$tot
   
    #Set array to 0 if NULL
    $count = 0 ; while ($count -le ($columns)) {$count++ ; if($array_http[$day,$count] -le 1) {$array_http[$day,$count] = 0}}
    
    #Write Results to Screen
    write-host $array_http[$day,0].tostring().split(" ")[0].padleft(0) -f black -NoNewline;
    write-host $array_http[$day,1].tostring().padleft(10),$array_http[$day,2].tostring().padleft(9),$array_http[$day,3].tostring().padleft(9),$array_http[$day,4].tostring().padleft(9),$array_http[$day,5].tostring().padleft(9) -f darkgreen -NoNewline;
    write-host $array_http[$day,6].tostring().padleft(10),$array_http[$day,7].tostring().padleft(9),$array_http[$day,8].tostring().padleft(9),$array_http[$day,9].tostring().padleft(9),$array_http[$day,10].tostring().padleft(9) -f red -NoNewline; 
    write-host $array_http[$day,11].tostring().padleft(9),$array_http[$day,12].tostring().padleft(9) -f black 
        
     $day--
    }
}

