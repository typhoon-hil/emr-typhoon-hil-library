# Energetic Macroscopic Representation Library for Typhoon HIL Schematic Editor

## Getting Started
### 
1. Download and install Typhoon HIL Control Center,
2. Download the EMR Library from this GitHub repository,
3. Include the EMR library in the Schematic Editor.

### Typhoon HIL Control Center
The steps for downloading the Typhoon HIL Control Center can be found at the [software download](https://www.typhoon-hil.com/products/software-download/) page.
The Schematic Editor is one of the tools within the Typhoon HIL Control Center toolchain. 

### GitHub repository
In order to download the project of the [GitHub repository](https://github.com/typhoon-hil/emr-typhoon-hil-library), 
click the *Code* button on the right hand side at the top of the page, then the *Download ZIP* button.

The described manner of downloading the project is in user only mode, where only the latest releases are downloaded and used.  
The project can also be used in developer mode, in which easy access to the latest state of the software is available.
Contribution to the project is possible in the developer mode, while abiding by the contribution guidelines.

In developer mode, the project can be cloned using one of the provided options (HTTPS, SSH, GitHub CLI).
In order to clone the project, *git* software and a GitHub account are required.

### EMR Library in Schematic Editor
A quick guide for including the EMR library in the Schematic Editor is provided.
1. In the Schematic Editor, click on *File* | *Modify library paths...*.
2. Click *Browse* and set the path to the *emr-typhoon-hil-library / libs* directory (where the EMR library is located).
3. Click *Apply and Save*.
4. Click *File* | *Reload libraries* in order to load the library.

Once the described steps have been carried out, the library will be automatically loaded the next time Schematic Editor is opened.   

More detailed description of the steps for including libraries in the Schematic Editor, as well as some additonal options can be found in the [Loading libraries guide](https://www.typhoon-hil.com/documentation/typhoon-hil-software-manual/concepts/loading_a_library_in_library_browser.html). 

## EMR Library description
EMR formalism is used to organize simulation models.

EMR is based on action reaction principle, which organizes the system model as interconnected subsystems according to 
the integral causality. An inversion of this description leads to macro-control blocks. [1]

EMR library in Typhoon HIL Schematic Editor is comprised of components which implement EMR pictograms.
EMR pictograms for simulation, estimation, control, and power adaptation are supported.  
The components are implemented as empty subsystems.

Examples of using EMR formalism to model an electric vehicle can be found in the *examples* directory of this repository.


### Useful links
[1] [EMR website](http://www.emrwebsite.org/) (hosted by the University of Lille)

[2] A. Genic, C. Mayet, M. Almeida, A. Bouscayrol, N. Stojkov. [*EMR-Based Signal-HIL Testing of an Electric Vehicle Control*](https://ieeexplore.ieee.org/document/8331047), 
2017 IEEE Vehicle Power and Propulsion Conference (VPPC), Belfort, France, 2017.
