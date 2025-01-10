# Smooth, high precision input curve script for TouchOSC faders and XY controls

On my cheap tablet, doing small swipe high precision increments or decrements on
TouchOSC faders is, sadly, not possible :(

The screen recognizes the finger touch alright, but, it needs a considerable
travel distance before it starts to register actual movement. By then, the
distance travelled and registered is so big that any "smaller" fader control
will register a big initial value jump, usually as big as 6-8 MIDI value
steps. This is unacceptable for fine tuning the current values of, for example,
synthesizer controls or knobs.

The LUA script in this repository aims to rectify this by provoding a smoother
initial input curve:

Upon touch it registers the initial touch starting coordinates and sets a large
initial dampening factor for all value changes. Then, while you move away from
this starting point (in x or y direction, with respect to whether you are
changing a fader, or an XY control value), it gradually reduces the dampening
factor until it reaches a normal input factor of 1.0. The dampening factor will
*only decrease*, so it will not ramp up again when you fade back in the other
direction, the purpose of this being to initially have extremely fine control of
the fader value, and then with moving re-establish normal value sensitivity for
the input :)

## Features

**High precision:**
- For faders with "Relative" response, this results in high-precision fine control of value at touch start
- For faders with "Absolute" response, the resulting behaviour is best described as "lazy" value updating, i.e. the value will smoothly fade towards the touch point.

**Reset on double tap:**
- In addition, the script also includes an optional "reset to default or zero value" on double tapping the control.

## Download

Check the
[Releases](https://github.com/bobbadshy/touchosc_luascript_smooth_input_curve/releases)
section.

Or, directly download the current demo .tosc file:
- [demo.tosc](https://github.com/bobbadshy/touchosc_luascript_smooth_input_curve/raw/refs/heads/main/demo.tosc)

Many thanx and Enjoy!
