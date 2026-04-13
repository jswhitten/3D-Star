# 3DSTAR

**Version 0.01 — January 1994**

A QBasic/QuickBASIC program I wrote in high school that lets you fly through our
stellar neighborhood and watch the sky from anywhere within a few thousand
light-years of Sol. Stars are stored in true galactic (X, Y, Z) coordinates,
so as you move their positions, apparent magnitudes, and constellations all
shift correctly. This is the predecessor to my HYGMap web application.

## Files

| File          | Purpose                                                            |
|---------------|--------------------------------------------------------------------|
| `3DSTAR.BAS`  | Main program — renders the sky and handles flight controls         |
| `3DDATA.BAS`  | Data-entry tool; converts RA/Dec + distance into galactic X, Y, Z  |
| `3DSTAR.DAT`  | Star database (64 stars: brightest, nearest, Big Dipper, Orion…)   |
| `3DSTAR.GIF`  | Reference image explaining the on-screen coordinate system         |
| `3DSTAR.TXT`  | Original documentation and development history                     |
| `3D.BAT`      | One-line launcher: `qbasic /run 3dstar`                            |

## Running it

Needs DOS (or DOSBox) with QBasic available on the path:

```
3D
```

or directly:

```
qbasic /run 3dstar
```

At the prompts, press **Enter** seven times to accept the defaults (origin
near Sol, heading toward the galactic core, speed 0.05 ly/jump,
magnification 1).

## Controls

| Key           | Action                                                 |
|---------------|--------------------------------------------------------|
| `8` / `2`     | Pitch up / down 5°                                     |
| `4` / `6`     | Yaw left / right 5°                                    |
| `A` / `S`     | Accelerate / slow down (doubles or halves speed)       |
| `Z` / `X`     | Zoom in / out (doubles or halves magnification)        |
| `M`           | Star map (partial — WIP in v0.01)                      |

Keys are uppercase only, so turn Caps Lock on. Use the numeric keypad with
Num Lock on for the direction keys.

## How it works

- **3DDATA.BAS** takes a star's right ascension, declination, distance, and
  absolute magnitude, converts to equatorial rectangular coordinates, then
  rotates into galactic coordinates using the three Euler angles
  (α = 62.53°, β = 78.56°, γ = 33.02°) that align the equatorial frame with
  the galactic frame. The result is appended to `3DSTAR.DAT`.

- **3DSTAR.BAS** loads the database, then on each frame:
  1. Subtracts the observer's position from each star.
  2. Rotates the result by the current galactic longitude/latitude heading.
  3. Converts the rotated vector to spherical (θ, φ) and projects it to the
     640×480 VGA screen.
  4. Computes apparent magnitude from the new distance
     (`m = M − 5 + 5·log₁₀(d / 3.26 pc)`) and picks a color from the
     spectral class (O/B/A/F/G/K/M).
  5. Erases the previous frame's circle and draws the new one. Up to four
     past positions are kept (`StarHop` cycles 1–4) so the erase step can
     find where the star used to be.

## Star catalog

64 stars: the 25 brightest (as seen from Earth), the 26 nearest (including
Sol), the seven stars of the Big Dipper, and the brighter stars of Orion.
Stars of unknown absolute magnitude are given `M = 32000` as a sentinel so
they stay invisible unless you fly very close.

## Known limitations (per the 1994 notes)

- Pure BASIC interpreter — on a 386SX/16 each frame took ~6 seconds with
  all 64 stars loaded.
- Star map (`M` key) was half-implemented; hitting it does "weird things".
- Planned v0.02 would finish the star map; v1.0 would ship compiled as
  shareware under QuickBASIC.

