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

To install xplanetFX (by default, installs with gnu-sed and gui options):

```
brew install blogabe/xplanet/xplanetfx
  --with-gnu-sed uses GNU sed rather than Apple's version
  --with-xp-all installs Xplanet dependency with default compile options
  --with-complete adds GNU sed and installs Xplanet's default compile options
  --without-gui only supports command line usage (skinnier install)
```

The above two install commands will build from source, but will still install the dependencies as bottles due to Homebrew changes.  Install with the below command ff you want to ensure all dependencies are also built from source:

```
brew install --build-from-source `brew deps -n --include-build --include-requirements --include-optional xplanetfx | grep -v ':'`
brew install --build-from-source xplanetfx  <options>
```

This will download and build each and every single dependency whether or not you install with the full complement of options or merely a subset.  It's the only way given Homebrew's changes that you can ensure dependencies also get built from source.

As of 25Jan2019, the first step described above will break while trying to install the graphite2 dependency.  Simply `brew install graphite2` then re-run the above steps.
