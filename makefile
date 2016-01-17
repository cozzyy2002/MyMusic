# makefile to make m3u play list from mk_m3u

list_file_type = list
play_list_type = m3u8

list_files = $(shell ls *.$(list_file_type))
play_lists = $(patsubst %.$(list_file_type),%.$(play_list_type),$(list_files))
script_file = mk_m3u.sh

# current directory
# audio files are assumed to locate in parent(..) directory
cd := $(shell basename `pwd`)

#default target
all.$(play_list_type): $(play_lists)
	rm -f $@
	cat $^ >> $@

$(play_lists) : $(script_file)

%.$(play_list_type): %.$(list_file_type)
	cd ..; $(cd)/$(script_file) $(cd)/$<

.PHONY: clean
clean:
	rm -f $(play_lists)

.PHONY: files
files:
	ls -l $(list_files) $(play_lists)
