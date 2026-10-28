# Legacy archive

These formulae and patches are retained for historical reference. They are not maintained or expected to install with current Homebrew.

- `xplanetfx.rb`: the unmaintained xplanetFX frontend, whose optional GUI depends on `pygtk` → `pygobject` → `python@2`.
- `pygtk.rb`, `pygobject.rb`, and `python@2.rb`: the historical Python 2/GTK dependency chain.
- `imagemagick.rb`: the historical custom ImageMagick formula. xplanetFX also declares an ImageMagick dependency.
- `patches/`: the two patches used by the archived PyGTK and PyGObject formulae.

This root-level archive sits outside Homebrew's normal formula discovery. The active Xplanet formula and its five repository-hosted patches remain at the repository root and in `../patches/`, respectively.

The archived PyGTK and PyGObject patch URLs are pinned to the verified pre-move commit [`7fffa6d`](https://github.com/blogabe/homebrew-xplanet/tree/7fffa6d370648445d9b4e619cda3f02f45852145/patches), preserving their original SHA-256 checksums. Historical dependency declarations and build instructions inside the formulae are otherwise unchanged; moving them here does not restore the obsolete dependency chain.
