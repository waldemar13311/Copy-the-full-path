Add-Type -AssemblyName PresentationCore

if ($args.Length -lt 2) {
    exit
}

$slashStyle = $args[1] # Get path style
$path = $args[0]

switch ($slashStyle) {
    "windows" {  
        ;
    }
    
    "linux" { 
        $path = $path.Replace("\", "/")
    }
    
    "wsl" {
        $path = $path.Replace("\", "/")
        $letterDrive = $path.Substring(0, $path.IndexOf(":"))
        $path = $path.Replace("$letterDrive`:", "/mnt/" + $letterDrive.ToLower())

        if($path.Contains(" ")) {
            $path = "`"$path`""
        }
    }
}


[Windows.Clipboard]::SetText($path) 
 