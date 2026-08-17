# Lplanner

A mixed-gas decompression planner for macOS, iPhone, iPad, and Android — one
decompression engine shared by all of them.

    Bühlmann ZHL-16B / ZHL-16C with gradient factors
    Thalmann EL-DCM (VVAL-18), the U.S. Navy exponential-linear model
    Open circuit, surface supplied, and closed circuit with setpoint switching
    Trimix, deco gas selection by Max PO2 and Max END, Pyle deep stops
    CNS, OTU, EAD, END, gas density, gas consumption, time to fly
    Tissue loading carried between dives, aging in real time.

---

## Read this before you use it

**This generated dive schedule could indirectly kill you and probably has bugs.
The author does not warrant that it accurately reflects A. A. Bühlmann's
algorithm or the VVAL-18 algorithm. This dive schedule is experimental, and you
use it at your own risk.**

Cross-check anything you intend to dive against tables or a planner you already
trust. The same disclaimer appears in the app's Info panel.

---

## Get it

**macOS** — free, from the [Releases](../../releases) page.
Installation is not a plain double-click; follow
**[INSTALL-macOS.md](INSTALL-macOS.md)**.

**Android** — on Google Play.

**iPhone and iPad** — not currently distributed.

## What changed

**[CHANGELOG.md](CHANGELOG.md)** — engine 1.12.0 changes the VVAL-79 schedules. Closed
circuit is materially longer, trimix is shorter and now warns. Bühlmann is
unchanged. Worth reading before you dive a plan from this version.

## Manual

**[MANUAL.md](MANUAL.md)** covers entering a dive, reading the schedule, closed
circuit, deco gases, surface intervals and residual gas, and every Config
setting. The same text is in the app under **Info**.

## Reporting a problem

Open an [issue](../../issues) and quote the version line at the bottom of the
app's Info panel — it reads like `1.5.0 (2) · engine 1.12.0`. The first part
identifies the build, the last identifies the decompression engine, and a report
is hard to act on without both.

If a schedule looks wrong, send the dive that produced it: depth, time, mix, and
any Config settings away from their defaults, so it can be reproduced exactly.

## Verification

The closed-circuit inspired-gas calculation has been compared line by line
against [Subsurface](https://github.com/subsurface/subsurface) and
[Abysner](https://github.com/NeoTech-Software/Abysner) — all three compute the
same result. VVAL-18 no-stop limits are checked against the U.S. Navy Diving
Manual Revision 7. See the *Models* section of the manual.

---

2026 Carlos Lander. See [NOTICE](NOTICE).
