# Prints a start message to the console
echo "getNez.sh started."

# Restore NuGet packages for the Nez solution
# This command restores all NuGet packages required by the Nez solution file (Nez.sln).
# The `-Verbosity detailed` flag provides detailed logging output to help diagnose issues.
# If the command fails, the script exits with code 2.
nuget restore Nez/Nez.sln -Verbosity detailed || exit 2

# Build the Nez solution
# This command compiles the Nez solution (Nez.sln) using MSBuild.
# The `/v:diagnostic` flag provides detailed logging output to help diagnose issues.
# If the command fails, the script exits with code 3.
msbuild Nez/Nez.sln /v:diagnostic || exit 3

# Restore NuGet packages for the new project
# This command restores all NuGet packages required by the new project.
# The `newProjectName` variable should contain the name of the new project.
# The `/t:restore` flag specifies that MSBuild should perform a package restore.
# The `/v:diagnostic` flag provides detailed logging output to help diagnose issues.
# If the command fails, the script exits with code 4.
msbuild /t:restore $newProjectName /v:diagnostic || exit 4

# Build the new project solution
# This command compiles the new project solution using MSBuild.
# The `newProjectName.sln` variable should contain the name of the new project solution file.
# The `/v:diagnostic` flag provides detailed logging output to help diagnose issues.
# If the command fails, the script exits with code 5.
msbuild $newProjectName.sln /v:diagnostic || exit 5

# Print a success message
# This message indicates that the script completed successfully.
echo "getNez.sh completed successfully."

# Exit with code 0 to indicate successful completion of the script
exit 0
