---
layout: post
title:  "Computer Keying CW on the IC-7300"
date:   2021-09-22 12:50:58 -0400
categories: IC-7300
---
## Computer Keying CW on the IC-7300 with a Raspberry Pi

There are 3 ways to key CW on the IC-7300 with a computer like the RPI.
  1. Using an I/O interface with a transistor that connects to the radio like a key. This could be done with the IO on the RPI.
  2. Using the serial interface to pull the RTS or DTR signal down to key. This relies on the computer to do the timing.
  3. Using CAT, more specifically, the Icom's CI-V commands to send ASCII characters to the radio. The Radio's CPU will do the timing of sending the actual characters
at the speed that the radio's keyer is set to.

On the Raspberry Pi, I have hamlib installed from the repositories. Hamlib can use #3 above to directly send. If you want to do #2, you will need to also install CWDaemon.

Both #2 and #3 can share a cable with CAT control so that you only have one wire from the RPI to the radio. That wire can be either USB or the serial cable. You can choose
to use 2 cables if you want to. For example, doing #2 on the serial cable and CAT on the USB cable. That's not necessary though. If you do #2 and share a cable, both your CAT
program (e.g., hamlib or flrig) and CWDaemon will be writing to the same serial device, and that may lead to conflicts if they both try to write at once. YMMV. #3 doesn't have
that problem. #3 is also not dependent on the Pi's CPU timing. I was worried that the easily overloaded CPU could lead to bad timing if I did #2.

On the radio, USB SEND and USB Key should be set to "OFF" if using #3. Don't forget that Bkin needs to be "ON" or the radio will not transmit -just like with a paddle/key.

To test, run
> rigctl -m 373 -r /dev/ttyUSB0

You may need to set the speed (ex. -s 19200), and after hamlib v4, the model is 3073 rather than 373.

Once it's connected, you can type f and hit enter to see the current frequency. If hamlib is working correctly, you will see the frequency.

Now type b and hit enter. Type a word and hit enter. The radio should now key what you typed.

This can be combined in a single bash line as:
> rigctl -m 3073 -s 19200 -r /dev/ttyUSB0 -b CQ

I am using CQRLOG. In the preferences, set up hamlib for rig control, and under cw keyer, select hamlib.

