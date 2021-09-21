Add-Type -AssemblyName PresentationCore

if ($args.Length -lt 2) {
    exit
}

$slashStyle = $args[1] # Windows or Linux slash
$path = $args[0]

if ($slashStyle.Equals("linux")) {
    $path = $path.Replace("\", "/")
} 

[Windows.Clipboard]::SetText($path) 
 