# homebrew-xplanet
Xplanet homebrew formula now hosted on personal tap due to Homebrew policy changes.  See https://github.com/Homebrew/homebrew-core/issues/31510 (no more options in formula) and previous to this https://github.com/Homebrew/brew/pull/2482 (no more options for default dependencies) for more information.

This tap allows for customized compilation options for Xplanet and xplanetFX mirroring how they used to work in Homebrew prior to the policy changes.  They will continue to be updated with patches and version updates and in some cases may be more up to date than the formula in Homebrew.

Xplanet, by default, compiles with the following libraries: freetype, gif, jpeg, png, tiff, pango, pnm, and cspice.  Xplanet on Homebrew installs only with png, jpeg, tiff, gif, and freetype; presumably because the others take too long to install (pango) or not as widely used (pnm through netpbm and cspice).  The default option in this tap mimics Homebrew's default, but allows for any desired combination and supports both Apple Aqua and X11.

Installation
------------
Tap: ```brew tap blogabe/xplanet```

To install Xplanet:

```
brew install blogabe/xplanet/xplanet
  --with-all installs all the default Xplanet compile options,
    i.e., it adds pango, netpbm, and cspice to Homebrew's default compile options
  --with-pango adds pango to Homebrew's default compile options
  --with-netpbm adds pbm to Homebrew's default compile options
  --with-cspice adds cspice to Homebrew's default compile options
  --with-X11 compiles with X11 support instead of Apple Aqua (not part of --with-all)
```

To install xplanetFX:

```
brew install xplanetfx
  --with-gnu-sed uses GNU sed rather than Apple's version
  --with-xp-all installs Xplanet dependency with default compile options
  --with-complete adds GNU sed and installs Xplanet's default compile options
  --without-gui only supports command line usage (skinnier install)
```
