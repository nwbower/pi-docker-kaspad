# pi-docker-kaspad
Kaspa Node in Docker on a Raspberry Pi 4 Model B 8GB - arm64
<p>Container hosted publicly at : <a href="https://hub.docker.com/r/nwbower/pi-kaspad">https://hub.docker.com/r/nwbower/pi-kaspad</a></p>
<p>Buy me a coffee: kaspa:qqz5xkyz36hj2pu9srdzd46wzlz2v24qf7mkgxtg44lnzl2gpxkp7jezgjf6z</P>

<h1>Containerized Kaspad for Raspberry Pi 4 Model B.</h1>
<p>Yes, you can run a Kaspa Node on your Raspberry Pi 4 Model B. I'm using an 8GB version and it's been working great! The 8GB version is required as the node idles around 4.5gb of mem when synced. I'm booting to Ubuntu 22.04.1 LTS on a 512GB SSD.</p>
<p>Shout out to <a href="https://hub.docker.com/u/supertypo">supertypo</a> for the detailed readme and his x86-64 and amd64 versions, <a href="https://hub.docker.com/r/supertypo/kaspad">supertypo/kaspad</a>. I have copied some of his readme, but modified as appropriate here for this build image on a pi. Thank you supertypo!</p>
<p>There is also a great CLI reference for <a href="https://kaspawiki.net/index.php/Setting_up_a_CLI_node#Setting_up_a_node_in_Docker">setting up a Kaspa node in docker</a> on the kaspawiki.</p>
</br>
<p>Kaspa is an ancient Aramaic word for “silver” and “money.”
Kaspa aims to become the most resilient, robust and fastest PoW BlockDAG in the world.</p>
<p><a href="https://kaspa.org">https://kaspa.org</a></p>
<p>Kaspad release binaries are unaltered from the corresponding official version at:<br>
<a href="https://github.com/kaspanet/kaspad">https://github.com/kaspanet/kaspad</a> (ISC licensed)</p>

<p>The loadbalancer, HAProxy, is GPLv2 licensed.<br>
<a href="http://www.haproxy.org/">http://www.haproxy.org/</a></p>

<p>Build source for this image is available at:
<a href="https://github.com/nwbower/pi-docker-kaspad">https://github.com/nwbower/pi-docker-kaspad</a></p>

<p>Credit to supertypo for the loadbalancer and supporting readme reference available at:
<a href="https://github.com/supertypo/docker-kaspad">https://github.com/supertypo/docker-kaspad</a></p>
</br>

<h2>Quickstart:</h2>
<h4>Make sure your system is update to date first (this example is for Ubuntu 22.04.1 LTS)</h4>
<pre><code>sudo apt update &amp;&amp; sudo apt dist-upgrade -y
</code></pre>
<p>Reboot now if you're told to after the updates have been installed.</p>
<h4>Install docker (this example is for Ubuntu on a Raspberry Pi)</h4>
<p>I used detailed instructions for installing on rpi <a href="https://www.simplilearn.com/tutorials/docker-tutorial/raspberry-pi-docker">here</a>.</p>
<pre><code>curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
</code></pre>
<h4>Make sure Docker is started at boot</h4>
<pre><code>sudo systemctl enable docker
</code></pre>
<h4>Create datadir and set correct permissions</h4>
<pre><code>sudo mkdir -p /var/kaspad &amp;&amp; sudo chown 51591 -R /var/kaspad
</code></pre>
<h4>Start Kaspad container</h4>
<pre><code>sudo docker run --pull always -d --restart unless-stopped -v /var/kaspad/:/app/data/ -p 16110:16110 -p 16111:16111 --name kaspad nwbower/pi-kaspad:latest
</code></pre>
<p>Thats it! The node will take some time to sync. For a Raspberry Pi this can take several hours.<br>
Check the logs to know when it's ready.</p>
<h3>Tail logs:</h3>
<pre><code>sudo docker logs -n 1000 -f kaspad
</code></pre>
<p>The node is fully synced when it prints lots of "Accepted block ..." lines.</p>
<h3>View kaspad disk usage<h3>
<pre><code>sudo docker system df -v
</code></pre>
<h4>Later, when you want to upgrade to the newest kaspad</h4>
<pre><code>sudo docker rm -f kaspad
sudo docker run --pull always -d --restart unless-stopped -v /var/kaspad/:/app/data/ -p 16110:16110 -p 16111:16111 --name kaspad nwbower/pi-kaspad:latest
</code></pre>
<h4>To clear database and resync (if needed)</h4>
<pre><code>sudo docker stop kaspad
sudo rm -r /var/kaspad/.kaspad
sudo docker start kaspad
</code></pre>
</br>

