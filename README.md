# HSCAP

This script was beautifully made by MidNightSonne (me), it is supposed to send deauth packages to a Internet AP and capture the HandShake file.

### Prerequisites

What things you need to install the software and how to install them

```
mdk3          - sudo apt-get install mdk3
mdk4          - sudo apt-get install mdk4
aircrack      - sudo apt-get install aircrack-ng
xterm         - sudo apt-get install xterm
xset          - sudo apt-get install x11-xserver-utils
```

### Installing

You can launch the script with just these commands:

```
cd /folder/where/HSCAP/is/located/at

sudo bash main.sh
```

The script should launch normally after these commands.

Also, there is no oficial way to install HSCAP, for now...

### You Can Edit The Script Yourself

There's four arguments that you can edit yourself for better use of the HSCAP script...

```
# - Amount Of Time Given To Mdk3 For It To Kick Clients From The Network - Default value "12"
TimeAttack=12

# - Amount Of Time Given To AiroDump For It To Capture The HandShake - Default value "24"
TimeCapture=24

# - Set XTerm Geometry Values ( Width And Height ) - Default value "100x25"
XTermGeometry=100x25

# - Which Attack Mode To Use - "mdk3" "mdk4" "aireplay" - Default value "mdk3"
AttackMode=mdk3
```
Each one has a very specific task on HSCAP, so don't leave them with nothing on.

## Authors

* **Anderson L Polo A** - *Initial work* - [MidNightSonne](https://github.com/midnightsonne)

## License

This project is licensed under the **GPL v3.0** License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* My ex GitHub account MidNightSun
