# makefile to make m3u play list using mk_m3u

list_files = $(wildcard *.list)
play_lists = $(patsubst %.list,%.m3u8,$(list_files))
script_file = mk_m3u.sh

# current directory
# audio files are assumed to locate in parent(..) directory
cd := $(shell basename `pwd`)

#default target
all: $(play_lists)

$(play_lists) : $(script_file)

%.m3u8: %.list
	cd ..; $(cd)/$(script_file) $(cd)/$<

.PHONY: clean
clean:
	rm -f $(play_lists)

.PHONY: files
files:
	@echo list files: $(list_files)
	@echo play lists: $(play_lists)
