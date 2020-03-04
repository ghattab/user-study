Command line options:
=======================
The interaction and visualiztion relies on [IMHOTEP-Medical](https://github.com/IMHOTEP-Medical/imhotep). The source file is provided under src.zip and the subsequent files to fit the 25 MB file size upload limitation.

-PID ParticipantID (Required)
Set the participant ID.


-outputDir path (Optional)
Set the path to the folder in which to store results


-logFile filename (Optional)
Where to write output.



Example usage:
```
dt-pyramid.exe -logFile log.txt -outputDir Results/ -PID 9374
```


Important:
======================

- The PID must be given! Otherwise the program will (silently) close.

- The PID must be unique, and a file with the same name must NOT exist under the path given by outputDir. Otherwise the program will (silently) close.
