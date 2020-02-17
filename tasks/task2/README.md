# UserEvaluationPolaris
User Evaluation GUI using a Polaris optical tracking system

## Description
This application tracks a tool (e.g. passive NDI Polaris pointer tool) relative to an object (e.g. 3D printed object).
It supports various versions of the Polaris optical tracking system and offers the following functionality.

## Functionality
* Registration: This application performs a registration of the tracked tool in the coordinate system of the object.
This transforms the recordings from the world coordinate frame into the local coordinate frame of the object.
This functionality is inherited from the main software framework (Mediassist). A registration example using a checkerboard is provided. 

* Polaris optical tracking system: The system is available in a passive and a passive/active configuration.
 The provided configuration files work for the specific example of a passive configuration for a tracked tool that includes 4 spheres. 

* 3D Position and quaternion coordinates: The application records and saves two different data streams (snapshot and continuous). 
The snapshot data contains 10 different recordings of the pointer tool in the coordinate system of the object (see [Miniminal distance](https://github.com/ghattab/UserEvaluationPolaris#minimal-distance), [Snapshot data](https://github.com/ghattab/UserEvaluationPolaris#snapshot-data)).
From the first recording onwards, a continuous recording starts and saves real-time recordings in the local coordinate frames.
Both local and global coorindates frames are saved in `.raw` files as a means of data backup.
Each dataset is saved in a CSV file.

Such a functionality enables the visualization of the position and orientation of the tracked tools (e.g. surgical instrument) in relation to the object of interest (e.g. 3D model).


## Building
The application is built within a software framework. To only compile this application:
```
$ cd MEDIASSIST_ROOT
$ mkdir build
$ cd build
$ cmake -DSTUDENT_PeterKlausing:BOOL="1" 
$ make -j7 UserEvaluationPolaris
```
Then run: `$ bin/UserEvaluationPolaris`


## GUI
The graphical user interface is designed with simplicity and functionality in mind. Setting up the application is done through the GUI in 2 steps: configuration setup, participant recordings. 


## Configuration setup
The configuration setup relies on creating a configuration file for every tracked  object.
This is performed using the registration application in the framework. 
It is located in `Examples/CalibrationAndRegistration/Registration` with a complete description.

To correctly configure the tracked objects, it is important to use one configuration file per object and one _ball configuration_ so the objects can be distinguished. Configuration order: always start with the Polaris.


### Polaris Communication Type
Various versions of the Polaris optical tracking systems exist. 
They either connect using an ethernet or serial interface.

#### Ethernet interface
Newer versions of the Polaris optical tracking system feature an Ethernet plug (Power over Ethernet or PoET).
Its configuration requires: a hostname, a port number. This can be found out by a simple lookup on the local network.

#### Serial interface
Older versions of the Polaris system employ a serial connection.
This system features a plug for an Ethernet cable and additionally a power supply on the backside.
Its configuration only requires the port number: the default is 0.

### Output Data Path
The application outputs files with 10 meassurements per participant and per phase, as well as continous tracking data.
These can be stored in seperat paths.

### Minimal Distance
During tracking, it is possible to set a minimum distance from all captured recordings in the phase (snapshot data). When set to 0, this option is ignored. The unit is millimeters.

### Connect
To connect, press the **Connect** button.
This configures and starts the Polaris optical tracking system and the subsequent instances.
A status bar, situated below the message box, indicates in either green or in red if the connection is successful.
When green, it is safe to proceed to the *participant tab* so as to start the evalutation.


### Extras and Known issues
* This application automatically saves previous setup configuration paths to one  global `.config` file. The latter is automatically loaded on the next application launch. 
It is possible to save and load a global configuration on request.

* Issue 1. After correctly connecting the Polaris, the GUI shows an error status (continuous red blinking of the LED).  
This can be addressed by first connecting the PoE, then the Polaris (the order matters).
Once the Polaris has finished booting (continuous green LED), the data cable may be connected.

* Issue 2. It is possible that the framework doesn't properly configure the Polaris interface. 
A workaround is to start NDIToolBox and connect to the Polaris optical tracking system, then capture one image and close the NDIToolBox.
In turn, this correctly resets the Polaris. 

## Participant recording
The first field is the participant **ID**; it is an integer.
Upon pressing the **Start Evaluation** button, the application checks if a corresponding output file already exists. If none is found, an output file is created and is ready for the recordings. Otherwise, the application loads the previous information and is ready for the next phase recordings.

### Phases
A drop down menu is provided to select a phase.
Once a phase is selected, the evaluation may start by pressing the **Start 10 Recordings** button.
A phase may be performed twice. If so, the application will prompt the user to move the obsolete data to a backup file; e.g. `FILENAME.backup`.

### Recordings
To start the recordings, press the **Start recordings** button or space bar to take one recording while pointing the tracked tool towards the object of interest.
Before proceeding, be sure that the tracked tool and the object are in sight of the Polaris system.
Tracking stops automatically after the last recording has been made.
Next, press the **Next Phase** button or the **Save recordings** button.

### Stop Recordings
When the **Stop recordings** button is pressed, the tracking is halted and the cached data of the current phase is moved to backup file.

## Output files
All output files are comma separated files or CSV.
This application outputs  files:

### Snapshot Data
By default, the application captures 10 recordings per phase.
Each recording translates into one row in a CSV file with the pointer or tool position and quaternions as well as other relevant information. 
For every phase and every participant ten recordings are saved to a file, e.g. `SNAPSHOTDATAPATH/snapshot_data_participant_PARTICIPANTID.csv`.

Each file has the following header:
ParticipantID, PhaseID, PositionPointerX, PositionPointerY, PositionPointerZ, OrientationPointerX, OrientationPointerY, OrientationPointerZ, OrientationPointerW, ElapsedTime, Timestamp


* `Participant ID`: Integer ID in the Participant ID field
* `Phase ID`: Phase (starting from 1) chosen from the Phases drop menu
* `Visibility Pointer/Object`: Binary with visible (1), else (0)
* `Position Pointer/Object(X/Y/Z)`: Floating point values representing position in millimeters
* `Orientation Pointer/Object (X/Y/Z/W)`: Floating point values representing orientation as quaternion
* `Elapsed Time`: Calculated since  the **start 10 Recordings** button was pressed in milliseconds
* `Timestamp`: ISO 8601 format.

As means of backup, a raw file is also saved in the following format: `SNAPSHOTDATAPATH/snapshot_data_participant_PARTICIPANTID.raw.csv`.

It contains both local and global coordinate frames. 
Below is an example header for two objects and one pointer. 
The complete header is:

```ParticipantID, PhaseID,
PointerVisible, PositionPointerX, PositionPointerY, PositionPointerZ,
OrientationPointerX, OrientationPointerY, OrientationPointerZ, OrientationPointerW,
Object1Visible, PositionObject1X, PositionObject1Y, PositionObject1Z,
OrientationObject1X, OrientationObject1Y, OrientationObject1Z, OrientationObject1W,
Object2Visible, PositionObject2X, PositionObject2Y, PositionObject2Z,
OrientationObject2X, OrientationObject2Y, OrientationObject2Z, OrientationObject2W,
EllapsedTime, Timestamp
```

### Continuous Data
The continuous data is also saved as a CSV file for each participant and phase in the following format: `CONTINOUSDATAPATH/snapshot_data_participant_PARTICIPANTID_PHASEID.csv`
Each file has the same header as seen for the snapshot data.

The raw file for the continuous data also includes both local and world coorindate frames; saved under the example CSV file: `CONTINOUSDATAPATH/snapshot_data_participant_PARTICIPANTID_PHASEID.raw.csv`

### Backup
When a certain phase is performed once more, the application does not overwrite the data. It saves the previous recordings for both snapshot and continuous data to a `.backup` file extension.

### Temp files
When the application is running, cached data is created and stored to `.tmp` files in the same path. Such files may be useful in case the application crashes. Otherwise, do not modify these files. Once closed, the application is tasked to remove all temporary files.

# Licence
```
UserEvaluationPolaris is licensed under the GNU General Public License v3.0
Copyright and license notices must be preserved. Contributors provide an express grant of patent rights.
For the full licence, please refere to the LICENCE file.
```
