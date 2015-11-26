                                                                       
                                                     ,d                
                                                     88                
                             ,adPPYb,d8  ,adPPYba, MM88MMM ,adPPYba,   
                            a8"    `Y88 a8"     "8a  88   a8"     "8a  
                            8b       88 8b       d8  88   8b       d8  
                            "8a,   ,d88 "8a,   ,a8"  88,  "8a,   ,a8"  
                             `"YbbdP"Y8  `"YbbdP"'   "Y888 `"YbbdP"'   
                             aa,    ,88                                
                              "Y8bbdP"                                 

Tired of cd:ing your way through folders? Are aliases too clumsy for you? Get goto: a lightweight POSIX compatible command line tool that takes you to places!

## Compatibility

goto is POSIX-compliant, and is known to run on dash and bash.

Please contact me if you run into any difficulties with goto on your system. Also please contact me if goto runs on your exotic choice of shell and it is not in the above list.

##Installation:

Choose any folder and type in the following:
```
$ git clone git@github.com:horttanainen/goto.git
$ cd goto
$ ./config
```
Config will prompt you with shortcut for goto:
```
give shortcut for goto(current: goto):
```
This is the shortcut that you use when you call goto. I recommend g as shortcut (it is shorter than cd!)

Add following line to your shell configuration file (for me its ~/.bashrc):
```
. /path/to/your/installationfolder/goto.sh
```
That's it!

## Usage

If I would like to my installation folder of goto (which is in ~/projects/goto/goto.sh) I would simply type:
```
$ g goto
```
goto will look for the folder recursively from your current location and shows the matching results:
```
Press (space) to goto, (n) next result, (p) previous.

/home/santeri/projects/goto/goto.sh
```
Pressing spacebar takes you to the folder. You may have noticed that finding the correct folder took some time, but next time will be lighting fast!

Goto stores your visited folders in a file (/your/path/to/goto/lines) and next time you goto to a previously visited folder goto will match your query to previously visited folders first!
```
$ g go
Press (space) to goto, (n) next result, (p) previous.
Press (s) to do a search from this directory.

/home/santeri/projects/goto/goto.sh
```
Notice how goto takes parts of filenames as input too! However I recommend using full folder/file names for the first goto to that folder/file.

## flags

After you have visited some folder with goto that folder is very easy to go to. Any part of filename (simply a character) is often enough to find the folder you want to visit.

But sometimes when you want to goto a folder the first time, goto doesn't seem to find your file or it finds too many results! If this happens you might find these flags useful:

###-c (save current folder)
Cd to the folder goto did not find and save it with -c flag:
```
$ cd folder/that/goto/simply/could/not/find
$ g -c
```
The folder is now saved at the lines file and next goto will find it.

###-a (save absolute path)
You can give goto a absolute path to folder it did not find:
```
$ g -a folder/that/goto/simply/could/not/find
```

###-r (save relative path)
You can give goto a relative path to the folder
```
$ cd folder/that/goto
$ g -r simply/could/not/find
```
folder/that/goto/simply/could/not/find is now stored at the lines file
