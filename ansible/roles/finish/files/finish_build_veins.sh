#!/bin/bash
# build veins
source ~/.shrc
cd ~/src/veins
./configure
make -j2

# build doxygen for veins
source ~/.shrc
cd ~/src/veins
make doxy

# build veins INET
source ~/.shrc
cd ~/src/veins/subprojects/veins_inet
./configure
make -j2

# import veins into workspace
cd ~/src/veins
source ~/.shrc
xvfb-run ~/src/omnetpp/ide/omnetpp -data ~/workspace.omnetpp -nosplash -application org.eclipse.cdt.managedbuilder.core.headlessbuild -import .

# import INET into veins
cd ~/src/veins/subprojects/veins_inet
source ~/.shrc
xvfb-run ~/src/omnetpp/ide/omnetpp -data ~/workspace.omnetpp -nosplash -application org.eclipse.cdt.managedbuilder.core.headlessbuild -import .

# add setenv script
STRING='cd "$HOME/src/veins" && . ./setenv > /dev/null; cd - > /dev/null'
FILE="~/.shrc"
if not grep -q "$STRING" "$FILE"; then
    echo $STRING >> ~/.shrc
fi