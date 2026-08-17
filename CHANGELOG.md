# Changelog

Lplanner ships one decompression engine shared by every platform. **The engine
version is the one printed at the top of every plan and shown in the Info
panel** — it is what determines the schedule, so it is the number to quote in a
bug report. The app version tracks the interface around it.

| | version |
|---|---|
| **Decompression engine** | **1.12.0** |
| macOS / iPhone / iPad app | 1.5.0 |
| Android app | 1.5.0 |

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
