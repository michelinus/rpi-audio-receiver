#!/bin/bash -e

echo -n "Do you want to install Shairport Sync AirPlay Audio Receiver (shairport-sync v${SHAIRPORT_VERSION})? [y/N] "
read REPLY
if [[ ! "$REPLY" =~ ^(yes|y|Y)$ ]]; then exit 0; fi

apt install --no-install-recommends -y avahi-daemon libavahi-client3 libconfig9 libdaemon0 libjack-jackd2-0 libmosquitto1 libpopt0 libpulse0 libsndfile1 libsoxr0
dpkg -i shairport-sync_3.3.5-1~bpo10+1_armhf.deb
usermod -a -G gpio shairport-sync

PRETTY_HOSTNAME=$(hostnamectl status --pretty)
PRETTY_HOSTNAME=${PRETTY_HOSTNAME:-$(hostname)}

cat <<EOF > "${SHAIRPORT_SYSCONFDIR}/shairport-sync.conf"
general = {
  name = "${PRETTY_HOSTNAME}";
}

alsa = {
//  mixer_control_name = "Softvol";
}

sessioncontrol = {
  allow_session_interruption = "yes";
  session_timeout = 20;
};
EOF

systemctl enable --now shairport-sync
