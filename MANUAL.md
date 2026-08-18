# Lplanner — Manual

A mixed-gas decompression planner for macOS and Android.

---

## Before anything else

**This generated dive schedule could indirectly kill you and probably has bugs.
The author does not warrant that it accurately reflects A. A. Bühlmann's
algorithm, the VVAL-18 algorithm, or the VPM-B algorithm. This dive schedule is
experimental, and you use it at your own risk.**

Decompression is not a solved problem. No model predicts it reliably for every
diver on every day. Cross-check anything you intend to dive against tables or a
planner you already trust.

**The intended use is educational**
---

## Entering a dive

Type **Depth**, **Time** and **O2 %** — plus **He %** for trimix — then press
**Add**. Repeat for each level. Time is the time spent *at* that level.

- Tap a level to edit it
- The arrows reorder levels
- **×** removes one
- The checkbox leaves a level out of the calculation without deleting it

Press **Calculate**. On a phone, the result appears on the **Plan** tab.

### Closed circuit

Set the circuit to **CCR** — the first chip on a phone, the Open/Closed control
on a Mac or iPad. Two more fields appear beside the mix:

- **Set** — the setpoint held at that level, e.g. `1.20`
- **Sld** — Scamahorn slide, entered as a range such as `1.2-1.6`

The mix you enter on closed circuit is the **diluent**. It does not set your
inspired PO2 — the setpoint does — but its inert content still drives your
tissue loading, and you can see its effect in the EAD column.

You can do any combination of CCR–OC or OC–CCR, as it's done in the Navy.
Example: CCR SP0.7 from 0-40 feet/ 0-12 meters and SW to OC after; same on return. 

### Deco gases

Turn **Deco gases** on and list the mixes, e.g. `50, 100`. The planner picks the
richest one allowed by **Max PO2** and **Max END** at each stop. The new mix
appears in the gas column of the stop you change on to it at; where the switch
depth is not a stop, a **GasSw** row marks it instead. Switch depths are
snapped to whole stop increments, so a gas whose limit falls at 21.6 m switches
at 21 m.

A closed-circuit dive may leave the loop for an open-circuit deco mix and later
return to a deco setpoint. This is intended — US Navy practice permits shifting
off the rig for decompression and back again.

---

## Reading the plan

```
        depth   stop    run   gas       PO2   EAD
 ------------------------------------------------------
 ↓        45m    3:00      3   TMX 21/25
 —        45m   20:00     23             1.15   28m
 DStop    27m    2:09     26             0.77   15m
 ↑        21m    0:40     26
 GasSw    21m    0:00     26   EAN50     1.54   10m
 —         3m   12:00     46             0.65    0m
 ↑         0m    1:00     47
```

| Column | Meaning |
|---|---|
| ↓ ↑ | Descent or ascent leg |
| — | A stop, or time at a level |
| **DStop** | A deep stop |
| **GasSw** | Where the breathing source changes |
| depth | Depth of the stop or level |
| stop | Time spent there, mm:ss |
| run | Total runtime on leaving, minutes |
| gas | Mix, or `SP1.20` for a closed-circuit setpoint |
| PO2 | Inspired oxygen partial pressure |
| EAD | Equivalent air depth for the inert loading |

Below the table: the depth at which the deco zone begins, bottom gas density,
total deco time, total run time, CNS and OTU totals, gas consumption per mix,
and time to fly.

**Deco zone start** is the depth at which the leading compartment's inert gas
tension first reaches ambient pressure on the way up. Shallower than it you are
supersaturated and a bubble can grow; deeper than it you are not. Your first
stop is always above this depth — if it ever reads equal to the first stop, the
figure is wrong and worth reporting.

It is not the depth at which off-gassing begins. That happens almost as soon as
you leave the bottom, because the inspired inert pressure falls with you, and
it is nearly the bottom itself.

Short ascents between stops with no gas change are folded into the following
stop's time, so the schedule reads the way you would dive it. VPM-B is the
exception: it absorbs the travel leg itself by rounding the run time up on
arrival, so its ascents get their own row.

### Full screen

Press **Full screen** above the schedule to read it with nothing else on the
display. The type size is computed to fit the width exactly, so turning the
phone sideways makes the text bigger rather than merely wider.

- **A− / A+** change the size, **Fit** returns to the computed one
- **Sun** goes to full brightness for reading in sunlight
- The screen is held awake the whole time it is open
- Tap once to hide the controls; Back closes it

---

## Surface intervals and residual gas

After a dive, press **Next dive** to carry your inert gas loading forward. The
loading is kept when the app is closed and ages with real time.

While gas is carried, you must state a surface interval — **48 hr**, **24 hr**,
or an actual time — before **Calculate** will work. This is deliberate: guessing
it from the clock would let you get a schedule without confronting the fact that
a previous dive is still loaded.

Use your exact surface interval, or a shorter one if you are unsure how long you
will wait.

**Clear** declares you clean again.

> **Next dive** means "assume I dived this schedule". It carries the *plan's*
> tissue loading, not your actual dive's. If you deviated from the plan, the
> baseline is optimistic.

