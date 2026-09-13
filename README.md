# Lplanner

A mixed-gas decompression planner for macOS, iPhone, iPad, and Android — one
decompression engine shared by all of them.

    Bühlmann ZHL-16C with gradient factors
    Thalmann EL-DCM (VVAL-79), the U.S. Navy air model (air/nitrox only)
    VPM-B (Yount/Hoffman varying permeability, Baker's implementation)
    Open circuit, surface supplied, and closed circuit with setpoint switching
    Trimix, deco gas selection by Max PO2 and Max END, Pyle deep stops
    Air breaks, Navy dead time or modelled; travel gas off a hypoxic back gas
    CNS, OTU, EAD, END, gas density, gas consumption, time to fly
    Tissue loading carried between dives, aging in real time.

---

## Read this before you use it

**This generated dive schedule could indirectly kill you and probably has bugs.
The author does not warrant that it accurately reflects A. A. Bühlmann's
algorithm, the VVAL-79 algorithm, or the VPM-B algorithm. This dive schedule is
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
trimix warning on VVAL-18. Engine 1.20.0 fixed **Deco zone start**, which was
never computed at all — it reported the first stop under another name.

**Engine 1.34.0 renames VVAL-18 to VVAL-79 and restricts it to air, nitrox
and oxygen.** It now carries the published nine-compartment parameter set and
reproduces the Navy's own no-decompression table to within a minute; a dive
carrying helium is refused rather than computed against numbers the Navy has
never published. If you have planned trimix on VVAL-18, replan it on VPM-B or
on ZHL16-C with gradient factors.

**Engine 1.26.0 to 1.35.0 add air breaks and travel gas.** A break is planned
when you are on oxygen at the last stop depth or shallower, or when CNS reaches
the warning threshold, in two treatments: Navy dead time, or modelled on the
break gas. Travel gas starts a descent on a hypoxic back gas with the leanest
mix you carry that is breathable at the surface.

**Engine 1.21.0 fixes altitude diving, and if you dive at altitude you should
read it before trusting an older plan.** The engine had assumed every altitude
diver was already equilibrated to the mountain; a diver who drove up that
morning was getting less than half the decompression he needed. Config now
asks, and the default is the conservative answer. Verified against the U.S.
Navy Diving Manual rev 7, chapter 9.

Sea-level ZHL-16C and VPM-B schedules are unchanged throughout.

## Manual

**[MANUAL.md](MANUAL.md)** covers entering a dive, reading the schedule, closed
circuit, deco gases, surface intervals and residual gas, and every Config
setting. The same text is in the app under **Help ▸ Lplanner Manual** on macOS
and under **Info** on iOS and Android.

## Privacy

**[PRIVACY.md](PRIVACY.md)** — Lplanner declares no Android permissions at all,
including no internet permission, so it cannot transmit anything. Your dive,
your settings and your saved plans stay in the app's private storage on the
device.

## Reporting a problem

Open an [issue](../../issues) and quote the version line at the bottom of the
app's Info panel — it reads like `1.6.0 (1) · engine 1.21.0`. The first part
identifies the build, the last identifies the decompression engine, and a report
is hard to act on without both.

If a schedule looks wrong, send the dive that produced it: depth, time, mix, and
any Config settings away from their defaults, so it can be reproduced exactly.

## Verification

The closed-circuit inspired-gas calculation has been compared line by line
against [Subsurface](https://github.com/subsurface/subsurface) and
[Abysner](https://github.com/NeoTech-Software/Abysner) — all three compute the
same result. VVAL-79 no-stop limits are checked against *U.S. Navy Diving
Manual Revision 7, Table 9-7*, which they reproduce to within one minute at
sixteen of seventeen depths. Schedules have also been compared against MultiDeco
and TechDeco on matched settings.

VPM-B is validated against Erik Baker's own reference output: on his 80 msw
trimix benchmark it reproduces the published schedule stop for stop — eighteen
stops, every stop time, every run time. Two deliberate differences are
documented in the manual rather than hidden. See the *Models* section.

## Supporting the project

Lplanner is free software with no adverts, no tracking and no subscription. The
macOS and F-Droid builds show a PayPal address in the Info panel, with a
payment link when one is configured; it is a link out to PayPal and nothing
more — the app requests no network permission and sends nothing. The Google
Play build does not show it, because Play's Payments policy does not permit
external payment links of this kind for a non-charity, and neither does the iOS
build, where App Review treats them as circumventing in-app purchase.

Contributions are voluntary and change nothing about the software: it is
GPL-3.0, every feature is available to everyone, and it will stay that way.

---

2026 Carlos Lander. See [NOTICE](NOTICE).
