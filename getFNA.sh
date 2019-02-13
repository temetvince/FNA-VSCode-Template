#!/bin/bash
# Program: getFNA
# Author: Caleb Cornett
# Usage: ./getFNA.sh
# Description: Quick and easy way to install a local copy of FNA and its native libraries.

# Checks if dotnet is installed
function checkDotnet()
{
	# || { echo >&2 "ERROR: dotnet is not installed. Please install dotnet to download the t4 tool."; exit 1; }
	command -v dotnet > /dev/null 2>&1
    if [ ! $? -eq 0 ]; then
        echo >&2 "ERROR: dotnet is not installed. Please install dotnet to download the t4 tool."
        exit 1
    fi
}

# Checks if t4 is installed and installs it if it isnt
function installT4()
{
	checkDotnet
	command -v t4 > /dev/null 2>&1
    if [ ! $? -eq 0 ]; then
		dotnet tool install -g dotnet-t4
    fi
}

# Checks if git is installed
function checkGit()
{
    git --version > /dev/null 2>&1
    if [ ! $? -eq 0 ]; then
        echo >&2 "ERROR: Git is not installed. Please install git to download FNA."
        exit 1
    fi
}

# Clones FNA from the git master branch
function downloadFNA()
{
    checkGit
	echo "Downloading FNA..."
	git -C $MY_DIR clone https://github.com/FNA-XNA/FNA.git --recursive
	if [ $? -eq 0 ]; then
		echo "Finished downloading!\n"
	else
		echo >&2 "ERROR: Unable to download successfully. Maybe try again later?"
	fi
}

# Pulls FNA from the git master branch
function updateFNA()
{
    checkGit
    echo "Updating to the latest git version of FNA..."
	git -C "$MY_DIR/FNA" pull --recurse-submodules
	if [ $? -eq 0 ]; then
		echo "Finished updating!\n"
	else
		echo >&2 "ERROR: Unable to update."
		exit 1
	fi
}


# Clones FNA from the git master branch
function downloadImGui()
{
    checkGit
	echo "Downloading ImGui..."
	echo "Temporarily using ImGui.NET branch until ImGui.NET master is updated"
	#git -C $MY_DIR clone https://github.com/mellinoe/ImGui.NET.git --recursive
	git -C $MY_DIR clone -b fix-MonoGame-FNA https://github.com/prime31/ImGui.NET.git --recursive
	if [ $? -eq 0 ]; then
		echo "Finished downloading!\n"
	else
		echo >&2 "ERROR: Unable to download successfully. Maybe try again later?"
	fi
}

# Pulls FNA from the git master branch
function updateImGui()
{
    checkGit
    echo "Updating to the latest git version of ImGui.NET..."
	git -C "$MY_DIR/ImGui.NET" pull --recurse-submodules
	if [ $? -eq 0 ]; then
		echo "Finished updating!\n"
	else
		echo >&2 "ERROR: Unable to update."
		exit 1
	fi
}


# Downloads and extracts prepackaged archive of native libraries ("fnalibs")
function getLibs()
{
    # Downloading
    echo "Downloading latest fnalibs..."
    curl http://fna.flibitijibibo.com/archive/fnalibs.tar.bz2 > "$MY_DIR/fnalibs.tar.bz2"
    if [ $? -eq 0 ]; then
        echo "Finished downloading!"
    else
        >&2 echo "ERROR: Unable to download successfully."
        exit 1
    fi

    # Decompressing
    echo "Decompressing fnalibs..."
    mkdir -p $MY_DIR/fnalibs
    tar xjC $MY_DIR/fnalibs -f $MY_DIR/fnalibs.tar.bz2
    if [ $? -eq 0 ]; then
        echo "Finished decompressing!"
        rm $MY_DIR/fnalibs.tar.bz2
    else
        >&2 echo "ERROR: Unable to decompress successfully."
        exit 1
    fi
}

# Get the directory of this script
MY_DIR=$(dirname "$BASH_SOURCE")


# gather input

# FNA
if [ ! -d "$MY_DIR/FNA" ]; then
    read -p "Download FNA (y/n)? " shouldDownload
else
    read -p "Update FNA (y/n)? " shouldUpdate
fi

if [ ! -d "$MY_DIR/fnalibs" ]; then
    read -p "Download fnalibs (y/n)? " shouldDownloadLibs
else 
    read -p "Redownload fnalibs (y/n)? " shouldDownloadLibs
fi


# Dear ImGui
if [ ! -d "$MY_DIR/ImGui.NET" ]; then
    read -p "Download ImGui.NET (y/n)? " shouldDownload
else
    read -p "Update ImGui.NET (y/n)? " shouldUpdate
fi


# act on the input

# FNA
if [[ $shouldDownload =~ ^[Yy]$ ]]; then
    downloadFNA
elif [[ $shouldUpdate =~ ^[Yy]$ ]]; then
    updateFNA
fi

# FNALIBS
if [[ $shouldDownloadLibs =~ ^[Yy]$ ]]; then
    getLibs
fi

# Dear ImGui
if [[ $shouldDownload =~ ^[Yy]$ ]]; then
    downloadImGui
elif [[ $shouldUpdate =~ ^[Yy]$ ]]; then
    updateImGui
fi


# install t4 engine
installT4



# Only proceed from here if we have not yet renamed the project
if [ ! -d "$MY_DIR/project_name" ]; then
	# old project_name folder already renamed so we are all done here
	exit 1
fi


read -p "Enter the project name to use for your folder and csproj file or 'exit' to quit: " newProjectName
if [[ $newProjectName = 'exit' || -z "$newProjectName" ]]; then
    exit 1
fi

sed -i '' "s/project_name/$newProjectName/g" project_name.code-workspace
sed -i '' "s/project_name/$newProjectName/g" project_name.sln
sed -i '' "s/project_name/$newProjectName/g" .gitignore
sed -i '' "s/project_name/$newProjectName/g" project_name/project_name.sln
sed -i '' "s/project_name/$newProjectName/g" project_name/project_name.csproj
sed -i '' "s/project_name/$newProjectName/g" project_name/Game1.cs
sed -i '' "s/project_name/$newProjectName/g" project_name/Program.cs
sed -i '' "s/project_name/$newProjectName/g" project_name/.vscode/tasks.json
sed -i '' "s/project_name/$newProjectName/g" project_name/.vscode/launch.json

mv project_name.code-workspace "$newProjectName.code-workspace"
mv project_name.sln "$newProjectName.sln"
mv project_name/project_name.sln "project_name/$newProjectName.sln"
mv project_name/project_name.csproj "project_name/$newProjectName.csproj"
mv project_name/project_name.csproj.user "project_name/$newProjectName.csproj.user"
mv project_name "$newProjectName"

git init
git submodule add git@github.com:prime31/Nez.FNA.git
cd Nez.FNA
git submodule init
git submodule update

command -v pbcopy > /dev/null 2>&1
if [ ! $? -eq 0 ]; then
	printf "\n\nManually run the following command:\n\nnuget restore Nez.FNA/Nez/Nez.sln && msbuild Nez.FNA/Nez/Nez.sln && msbuild /t:restore $newProjectName\n\n"
else
	echo "nuget restore Nez.FNA/Nez/Nez.sln && msbuild Nez.FNA/Nez/Nez.sln && msbuild /t:restore $newProjectName" | pbcopy
	echo "command copied to your clipboard\n"
fi
