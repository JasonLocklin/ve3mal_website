---
layout: post
title: "Weechat IRC"
description: "Some tricks and hints for using IRC"
date:   2023-06-29 12:50:58 -0400
categories: Software 
---

IRC (Internet Relay Chat) is a protocol for internet chatrooms that pre-dates the "web" and is beautifully antiquated in my mind. 
No pictures, not video or audio chat, just a protocol so simple that people have built clients for it over the years for 
every device and operating system imaginable, with a great deal of diversity in implementation. 

I prefer to use IRC in a terminal, so I use Weechat. It's an "old school" terminal IRC client, but is packed to the gills with features
and hackable things. There are plenty of pages online covering various scripts and configurations, but there are a few things
I do with it that I'd like to document here.

## Dtach

Dtatch is a really simple way to run weechat as a background process so that you can close your ssh session, or terminal, and leave
weechat running in the background. Some use tmux, but that does much more, and dtach works great inside tmux anyway. Simply
install dtach through your package manager (it's absolutely tiny!), and then add the following alias to your bashrc:

```
alias wc="dtach -A ~/weechat.socket weechat"
```

Now, when you type "wc," you will automatically connect to a running instance of weechat, or start a new one if it isn't already running. 
You can detach from that session any time with `Ctrl-\` if you want to get back to your terminal. You will see that `weechat.socket` file 
in your home directory if it is currently running.


## Push notifications

If you are running weechat full time, rather than just a bouncer, be sure to set up a push notification system. 
I use [Irssi Notifier](https://irssinotifier.appspot.com/). It works great with weechat, despite the name, and seems to be 
very reliable. Don't try to keep any irc client connected on your mobile device, as it's not a battery friendly system -use push instead.

## Automate things
Weechat has lots of optional "bars" that display things like the channel list, nick list, buffers like the highlight monitor, 
and even split windows that can show multiple buffers. This obviously works best in big terminals, and rather than have to turn them
on and off when I use different sized windows, I have them automatically toggle when the window is resized. It's extremely handy and slick.

This is mentioned in the user guide [here](https://weechat.org/files/doc/stable/weechat_user.en.html#trigger_example_responsive_layout).

## Relays

Weechat has a "relay" system that lets it act like a "buncer" so that other clients can connect to it. 
You leave your main weechat instance running full time, and just connect to it from a different device when needed.
Many people use the weechat android client, or Glowingbear, to connect to weechat as a full featured client.

However, you can also use the basic [IRC proxy](https://weechat.org/files/doc/weechat/stable/weechat_user.en.html#relay_irc_proxy)
version of the relay to connect to it with *ANY* irc client.
Why would you use this?

I copy my `.weechat` config folder to various computers, and swap out the server for weechat's relay. This way, I can start up
weechat locally on various computers, and connect to my already established sessions. Unlike remote connecting to my VPS, there is
zero lag this way, and I can have different configurations on different computers. I might have a big window split with multiple buffers
on one computer, while another might have a tiny window with just one buffer displayed. 

The IRC proxy supports TLS, but I use a wireguard server on my vps so remote connections to weechat are protected that way.

### Web client
Many people use [Glowingbear](https://glowing-bear.org) when they wish to connect to their weechat instance with a web browser (either for a gui 
experience, or on a device without a terminal). 
Glowingbear works as a client inside your browser, and can make use of the weechat relay if you have set up tls and port forwarding,etc.

However, with the IRC proxy, you can use any client. I have [TheLounge](https://thelounge.chat/) running on my VPS, and it is a
full-blown IRC client running on the server. It connects to the IRC proxy, and any time I open the web page on any device, I can
immediately resume chatting as if I was on my weechat instance. TheLoungs is quite nice, and would also work great if I just wanted 
a web IRC client that stays connected 24/7 on it's own -but I like to have the terminal option!

```
 Connected IRC Clients:

┌─────────────┐
│SSH in a Term├────────────────────────────────────────────────────┐
└─────────────┘                                                    │
                                                                   │
┌─────────────────┐                       ┌────────────────────────┼────────┐
│Weechat in a Term├────┐                  │     VPS                │        │
└─────────────────┘    │                  │                        │        │
                       │                  │  ┌─────────┐     ┌─────┴──────┐ │
┌─────────────────┐    │               ┌──┼──┤IRC Proxy├─────┤Dtach       │ │
│Weechat in a Term├────┤  ┌──────────┐ │  │  └─────────┘     │  ┌───────┐ │ │ ┌───────────┐
└─────────────────┘    ├──┤ Wireguard├─┤  │                  │  │Weechat├─┼─┼─┤IRC Servers│
                       │  └──────────┘ │  │  ┌─────────────┐ │  └─────┬─┘ │ │ └───────────┘
┌───────────────┐      │               └──┼──┤Weechat Relay├─┤        │   │ │
│Weechat Android├──────┘                  │  └──────┬──────┘ └────────┼───┘ │
└───────────────┘                         │         │                 │     │ ┌────────────┐
                                          │  ┌──────┴─────────────┐   └─────┼─┤Push Service│
┌───────────┐                  ┌──────────┼──┤TheLounge Web Client│         │ └────────────┘
│Web Browser├───────┐          │          │  └────────────────────┘         │
└───────────┘       │          │          │                                 │
                    ├──────────┘          │                                 │
┌───────────┐       │                     └─────────────────────────────────┘
│Web Browser├───────┘
└───────────┘

```
