#/bin/bash

IFS=$'\n'

excluding=0
excludes=()

type_filter() {
  for type in wma mp3
  do
    if [[ "$1" == *.${type} ]]
    then
      return 0
    fi
  done
  return 1
}

file_filter() {
  for exclude in ${excludes[@]}
  do
    if [[ "$1" == "${exclude}" ]]
    then
      return 1
    fi
  done
  return 0
}

make_filter() {
  case "$1" in
    -* ) excluding=1;;
    +* ) excluding=0;;
    *  )
      if [ ${excluding} == 1 ]
      then
        excludes+=("$1")
      else
        return 0
      fi;;
  esac
  return 1
}

out=${1%.*}.m3u8
rm -f ${out}
while read dir
do
  if [ -n "${dir}" ] && make_filter "${dir}"
  then
    if [ -d "${dir}" ]
    then
      for file in `ls -1 "${dir}"`
      do
        path=${dir}/${file}
        if type_filter "${file}" && file_filter "${path}"
        then
          echo ${path} >> ${out}
        fi
      done
    else
      echo ${dir} >> ${out}
    fi
  fi
done < $1

ls -l ${out}
