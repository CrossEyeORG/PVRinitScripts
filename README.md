PVRinitScripts
==============

Ubutnu PVR init.d Scripts

Got tired of my friends asking me what my init scripts looked like, so here is what I use.

Couple of things, I keep all of my PVR programs under /opt/NAME like /opt/sickbeard

So for a quick setup,

<code>
sudo mkdir -p /opt/pvrinitscripts
sudo mkdir -p /opt/sabnzbd
sudo mkdir -p /opt/sickbeard
sudo mkdir -p /opt/couchpotato
sudo mkdir -p /opt/headphones
sudo chmod 777 -R /opt
</code>

<code>
git clone git://github.com/CrossEyeORG/PVRinitScripts.git /opt/pvrinitscripts
git clone git://github.com/sabnzbd/sabnzbd.git /opt/sabnzbd
git clone git://github.com/midgetspy/Sick-Beard.git /opt/sickbeard
git clone git://github.com/RuudBurger/CouchPotatoServer.git /opt/couchpotato
git clone git://github.com/rembo10/headphones.git /opt/headphones
</code>

<code>
Make sure to edit the "USERNAME" in SickBeard, CouchPotato and Headphones scripts to use them.
</code>

<code>
sudo cp /opt/pvrinitscripts/SABnzbd.sh /etc/init.d/sabnzbd
sudo chmod +x /etc/init.d/sabnzbd
sudo update-rc.d sabnzbd defaults
sudo cp /opt/pvrinitscripts/SickBeard.sh /etc/init.d/sickbeard
sudo chmod +x /etc/init.d/sickbeard
sudo update-rc.d sickbeard defaults
sudo cp /opt/pvrinitscripts/CouchPotato.sh /etc/init.d/couchpotato
sudo chmod +x /etc/init.d/couchpotato
sudo update-rc.d couchpotato defaults
sudo cp /opt/pvrinitscripts/Headphones.sh /etc/init.d/headphones
sudo chmod +x /etc/init.d/headphones
sudo update-rc.d headphones defaults
</code>

<code>
sudo service sabnzbd start
sudo service sickbeard start
sudo service couchpotato start
sudo service headphones start
</code>