# Changelog

Lplanner ships one decompression engine shared by every platform. **The engine
version is the one printed at the top of every plan and shown in the Info
panel** — it is what determines the schedule, so it is the number to quote in a
bug report. The app version tracks the interface around it.

| | version |
|---|---|
| **Decompression engine** | **1.18.0** |
| macOS / iPhone / iPad app | 1.6.0 |
| Android app | 1.5.1 |

---

## Engine 1.18.0 — macOS / iPhone / iPad 1.6.0

**ZHL-16C and VVAL-18 schedules are unchanged from engine 1.12.0.** Verified by
building both versions and diffing their output across air, nitrox and trimix
profiles from 18 to 90 metres. Everything below is either new or applies to
VPM-B alone.

### VPM-B

The Varying Permeability Model of Yount and Hoffman, in the implementation Erik
Baker released to the diving community, is now a third model alongside ZHL-16C
and VVAL-18.

Where Bühlmann and Thalmann limit the gas tension dissolved in tissue, VPM-B
tracks bubble nuclei and constrains the ascent so the volume of gas released
from them stays under a critical limit. Nuclei are crushed on descent,
regenerate slowly afterwards, and the gradient each one tolerates shrinks as the
diver ascends and the bubble expands under Boyle's law.

What a diver notices is where decompression starts. On 80 m for 27 minutes with
15/45, VPM-B holds its first stop at 51 m against ZHL-16C's 30 m.

**Validation.** On Baker's own 80 msw benchmark this implementation reproduces
his published schedule stop for stop — eighteen stops, every stop time, every
run time, and the same start of the decompression zone. Two differences are
deliberate and documented rather than hidden:

- The critical volume loop is iterated to convergence, which is what Baker's
  written rule specifies. His compiled 2003 program stops one iteration earlier.
  On the benchmark that is a two-minute difference.
- The first stop is placed by this engine's ascent rule rather than Baker's,
  which can put it one stop increment shallower.

**Settings.** VPM-B inherits everything else you already set — stop grid, last
stop depth, Pyle stops, extra-slow ascent, extended stops on a gas switch, deco
gas selection by Max PO2 and Max END, CCR setpoints, CNS and OTU, and tissue
loading carried between dives. It adds:

- **Conservatism 0–4**, which scales both critical radii. Level 0 is Baker's
  nominal VPM-B.
- **Radius N2 / Radius He**, the initial critical radii in microns, 0.6 and 0.5
  by default. These are what actually differ between implementations. Changing
  them leaves the validated envelope.

Gradient factors and the Conservatism percentage apply to ZHL-16C only; both go
inert when VPM-B is selected, and VPM-B uses its own conservatism instead.

Stops and run times are whole minutes, as in Baker's output.

### The VVAL-18 trimix warning was wrong

It read: *"Trimix schedules from this model are shorter than VPM-B and Bühlmann
give."*

That was true when it was written at engine 1.12.0. The helium work in 1.14.0
and 1.15.0 made it false, and it was left standing. With VPM-B now in the engine
it can be measured directly instead of compared against another planner, and
VVAL-18 trimix comes out **longer** than VPM-B on every profile tested, 45 to
90 metres:

| dive | VVAL-18 | ZHL-16C raw | ZHL-16C 30/85 | VPM-B |
|---|---:|---:|---:|---:|
| 45 m / 25 min 21/35 | 26 | 15 | 25 | 19 |
| 55 m / 25 min 18/45 | 50 | 29 | 47 | 36 |
| 70 m / 26 min 18/45 | 85 | 50 | 83 | 64 |
| 80 m / 27 min 15/45 | 121 | 78 | 131 | 103 |
| 90 m / 20 min 13/55 | 130 | 81 | 145 | 117 |

The caution still stands, for a better reason. Total time was never the problem
— the shape is. VVAL-18 has neither gradient factors nor a bubble term, so
nothing pulls its first stop deep on helium:

| dive | VVAL-18 | ZHL-16C 30/85 | VPM-B |
|---|---:|---:|---:|
| 70 m / 26 min 18/45 | 27 m | 39 m | 39 m |
| 80 m / 27 min 15/45 | 33 m | 48 m | 51 m |
| 90 m / 20 min 13/55 | 39 m | 54 m | 60 m |

It runs longer than VPM-B while starting eighteen metres shallower. The warning
now says that instead.

---

## Engine 1.12.0 — apps 1.5.0

## The decompression model

The VVAL-79 implementation was reviewed line by line against the U.S. Navy
Experimental Diving Unit's own software design report for the EL-DCA
table-generation program. Five things were wrong. All five are fixed.

### Off-gassing rate in the linear regime

The Thalmann model switches from exponential to linear gas elimination once a
compartment is sufficiently supersaturated. The rate used for that linear phase
was a constant — it depended on neither depth nor the gas being breathed.

It should be the slope of the exponential curve where the two regimes meet, so
they join smoothly:

    was:  dP/dt = −k · PBOVP
    now:  dP/dt = −k · (PVSAT + PBOVP − P_arterial)

**What you would have seen.** Decompression stops came out flat instead of
lengthening as you got shallower, and — the giveaway — switching to a rich deco
mix made the *following* stop longer instead of shorter. On 70 m / 26 min with
18/45 and EAN50, the stop at 21 m ran 14:00 against 5:18 at 24 m below it. It is
now 1:00, and the 3 m stop lands within 20 seconds of MultiDeco VPM-B/E +2 on
the same dive.

A rich gas cannot speed up elimination if the elimination rate does not depend
on the gas. That was the whole of it.

### Closed circuit is a separate formula