<h2>Prerequisits for building this image on your Pi:</h2>

<p>You will need an arm64 compatible version of golang. Install GO on your pi by executing these steps one by one.</p>
<pre><code>curl -OL https://golang.org/dl/go1.20.linux-arm64.tar.gz</code></pre>
<pre><code>sha256sum go1.20.linux-arm64.tar.gz
</code></pre>
<p>Confirm output from the last command looks like this:</p>
<pre><code>17700b6e5108e2a2c3b1a43cd865d3f9c66b7f1c5f0cec26d3672cc131cc0994  go1.20.linux-arm64.tar.gz
</code></pre>
<pre><code>sudo tar -C /usr/local -xvf go1.20.linux-arm64.tar.gz
</code></pre>
<pre><code>sudo nano ~/.profile
</code></pre>
<p>Add following to end of the file and use ctl+x to save</p>
<pre><code>export PATH=$PATH:/usr/local/go/bin
</code></pre>
<p>Refresh your profile.</p>
<pre><code>source ~/.profile 
</code></pre>
<p>Logout of ubuntu and then back in again to force a profile refresh. Check the version of go that is installed</p>
<pre><code>go version
</code></pre>
<p>The version output should read as</p>
<pre><code>go version go1.20 linux/arm64
</code></pre>
<p>That's it! You should be able to clone this repo and build your own Kaspa Docker image.</p>
</br>


<h2>Build and run the docker image on your pi</h2>

<pre><code>git clone https://github.com/nwbower/pi-docker-kaspad.git
</code></pre>
<p>Change directory</p>
<pre><code>cd pi-docker-kaspad
</code></pre>
<p>Build the image</p>
<pre><code>docker build -t kaspad .
</code></pre>
<p>When you are ready, run the container to start the node</p>
<pre><code>docker-compose up -d
</code></pre>
</br>

<h2>*Pro Tip</h2>
<p>Raspberry Pi gets hot if it’s enclosed in a case without heat sinks. Use a proper heat sink with good ventilation to keep temperatures under control. There are some great cases built as a heat sink. I use and really like the <a href="https://flirc.tv/products/flirc-raspberrypi4-silver?variant=43085036454120">flirc</a>.</p>
<p>You can check the temperature as well as the clock speed in ubuntu to investigate overheating and or potential thermal throttling issues. I've not had any issues with the flirc case.</p>
<h3>Check temperature:</h3>
<p>(result example 53069 means 53ºC)</p>
<pre><code>sudo cat /sys/class/thermal/thermal_zone0/temp</code></pre>
<h3>Check clock speed (MHz):</h3>
<p>(result example 1500000 means 1500Mhz)</p>
<pre><code>sudo cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq</code></pre>
</br>

<h2>Advanced: Run 2 independent instances, persistent storage and a load balancer using Docker Compose</h2>
<p>HAProxy is used as loadbalancer, and the configuration is included in the kaspad_loadbalancer image (see git repo for details).<br>
The HAProxy stats page is mapped to 9000 per default.</p>
<p>docker-compose.yaml:</p>
<pre><code>version: "3"

services:
  kaspad1:
    container_name: kaspad1
    image: nwbower/pi-kaspad:latest
    restart: unless-stopped
    volumes:
      - kaspad1:/app/data/
\#    command: /app/kaspad --utxoindex --enablebanning --whitelist=192.168.1.0/24

  kaspad2:
    container_name: kaspad2
    image: nwbower/pi-kaspad:latest
    restart: unless-stopped
    volumes:
      - kaspad2:/app/data/
\#    command: /app/kaspad --utxoindex --enablebanning --whitelist=192.168.1.0/24

  kaspad_loadbalancer:
    container_name: kaspad_loadbalancer
    image: supertypo/kaspad_loadbalancer:latest
    restart: unless-stopped
    ports:
      - "9000:9000/tcp"
      - "16110:16110/tcp"
      - "16111:16111/tcp"
    links:
      - kaspad1
      - kaspad2

volumes:
  kaspad1:
  kaspad2:
</code></pre>
<p>Run/upgrade with: <code>sudo docker-compose pull &amp;&amp; sudo docker-compose up -d</code></p>
<h3>Resync example (resync node nr. 1 - without downtime)</h3>
<pre><code>sudo docker rm -f kaspad1
sudo docker volume rm docker-kaspad_kaspad1
sudo docker-compose up -d
</code></pre>