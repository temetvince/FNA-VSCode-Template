#!/bin/bash
# Program: getFNA
# Author: Caleb Cornett
# Usage: ./getFNA.sh
# Description: Quick and easy way to install a local copy of FNA and its native libraries.
# Now with unique return codes for various stages and errors.

set -e
set -x

function checkDotnet() {
    echo "Checking for dotnet..."
    command -v dotnet > /dev/null 2>&1 || { echo >&2 "ERROR: dotnet is not installed. Please install dotnet to download the t4 tool."; exit 2; }
}

function installT4() {
    echo "Installing t4 tool..."
    checkDotnet
    if ! command -v t4 > /dev/null 2>&1; then
        dotnet tool install -g dotnet-t4 || { echo >&2 "ERROR: Failed to install t4."; exit 3; }
    fi
}

function checkGit() {
    echo "Checking for git..."
    git --version > /dev/null 2>&1 || { echo >&2 "ERROR: Git is not installed. Please install git to download FNA."; exit 4; }
}

function downloadFNA() {
    checkGit
    echo "Downloading FNA..."
    git -C "$MY_DIR" clone https://github.com/FNA-XNA/FNA.git --depth 1 --recursive || { echo >&2 "ERROR: Unable to download successfully. Maybe try again later?"; exit 5; }
    echo "Finished downloading!"
}

function updateFNA() {
    checkGit
    echo "Updating to the latest git version of FNA..."
    git -C "$MY_DIR/FNA" pull --recurse-submodules || { echo >&2 "ERROR: Unable to update."; exit 6; }
    echo "Finished updating!"
}

function getLibs() {
    echo "Downloading latest fnalibs..."
    curl -L http://fna.flibitijibibo.com/archive/fnalibs.tar.bz2 -o "$MY_DIR/fnalibs.tar.bz2" || { echo >&2 "ERROR: Unable to download successfully."; exit 7; }
    echo "Finished downloading!"

    if [ ! -f "$MY_DIR/fnalibs.tar.bz2" ]; then
        echo "ERROR: Downloaded file not found."
        exit 8
    fi

    mkdir -p "$MY_DIR/fnalibs"
    echo "Decompressing to directory: $MY_DIR/fnalibs"
    tar xjf "$MY_DIR/fnalibs.tar.bz2" -C "$MY_DIR/fnalibs" || { echo >&2 "ERROR: Unable to decompress successfully."; exit 9; }
    echo "Finished decompressing!"
    rm "$MY_DIR/fnalibs.tar.bz2"
}

echo "Setting MY_DIR..."
MY_DIR=$(dirname "$BASH_SOURCE")
echo "MY_DIR is set to $MY_DIR"

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

if [[ $shouldDownload =~ ^[Yy]$ ]]; then
    downloadFNA
elif [[ $shouldUpdate =~ ^[Yy]$ ]]; then
    updateFNA
fi

if [[ $shouldDownloadLibs =~ ^[Yy]$ ]]; then
    getLibs
fi

installT4

if [ ! -d "$MY_DIR/project_name" ]; then
    echo "Directory $MY_DIR/project_name not found."
    exit 10
fi

read -p "Enter the project name to use for your folder and csproj file or 'exit' to quit: " newProjectName

if [[ $newProjectName = 'exit' || -z "$newProjectName" ]]; then
    exit 11
fi

files=(project_name.sln .gitignore project_name/project_name.csproj project_name/Game1.cs project_name/DemoComponent.cs project_name/DefaultScene.cs project_name/Program.cs .vscode/tasks.json .vscode/settings.json .vscode/launch.json .vscode/buildEffects.sh .vscode/processT4Templates.sh)

for file in "${files[@]}"; do
    echo "Replacing project_name with $newProjectName in $file"
    if [ -f "$file" ]; then
        sed -i "s/project_name/$newProjectName/g" "$file" || { echo >&2 "ERROR: Failed to replace project_name in $file"; exit 12; }
    else
        echo "WARNING: File $file not found."
    fi
done

# Debugging: Print the directory structure before renaming
echo "Directory structure before renaming:"
ls -R

echo "Renaming solution and project files..."
mv project_name.sln "$newProjectName.sln" || exit 13
mv project_name "$newProjectName" || exit 14

echo "Directory structure after renaming:"
ls -R

echo "Initializing git repository..."
git init || exit 15
git submodule add --depth 1 https://github.com/prime31/Nez.git || exit 16
cd Nez || exit 17
git submodule init || exit 18
git submodule update --depth 1 || exit 19

echo "Checking for pbcopy..."
if ! command -v pbcopy > /dev/null 2>&1; then
    printf "\n\nManually run the following command:\n\nnuget restore Nez/Nez.sln && msbuild Nez/Nez.sln && msbuild /t:restore $newProjectName && msbuild $newProjectName.sln\n\n"
else
    echo "nuget restore Nez/Nez.sln && msbuild Nez/Nez.sln && msbuild /t:restore $newProjectName && msbuild $newProjectName.sln" | pbcopy
    echo "A build command was copied to your clipboard. Paste and run it now."
fi

echo "Script completed successfully."
exit 0 # Successful completion of the script
