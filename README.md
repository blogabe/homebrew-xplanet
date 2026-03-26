# homebrew-xplanet
Xplanet homebrew formula hosted on a personal tap due to Homebrew policy changes. See [no more options in formula](https://github.com/Homebrew/homebrew-core/issues/31510) and [no more options for default dependencies](https://github.com/Homebrew/brew/pull/2482) for background.

This tap allows for customized compilation options for Xplanet mirroring how they used to work in Homebrew prior to the policy changes. The formula includes all upstream patches through SVN r225, keeping it current with the latest source fixes.

## Installation

Tap:
```
brew tap blogabe/xplanet
```

Install Xplanet:
```
brew install blogabe/xplanet/xplanet
```

### Options

| Option | Description |
|--------|-------------|
| `--with-all` | Install with all optional dependencies (pango, netpbm, cspice) |
| `--with-cspice` | Add JPL SPICE toolkit support |
| `--with-pango` | Add internationalized text support |
| `--with-netpbm` | Add PNM graphic support |
| `--without-giflib` | Disable giflib (enabled by default) |
| `--without-jpeg` | Disable jpeg (enabled by default) |
| `--without-libpng` | Disable libpng (enabled by default) |
| `--without-libtiff` | Disable libtiff (enabled by default) |

Example:
```
brew install --formula --build-from-source blogabe/xplanet/xplanet --with-cspice --without-giflib
```

## xplanetFX

xplanetFX is no longer maintained and depends on Python 2, which has been removed from Homebrew. The formula and its supporting patches are retained in this repo for reference but are not expected to work.

To install xplanetFX (by default, installs with gnu-sed and gui options):

```
brew install blogabe/xplanet/xplanetfx
  --with-gnu-sed uses GNU sed rather than Apple's version
  --with-xp-all installs Xplanet dependency with default compile options
  --with-complete adds GNU sed and installs Xplanet's default compile options
  --without-gui only supports command line usage (skinnier install)
```

The above two install commands will build from source, but will still install the dependencies as bottles due to Homebrew changes.  Install with the below command if you want to ensure all dependencies are also built from source:

```
brew install --build-from-source `brew deps -n --include-build --include-requirements --include-optional xplanetfx | grep -v ':'`
brew install --build-from-source xplanetfx  <options>
```

This will download and build each and every single dependency whether or not you install with the full complement of options or merely a subset.  It's the only way given Homebrew's changes that you can ensure dependencies also get built from source.
