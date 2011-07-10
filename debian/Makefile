# 2011-07-09  Michele Tavella <michele.tavella@epfl.ch>

all: clean copy deb

copy:
	rsync -av ../ eegc3/opt/ \
		--exclude debian \
		--exclude .git \
		--exclude .dummy \
		--delete-excluded

deb:
	 dpkg --build eegc3

clean:
	rm -fv *.deb
	rm -frv eegc3/opt/*
