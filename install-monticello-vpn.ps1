# installs sonicwall mobile connect and saves app package to users root folder 
wget "http://tlu.dl.delivery.mp.microsoft.com/filestreamingservice/files/a9bea512-f9fe-4ab9-b315-41efbf1c6afc?P1=1670949373&P2=404&P3=2&P4=mGLdjTpackHiFmQjr%2bQTq0JytnT8w1JjwcLBMxn5lBQSU8eU8aLdDpiy7J0scWNU6PSjzpKScji5WYJptCuHPw%3d%3d" -OutFile "sonicwall-mobile-connect.appx"

# installs app 
Add-AppxPackage -Path "C:\Users\$env:UserName\sonicwall-mobile-connect.appx"

# setups vpn connection 
$config = [xml]::new()
$config.LoadXML('<blank>0</blank>')

Add-VpnConnection -Name "Monticello Homes" -ServerAddress "https://98.6.125.19:4433" -PassThru -PlugInApplicationID "SonicWALL.MobileConnect_e5kpm93dbe93j" -CustomConfiguration $config

