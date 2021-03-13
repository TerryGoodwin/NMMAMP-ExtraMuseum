# Namco Musem - My Arcade Mini Player - Extra Musem
Version 0.1.2.0

### What is this?
A set of Windows batch files and an Android APK to allow you to install
and run RetroArch on the Namco Museum My Arcade Mini Player. Granting you an Extra Museum, if you will.

Crucially, this provides a RetroArch configuration that allows you to
navigate the RetroArch frontend using the built-in controls of the
Namco Museum My Arcade Mini Player.

The original frontend and game selection are easily accessible from the
new launcher - at boot you can choose to launch RetroArch or the
original experience.

### What is this not?
A collection of ROMs or emulators - you'll have to find and add those
yourself.

This isn't a frontend (lavish or otherwise) for a new collection of
ROMs and emulators on the Namco Museum My Arcade Mini Player - while
there's a new launcher to choose the stock content or RetroArch, there
is no extra frontend added on top of RetroArch.

Knowing how to use RetroArch is beyond scope here - the intention is
currently to get everything onto the Namco Museum My Arcade Mini Player
that you need to launch RetroArch and play games with it, but beyond
that you'll have to find information elsewhere on what to do and how to
properly use it.

## Pre-requisites
Here's what you'll need:

* A Namco Museum My Arcade Mini Player
* A USB-A to USB-micro data cable - NOT simply a charging cable!
* Android SDK Platform Tools [https://developer.android.com/studio/releases/platform-tools]
* RetroArch for Android (32bit) [https://buildbot.libretro.com/stable/1.9.0/android/RetroArch_ra32.apk]
* RetroArch Cores for Android [https://buildbot.libretro.com/nightly/android/latest/armeabi-v7a/]
* ROMs of your choice to go with the cores

## Step-by-step Instructions
You only have to do this process once to install everything:

* Download the latest release [https://github.com/TerryGoodwin/NMMAMP-ExtraMuseum/releases]
* Unzip it wherever you want
* Install the Android SDK Platform Tools
 * Recommended location is `c:\android\platform-tools`
* Rename your RetroArch 32bit APK as `retroarch.apk` and put it in the `retroarch` folder
* Put any cores you want to use into `retroarch\cores`
* Put any ROMs, BIOS files etc. you need for RetroArch into `GAME-EXTRA`
* IMPORTANT! Make sure no other Android devices are connected!
* Make sure your device is plugged into the computer and turned on
  * IMPORTANT! Make sure it's finished booting before continuing...
* Double-click the file `run_me_first_after_readme.bat`
* Be patient as everything is installed
* That's (hopefully) it!
 
You should then be able to use choose from the original game selection
or RetroArch when you boot the device, then use the controls on the
device to navigate RetroArch and play some games!

## Controls
The biggest hurdle to getting this working was figuring out how to
translate the built-inc ontrols into something that RetroArch could
understand. Fortunately the stock software prints every button press
to the log, so I could see what button codes correspond with which input
- these have been translated into the `retroarch.cfg` included with the
scripts.

### Action buttons
The four actions buttons are mapped directly to the button IDs
internally, but with cerain systems they don't have a great layout - but should be usable.

### Reset
Does nonthing at this time - it is just a regular button so I will
probably remap the hotkey to this away from coin...

### Coin + Y
The coin button acts as the hotkey within RetroArch, so the usual
RetroArch combinations should work, but all I've really tested it with
is Y to bring up the RetroArch menu. (This doesn't invoke RetroArch
from anywhere else, such as the stock software, sorry!)

### Common errors

#### Couldn't start ADB
Check you've installed the Android SDK Platform Tools where you think
you did. If you didn't install them to `c:\android\platform-tools` then
you'll need to change the path at the top of each .bat file by hand to
reflect reality.

#### Root failed
This could be for a couple of reasons:

* Windows couldn't figure out the drivers for the device - see https://stackoverflow.com/questions/15721778/adb-no-devices-found and follow the answer by António Almeida. On my Windows 10 machine I didn't have to do anything, but on my Windows 8.1 machine I had to do that extra step.
* Your USB cable isn't transmitting data, only charge - try a different cable!

## What else can I do?

### get_latest_retroarch_config.bat
Downloads `retroarch.cfg` from the device and places it at
`retroarch\retroarch.new.cfg` so you can make new changes, then push
them back to the device.

### install_launcher.bat
(Re-)Installs the launcher APK from frontend\emlauncher.apk

### install_retroarch.bat
Installs RetroArch APK from retroarch\retroarch.apk then copies over
the custom configuration file from retroarch\retroarch.cfg

### install_retroarch_config.bat
If you want to make manual changes to the `retroarch.cfg` this is how
you get them back on the device. NOTE! If you've made any changes ON
the device, they won't be reflected here until you run...

### install_retroarch_cores.bat
Re-copies the contents of `retroarch\cores` to your device. This is not
a sync - if you delete cores locally and then run this, they won't be
removed from your device.

### install_roms.bat
Re-copies the contents of `GAME-EXTRA` to your device. This is not a
sync - if you delete ROMs locally and then run this, they won't be
removed from your device.

### reboot_device.bat
Reboots the device and takes you back to the stock UI.

### remove_all.bat
Uninstalls everything from the device that's been put there by these
scripts and restores it to stock

### remove_all_retroarch_cores.bat
After receiving confirmation, deletes all installed cores from the
device. Use `install_retroarch_cores.bat` to put some back.

### remove_all_roms.bat
After receiving confirmation, deletes all installed ROMs from the
device. Use `install_roms.bat` to put some back.

### remove_retroarch_cores.bat
Prints a list of currently installed cores, and allows you to type the
full file name of the core you wish to remove. Type `quit` `stop` or
`exit` to stop deleting.

### remove_roms.bat
Prints a list of currently installed ROMs, and allows you to type the
full file name of the ROM you wish to remove. Type `quit` `stop` or
`exit` to stop deleting.

### set_extra_launcher.bat
If you've chosen to switch back to the stock experience via the script
below (without uninstalling anything) run this to get the launcher back
so you can boot into RetroArch.

### set_original_launcher.bat
Restore the device back to the stock experience - without removing
anything. Just run set_extra_launcher.bat if you want to get it all
back again.

## To Do
A lot...

* Write a Java app to act as a configurable frontend for ROM collections so you don't have to use RetroArch's menus
* Add button mappings per core/system so they make more sense.
* Extend RetroArch core and ROM scripts to allow drag-and-drop of single files

## License

Copyright 2021 Terry Goodwin

No copyrighted from Namco or My Arcade content is included or
distributed here! All scripts and artwork is entirely original.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to
deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.