**Log** is a different thing entirely. Every successful Calculate is recorded
there automatically with the settings that produced it. It is history only —
nothing in the log affects a future calculation.

---

## Config

### Units
Depths sets the units for depth, altitude, stop distance and END. RMVs sets the
units for breathing-rate and gas-consumption figures — the two can differ.

### Environment
Fresh or salt water changes the depth-to-pressure conversion. O2 Narcotic
controls whether oxygen counts as narcotic when calculating equivalent narcotic
depths (ENDs).

### Model
Three models ship, and the picker chooses between them.

**ZHL16-C** is the Bühlmann set used here, optionally with gradient factors.

**VVAL-18** is the U.S. Navy Thalmann EL-DCM (exponential uptake, linear
elimination).

**VPM-B** is the Yount/Hoffman varying permeability model in Erik Baker's
implementation. It limits the volume of gas released from bubble nuclei rather
than the tension dissolved in tissue, which is why it begins decompression much
deeper — most visibly on helium mixes.

Gradient factors and Conservatism apply to **ZHL16-C only**. VVAL-18 has
neither. VPM-B has its own conservatism ladder, described below, and ignores the
Conservatism slider. With gradient factors enabled, Pyle deep stops are disabled
— GF Low provides the deep-stop function — and Conservatism is ignored.

### VPM-B
Shown only when VPM-B is the selected model.

**Conservatism** runs 0 to 4 and scales both critical radii. A larger nucleus is
excited by a smaller gradient, so higher levels give more decompression. Level 0
is Baker's nominal VPM-B and is the setting that reproduces his published
reference schedule.

**Radius N2** and **Radius He** are the initial critical radii in microns. These
are the parameter that actually differs between implementations — Baker ships
0.6 and 0.5, Subsurface 0.55 and 0.45. Changing them takes you outside the
validated envelope. Leave them alone unless you are deliberately comparing
against another planner.

### Alternative gradient factors
A second GF pair, used instead of the main pair whenever **altGF** is turned on
from the main screen. Any values are accepted, low and high independently, and
they need not bracket the main pair. 100/100 gives the pure Bühlmann ZHL-16C
ceiling; values above 100 go beyond it; a low GF Low with a high GF High deepens
the first stop while keeping the shallow stops short.

### NDL calculation
Which gradient factor decides whether a direct, no-stop ascent to the surface is
still allowed. GF High is the standard behavior for ZHL16-C. GF Low is stricter
and ends the no-decompression phase earlier.

### Conditions
Altitude of the dive site (0 for sea level; be extra conservative if you are
still off-gassing from travel to altitude). **Conservatism** applies only when
gradient factors are switched off. It (0–50 %) preloads the tissue compartments
with additional inert gas — nitrogen, and helium in proportion when the profile
uses trimix — weighted from the fast compartments (none) to the slow ones (the
full percentage), as if a previous dive had been made. Zero is the clean-diver
profile.

### Stop depths
**Stop distance** is the interval between decompression stops — 3 m is the
convention; some rebreather divers prefer 6 m. **Last stop** is the depth of the
final stop; some prefer pulling the 10 ft / 3 m stop deeper. Both apply to every
schedule, whichever model, gradient factors, or deep stops are in use.

### Deep stops
Pyle deep stops insert short stops between the bottom and the first normal stop
(mean-depth rule, re-run iteratively) to reduce microbubble formation and
post-dive fatigue. Pyle stop time is the minutes spent at each generated stop
(1–5). Not shown when gradient factors are enabled: GF Low takes over the
deep-stop role.

### Ascent behavior (experimental)
**Extra slow** delays the ascent to the next stop while the off-gassing gradient
of any compartment — tissue inert tension minus ambient pressure, i.e.
supersaturation — exceeds 1.25 bar. It only ever adds time at the deeper depth,
so the schedule stays below the gradient factor regardless of the rule. Two
limits keep it practical: it never applies to the final ascent to the surface,
and it adds at most 5 minutes per stop. Time held is counted in the total
decompression time.

### Descent and ascent rates
One range per line: `depth1-depth2, rate`. Descent lists shallowest first,
ascent lists deepest first. Leave no gaps. Slow shallow ascent rates are
credited to the decompression and can shorten stops or remove them entirely.

### Deco setpoint (CCR) and slide rate
Setpoint changes by depth range during CCR deco, one per line, e.g. `80-30, 1.4`
— a setpoint of 0 switches to open circuit for that range. Only active on closed
circuit. **Slide rate** is the PO2 burned off per minute during a Scamahorn
Slide: enter a bottom setpoint like `1.2-1.6` to ride the descent PO2 spike down
to the setpoint for a decompression advantage.

### Extended stops on a deco mix switch
Extra minutes held where the planner switches to a deco mix, on top of whatever
the model requires. Common practice: settle on the new gas, confirm the analysis
and the PO2, and let the switch do some work for you. Chosen by the depth of the
switch, in two bands. Switches shallower than 7 m / 23 ft are not extended — the
final stop is already long. The extra time off-gasses you, so it does not simply
add to the total: the stops above it usually shorten.

