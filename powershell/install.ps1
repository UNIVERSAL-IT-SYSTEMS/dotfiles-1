# FIXME rewrite this as batch file or bash if possible
# FIXME register .sh and stuff so it is not unknown
pushd
# need if you call from start menu
cp $PSScriptRoot\profile.ps1 $pshome

# app paths
cd 'hklm:\software\microsoft\windows\currentversion\app paths'
@{
  "${env:homedrive}\cygwin64\bin"   = 'bash.exe'
  "${env:programfiles}\notepad2"    = 'notepad2.exe'
  "${env:programfiles(x86)}\mpc-hc" = 'mpc-hc.exe'
  "${pshome}"                       = 'powershell.exe'
} | % getEnumerator | % {
  join-path $_.key $_.value | ni -f $_.value
}

# Notepad2
@{
  '.css'    = 'cssfile',                      $null
  '.ini'    = 'inifile',                      $null
  '.nfo'    = 'txtfile',                      $null
  '.txt'    = 'txtfile',                      $null
  'unknown' = 'unknown',                      $null
  '.bat'    = 'batfile',                      '"%1" %*'
  '.cmd'    = 'cmdfile',                      '"%1" %*'
  '.htm'    = 'firefoxhtml',                  'firefox "%1"'
  '.xml'    = 'firefoxhtml',                  'firefox "%1"'
  '.avs'    = 'avsfile',                      'mpc-hc "%1"'
  '.ps1'    = 'microsoft.powershellscript.1', 'powershell "%1"'
  '.reg'    = 'regfile',                      'regedit "%1"'
  '.js'     = 'jsfile',                       'wscript "%1"'
} | % getEnumerator | % {
  $k1 = $_.key
  $k2 = $_.value[0]
  $pm = $_.value[1]
  cd hklm:\software\classes
  si $k1 $k2
  sp $k1 perceivedtype $null
  ni -f $k2\shell
  cd $k2\shell
  if ($pm) {
    ni -va Run 0
    ni -va $pm 0\command
  }
  ni -va Edit 1
  ni -va 'notepad2 "%1"' 1\command
  ni -va Open 2
  ni -va 'notepad "%1"' 2\command
}

# shell options
cd hklm:\software\classes
% -pv 1 {'directory', 'directory\background', 'drive'} |
% -pv 2 {'powershell', 'bash'} |
% {'cmd /c start /d "%v" {0}' -f $2 | ni -f $1\shell\$2\command}

# Console
cd hkcu:\
sp console QuickEdit 1
'0x{0:x4}{1:x4}' | % {
  sp -t d console WindowPosition ($_ -f 400,900)
  sp console WindowSize     ($_ -f  22, 80)
}
cd console
% -pv 1 {'%systemroot%_system32_windowspowershell_v1.0_powershell.exe'} |
% -pv 2 {'0x00{2:x2}{1:x2}{0:x2}'} | % {
  ni -f $1
  sp -t d $1 ColorTable00 ($2 -f   1, 36, 86)
  sp -t d $1 ColorTable07 ($2 -f 238,237,240)
}

# shortcut extension remove
cd hkcu:\software\microsoft\windows\currentversion
sp explorer link ([byte[]](0,0,0,0))

# need homedrive for man
@{
  CYGWIN = 'noDosFileWarning'
  PATH = @(
    'c:\windows\system32'
    'c:\windows\system32\windowspowershell\v1.0'
    'd:\documents'
    'd:\git\a\misc'
  ) -join ';'
} | % getEnumerator | % {
  [environment]::setEnvironmentVariable($_.key, $_.value, 'm')
}

# clear explorer and wallpaper history
cd hkcu:\software\microsoft\windows\currentversion\explorer
rd -ea 0 typedPaths, wallpapers\images

# clear run history
rundll32 inetcpl.cpl ClearMyTracksByProcess 1

# hide file extensions
cd hkcu:\software\microsoft\windows\currentversion\explorer
sp advanced hideFileExt 0
popd