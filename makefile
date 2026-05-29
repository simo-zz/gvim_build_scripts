VIM_DIR = ./vim/
v ?= 3
GUI = gtk-$(v)

NCPUS = $(shell cat /proc/cpuinfo  | grep processor | wc -l)

.PHONY: all update clean uninstall config compile install

all: update clean uninstall config compile install

clean:
	$(MAKE) -C $(VIM_DIR) clean distclean

uninstall: 
	sudo $(MAKE) -C $(VIM_DIR) uninstall


update:
	cd $(VIM_DIR); \
	if [ "$$(git branch | awk '{print $$2}')" != "master" ]; then \
		git checkout master; \
	fi; \
	git fetch --all --tags; \
	git pull
  	
config:
	cd $(VIM_DIR); \
	export CFLAGS="-Ofast"; \
	./configure \
	--prefix=/usr/local/ \
	--with-features=huge \
	--enable-$(GUI)-check \
	--enable-gui=$(GUI) \
	--enable-multibyte \
	--enable-wayland \
	--enable-fork \
	--enable-terminal=no \
	--enable-xim \
	--with-tlib=ncurses \
	--with-x \
	--enable-fontset \
	--enable-autoservername \
	--disable-rightleft \
	--disable-arabic \
	--disable-farsi \
	--enable-gpm=yes \
	--enable-cscope \
	--enable-year2038 \
	--with-gnome-includes=/usr/include/gtk-${v}.0 \
	--with-compiledby=simo.zz.dev@gmail.com

compile:
	$(MAKE) -C $(VIM_DIR) -j $(NCPUS)

install:
	sudo $(MAKE) -C $(VIM_DIR) install
