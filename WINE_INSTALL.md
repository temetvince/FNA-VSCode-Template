(Linux/macOS) Installing the DirectX SDK on Wine
------------------------------------------------

On Linux and macOS, the DirectX SDK is still required to compile shaders. On these platforms we use Wine to run the DirectX SDK tools.

To install Wine and winetricks on **Linux**, refer to your distribution's package database. Typically the package names will simply be `wine` and `winetricks`.

To install Wine and winetricks on **macOS**:

- Install Homebrew from https://brew.sh/
- Install wine with `brew install wine`
- Install winetricks with `brew install winetricks`
- (If you already have these installed, update with: `brew update`, `brew upgrade wine`, `brew upgrade winetricks`)

Once Wine and winetricks are installed:

- Setup Wine with `winecfg`
- Install the DirectX SDK with `winetricks dxsdk_jun2010`

**Alternative method:** Instead of installing the DirectX SDK, you can place a copy of `fxc.exe` from the DirectX SDK in the `build/tools` directory. Then use `winetricks d3dcompiler_43` to install the required DLL from the DirectX redistributable (this is a smaller download than the SDK). See `BuildShaders.targets` for details. The same fallback also works on Windows.
