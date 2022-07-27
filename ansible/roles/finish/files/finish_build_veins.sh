#!/bin/bash
(# build veins
source ~/.shrc
cd ~/src/veins
./configure
make -j2

echo "40";
echo "# Build doxygen for veins";

# build doxygen for veins
source ~/.shrc
cd ~/src/veins
make doxy

echo "50";
echo "# Build veins INET";

# build veins INET
source ~/.shrc
cd ~/src/veins/subprojects/veins_inet
./configure
make -j2

echo "60";
echo "# Import veins into workspace";

# import veins into workspace
cd ~/src/veins
source ~/.shrc
xvfb-run ~/src/omnetpp/ide/omnetpp -data ~/workspace.omnetpp -nosplash -application org.eclipse.cdt.managedbuilder.core.headlessbuild -import .

echo "70";
echo "# Import INET into veins";

# import INET into veins
cd ~/src/veins/subprojects/veins_inet
source ~/.shrc
xvfb-run ~/src/omnetpp/ide/omnetpp -data ~/workspace.omnetpp -nosplash -application org.eclipse.cdt.managedbuilder.core.headlessbuild -import .

echo "90";
echo "# add setenv script";

# add setenv script
STRING='cd "$HOME/src/veins" && . ./setenv > /dev/null; cd - > /dev/null'
FILE="~/.shrc"
if not grep -q "$STRING" "$FILE"; then
    echo $STRING >> ~/.shrc
fi

echo "100";
echo "# Finished";

) |
zenity --progress \
    --title="Finish veins build" \
    --text="Build veins" \
    --percentage=0