### Deco gas limits
The planner auto-selects the deco gas with the highest PO2 that stays within
**Max PO2** and **Max END**. Set Max PO2 to 1.6 if you want 100% O2 at the
20 ft / 6 m stop; tune it down to lower CNS exposure at the cost of longer deco.

### RMV values
Respiratory Minute Volume for gas-consumption planning, in the RMV units above.
Deco is usually lower than Bottom, since you are more at rest hanging on the
line. If you don't know your RMV, measure it.

---

## The models

**Bühlmann ZHL-16B and ZHL-16C** — sixteen tissue compartments, with optional
gradient factors after Baker. Inert gas loading is computed against alveolar
pressure, with water vapour taken as 0.0627 bar (Bühlmann's value, Rq = 1.0).

**VVAL-18 (79) / Thalmann EL-DCM** — the U.S. Navy exponential-linear model:
exponential uptake, linear elimination. Gradient factors and conservatism do not
apply to it, by design. The no-stop limits are checked against the U.S. Navy
Diving Manual Revision 7.

*On trimix, use something else.* VVAL-18 is a nitrogen model. The U.S. Navy
publishes no helium parameters for it, and the helium handling here is this
project's own extrapolation with nothing to validate it against. It has neither
gradient factors nor a bubble term, so nothing pulls its first stop deep on a
helium mix: on 80 m for 27 minutes with 15/45 it first stops at 33 m where VPM-B
stops at 51 m, while running *longer* overall. A long schedule weighted to the
shallow stops is the combination bubble models exist to avoid. Every trimix plan
on VVAL-18 says so.

**VPM-B** — the varying permeability model of Yount and Hoffman, in the
implementation Erik Baker released to the diving community. Where Bühlmann and
Thalmann limit dissolved gas tension, VPM-B tracks bubble nuclei: the ascent is
constrained so that the volume of gas released from them stays under a critical
limit. Nuclei are crushed on descent, regenerate slowly, and the gradient each
one tolerates shrinks as the diver ascends and the bubble expands under Boyle's
law.

The consequence a diver notices is where decompression starts. On 80 m for 27
minutes with 15/45, VPM-B's first stop is 51 m against ZHL16-C's 30 m.

This implementation is validated against Baker's own published output: on his
80 msw benchmark it reproduces the schedule stop for stop. Two details differ
deliberately and are documented rather than hidden. The critical volume loop is
iterated to convergence, as Baker's written rule specifies, which gives about
two minutes less than his compiled 2003 program on that dive. And the first stop
is placed by this engine's ascent rule rather than Baker's, which can put it one
stop increment shallower. Cross-check against a planner you trust before diving
it.

**Closed circuit.** With the setpoint held, the inspired inert pressure is the
alveolar pressure less the setpoint, divided between nitrogen and helium in the
proportion the diluent carries them. This has been checked line by line against
[Subsurface](https://github.com/subsurface/subsurface) and
[Abysner](https://github.com/NeoTech-Software/Abysner); all three compute the
same result.

---

## Gas density

Every plan reports the density of the bottom gas at the deepest point, and warns
when it is high.

Density is computed as ambient pressure in atmospheres times the mixture's molar
mass divided by 22.414 — the ideal gas at 0 °C referenced to one atmosphere,
which is the convention the published limits were derived under. It reproduces
their anchor points: air at 30 m comes out 5.1 g/L, and at 39 m 6.3 g/L.

Following **Anthony & Mitchell**:

- **Under 5.2 g/L** — ideal. No advisory.
- **5.2 to 6.2 g/L** — above ideal, below the limit. The plan says so.
- **Over 6.2 g/L** — the plan warns. Work of breathing and carbon dioxide
  retention rise steeply beyond this, and CO2 retention is itself a risk factor
  for both oxygen toxicity and inert gas narcosis.

On air that puts the ideal limit at about 30 m and the hard limit near 39 m,
which is where the usual advice comes from. It bites on trimix too: **18/45 at
70 m is 6.4 g/L, over the limit** — 18/50 brings it to 5.9 and 15/55 to 5.5.
Helium is not only there to keep you clear-headed.

Other planners may report a lower figure for the same gas by computing at room
or body temperature rather than at 0 °C. The number here is the one the 5.2 and
6.2 limits were written against.

---

## Sharing and printing

Both become available once a plan has been calculated. Print produces the plan
in a fixed-width font on light paper regardless of whether the app is in dark
mode.

---

## Reporting a problem

Open an issue and quote the version line at the bottom of the app's **Info**
panel. It reads like `1.1 (7) · engine 1.10.0` — the first part identifies the
build, the last identifies the decompression engine. A report is hard to act on
without both.

If a schedule looks wrong, the most useful thing to send is the dive that
produced it — depth, time, mix, and any Config settings away from their
defaults — so it can be reproduced exactly.

Any questions? Email me: carlos.lander@etik.com
