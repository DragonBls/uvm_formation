#!/usr/bin/env bash

set -e

dest_dir="$1"


#--------------------------------------------------------------
# functions
#--------------------------------------------------------------
error() {
  >&2 echo "ERROR: $@"
  exit 1
}

usage() {
  echo "usage: ./$(basename $0) dest_dir"
}

get_abs_path() {
  local d="$1"
  local d_abs
  d_abs="$(readlink -e $d)" || error "$d does not exist"
  echo $d_abs
}

exclude_files() {
  local top_dir="$1"
  shift 1
  cd $top_dir
  local pattern
  for pattern in $@; do
    rm -rf $(find -name $pattern)
  done
  cd - > /dev/null
}

remove_sections() {
  local top_dir="$1"
  local pragma="REMOVE_SECTION"
  local files
  local start_pragma="__START_${pragma}__"
  local end_pragma="__END_${pragma}__"
  cd $top_dir
  while true; do
    files="$(grep -rl $start_pragma)"
    [ "$files" = "" ] && break
    for f in $files; do
      start_line="$(grep -hn $start_pragma $f | sed 's/:.*//' | head -n1)"
      end_line="$(grep -hn $end_pragma $f | sed 's/:.*//' | head -n1)"
      sed -i "$start_line,${end_line}d" $f
    done
  done
  cd - > /dev/null
}


#--------------------------------------------------------------
# execution
#--------------------------------------------------------------
if ! [ -d "$dest_dir" ]; then
  usage
  error "dest_dir=$dest_dir does not exist"
fi

src_dir="$(dirname $0)"
src_dir_abs="$(get_abs_path $src_dir)"
dest_dir_abs="$(get_abs_path $dest_dir)"
[ "$dest_dir_abs" = "$src_dir_abs" ] && error "src and dest dir cannot be the same"

cd $src_dir_abs
rsync -avzpq --files-from=<(git ls-files) . $dest_dir_abs

exclude_files $dest_dir_abs "generated_tb" ".git*" "fifo_*.tpl" "pinlist" || error "exclude_files failed"
remove_sections $dest_dir_abs || error "remove_sections failed"
