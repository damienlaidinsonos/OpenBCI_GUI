To release:

- Install the Processing IDE
- Launch the IDE and then got to `Tools` -> `Install "processing-java"`.
- Pick whatever option (global or user only install) but the key is to have the `processing-java` script in your PATH.
- Install the python module `dmgbuild`.
- Make sure the Processing IDE is closed and run, from the root of the repo : `python3 release/build.py`
- Then, to create the DMG file : `dmgbuild -s release/mac/dmgbuild_settings.py -D app=$(pwd)/application.macosx/OpenBCI_GUI.app "SonosOpenBCI" SonosOpenBCI_Install.dmg`