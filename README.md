[CENTER]==============================================
[B][SIZE="6"][U]Auto System Image Exctractor[/U][/SIZE][/B]
==============================================

==============================================
[B][SIZE="4"][U]Supports[/U][/SIZE][/B]
1) system.new.dat
2) system.new.dat.br
3) payload.bin
==============================================


==============================================
[SIZE="5"][B]Requiremnets[/B][/SIZE]
==============================================
1. [URL="https://www.python.org/downloads/"]python v3.x[/URL]
2.[URL="http://www.7-zip.org/download.html"] 7-Zip[/URL]
[LEFT][I]Note 1:  make sure your environment variables path is correctly set for python and 7-Zip(set it in system properties-->advance-->environment variable-->path)
Note2: while installing python, set the environment variables in installer itself[/I][/LEFT]

==============================================
[SIZE="5"][B]How To[/B][/SIZE]
==============================================
1) extract [I]system_new_dat_extractor.zip[/I] into a folder (preferable in a path where there are no name spaces)
2) place your rom zip file in the directory where you extracted
3) open the file system_image_extractor_V4.cmd
4) wait for it to extract everything 
5) folder with extracted content will open automatically
6) have fun tweaking 
[I]*make sure to delete the created folders every time you want to extract[/I]


==============================================
[SIZE="5"][B]Credits[/B][/SIZE]
==============================================
1) And_pda for imgextractor
2) [URL="http://forum.xda-developers.com/member.php?u=5361113"]xpirt[/URL] for sdat2img.py
3) google
4) [URL="https://github.com/cyxx/extract_android_ota_payload"]cyxx[/URL]
5) ius
6) [URL="https://forum.xda-developers.com/member.php?u=7285913"]@aIecxs[/URL]




==============================================
[SIZE="5"][B]Change-log[/B][/SIZE]
==============================================


[CODE]* initial release

-----------------------------

V2 supports Nougat
converts file_contexts.bin to file_contexts

-----------------------------

V3
[U]Now Supports[/U]
1) system.new.dat
2) system.new.dat.br
3) payload.bin

V4 (25-06-2019)
1) changed the entire script.
2) Fixed issues where user files got deleted automatically
            -it was due spaces in path

[/CODE]









[URL="https://github.com/chiragkrishna/system.new.dat-extractor"]source[/URL][/CENTER]
