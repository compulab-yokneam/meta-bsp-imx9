# Copyright 2021 CompuLab

do_install:prepend() {
	sed -i "s/\(\"compatible.*imx93.*\)\",/\1, ${MACHINE}\", /g" ${WORKDIR}/demos/demos.json # Make it work with the ucm-imx93 boards
	sed -i "s/2.8.0/2.9.1/g" ${WORKDIR}/demos/downloads.txt
}

