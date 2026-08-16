# Installing Lplanner on macOS

Lplanner is distributed directly rather than through the Mac App Store, and is
not notarised by Apple. macOS will therefore refuse to open it the first time.
This is expected, and the steps below are the ones Apple intends you to follow.

## Install

1. Download `Lplanner.zip` and double-click it to unzip.
2. Drag **Lplanner.app** into your **Applications** folder.
3. Double-click it. macOS will say it *"cannot be opened because Apple cannot
   check it for malicious software"*. Click **Done**.
4. Open **System Settings → Privacy & Security**, scroll to the **Security**
   section at the bottom. You will see a line naming Lplanner. Click
   **Open Anyway**, then confirm with **Open**.
5. That is the whole of it. Every launch after this one is normal.

On macOS Sequoia (15) and later, this System Settings route is the only way —
the old trick of Control-clicking the app and choosing Open no longer bypasses
the check.

### If you would rather use the Terminal

    xattr -dr com.apple.quarantine /Applications/Lplanner.app

That strips the download flag, and the app opens on the first double-click.

## Why the warning appears

Apple charges $99 a year for a Developer ID certificate, which is what lets a
Mac app be notarised and open without any warning. Lplanner is a free tool for
a small number of divers and does not carry that cost, so it ships unsigned.

The warning means only that Apple has not been paid to review the app. It is not
a finding about the app. 

## Requirements

- macOS 12.4 or later
- Apple Silicon or Intel

## Before you use it for a real dive

Read the disclaimer in the app's **Info** panel. In short: this schedule is
experimental; it probably has bugs, and the author does not warrant that it
accurately reflects the algorithm it names. Cross-check anything you intend to
dive against tables or a planner you already trust.

Please report what you find, and quote the version line at the bottom of the
Info panel — it reads something like `1.1 (7) · engine 1.10.0`. The first part
identifies the build, the last part identifies the decompression engine, and a
report is hard to act on without both.

Email me with any questions at: carlos.lander@etik.com