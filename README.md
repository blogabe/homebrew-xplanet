# homebrew-xplanet

Xplanet Homebrew formula hosted on a personal tap to retain custom build options. See [no more options in formula](https://github.com/Homebrew/homebrew-core/issues/31510) and [no more options for default dependencies](https://github.com/Homebrew/brew/pull/2482) for background.

This tap builds Xplanet **1.3.2** from [a maintained fork](https://github.com/blogabe/xplanet-src)
of [Hari Nair’s Xplanet](https://xplanet.sourceforge.io/). It is a downstream
release and does not require Subversion.

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

Version 1.3.2 supersedes this tap’s 1.3.1.225 revision 3 build. Run:

```sh
brew update
brew upgrade --build-from-source blogabe/xplanet/xplanet
```

To rebuild an already-current installation, use `brew reinstall --build-from-source blogabe/xplanet/xplanet`. Homebrew reuses the previous installation options, including the legacy `--without-jpeg` opt-out. See the [Homebrew command reference](https://docs.brew.sh/Manpage) for details.

## Source and build details

For a direct build, download the named [`xplanet-1.3.2.tar.gz` release asset](https://github.com/blogabe/xplanet-src/releases/download/v1.3.2/xplanet-1.3.2.tar.gz), not GitHub’s automatic “Source code” archives. The formula pins the release asset’s SHA-256. Build instructions and the renderer’s history are in [xplanet-src](https://github.com/blogabe/xplanet-src).

For macOS Finder Automation troubleshooting, see the [recovery guide](https://github.com/blogabe/Xplanet/blob/main/docs/management.md#finder-automation-permission).
