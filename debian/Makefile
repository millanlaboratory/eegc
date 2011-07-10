# 2011-07-09  Michele Tavella <michele.tavella@epfl.ch>

all: clean copy deb

copy:
	rsync -av ../ eegc3/DEBIAN/opt/ --exclude debian --exclude git --delete-excluded

deb:
	 dpkg --build eegc3

clean:
	rm -fv *.deb
	rm -frv eegc3/DEBIAN/opt/*
