#!/bin/sh
set -eu
f=/usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js
before=$(md5sum <"$f")
perl -0pi -e 's|(?<!//)(Ext\.Msg\.show\(\{\s+title: gettext\(\x27No valid sub)|void({ //$1|g' "$f"
after=$(md5sum <"$f")
if [ "$before" != "$after" ]; then
  echo patched
  systemctl restart pveproxy
fi
