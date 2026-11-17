# Legacy archive

These formulae and patches are retained for historical reference. They are not maintained or expected to install with current Homebrew.

- `xplanetfx.rb`: the unmaintained xplanetFX frontend, whose optional GUI depends on `pygtk` → `pygobject` → `python@2`.
- `pygtk.rb`, `pygobject.rb`, and `python@2.rb`: the historical Python 2/GTK dependency chain.
- `imagemagick.rb`: the historical custom ImageMagick formula. xplanetFX also declares an ImageMagick dependency.
- `patches/`: the two patches used by the archived PyGTK and PyGObject formulae.
- `patches/xplanet-1.3.1/`: the five former Xplanet upstream backports (r214 and r222–r225), now included in the complete SVN r225 source and no longer applied by the active formula.

This root-level archive sits outside Homebrew's normal formula discovery. The active Xplanet formula remains at the repository root. Its Aqua handoff patch remains in `../patches/`; it is not part of this archive.

The archived PyGTK and PyGObject patch URLs are pinned to the verified pre-move commit [`7fffa6d`](https://github.com/blogabe/homebrew-xplanet/tree/7fffa6d370648445d9b4e619cda3f02f45852145/patches), preserving their original SHA-256 checksums. Historical dependency declarations and build instructions inside the formulae are otherwise unchanged; moving them here does not restore the obsolete dependency chain.

Older Xplanet formula revisions use commit-pinned patch URLs, so moving the five backports here does not change their historical downloads or checksums. The r214 patch was downloaded from a pinned Homebrew core commit; its archived file is a reference copy. The r222–r225 URLs remain available at the original paths in commit [`c12f559`](https://github.com/blogabe/homebrew-xplanet/tree/c12f559b97ba8da69db029354739adc772b1bd9d/patches).
