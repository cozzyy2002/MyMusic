list_files = Fusion.list  IdleCollection.list  Oldies.list Rock.list
play_lists = $(patsubst %.list,%.m3u8,$(list_files))

cd := $(shell basename `pwd`)

all: $(play_lists)

%.m3u8: %.list
	cd ..; $(cd)/mk_m3u.sh $(cd)/$<

show:
	: $(play_lists)
	: $(list_files)
