Scale mac resolution with more pixel on your non-4K monitor.
=====================
## 1. Enable HiDpi mode

`sudo defaults write /Library/Preferences/com.apple.windowserver.plist DisplayResolutionEnabled -bool true`

## 2. Detect the monitor and display port 

`ioreg -lw0 | grep IODisplayPrefsKey`

Although monitor mode may be the same with others', depending on the port you connect. The plist may not work.
For me, my monitor is U2515H. it is neither d06e nor d072, it is d070(mapping to HDMI 1)

## 3. Choose the resolution you need

A [website](https://comsysto.github.io/Display-Override-PropertyList-File-Parser-and-Generator-with-HiDPI-Support-For-Scaled-Resolutions/) I referenced to, it automatically transfer you configuration into hexadecimal

## 4. Disable system integrity(SIP) protection

This give you access to write to system level directories including /system, which we are gonna write to. Initially denied because of apple default integrity protection
#### 4.1.use `csrutil status` to check your current protection status
#### 4.2 Hold COMMAND+R when you restart to enter recovery mode
#### 4.3 `csrutil disable; reboot` to disable the protection and reboot
If you feel disable the protection too risky, revert it back by enter recovery mode and `csrutil enable; reboot`

update for Catalina, you may encounter "read only file system" with your SIP disabled. `sudo mount -uw /; killall Finder ` [reddit post](https://www.reddit.com/r/MacOS/comments/caiue5/macos_catalina_readonly_file_system_with_sip/)

update for Big Sur, resolution for Read Only System [won't work](https://developer.apple.com/forums/thread/649832) as it returns error "/ failed with 66". In the same thread, people suggested using  /Library instead of /System/Library 
`sudo cp -R /System/Library/Displays /Library/`
## 5. Copy the file to System folder to config your resolution
Catalina:
`sudo cp ~/Downloads/DisplayProductID-d070.plist /System/Library/Displays/Contents/Resources/Overrides/DisplayVendorID-10ac/DisplayProductID-d070`

Big Sur:
`sudo cp ~/Downlaods/DisplayProductID-d070.plist /Library/Displays/Contents/Resources/Overrides/DisplayVendorID-10ac/DisplayProductID-d070`

You may want to remove the extension as above while you copy. That works for me.

## 6. Restart and apply the configuration.

Restart to apply the properlist file and switch to the resolution you want.

If you don't have a resolution switching app. You probably need one, since those customize resolution won't appear in System Preference. Check out [RDM](https://github.com/avibrazil/RDM), a free resolution manation menubar app. 

If you have ever tried SwitchResX, uninstall and remove it completely. Otherwise there is a chance that your resolution can't take effect.

Happy scale and enjoy your HiDPI!
