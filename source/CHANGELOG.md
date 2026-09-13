# OpenJazz Pocket Analogizer 240p v1.0

## Analog CRT output

- Added live OpenJazz framebuffer output through Analogizer.
- Added stable fixed-262-line progressive 240p raster.
- Removed the earlier 262/263-line alternating-frame wobble.
- Moved frame-duration compensation into vertical blanking so all visible
  scanlines have identical horizontal timing.
- Eliminated visible text/geometry scanline squiggle.
- Preserved V13's V10 fast-path placement after hardware testing showed it was
  visibly sharper and more stable than an equivalent refactored path.
- Restored functional Analogizer Enable and Video Out menu controls.

## OpenJazz presentation

- Added DOS 4:3 FILL.
- Added 320x200 CENTER.
- Added POCKET 320x288.
- Changed fresh-install default to 320x200 CENTER.
- Added true black padding for centered/padded modes.

## Pocket controls

- Pocket A selects menu items.
- Pocket B acts as Back in generic OpenJazz menus without changing B's normal
  gameplay function.

## Known / unverified

- OpenJazz's native SAVE.* implementation is present, but persistence across a
  Pocket power cycle has not yet been formally validated for this release.