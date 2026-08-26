# Privacy Policy — Lplanner

**Last updated: 26 August 2026**

Lplanner is a mixed-gas decompression planner published by Landerlab (Carlos
Lander). This policy covers the Lplanner Android application in both the
builds it is distributed as:

| build | application id | store |
|---|---|---|
| Lplanner | `com.landerlab.lplanner` | Google Play |
| Lplanner (F-Droid) | `com.landerlab.lplanner.fdroid` | F-Droid |

The two are the same application, compiled from the same source. They carry
different application ids only because each store signs with its own key, and
Android will not install one over the other. Everything below applies equally
to both.

## The short version

**Lplanner collects nothing, sends nothing, and has no way to.** The app
declares no Android permissions at all — including no internet permission. It
cannot reach a network even if it wanted to.

There are no accounts, no analytics, no advertising, no crash reporting, no
tracking of any kind, and no third-party SDKs that gather data.

Everything below is detail on that.

## What the app stores

Lplanner saves your work so it survives closing the app:

- **The dive you entered** — depths, times, gas mixes, setpoints, and which
  levels are enabled.
- **Your Config settings** — units, water type, altitude, model, gradient
  factors, ascent and descent rates, RMVs, and the rest.
- **Your plan log** — schedules you explicitly pressed **Keep** to save,
  together with the dive and settings that produced each one.
- **Residual tissue loading** — your inert gas state carried between
  repetitive dives, if you use **Next dive**, with the time it was recorded.

These are written to two files, `state.json` and `log.json`, in the app's
private internal storage. That area belongs to Lplanner alone; other apps on
the device cannot read it. Uninstalling the app deletes both files.

None of this is personal information. It is dive planning data. Lplanner never
asks for your name, email address, date of birth, location, or any device
identifier, and it has no field in which you could enter them.

## What the app does not do

- It has **no internet permission**, so it cannot transmit anything, anywhere.
- It does **not** use analytics or telemetry of any kind.
- It does **not** contain advertising or advertising identifiers.
- It does **not** collect crash reports.
- It does **not** request your location, camera, microphone, contacts, files,
  or any other protected resource.
- It does **not** create an account or require a sign-in.
- It does **not** share, sell, or transfer data to anyone, because it holds
  nothing to share and no means of sending it.

## Where your data can leave the device

There are three ways, and all three are things you choose to do.

**Google Android Backup.** Lplanner participates in Android's standard backup
system, which is switched on by default on most devices. If backup is enabled
in your Android settings, `state.json` and `log.json` may be copied to your own
Google account and restored when you set up a new device. This is Google's
service operating on your data under your Google account — Landerlab has no
access to it and cannot read it. You can turn it off for all apps, or for
Lplanner alone, in your device's Backup settings.

**Share.** Pressing **Share** hands the plain text of the current schedule to
Android's share sheet, and from there to whichever app you pick — mail,
messaging, notes, cloud storage. What happens to it afterwards is governed by
that app's privacy policy, not this one. Lplanner sends nothing until you press
the button and choose a destination.

**Print.** Pressing **Print** hands the schedule to Android's print framework.
If you save it as a PDF it stays on your device. If you select a cloud printing
service, the schedule goes to that service under its own terms.

## Children

Lplanner is a technical tool for trained mixed-gas decompression divers. It is
not directed at children and collects no data from anyone, including children.

## Changes to this policy

If the app ever changes in a way that affects this document, the policy will be
updated here and the date at the top revised. Because the current version has
no network access, any change of that kind would require a new release, and it
would be described in the [changelog](CHANGELOG.md).

## Verifying this yourself

You do not have to take the above on trust. The absence of an internet
permission is visible to anyone. On the Google Play listing it is under **App
permissions → See more**; on F-Droid it is in the **Permissions** section of
the app page. Both report none. Android will also show you the full list under
**Settings → Apps → Lplanner → Permissions**.

The F-Droid build goes further: F-Droid compiles it themselves from published
source, so the claims in this document are checkable against the code rather
than taken on trust. The source is at
<https://github.com/landerlab-apps/Lplanner-FDroid>, under the GNU General
Public License v3.

## Contact

Questions about this policy, or about the app:

**scubalander@gmail.com**

Landerlab — Carlos Lander
