# homebrew-xplanet

Xplanet Homebrew formula hosted on a personal tap to retain custom build options. See [no more options in formula](https://github.com/Homebrew/homebrew-core/issues/31510) and [no more options for default dependencies](https://github.com/Homebrew/brew/pull/2482) for background.

This tap builds Xplanet **1.3.1.225** from a maintained source snapshot, not an
official upstream release. It does not require Subversion. The current Homebrew
package includes Alpha-5 satellite support and Finder Automation troubleshooting.

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

Version 1.3.1.225 supersedes the earlier 1.3.1 revision 102 (`1.3.1_102`) build. Homebrew compares the source version before its packaging revision, so this is an upgrade without a revision-number workaround. Run:

```sh
brew update
brew upgrade --build-from-source blogabe/xplanet/xplanet
```

To rebuild an already-current installation, use `brew reinstall --build-from-source blogabe/xplanet/xplanet`. Homebrew reuses the previous installation options, including the legacy `--without-jpeg` opt-out. See the [Homebrew command reference](https://docs.brew.sh/Manpage) for details.

## Source and build details

Homebrew revision 3 (`1.3.1.225_3`) uses the checksum-pinned
[`xplanet-1.3.1.225-source.2.tar.gz` release asset](https://github.com/blogabe/homebrew-xplanet/releases/tag/xplanet-1.3.1.225-source.2).
Download that named asset for a direct build, not GitHub’s automatic “Source code”
archives, which contain the tap. See `BUILDING.txt` and `SOURCE-CHANGES.txt` in
the archive. The preceding archive remains available under its original tag.

The snapshot is based on upstream SVN r225 and retains the FreeType, Aqua and
platform-helper fixes. Alpha-5 no longer needs a formula patch; check support
with `xplanet -version`. On Finder Automation denial, the renderer retains its
image and points to the [recovery guide](https://github.com/blogabe/Xplanet/blob/main/docs/management.md#finder-automation-permission).
The archive retains the upstream authorship and license notices. Historical
[upstream backports](legacy/patches/xplanet-1.3.1/) and the
[original Aqua patch](patches/) remain available for reference.

## Legacy archive

Historical xplanetFX, Python 2/GTK, and custom ImageMagick formulae and supporting patches are retained for reference in [legacy/](legacy/README.md).