On constant PO2 the arterial oxygen tension is fixed by the setpoint and does
**not** scale with depth, so every part of a depth change goes into the inert
gas. That is a different equation from open circuit, and we were using the
open-circuit one for both.

    constant PO2 :  PAO2 = PO2 · SURFP · (1 − PH2O/PAMB) − AMBAO2
    open circuit :  PAO2 = (PAMB − PH2O) · FO2           − AMBAO2

The arterial CO2 correction is also a flat subtraction from the inert tension,
not one scaled by the inert fraction. The old form happened to give nearly the
right answer on air and diverged on every other mix.

### Saturation/desaturation ratio

Elimination rate constants are scaled by 0.70 when running constant PO2, **or**
when the inspired oxygen fraction reaches 0.80. This was missing entirely.

Note the first condition: on a rebreather it applies whatever your FO2 is. This
is the single largest change in this release and the reason CCR schedules
lengthen by roughly 40%.

### Crossover reference

The exponential-to-linear transition is measured against a venous saturation
reference, not against ambient pressure:

    PVSAT = PAMB − (PVO2 + PVCO2 + PH2O)

### Last stop

Leaving the final stop is now judged by allowing an instantaneous ascent to the
surface from one stop increment, crediting the gas exchange during travel to it.
The previous rule was the most conservative of the three the Navy program
defines.

### Crossover overpressure refitted

PBOVP moved from the published 10 fsw to **14 fsw**. The published value was
fitted in a model with no venous reference; with the venous term in place it
misses the NEDU manned-trial anchor by two minutes, and 14 reproduces it
exactly. This is a fit, and it is labelled as one.

### Trimix on VVAL-79 now warns

VVAL-79 is a **nitrogen** model. The U.S. Navy publishes no helium parameters
for it — the surface-supplied helium-oxygen table in the Diving Manual is an
edited 1939 table, not model-derived, and NEDU's replacement work used a
different model entirely. The helium handling here is this project's own
extrapolation with nothing to validate it against, and it produces schedules
about 22% shorter than VPM-B on the same dive.
(Superseded at engine 1.18.0 — see above. Later helium work reversed this, and
VVAL-18 trimix now runs longer than VPM-B, not shorter.)

Every trimix plan on VVAL-79 now says so and points at ZHL-16C with gradient
factors, which reproduces MultiDeco VPM-B/E +2 to within three minutes.

### How it was checked

| test | reference | result |
|---|---|---|
| 132 fsw / 20 min, stop at 20 fsw | **9 min**, NEDU manned trial | **9 min** |
| No-stop limits, 30–190 fsw | USN Rev 7 Table 9-7 | mean error 1.25 min |
| 150 fsw / 20 min | Rev 7 Table 9-9: 2 + 15 | 3 + 19 |
| ZHL-16C output | must not change | **identical** |

**Known and unresolved.** 150 fsw / 20 min still gives 22 minutes against a
published 17. Debugging shows the last stop is controlled by the 40-minute
compartment arriving with more loading than the Navy model would leave it, so
the difference is upstream of the stop, not in it. The error is conservative.
No-stop limits also now run slightly *long* at shallow depths (+4 min at 30 fsw)
where they previously ran short — a consequence of the corrected arterial
formula.

---

## Schedule report

- Closed-circuit rows read `SP1.20` instead of `CC SP1.20`. The prefix appeared
  on every row of a CCR dive so it distinguished nothing, and `SP` implies
  closed circuit by itself. The gas column narrowed from eleven characters to
  nine and the whole table from 57 to 55, which is what makes it fit a phone.

---

## Configuration

- **Stop depths is now its own section.** Stop distance and Last stop used to
  live inside Deep stops, which meant they vanished entirely when gradient
  factors were enabled — so with GF on there was no way to set the stop grid at
  all, despite every schedule being built on it.

---

## Android

- **Full-screen plan reader.** The schedule on its own, with the type size
  computed to fit the width exactly — so turning the phone sideways makes the
  text bigger rather than merely wider. A− / A+ / Fit adjust it, Sun goes to
  full brightness for reading in sunlight, and the screen is held awake the
  whole time. Written for copying a plan onto a slate with wet hands.
- **Phone layout rebuilt.** The three setup rows became one strip of chips that
  folds away on the Plan tab. Depth, time, O2 and He sit on one line with Add.
  Numeric fields open the number pad instead of a full keyboard, and the
  keyboard no longer covers the field you are typing into.
- **Landscape works.** The tablet layout was being chosen on screen width alone,
  so a phone on its side got a layout needing height it did not have.
- **Circuit chip reads OC / CCR** rather than Open / Closed.
- **Keep.** The log no longer records every calculation — it filled with the
  throwaway runs it takes to settle on a dive. Press Keep to file the one you
  want. This is unrelated to Next dive, which loads your tissues.
- **Calculate reads Calc**, and the Pyle stop-time row no longer runs its `+`
  button off the edge of the screen.
- Dark mode no longer flashes white on launch.

---

## macOS, iPhone and iPad

- **Dark mode is properly supported.** The page background was fixed to white
  while text fields took their colour from the system, so in Dark Mode you got
  black boxes on a white page. Everything now follows the system appearance, in
  greyscale as before.
- **Printing is pinned to light.** A plan printed from Dark Mode came out white
  ink on white paper.
- The Info panel shows the app version and build alongside the engine version,
  so a bug report can be tied to a build.

---

## Fixes that affect your gas loading

- **"Next dive" is now one press per calculation.** It used to stay live after
  committing, and pressing it again re-stamped the *same* dive with a fresh
  timestamp — silently resetting your surface interval to zero while the plan on
  screen was unchanged. Affected macOS, iPhone, iPad and Android.
