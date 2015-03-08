#/bin/bash

# Script to make m3u play list
#
# Usage mk_m3u list_file
#
# Makes m3u file contains file names in the directory specified in list_file.
# If a file name is specified instead of directory,
# the file name is output to m3u file.
#
# About "-" and "+" in list_file, see Excluding status below

# Only file that has following extension are recognized as a music file.
types=("wma" "mp3")

IFS=$'\n'

# Excluding status
# When "-" line appears, set to 1.
# When "+" line appears, reset to 0.
# If this is 1, following lines are added to excludes array.
excluding=0

# Array to hold exclude list.
# Lines that equal to one of entries in this array
# are not included in m3u file.
excludes=()

# Count of excluded/included lines
excluded=0
included=0

# Filters file by extension
# If extension of $1 is equal to one of entries in types array, returns 0
type_filter() {
  for type in ${types[@]}; do
    if [[ "$1" == *.${type} ]]; then
      return 0
    fi
  done
  return 1
}

# Filters file by excludes array
# If $1 is NOT equal to all entries in exclues array, returns 0
file_filter() {
  for exclude in ${excludes[@]}; do
    if [[ "$1" == "${exclude}" ]]; then
      excluded=$(($excluded+1))
      return 1
    fi
  done
  return 0
}

# Makes excludes array to be used by file_filter
# Adds file(s) following "-" line to excludes array
make_filter() {
  case "$1" in
    -* ) excluding=1;;
    +* ) excluding=0;;
    *  )
      if [ ${excluding} == 1 ]; then
        excludes+=("$1")
      else
        return 0
      fi;;
  esac
  return 1
}

out() {
  echo $1 >> ${out_file}
  included=$(($included+1))
}

out_file=${1%.*}.m3u8
rm -f ${out_file}
while read dir; do
  if [ -n "${dir}" ] && make_filter "${dir}"; then
    if [ -d "${dir}" ]; then
      for file in `ls -1 "${dir}"`; do
        path=${dir}/${file}
        if type_filter "${file}" && file_filter "${path}"; then
          out ${path}
        fi
      done
    else
      out ${dir}
    fi
  fi
done < $1

echo "out $included line(s), excluded $excluded line(s)"
ls -l ${out_file}
