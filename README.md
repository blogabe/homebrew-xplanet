# homebrew-xplanet

Xplanet Homebrew formula hosted on a personal tap to retain custom build options. See [no more options in formula](https://github.com/Homebrew/homebrew-core/issues/31510) and [no more options for default dependencies](https://github.com/Homebrew/brew/pull/2482) for background.

The formula builds Xplanet 1.3.1 with macOS Aqua support and backports SVN revisions r207, r208, r214, and r222–r225. The five patches hosted in this repository are pinned to [commit c12f559](https://github.com/blogabe/homebrew-xplanet/tree/c12f559b97ba8da69db029354739adc772b1bd9d/patches); all seven patches have SHA-256 checksums in [xplanet.rb](xplanet.rb).

## Installation

Tap this repository and build Xplanet from source:

```sh
brew tap blogabe/xplanet
brew install --build-from-source blogabe/xplanet/xplanet
```

Use the fully qualified formula name to select this tap's custom options. Homebrew may still install dependencies from bottles when available.

### Options

The default build enables FreeType, GIF, JPEG, PNG, and TIFF support. CSPICE, Pango, and Netpbm are disabled unless selected individually or through `--with-all`.

| Option | Description |
|--------|-------------|
| `--with-all` | Require and enable cspice, pango, and netpbm |
| `--with-cspice` | Add JPL SPICE toolkit support |
| `--with-pango` | Add internationalized text support |
| `--with-netpbm` | Add PNM graphic support |
| `--without-giflib` | Disable GIF support |
| `--without-jpeg` | Disable JPEG support |
| `--without-libpng` | Disable PNG support |
| `--without-libtiff` | Disable TIFF support |

`--with-all` adds the three optional features; it still honors the four image-format opt-outs above. The Homebrew option names remain `--without-libpng` and `--without-libtiff`; the formula translates them to the upstream configure flags.

For example, enable all three optional features but disable TIFF:

```sh
brew install --build-from-source blogabe/xplanet/xplanet --with-all --without-libtiff
```

Or select CSPICE alone and disable GIF:

```sh
brew install --build-from-source blogabe/xplanet/xplanet --with-cspice --without-giflib
```

### Updating an existing installation

The formula is still version 1.3.1, revision 99. If that version is already installed, formula fixes alone do not make it outdated for `brew upgrade`. To rebuild it with the current formula:

```sh
brew update
brew reinstall --build-from-source blogabe/xplanet/xplanet
```

`brew reinstall` reuses the previous installation options and accepts additional formula options. See the [Homebrew command reference](https://docs.brew.sh/Manpage) for details.

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
