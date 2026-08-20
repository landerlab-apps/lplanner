# Lplanner

A mixed-gas decompression planner for macOS, iPhone, iPad, and Android — one
decompression engine shared by all of them.

    Bühlmann ZHL-16B / ZHL-16C with gradient factors
    Thalmann EL-DCM (VVAL-18), the U.S. Navy exponential-linear model
    VPM-B (Yount/Hoffman varying permeability, Baker's implementation)
    Open circuit, surface supplied, and closed circuit with setpoint switching
    Trimix, deco gas selection by Max PO2 and Max END, Pyle deep stops
    CNS, OTU, EAD, END, gas density, gas consumption, time to fly
    Tissue loading carried between dives, aging in real time.

---

## Read this before you use it

**This generated dive schedule could indirectly kill you and probably has bugs.
The author does not warrant that it accurately reflects A. A. Bühlmann's
algorithm, the VVAL-18 algorithm, or the VPM-B algorithm. This dive schedule is
experimental, and you use it at your own risk.**

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

**[CHANGELOG.md](CHANGELOG.md)** — engine 1.19.0 added **VPM-B** as a third
model, validated against Erik Baker's own published output, and corrected the
trimix warning on VVAL-18, which was saying the opposite of what the model now
does. Engine 1.20.0 fixes **Deco zone start**, which was never computed at all
— it reported the first stop under another name, so the two always matched.
Android 1.6.0 brings VPM-B to the phone, adds **Print**, and moves the plan
warnings into Info. No schedule changed on any model in 1.20.0.

Worth reading before you dive a plan from this version.

## Manual

**[MANUAL.md](MANUAL.md)** covers entering a dive, reading the schedule, closed
circuit, deco gases, surface intervals and residual gas, and every Config
setting. The same text is in the app under **Info**.

## Privacy

**[PRIVACY.md](PRIVACY.md)** — Lplanner declares no Android permissions at all,
including no internet permission, so it cannot transmit anything. Your dive,
your settings and your saved plans stay in the app's private storage on the
device.

## Reporting a problem

Open an [issue](../../issues) and quote the version line at the bottom of the
app's Info panel — it reads like `1.6.0 (1) · engine 1.20.0`. The first part
identifies the build, the last identifies the decompression engine, and a report
is hard to act on without both.

If a schedule looks wrong, send the dive that produced it: depth, time, mix, and
any Config settings away from their defaults, so it can be reproduced exactly.

## Verification

The closed-circuit inspired-gas calculation has been compared line by line
against [Subsurface](https://github.com/subsurface/subsurface) and
[Abysner](https://github.com/NeoTech-Software/Abysner) — all three compute the
same result. VVAL-18 no-stop limits are checked against the U.S. Navy Diving
Manual Revision 7.

VPM-B is validated against Erik Baker's own reference output: on his 80 msw
trimix benchmark it reproduces the published schedule stop for stop — eighteen
stops, every stop time, every run time. Two deliberate differences are
documented in the manual rather than hidden. See the *Models* section.

---

2026 Carlos Lander. See [NOTICE](NOTICE).
