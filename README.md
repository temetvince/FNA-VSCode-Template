# FNA VSCode Template
Start new FNA projects with Nez quickly and easily with handy setup scripts, a versatile boilerplate project, and convenient Visual Studio Code integration.


## Features ##
- Super simple setup scripts that download and install Nez, FNA and its native libraries for you
- Boilerplate project already included -- no need to wrestle with MSBuild configurations or writing yet another Game1 class
- Visual Studio Code tasks for building and running your game, cleaning/restoring your project, compiling .fx files and building content with the MonoGame Pipeline tool
- In-editor debugging support with the Mono Debugger


## Prerequisites ##
- [Visual Studio Code](https://code.visualstudio.com)
  - [C# Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode.csharp)
  - [Mono Debugger Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode.mono-debug) (required for macOS debugging -- [Windows can use `clr` instead](https://github.com/OmniSharp/omnisharp-vscode/wiki/Desktop-.NET-Framework))
- [Mono](https://www.mono-project.com/docs/getting-started/install/mac/) (required for MacOS)
- [Git](https://git-scm.com)
- [7-Zip](https://www.7-zip.org) (required for Windows to decompress fnalibs)
- [Microsoft DirectX SDK (June 2010)](https://www.microsoft.com/en-us/download/details.aspx?id=6812) (required for building effects -- on Mac, [you can use Wine to run this](https://github.com/AndrewRussellNet/FNA-Template#linuxmacos-installing-the-directx-sdk-on-wine))


## Setup Instructions ##
1. Download and unzip the ZIP archive (don't clone the repo!)
2. Copy+paste the resulting folder to your desired project directory
3. Run `./getFNA.sh` (macOS) to download the latest Nez, FNA and fnalibs to the directory. You can run this script again if you want to update either FNA or the libraries at a later point. Nez is setup as a submodule so you can update it in the normal fashion.
4. Open the newly-created and named `code-workspace` file (or open the project folder in Visual Studio Code or the top-level sln in Visual Studio)

That's it! Now you're ready to build and run the base project!


## Build Tasks ##
- **Restore Project:** Restores the .csproj. Run this before building for the first time, and run it again whenever you change the .csproj file.
- **Build (Debug/Release):** Builds the project with the specified configuration but does not run it. This also copies over everything in the Content/ subdirectory and the fnalibs.
- **Build and Run (Debug/Release):** Builds and runs the project. On MacOS, it runs the output with Mono. On Windows, it runs the output with .NET Framework.
- **Clean Project:** Cleans the output directories and all their subdirectories.
- **Build Effects:** Runs `fxc.exe` on all of the `.fx` files found in the Content/ subdirectories and outputs corresponding `.fxb` files that can be loaded through the Content Manager at runtime.
- **Build Content:** Runs good old MGCB.exe on the Content.mgcb file
- **Force Build Content:** Force builds the content (MGCB.exe -r)
- **Open Pipeline Tool:** Opens the MonoGame Pipeline tool


## License and Credits ##
FNA VSCode Template is released under the Microsoft Public License.
Many thanks to Andrew Russell for his [FNA Template](https://github.com/AndrewRussellNet/FNA-Template), from which I learned a lot (and borrowed a little).
