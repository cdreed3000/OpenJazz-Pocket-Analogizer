# OpenJazz Pocket Analogizer 240p v1.0

A community release of OpenJazz Pocket with a hardware-tested Analogizer CRT
output path.

## What is included

- Stable progressive 15-kHz CRT output
- V13 V10-fast-path implementation for the tested sharp/shimmer-free picture
- Analogizer Enable menu control
- Analogizer Video Out menu control
- 320x200 CENTER as the fresh-install default
- DOS 4:3 FILL and POCKET 320x288 as alternate presentation modes
- Proper black padding in centered mode
- Pocket A = Select / B = Back in OpenJazz generic menus
- Pocket/Dock display paths retained

## Default presentation

Fresh installs start in:

**320x200 CENTER**

Existing users who already have an OpenJazz configuration file keep their saved
presentation choice.

Presentation modes are found in:

SETUP OPTIONS -> VIDEO

## Installation

Extract the contents of:

OpenJazz-Pocket-Analogizer-240p-v1.0-pocket-install.zip

to the root of the Analogue Pocket SD card and merge/overwrite the existing
Assets, Cores and Platforms folders as needed.

## Game data

Jazz Jackrabbit game data is NOT included.

Supply your own legally obtained Jazz Jackrabbit data using the normal
OpenJazz Pocket method.

## Saving

The OpenJazz engine contains native Jazz 1 SAVE.* support. Save persistence on
this specific Pocket release has not yet been formally hardware-validated, so
it is considered **supported by the engine but unverified on this release**.

## Release philosophy

The final FPGA package intentionally preserves the exact V13/V10 fast-path
structure that produced the best tested analog image. Earlier logically
equivalent refactors caused visible softness/shimmer on real CRT hardware.

This is an independent community modification and is not an official release
from Analogue, Negenii, OpenJazz, openfpgaOS, or the Analogizer project.