# Changelog

Lplanner ships one decompression engine shared by every platform. **The engine
version is the one printed at the top of every plan and shown in the Info
panel** — it is what determines the schedule, so it is the number to quote in a
bug report. The app version tracks the interface around it.

| | version |
|---|---|
| **Decompression engine** | **1.21.0** |
| macOS / iPhone / iPad app | 1.6.0 |
| Android app | 1.6.0 |
| Android app (F-Droid) | 1.6.0 |

---

## Engine 1.21.0

### Altitude: the engine assumed you lived on the mountain

**If you dive at altitude, read this before using an older plan.**

The engine started every dive with your tissues already equilibrated to the
dive site's pressure. That silently assumed you had been living at that
altitude long enough to off-gas your sea-level nitrogen. For anyone who drives
up to a mountain lake in the morning it was the least conservative assumption
available, and nothing on the plan said so.

| | engine said | actually required |
|---|---:|---:|
| 3000 m, 30 m / 25 min, air | 8.6 min | **18.6 min** |
| 4000 m, 40 m / 20 min, air | 24.6 min | **44.6 min** |

A diver who arrived that morning was being given less than half his
decompression, on a schedule that looked exactly as authoritative as any other.

Config now asks. Above sea level only — at 0 m the question has no meaning:

- **Diver equilibrated at this altitude** — you have been up there long enough
  for your tissues to have adjusted.
- **Hours at altitude** — how long since you arrived. `0`, meaning you have
  just driven up, is the **default**, because it is both the common case and
  the conservative one.

The tissues wash out from sea level toward the altitude equilibrium at their
own individual rates, so an hours figure means something real rather than
being a switch in disguise.

The plan header states which assumption produced the schedule —
`Altitude 3000m, diver just arrived` — because it changes the answer by more
than most Config settings do.

**Sea level is completely unaffected.** ZHL-16C and VVAL-18 verified unchanged
across the full profile set.

### Equilibration, not acclimatisation

The U.S. Navy Diving Manual (rev 7, §9-13.4) separates two things this project
had merged:

> The body off-gases excess nitrogen to come into equilibrium with the lower
> partial pressure of nitrogen... The first process is called equilibration;
> the second is called acclimatization. Approximately twelve hours at altitude
> is required for equilibration.

Lplanner models the nitrogen and **nothing at all** of the adjustment to lower
oxygen. Calling the setting "acclimatised" named the wrong process and could
have suggested the planner accounted for altitude adaptation. It says
*equilibrated* now, with the Navy's twelve-hour figure where you will read it.

The same section is also the authority for the fix above: a diver diving
within twelve hours of arrival must account for his residual sea-level
nitrogen, and the Navy does it by treating the ascent to altitude as a
repetitive dive.

One caveat their figure does not carry over. Twelve hours is right for the
Navy's tables, which are led by a 120-minute compartment — 1.6 % of the excess
left. Bühlmann's set runs to 635 minutes, which still holds **46 %** at twelve
hours. It rarely shows on a single dive, because the compartments that lead a
30–40 m dive are done long before. It does show on a second day. If you
arrived yesterday, enter the hours rather than ticking the box.

### Checked against the Navy's own tables

The altitude arithmetic was verified against U.S. Navy Diving Manual rev 7,
chapter 9, rather than against itself:

- **Atmospheric pressure** matches Table 2-19 to within **0.05 %** at every
  altitude from 1,000 to 10,000 ft.
- **Sea level equivalent depth** reproduces **45 of 50** sampled cells of Table
  9-4 exactly. All five disagreements sit in the 1,000 ft column, where the
  Navy leaves shallow depths uncorrected and the ratio rounds up one table step
  — deeper, the safe direction.
- **Equivalent stop depths** reproduce **59 of 60** cells of the Table 9-4
  footer. The one miss lands on exactly 46.5 and is a rounding tie.

Note this does not make Lplanner a Cross Correction planner, and it should not
be one. Cross Correction exists so a fixed printed table can be read at
altitude. Lplanner evaluates the model at the pressure that actually obtains,
as Bühlmann and VPM-B do. What the checks confirm is the physics under both.

