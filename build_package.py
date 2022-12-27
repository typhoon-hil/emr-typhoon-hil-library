import os
from pathlib import Path
from sys import path
import shutil
import fnmatch
from typhoon.api.package_manager import package_manager as pkm

root_folder = os.path.dirname(os.path.abspath(__file__)) #Path to location where libs, examples, docs... folders are located
path_to_scripts = os.path.join(root_folder.split("hil_compatibles")[0], "package_deployment", "package_scripts") #path to scripts with functions
if path_to_scripts not in path:
    path.append(path_to_scripts)


#-------------------------------------Parameters related to Package title and basic information-----------------------------------------

package_name = "EMR Library" #Package name
version = "1.0" #Package version
author = "Typhoon HIL" #Author of the package
description = package_name + " with examples." #Package description


#-------------------------------------------Parameters related to Library encryption----------------------------------------------------

encryption = False  #Library should be encrypted
#Categories and components that should be hidden. If nothing, set [] or None
categories_to_hide = [] #'Dev' This is added manually in .tlib already
components_to_hide= [] #'PD250', '"CAB1K 3 LVL"'
docs_of_libs = "docs" #Name of folder with documentation for libs, or relative path to it


#--------------------------------------------Parameters related to Package content------------------------------------------------------
#If HILCompatible structure was followed during development this shouldn't be changed

examples_folder_name = "examples" #Name of folder with examples or relative path to it
release_notes_folder_name = "release_notes" #Name of folder with release note, or relative path to it


#----------------------Utility Functions Definitions--------------------------------------------------------------------
def generate_non_encrypted_libs(directory_path ,docs_folder_name = "docs"):
    """Args:
        directory_path: path of the folder with libs folder
        docs_folder_name: Name of folder that contains documentation for component"""
    root_dir = directory_path
    source_path = os.path.join(root_dir, 'libs')

    print("Creating temporarily libs_deployment")

    deploy_lib_dir = 'libs_deployment'
    deploy_dir = os.path.abspath(os.path.join(root_dir, deploy_lib_dir))
    if not os.path.exists(deploy_dir): os.makedirs(deploy_dir)

    for item in os.listdir(source_path):
        source = os.path.join(source_path, item)
        deploy = os.path.join(deploy_dir, item)
        if os.path.isfile(source):
            if not os.path.exists(deploy):
                shutil.copy(source, deploy)
        if os.path.isdir(source):
            if not os.path.exists(deploy):
                    shutil.copytree(source, deploy)

    if docs_folder_name is not None and docs_folder_name != " ":
        docs_folder_path = os.path.abspath(os.path.join(deploy_dir, docs_folder_name))
        for item in fnmatch.filter(os.listdir(docs_folder_path), '*.docx'):
            os.remove(os.path.join(docs_folder_path, item))
    print("Finished creating temporarily libs_deployment.")
    return deploy_dir

def delete_lib_deployment(directory_path):
    root_dir = directory_path
    for item in os.listdir(root_dir):
        if "_deployment" in item:
            shutil.rmtree(os.path.abspath(os.path.join(root_dir, item)))
#-----------------------------------------------------------------------------------------------------------------------


#----------------------------------------------------Package creation--------------------------------------------------------------------

if encryption:
    library_path = [generate_encrypted_libs(root_folder, categories_to_hide, components_to_hide, docs_of_libs)]
else:
    library_path = [generate_non_encrypted_libs(root_folder, docs_of_libs)]

release_notes_paths = None

example_paths = [os.path.join(root_folder, examples_folder_name)]
additional_files_paths = []
documentation_paths = []
documentation_landing_page = None

# TODO
python_packages_paths = []

output_path = os.path.join(root_folder, package_name + " Package")

if os.path.exists(output_path):
    shutil.rmtree(output_path)

pkm.create_package(package_name=package_name, version=version, output_path=output_path, author=author,
                   description=description, library_paths=library_path,
                   resource_paths=[], example_paths=example_paths,
                   additional_files_paths=additional_files_paths, python_packages_paths=python_packages_paths,
                   documentation_paths=documentation_paths, documentation_landing_page=documentation_landing_page,
                   release_notes_path=release_notes_paths)

print("Building package finished.")
delete_lib_deployment(root_folder)
print("Temporarily libs_deployment deleted.")

