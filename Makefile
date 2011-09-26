#2011-09-26  Michele Tavella <michele.tavella@epfl.ch>

all:

install:
	mkdir -p $(DESTDIR)/opt/eegc3/
	rsync -a --delete $(PWD)/ $(DESTDIR)/opt/eegc3/ \
		--exclude ".git" --exclude "debian"