### DAN recommendations in Info

A standing section covering flying after diving, altitude after diving, diving
at altitude, thermal stress and ascent rate.

It says plainly that the **Time to Fly** figure on the plan is the model's own
arithmetic — the hours until your tissues tolerate a 10,000 ft cabin — and is
usually far shorter than DAN's guidance, which runs from 12 hours after a
single no-stop dive to 24 hours or more after decompression diving. The plan
prints only one of those two numbers. Take the longer.

---

## Engine 1.20.0

### The start of the decompression zone was never computed

The plan prints **Deco zone start** under the table. It was wrong, and wrong in
a way that hid itself: the figure was taken from the first stop that carried
any time, so it always equalled the first stop. On 70 m / 30 min with 18/45 on
VPM-B +2 it read 48 m because the first stop was 48 m. The number confirmed
itself and told you nothing.

The first stop must lie **above** the start of the decompression zone. Reading
the two as the same depth is the symptom that prompted this.

It is now measured during the ascent, as the depth at which the leading
compartment's total inert gas tension first reaches ambient pressure. Shallower
than that the diver is supersaturated and a bubble can grow; deeper than it he
is not. The first stop is necessarily above it.

A word on the criterion, because the obvious reading gives the wrong answer.
Off-gassing in the plain sense begins almost the moment the diver leaves the
bottom — the inspired inert pressure falls with him, so tissue tension exceeds
it immediately. That depth is nearly the bottom itself and is not what the term
means. The crossover worth naming is tension against **ambient** pressure,
which is what Baker's `CALC_START_OF_DECO_ZONE` computes, metabolic gases
included. The same test was already in the engine driving VPM-B's phase volume
time; it now serves every model.

Checked against Baker's own output rather than against itself. On his 80 msw
15/45 benchmark the engine gives 64.6 m where `VPM.OUT` prints 64.8 mswg; the
0.2 m is the fresh-water conversion and the integration interval.

| model | zone start | first stop |
|---|---:|---:|
| ZHL-16C | 54.8 m | 24 m |
| VVAL-18 | 54.8 m | 30 m |
| VPM-B +0 | 54.8 m | 48 m |
| VPM-B +2 | 54.8 m | 48 m |
| VPM-B +4 | 54.8 m | 48 m |

The zone start is the same for all three, which is correct — it is a property
of the tissues and the ascent, not of the stop rules.

Re-measured on every pass of VPM-B's critical volume loop, which ascends more
than once with different tissue loadings. A value carried over from the first
pass would describe a schedule you are not being given.

**Display only. No schedule changed on any model.** ZHL-16C and VVAL-18 verified
unchanged across 8 profiles.

---

## Android 1.6.0

Brings Android level with macOS and iOS, plus three changes that apply to the
phone alone.

### VPM-B

The model picker gains a third segment, with the conservatism slider and the
critical radii shown only when VPM-B is selected — as on the other platforms.
Gradient factors and the Conservatism percentage now correctly go inert when
VPM-B is chosen; the guard that disabled them tested for "not VVAL-18", which
would have silently applied gradient factors to VPM-B.

### Warnings moved out of the table and into Info

On a phone the warning block ran to several wrapped lines beneath a schedule
already short of height. The table now ends at the gas consumption figures and
the warnings are set out permanently under **WARNINGS** in Info.

macOS, iPhone and iPad still print them under the table. The trade is
deliberate and worth stating: the Info text is standing rather than computed,
so it gives the 5.2 and 6.2 g/L thresholds instead of the density of the gas
you just planned. Read it once.

The section was rewritten against Ross Hemingway's *Some common practices,
myths and mistakes on decompression* (decompression.org) rather than from
memory. Four items are new, and two concern settings Lplanner itself exposes:

- **Last stop at 6 m** is only sound on 100% oxygen, the one gas delivering
  zero inspired inert pressure at any depth. On 50% or leaner the inspired
  inert pressure must keep falling to drive off-gassing, so the stepped ascent
  through 4.5 and 3 m still has to be made. Config will let you set 6 m with
  any gas and say nothing.
