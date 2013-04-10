PVRinitScripts
==============

Ubutnu PVR init.d Scripts

Got tired of my friends asking me what my init scripts looked like, so here is what I use.

Couple of things, I keep all of my PVR programs under /opt/NAME like /opt/sickbeard

So for a quick setup,

<ul>
	<li>
		<code>
			sudo mkdir -p /opt/pvrinitscripts
		</code>
	</li>
	<li>
		<code>
			sudo mkdir -p /opt/sabnzbd
		</code>
	</li>
	<li>
		<code>
			sudo mkdir -p /opt/sickbeard
		</code>
	</li>
	<li>
		<code>
			sudo mkdir -p /opt/couchpotato
		</code>
	</li>
	<li>
		<code>
			sudo mkdir -p /opt/headphones
		</code>
	</li>
	<li>
		<code>
			sudo chmod 777 -R /opt
		</code>
	</li>
</ul>

<ul>
	<li>
		<code>
			git clone git://github.com/CrossEyeORG/PVRinitScripts.git /opt/pvrinitscripts
		</code>
	</li>
	<li>
		<code>
			git clone git://github.com/sabnzbd/sabnzbd.git /opt/sabnzbd
		</code>
	</li>
	<li>
		<code>
			git clone git://github.com/midgetspy/Sick-Beard.git /opt/sickbeard
		</code>
	</li>
	<li>
		<code>
			git clone git://github.com/RuudBurger/CouchPotatoServer.git /opt/couchpotato
		</code>
	</li>
	<li>
		<code>
			git clone git://github.com/rembo10/headphones.git /opt/headphones
		</code>
	</li>
</ul>

Make sure to edit the "USERNAME" in SickBeard, CouchPotato and Headphones scripts to use them.

<ul>
	<li>
		<code>
			sudo cp /opt/pvrinitscripts/SABnzbd.sh /etc/init.d/sabnzbd
		</code>
	</li>
	<li>
		<code>
			sudo chmod +x /etc/init.d/sabnzbd
		</code>
	</li>
	<li>
		<code>
			sudo update-rc.d sabnzbd defaults
		</code>
	</li>
	<li>
		<code>
			sudo cp /opt/pvrinitscripts/SickBeard.sh /etc/init.d/sickbeard
		</code>
	</li>
	<li>
		<code>
			sudo chmod +x /etc/init.d/sickbeard
		</code>
	</li>
	<li>
		<code>
			sudo update-rc.d sickbeard defaults
		</code>
	</li>
	<li>
		<code>
			sudo update-rc.d sickbeard defaults
		</code>
	</li>
	<li>
		<code>
			sudo cp /opt/pvrinitscripts/CouchPotato.sh /etc/init.d/couchpotato
		</code>
	</li>
	<li>
		<code>
			sudo chmod +x /etc/init.d/couchpotato
		</code>
	</li>
	<li>
		<code>
			sudo chmod +x /etc/init.d/couchpotato
		</code>
	</li>
	<li>
		<code>
			sudo update-rc.d couchpotato defaults
		</code>
	</li>
	<li>
		<code>
			sudo cp /opt/pvrinitscripts/Headphones.sh /etc/init.d/headphones
		</code>
	</li>
	<li>
		<code>
			sudo chmod +x /etc/init.d/headphones
		</code>
	</li>
	<li>
		<code>
			sudo update-rc.d headphones defaults
		</code>
	</li>
</ul>

<ul>
	<li>
		<code>
			sudo service sabnzbd start
		</code>
	</li>
	<li>
		<code>
			sudo service sickbeard start
		</code>
	</li>
	<li>
		<code>
			sudo service couchpotato start
		</code>
	</li>
	<li>
		<code>
			sudo service headphones start
		</code>
	</li>
</ul>
