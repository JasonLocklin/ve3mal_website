---
layout: post
title:  "IC-7300 Missing Control Module Project"
date:   2021-09-22 12:50:58 -0400
categories: IC-7300
---
## Design Goals

Build the "Missing IC-7300 Control Module", a minimal module SBC that provides automatic and reliable network
and io connectivity -the missing feature of this radio. 
This is intended to be a small box connected at the back of the Radio. Short wires,
and no user interface buttons or screens. This is not a shack PC, logger, or display, it's designed to support those
things by providing wireless connectivity from the radio to any and all of them.

Small, headless box with minimal wires and power consumption. It should support the following functions:
  1. Provide rgctl or wvfiew server connection over the network.
  2. Provide 2-way audio over the network (wfview, or some other voip).
  5. Keys CW transmissions (maybe fsk rtty too).
  6. Has Paddle input.

The idea is to use a SBC like a rpi, and set it up just like pi-star so that it can:
  1. Boot with radio power (directly from the radio's ACC 13.8v power pin)
  2. Use a tmpfs filesystem overlay just like pi-star so it can be powered off at any time without fs corruption
  3. Connect to any known wifi
  4. Create it's own network if no known wifi

Time Services:
  1. Get network time if available.
  2. Set radio clock if network time is available.
  3. Set computer time from radio clock if no network (IC-7300 has an RTC, but the pi doesn't)

Very minimal I/O replacing what is missing on the IC-7300:
  1. Paddle input so that front port can be used for SK.
  2. USB keyboard optional for either CW or RTTY
  3. Bluetooth audio for headphone (or speaker) monitoring of IC-7300 audio.
  4. (optional later: PTT port that permits bluetooth mic audio to radio).

## Parts:

* Raspberry PI SBC. I'd like to use a zero-w, but test for performance.
* * Look into power requirements (ACC socket is 1a max)
* * Will need a DC-DC converter to 5v plus filtering on the radio side
* * USB expansion HAT or a USB hub will be required.
* TRS connector for paddle.
* Metal enclosure for rfi reduction (ensure wifi compatible) 
* Short USB cable with ferrites
* ACC cable

## CW keying/paddle input 
Linux does not allow 2 programs to connect to a serial port at once. I've used CW over rigctl before,
but I would like to use DTL pin to key transmitter on the usb port. Rigctld or wfview monopolise the port, 
preventing this. Solutions might be:
  * Find some utility to allow sharing a serial port on linux
  * Patch wfview to allow controlling DTL pin from another program like cwdaemon.
  * Patch hamlib to allow controlling DTL pin from another program like cwdaemon.
  * Use the key jack on the front of the radio (extra wire I don't like).

Using rigctl CW keying works, but would not work with an external paddle input because it only takes ascii
input.

Maybe give up on paddle input, and just basically build a wfview remote?

Ditch the usb connection as cw, and just use a winkeyer or k3ng keyer?

# Roadmap:

v1. Purchase a pi-zer W and try using it just as a simple wfview remote. Wire into acc port power and usb only.

v2. Enclose and make neat cables.

v3. Solve CW keying/paddle input
