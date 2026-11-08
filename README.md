# homebrew-xplanet

Xplanet Homebrew formula hosted on a personal tap to retain custom build options. See [no more options in formula](https://github.com/Homebrew/homebrew-core/issues/31510) and [no more options for default dependencies](https://github.com/Homebrew/brew/pull/2482) for background.

The formula builds Xplanet 1.3.1 with macOS Aqua support and backports SVN revisions r207, r208, r214, and r222–r225. The complete r214 GIF patch is pinned to [Homebrew core commit b09831f](https://github.com/Homebrew/homebrew-core/blob/b09831fb902aa803218dcd2d7335840e48645334/Patches/xplanet/xplanet-1.3.1-giflib5.patch), with an identical reference copy in [patches/](patches/xplanet-1.3.1-r214-giflib5.patch). The four r222–r225 patches remain pinned to [commit c12f559](https://github.com/blogabe/homebrew-xplanet/tree/c12f559b97ba8da69db029354739adc772b1bd9d/patches); all seven patches have SHA-256 checksums in [xplanet.rb](xplanet.rb).

## Installation

Tap this repository and build Xplanet from source:

```sh
brew tap blogabe/xplanet
brew install --build-from-source blogabe/xplanet/xplanet
```

Use the fully qualified formula name to select this tap's custom options. Homebrew may still install dependencies from bottles when available.

### Options

The default build enables FreeType, GIF, JPEG (via `jpeg-turbo`), PNG, and TIFF support. CSPICE, Pango, and Netpbm are disabled unless selected individually or through `--with-all`.

| Option | Description |
|--------|-------------|
| `--with-all` | Require and enable cspice, pango, and netpbm |
| `--with-cspice` | Add JPL SPICE toolkit support |
| `--with-pango` | Add internationalized text support |
| `--with-netpbm` | Add PNM graphic support |
| `--without-giflib` | Disable GIF support |
| `--without-jpeg-turbo` | Disable JPEG support (`--without-jpeg` remains a compatibility alias) |
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

The formula is version 1.3.1, revision 101. This revision includes the complete upstream r214 GIF fix and the `jpeg-turbo` dependency introduced in revision 100. Earlier revisions are outdated, so `brew upgrade` rebuilds Xplanet with the updated formula:

```sh
brew update
brew upgrade --build-from-source blogabe/xplanet/xplanet
```

To rebuild an already-current installation, use `brew reinstall --build-from-source blogabe/xplanet/xplanet`. Homebrew reuses the previous installation options, including the legacy `--without-jpeg` opt-out. See the [Homebrew command reference](https://docs.brew.sh/Manpage) for details.

## Legacy archive

Historical xplanetFX, Python 2/GTK, and custom ImageMagick formulae and supporting patches are retained for reference in [legacy/](legacy/README.md).
