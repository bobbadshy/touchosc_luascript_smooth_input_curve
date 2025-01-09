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

***Important:** Currently, the script works for **relative** faders and XY
controls only, cause well ..that is where it makes sense ..when you want to fine
tune the **existing** value by swiping up or down ;)*

Upon touch it registers the initial touch starting coordinates and sets a large
initial dampening factor for all value changes. Then, while you move away from
this starting point (in x or y direction, with respect to whether you are
changing a fader, or an XY control value), it gradually increases the dampening
factor until it reaches a normal input factor of 1.0. The dampening factor will
*only increase*, so it will not decrease again when you fade back in the other
direction, the purpose of this being to initially have extremely fine control of
the fader value, and then with moving re-establish normal value sensitivity for
the input :)

## Download

Check the
[Releases](https://github.com/bobbadshy/touchosc_luascript_smooth_input_curve/releases)
section.

Many thanx and Enjoy!
