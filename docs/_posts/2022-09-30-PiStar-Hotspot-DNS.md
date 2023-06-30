---
layout: post
author: Jay 
title: PiStar Always Working DNS address 
categories: Hotspot
---
Local Dynamic DNS for Pi-Star

Problem: I don't have a screen on my hotspot, and I find it annoying that I need to figure out what IP it has 
on the local network whenever I connect it to a new one (or my phone's hotspot). Rarely, using http://pi-star.local seems to work, but 
it is not at all reliable. 

Solution: Using a dynamic dns updater to give a DNS address to the **local**
**ip** of the hotspot. It is very simple, and did not require installing anything on pi-star or logging in via
SSH. 

I already had an account at [NSUpdate.info](http://nsupdate.info), so I used that. I recommend it as it is free and reliable.

Once logged in, click "Add Host" and I filled out the name that I wanted to use, and selected one of their domains. Click "Create"

One the following page, you can see your "secret" (password), and they also provide the full URL to update your IP address. 
Note how your hostname and secret (password) are formatted in the URL -that will be used below.

Then, in the Pi-star web interface, edit the "System Cron" file by navigating to the tabs:

Pi-Star web interface

-> "Configuration"
   
-> "Expert"
   
-> "System Cron"

And add the following line at the end of the file:

	*/10 *	* * *	root	curl https://NAME%2Ensupdate%2Einfo:PASSWORD@ipv4.nsupdate.info/nic/update?myip=$(hostname -I)

(Change NAME%2Ensupdate%2Einfo to your username, and PASSWORD to your password)

Explanation:
This will run every 10 minutes. Change it to */5 to make it every 5 minutes.
It will use the "curl" command, that is already part of pi-star, to authenticate with Nsupdate.info and update the ip address if necessary.
It manually enforces the *local* ip address, instead of the world-reachable ip, address that most people use dynamic dns for.

Now, I no longer need to know the local ip address of pi-star, or rely on pi-star.local actually working. 
I can just always point my browser to pi-star-ve3mal.nsupdate.info and it will work **as long as both devices are on the same network** (and the network permits direct connections). No more need for fixed ip addresses, or struggling each time it connects to a new network or phone hotspot!

This does **not** expose the pi-star administration dashboard to the wide internet, and it will not work remotely over the Internet. 

If the IP address changes, it may take up to about 20 minutes to start working again, worst case. Most likely, it will be a few minutes.
