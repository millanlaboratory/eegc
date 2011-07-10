# 2011-07-09  Michele Tavella <michele.tavella@epfl.ch>

all: 

copy:
	rsync -av ../ eegc3/DEBIAN/opt/ --exclude debian --exclude git --delete-excluded

dist-deb:
	 dpkg --build eegc3

clean:
	rm -v *.deb
	rm -rv eegc3/DEBIAN/opt/*
