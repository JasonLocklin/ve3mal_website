---
layout: post
author: Jay 
title: Add an Amplified Receive Antenna 
categories: IC-7300
---

## Add an Amplified Receive Antenna to the Icom IC-7300

### RX Antenna Port Mod
I purchased an "RX7300" from a French ham on Ebay to add a RX
antenna port to the IC-7300. It uses SMA connectors,
and a little patch cable to bypass the RX antenna port when
using a single antenna as usual.
Install, was very easy, and required no permanent modifications or 
soldering. The only improvement I could see for such a kit would be to 
use a switch, or better yet, a relay, that can switch the RX antenna port
on/off instead of using the awkward patch cable. However, for the price, 
I'm very happy with it.


### Bias Tee Injector
TODO


### Tx/Rx Switching the Bias Tee Injector
The Bias Tee needs to be powered *only* when the transceiver
is in receive mode. This is accomplished by a fast (~1ms) reed relay
connected to the SEND pin of the IC-7300. 
![Circuit diagram](/assets/images/active_antenna_diagram.jpg)
This pin is normally
used for controlling and amplifier, and is connected to nothing
(floating) during RX, and goes to ground when transmitting. Using it
with the 13.8v pin 8 gives voltage during TX, so the normally open
pin of the relay can provide power during RX.

The circuit also includes TX and RX LED indicators, and a 
Zenier diode/Resistor combo to regulate the voltage down to 5.1v
for the LNA. This is inefficient, but noise free, and since the 
LNA only uses ~30ma, little heat is dissipated anyway.

### Low Noise Amplifier Powered by Bias Tee
TODO 


### Simple Rx Antennas
TODO
