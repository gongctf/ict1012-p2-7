#!/bin/sh
sysctl_orig="$(sysctl net.ipv4.ip_unprivileged_port_start | awk '{printf $3}')"
sysctl_new=80
script_dir="$(dirname "$0")"
echo "Original: net.ipv4.ip_unprivileged_port_start=$sysctl_orig"
echo "Reconfiguring to: net.ipv4.ip_unprivileged_port_start=$sysctl_new"
sudo sysctl net.ipv4.ip_unprivileged_port_start="$sysctl_new"
openssl req -x509 -newkey rsa:4096 -keyout "$script_dir"/config/key.pem -out "$script_dir"/config/cert.pem -sha256 -days 365 -nodes -subj '/C=SG/L=Singapore/O=ICT1012 P2-7 2026/CN=p272026.sitict.net/'
podman build --tag=ict1012-p2-7/web-server "$script_dir"/.
podman run --rm --publish=80:80 --publish=443:443 ict1012-p2-7/web-server
echo "Reverting to original: net.ipv4.ip_unprivileged_port_start=$sysctl_orig"
sudo sysctl net.ipv4.ip_unprivileged_port_start="$sysctl_orig"
echo "Done."
