# homebrew-xplanet

Xplanet Homebrew formula hosted on a personal tap to retain custom build options. See [no more options in formula](https://github.com/Homebrew/homebrew-core/issues/31510) and [no more options for default dependencies](https://github.com/Homebrew/brew/pull/2482) for background.

The formula builds the complete upstream SVN r225 source snapshot as **1.3.1.225**, a local version designation rather than an official upstream release. The checksum-pinned [release asset](https://github.com/blogabe/homebrew-xplanet/releases/tag/xplanet-1.3.1.225) includes all changes since 1.3.1 plus the maintenance fixes below. Installing this formula does not need Subversion or Autotools regeneration.

The archive already contains the FreeType pkg-config prefix correction, Aqua handoff fix, local version string, and refreshed `config.guess`/`config.sub`. The formula runs the included `prepare-build.sh` to normalize generated-file timestamps; it does not apply those fixes a second time. The packaging revision is 2 (`1.3.1.225_2`); the binary reports `1.3.1.225`. The formula applies an Alpha-5 TLE patch on top of the unchanged archive. It lets the renderer recognize catalog IDs 100000–339999 as well as the existing numeric IDs. Check for `TLE catalog IDs: Alpha-5` in `xplanet -version`.

Download the named `xplanet-1.3.1.225.tar.gz` release asset, not GitHub's automatically generated “Source code” archives, which contain this tap rather than Xplanet. The archive preserves upstream AUTHORS, COPYING and source notices. Xplanet remains the work of Hari Nair and contributors; this tap provides a maintained snapshot, not an official upstream release or a transfer of upstream maintainership.

Historical upstream backports are retained in [legacy/patches/xplanet-1.3.1/](legacy/patches/xplanet-1.3.1/). The [Aqua patch](patches/) remains available for reference and review; its changes are already incorporated in the source archive.

The tap also includes a macOS wallpaper handoff fix. Xplanet waits for Finder's reply before removing a temporary desktop image, allowing time for first-use automation authorization. A failed or timed-out handoff reports the macOS error and retains the image in the temporary directory; repeated failures can leave multiple images there. Successful updates retain the usual temporary-file cleanup, and `-save_desktop_file` still keeps images when requested.

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

## Legacy archive

Historical xplanetFX, Python 2/GTK, and custom ImageMagick formulae and supporting patches are retained for reference in [legacy/](legacy/README.md).