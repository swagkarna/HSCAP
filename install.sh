#!/bin/bash

sudo rm -rf /tmp/HSCAP/ 2> /dev/null

sudo cp -r ../HSCAP/ /tmp/HSCAP/ 2> /dev/null

sudo rm -rf /bin/hscap 2> /dev/null

cat >"/bin/hscap" <<-EOF
  sudo bash /tmp/HSCAP/main.sh
EOF

sudo chmod +x /bin/hscap
