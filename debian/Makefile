# 2011-07-09  Michele Tavella <michele.tavella@epfl.ch>

all: clean copy deb

copy:
	mkdir -pv eegc3/opt/eegc3
	rsync -av ../ eegc3/opt/eegc3/ \
		--exclude debian \
		--exclude .git \
		--exclude .dummy \
		--delete-excluded

deb:
	 dpkg --build eegc3

clean:
	rm -fv *.deb
	rm -frv eegc3/opt/*
