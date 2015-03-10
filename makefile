# makefile to make m3u play list using mk_m3u

list_files = $(wildcard *.list)
play_lists = $(patsubst %.list,%.m3u8,$(list_files))

# current directory
# audio files are assumed to locate in parent(..) directory
cd := $(shell basename `pwd`)

#default target
all: $(play_lists)

%.m3u8: %.list
	cd ..; $(cd)/mk_m3u.sh $(cd)/$<

.PHONY: clean
clean:
	rm -f $(play_lists)

.PHONY: files
files:
	@echo $(list_files)
	@echo $(play_lists)