- **Ascent rate** — the average technical diver manages about 5 m/min against
  a planned 10, and a table computed at 10 is wrong for him. The slow final
  ascent is the exception: the planner ignores it, so it is extra
  decompression rather than skipped decompression.
- **Trimix deco gas** — a 50/50 schedule comes out longer and divers assume a
  fault. It is not. Helium in the deco mix slows helium off-gassing; what
  50/50 buys is nitrogen removed earlier.
- **Extended stops** — not in the deepest part of the ascent, where ambient
  pressure still loads you.

The isobaric counterdiffusion note was too vague to act on and now gives the
mechanism: the switch onto EAN50 returns inspired nitrogen to roughly where it
was several stops deeper, halting nitrogen off-gassing while helium leaves
quickly. That is the accepted trade, not a fault.

### Print

Print had never existed on Android. A comment in the top bar referred to it as
though it did, which is how it came to be reported missing.

The schedule is a monospace table whose columns only align because every glyph
is the same width, so it is set at 9 pt — the largest size that keeps 54
columns inside a portrait margin without reflowing. It reaches a printer or
Save as PDF.

Share, Print and Info have lost their captions. The words were wider than the
icons they labelled, and on a 360 dp screen that width was the difference
between Print fitting in the bar and not. All three keep their accessibility
labels. Share and Print dim to 40% when there is no plan rather than
disappearing, so the bar never changes shape.

---

## Engine 1.19.0 — macOS / iPhone / iPad 1.6.0

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

### A VPM-B stop time was printed too long

Ascent legs shorter than a minute and a half are normally absorbed into the
stop that follows them, which is how MultiDeco presents a schedule. VPM-B
already does that absorbing itself: Baker rounds the run time up on arrival, so
the travel is inside the stop before the hold even begins. Doing it a second
time in the report counted the leg twice, and a whole minute at 48 m printed as
`1:49`.

The stop was always the right length — the engine, the total deco time, the CNS
and the OTU figures were all correct, and only the one printed field was wrong.
VPM-B ascent legs now get their own `↑` row and the stop shows its own time.

### Where the gas switch appears

The manual said a **GasSw** row marks every switch. It does not. A GasSw row is
printed when the diver changes gas at a depth he is passing through; when the
switch depth is also a stop — the usual case, since switch depths snap to the
stop grid — the new mix is printed in the gas column of that stop. Text only;
nothing in the output changed.

### Android: warnings moved out of the table

On a phone the warning block ran to several wrapped lines under a schedule that
is already short of height, so on **Android only** the plan table now ends at
the gas consumption figures and the warnings are set out permanently under
**WARNINGS** in Info — gas density, isobaric counterdiffusion, VVAL-18 on
trimix, and oxygen exposure.

macOS, iPhone and iPad still print the warnings under the table. The trade is
deliberate: the Info text is standing rather than computed, so it states the
5.2 and 6.2 g/L thresholds instead of the density of the gas you just planned.
Read it once. Nothing in the schedule changed on any platform.

### Gas density is now flagged

Every plan reports the density of the bottom gas; now it also warns. Following
Anthony & Mitchell: under 5.2 g/L nothing is said, between 5.2 and 6.2 the plan
notes the gas is above ideal, and above 6.2 g/L it warns and says to add helium.
Work of breathing and carbon dioxide retention rise steeply past that point, and
CO2 retention is itself a risk factor for oxygen toxicity and narcosis.

The figure itself has not changed. It is ambient pressure in atmospheres times
molar mass over 22.414 — the convention those limits were derived under, which
puts air at 30 m on 5.1 g/L and at 39 m on 6.3 g/L.

Worth knowing: **18/45 at 70 m is 6.4 g/L and trips the limit.** 18/50 brings it
to 5.9. Some planners report a lower number for the same gas by computing at
room temperature rather than at 0 °C.

Advisory only. No schedule changes, for any model.

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
