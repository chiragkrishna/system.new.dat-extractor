# Auto System Image Extractor


## Supports
- system.new.dat
- system.new.dat.br
- payload.bin

## Requiremnets
- [python v3.x](https://www.python.org/downloads/)
- [7-Zip](http://www.7-zip.org/download.html)

### Note 1: 
- make sure your environment variables path is correctly set for python and 7-Zip(set it in system properties-->advance-->environment variable-->path)
### Note 2: 
- while installing python, set the environment variables in installer itself


## How To
- extract system_new_dat_extractor.zip into a folder (preferable in a path where there are no name spaces)
- place your rom zip file in the directory where you extracted
- open the file system_image_extractor_V4.cmd
- wait for it to extract everything 
- folder with extracted content will open automatically
- have fun tweaking 
### make sure to delete the created folders every time you want to extract


## Credits
- And_pda for imgextractor
- [for sdat2img.py](http://forum.xda-developers.com/member.php?u=5361113)
- google
- [cyxx](https://github.com/cyxx/extract_android_ota_payload)
- ius
- [@aIecxs](https://forum.xda-developers.com/member.php?u=7285913)




````
Change-log


* initial release

-----------------------------

V2 supports Nougat
converts file_contexts.bin to file_contexts

-----------------------------

V3
Now Supports
1) system.new.dat
2) system.new.dat.br
3) payload.bin

V4 (25-06-2019)
1) changed the entire script.
2) Fixed issues where user files got deleted automatically
            -it was due spaces in path
````
