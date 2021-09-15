# Energetic Macroscopic Representation Library for Typhoon HIL Schematic Editor

- [Getting Started](#getting-started)
  - [Typhoon HIL Control Center](#typhoon-hil-control-center)
  - [GitHub repository](#github-repository)
  - [EMR Library in Schematic Editor](#emr-library-in-schematic-editor)
- [EMR Library description](#emr-library-description)
- [Contribution guide](#contribution-guide)
  - [Reporting bugs](#reporting-bugs)
  - [Contributing examples](#contributing-examples)
  - [Contributing components](#contributing-components)
    - [Port definition](#port-definition)
    - [Mask definition](#mask-definition)
    - [Adding component image](#adding-component-image)
- [Useful links](#useful-links)

## Getting started
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

## Contribution guide
Any contributions and suggestions for new features would be greatly appreciated!

Contributions to this GitHub hosted project are managed with [GitHub flow](https://guides.github.com/), through the 
addition of issues and pull requests.

### Reporting bugs
Bugs are reported using GitHub's issues.
Prior to creating a new bug related issue, it should be checked that the bug hasn't already been reported under project's 
[Issues](https://github.com/typhoon-hil/emr-typhoon-hil-library/issues).
In addition, the project should be locally updated to its latest version.  

Produce a clear bug report by providing the description of the expected and the defective behaviour.
If possible, the bug report should also contain the steps necessary to reproduce the issue.
Other additional information, if available, would be useful for debugging. That might be the schematic model where the 
bug is noticed, a traceback, an image of the erroneous behaviour, etc.

### Contributing examples
A new example should be located in the *examples* directory of this repository, under a new dedicated directory.

### Contributing components
A new component can be added by updating the *libs/emr.tlib* library description file.

A component contains input and output ports specification, and the specification for the mask containing component 
properties.
Basic component architecture description is provided in the following.

Each component is defined in a dedicated section. Format of the declaration for the component section is given the 
example below:
```
component Subsystem "Component Name" {
    # component structure 
}
```
Component names can consist of multiple words.

#### Port definition
Format of the port definition is given in the example below:
```
port "P1" {
    position = -40, -16
    kind = sp
    direction = out 
}
[
position = 7256, 8000
hide_terminal_label = True
]
```

Each port is declared with its name, followed by its description. First, the main port description is specified, in 
which it's described how the port is seen on the component's mask. This part is placed inside curly brackets {}.
It contains several attributes:

|Attribute|Description
|---------|------------
|position |Specifies the ports x and y coordinate relative to the center of the component's mask.
|         |**Note**: The direction of the x coordinate is from left to right, and the direction of the y coordinate is from top to bottom.
|kind     | *sp*, *pe*
|         |The *sp* keyword signifies that the port's type is signal processing, while *pe* indicates power electronic ports.
|direction|*in*, *out*
|         |Specifies the direction of the port side which is used in the internal component structure.
|         |The complementary port side, used to connect the component with other components, is automatically deduced from this.

**Note**: The described constants which indicate port's kind and direction correspond to the constants given in the [Typhoon API documentation](https://www.typhoon-hil.com/documentation/typhoon-hil-api-documentation/schematic_api.html#schematic-api-constants).

This description is followed by the description of the port in the internal component structure.
This part is placed inside square brackets [].
It contains several attributes:

|Attribute          |Description
|-------------------|------------
|position           |Specifies the ports x and y coordinate relative to the center of the top left corner of the whole scene.
|                   |Schematic scene size is 16k pixels (16384), so scheme scene center point is (8192, 8192).
|scale              |Scales the two sides of the port.
|                   |For example: `scale = -1, 1`. In this example, the port is fliped around the horizontal axis (left-right).
|hide_terminal_label|*True*, *False*
|                   |If set to True, it hides the terminal label.

#### Mask definition
Mask definition specifies the attributes of the mask and the customized properties (widgets).  

Mask definition for the Mono-Physical Converter component from the EMR Library is given below:
```
mask {
    icon = "image('emr_images/emr_mono_physical_converter.svg')"
    description = "Mono-physical converter block for Energetic Macroscopic Representation of models."

    block_type {
        label = "Block type"
        widget = combo
        combo_values = "Simulation", "Estimation"
        type = string
        default_value = "Simulation"

        CODE property_value_changed
            mdl.refresh_icon(container_handle)
        ENDCODE
    }

    CODE define_icon
        images = {"Simulation": "emr_images/emr_mono_physical_converter.svg",
                  "Estimation": "emr_images/emr_mono_physical_converter_estimation.svg"}

        block_type = mdl.get_property_value(mdl.prop(item_handle, "block_type"))
        mdl.set_component_icon_image(item_handle, images[block_type])
    ENDCODE
}
```
 
The mask has the following attributes:

|Attribute  |Description
|-----------|------------
|icon       |Defines the relative path to the component's image.
|description|Describes the component.

Properties have the following attributes:

|Attribute    |Description                                                                     |Necessity
|-------------|--------------------------------------------------------------------------------|---------
|label        |Label on the property dialog indicating which widget represents which property. |Optional
|widget       |*edit*, *combo*, *checkbox*, *togglebutton*                                     |Mandatory
|             |Defines the representation of the property on the property dialog.              |
|combo_values |Contains the list of values that will be shown in the combo widget.             |Used only if widget is set to *combo*.
|type         |*int*, *uint*, *real*, *string*, *bool*, *generic*                              |Mandatory
|             |**Note**: When setting widget to *combo*, the *type* attribute must be set to *string*.|
|default_value|Sets the property's value when the component is added to the schematic model.   |Mandatory

#### Adding component image
An image is linked to the component in the mask definition of the component, by setting the *icon* property.
The *icon* property contains the path to the component's image relative to the location of the library description .tlib file.

Images should be saved in .svg format.
A new component image should be located in the *libs/emr_images* directory of this project.

## Useful links
[1] [EMR website](http://www.emrwebsite.org/) (hosted by the University of Lille)

[2] A. Genic, C. Mayet, M. Almeida, A. Bouscayrol, N. Stojkov. [*EMR-Based Signal-HIL Testing of an Electric Vehicle Control*](https://ieeexplore.ieee.org/document/8331047), 
2017 IEEE Vehicle Power and Propulsion Conference (VPPC), Belfort, France, 2017.
