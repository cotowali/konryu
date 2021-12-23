#!/bin/sh


# -- start builtin --
#
# Copyright (c) 2021 zakuro <z@kuro.red>. All rights reserved.
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.


cotowali_true_value() {
	echo 'true'
}

cotowali_false_value() {
	echo 'false'
}


array_to_str() {
  name=$1
  echo "$( eval echo $(array_elements $name) )"
}

array_get() {
  name=$1
  i=$2
  eval echo "\$${name}_$i"
}

array_set() {
  name=$1
  i=$2
  val=$3
  eval "${name}_$i='$val'"
}

array_push() {
	name=$1
	value=$2

	array_set $name $(( ${name}_len )) "$value"
  eval "${name}_len=$(( ${name}_len + 1 ))"
}

array_push_array() {
  name="$1"
  values_name="$2"
	values_len=$(( ${values_name}_len ))

  push_array_i=0
  while [ "$push_array_i" -lt "$values_len" ]
  do
		array_push "$name" "$(array_get $values_name $push_array_i)"
    push_array_i=$((push_array_i + 1))
  done
}

array_len() {
  name="$1"
  eval "echo \$${name}_len"
}

array_elements() {
  name=$1
  len="$(array_len $name)"

  i=0
  while [ "$i" -lt "$len" ]
  do
    elem="${name}_$i"
    printf '"$%s"' "$elem"
    if [ "$i" -ne "$(( len - 1 ))" ]
    then
      printf ' '
    fi
    i=$((i + 1))
  done
}

array_assign() {
  name=$1
  shift
  len="$#"
  eval "${name}_len=$len"

  i=0
  while [ "$i" -lt "$len" ]
  do
    array_set "$name" "$i" "$(eval echo "\$$(( i + 1 ))")"
    i=$((i + 1))
  done
}

array_init() {
  name=$1
  len=$2
  value=$3

  eval "${name}_len=$len"
  i=0
  while [ "$i" -lt "$len" ]
  do
    array_set "$name" "$i" "$value"
    i=$((i + 1))
  done
}

array_copy() {
  dest_name="$1"
  src_name="$2"
  len="$(array_len $src_name)"
  eval "${dest_name}_len=$len"

  i=0
  while [ "$i" -lt "$len" ]
  do
    array_set "$dest_name" "$i" "$(array_get "$src_name" $i)"
    i=$((i + 1))
  done
}

map_keys_var() {
  echo "__cotowali_meta_map_keys_$1"
}

map_keys() {
  eval echo "\$$(map_keys_var $1)"
}

map_entries() {
  name="$1"
  for key in $(map_keys $name)
  do
    printf
  done
}

map_copy() {
  dst="$1"
  src="$2"
  for key in $(map_keys "$src")
  do
    value="$(map_get "$src" "$key")"
    map_set "$dst" "$key" "$value"
  done
}

map_get() {
  name=$1
  key=$2
  eval echo "\$${name}_$key"
}

map_set() {
  name=$1
  key=$2
  value=$3
  eval "${name}_$key=$value"
  eval "$(map_keys_var $name)=\"$({ map_keys $name; echo $key; } | sort | uniq )\""
}

# -- end builtin --

# file: konryu.li
# file: /home/zakuro/src/github.com/cotowali/cotowali/std/builtin.li
# Copyright (c) 2021 zakuro <z@kuro.red>. All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
print() {
  print_s="$1"
   printf '%s' "$print_s" 
}
println() {
  println_s="$1"
   printf '%s\n' "$println_s" 
}
eprint() {
  eprint_s="$1"
   printf '%s' "$eprint_s" >&2 
}
eprintln() {
  eprintln_s="$1"
   printf '%s\n' "$eprintln_s" >&2 
}
isatty() {
  isatty_fd="$1"
  isatty_true_='true'
  isatty_res='false'
  
    if [ -t $isatty_fd ]
    then
      isatty_res=$isatty_true_
    fi
  
  echo "${isatty_res}"
  return 0
}
_cotowali_tmp_0='/dev/tty'

tty="$_cotowali_tmp_0"
input() {
  input_prompt="$1"
  if "$(isatty 0)" && [ "${input_prompt}"  !=  '' ]
  then
    print "${input_prompt}" > "${tty}"
  fi
  input_res=
  
    read -r input_res
  
  echo "${input_res}"
  return 0
}
input_tty() {
  input_tty_prompt="$1"
  if [ "${input_tty_prompt}"  !=  '' ]
  then
    print "${input_tty_prompt}" > "${tty}"
  fi
  input_tty_res=
  
    read -r input_tty_res < $tty
  
  echo "${input_tty_res}"
  return 0
}
head96e89a298e0a9f469b9ae458d6afae9f() {
  head_n="$1"
   head -n $head_n 
}
first8b04d5e3775d298e78455efc5ca404d5() {
   head -n 1 
}
tail7aea2552dfe7eb84b9443b6fc9ba6e01() {
  tail_n="$1"
   tail -n $tail_n 
}
last98bd1c45684cf587ac2347a92dd7bb51() {
   tail -n 1 
}
count() {
   wc -l 
}
sequence() {
  array_assign "_cotowali_tmp_1" "$@"
  array_copy "sequence_elements" "_cotowali_tmp_1"
  for _cotowali_tmp_2 in $(array_elements sequence_elements)
  do
    sequence_for_2_elem="$(eval echo $_cotowali_tmp_2)"
    echo "${sequence_for_2_elem}"
  done
}
join() {
  join_sep="$1"
  join_ret=''
  set -- 0 
  join_i="$1"
  join_s="$2"
  while read join_s
  do
    if [ "${join_i}" -gt 0 ]
    then
      join_ret="${join_ret}""${join_sep}"
    fi
    join_ret="${join_ret}""${join_s}"
    join_i=$(( join_i += 1 ))
  done
  echo "${join_ret}"
  return 0
}
range() {
  range_begin="$1"
  shift
  range_end="$1"
  for _cotowali_tmp_3 in $(seq $(( range_end - range_begin )))
  do
    range_for_5_i="$(eval echo $_cotowali_tmp_3)"
    echo $((  (range_for_5_i ) + range_begin - 1 ))
  done
}

# info: fn exit(code)


# info: fn cat(files)


# info: fn seq(n)


# info: fn basename(path)


# info: fn cd(path)


# info: fn dirname(path)


# info: fn cp(args)

cp_r() {
  array_assign "_cotowali_tmp_4" "$@"
  array_copy "cp_r_args" "_cotowali_tmp_4"
  
    cp -r "$@"
  
}

# info: fn mkdir(args)

mkdir_p() {
  array_assign "_cotowali_tmp_5" "$@"
  array_copy "mkdir_p_args" "_cotowali_tmp_5"
  
    mkdir -p "$@"
  
}
pwd9003d1df22eb4d3820015070385194c8() {
   pwd 
}

# info: fn ls(files)


# info: fn rm(paths)

rm_r() {
  array_assign "_cotowali_tmp_6" "$@"
  array_copy "rm_r_paths" "_cotowali_tmp_6"
   rm -r "$@" 
}

# info: fn touch(files)

which8b7af514f25f1f9456dcd10d2337f753() {
  which_name="$1"
  which_res=
  
    which_res=$(which $which_name)
    if [ $? -ne 0 ]
    then
      which_res=''
    fi
  
  echo "${which_res}"
  return 0
}
filter() {
  filter_pat="$1"
   grep '-E' "$filter_pat" 
}
replace() {
  replace_old="$1"
  shift
  replace_new="$1"
  _cotowali_tmp_7='s/\\/\\\\/g'

  replace_pattern="$(echo "${replace_old}" | sed "$_cotowali_tmp_7" )"
  
    awk -v old="$replace_pattern" -v "new=$replace_new" '{gsub(old, new); print $0}'
  
}
string__replace() {
  string__replace_s="$1"
  shift
  string__replace_old="$1"
  shift
  string__replace_new="$1"
  _cotowali_tmp_8='s/\\/\\\\/g'

  string__replace_pattern="$(echo "${string__replace_old}" | sed "$_cotowali_tmp_8" )"
  _cotowali_tmp_15='{gsub(old, new); print $0}'

  _cotowali_tmp_14="new=${string__replace_new}"

  _cotowali_tmp_13='-v'

  _cotowali_tmp_12="old=${string__replace_pattern}"

  _cotowali_tmp_11='-v'

  _cotowali_tmp_10='RS=""'

  _cotowali_tmp_9='-v'

  print "${string__replace_s}" | awk "$_cotowali_tmp_9" "$_cotowali_tmp_10" "$_cotowali_tmp_11" "$_cotowali_tmp_12" "$_cotowali_tmp_13" "$_cotowali_tmp_14" "$_cotowali_tmp_15"
  return 0
}
string__substr() {
  string__substr_s="$1"
  shift
  string__substr_i="$1"
  shift
  string__substr_n="$1"
  if [ "${string__substr_n}" -le 0 ]
  then
    echo ''
    return 0
  fi
  _cotowali_tmp_22='{print substr($0, m, n)}'

  _cotowali_tmp_21="n=${string__substr_n}"

  _cotowali_tmp_20='-v'

  _cotowali_tmp_19="m=$(( string__substr_i + 1 ))"

  _cotowali_tmp_18='-v'

  _cotowali_tmp_17='RS=""'

  _cotowali_tmp_16='-v'

  echo "$(echo "${string__substr_s}" | awk "$_cotowali_tmp_16" "$_cotowali_tmp_17" "$_cotowali_tmp_18" "$_cotowali_tmp_19" "$_cotowali_tmp_20" "$_cotowali_tmp_21" "$_cotowali_tmp_22" )"
  return 0
}
string__index() {
  string__index_s="$1"
  shift
  string__index_t="$1"
  if [ "$(string__len "${string__index_t}")" -eq 0 ]
  then
    echo 0
    return 0
  fi
  _cotowali_tmp_27='{print index($0, t) - 1}'

  _cotowali_tmp_26="t=${string__index_t}"

  _cotowali_tmp_25='-v'

  _cotowali_tmp_24='RS=""'

  _cotowali_tmp_23='-v'

  echo "$(echo "${string__index_s}" | awk "$_cotowali_tmp_23" "$_cotowali_tmp_24" "$_cotowali_tmp_25" "$_cotowali_tmp_26" "$_cotowali_tmp_27" )"

  return 0
}
string__last_index() {
  string__last_index_s="$1"
  shift
  string__last_index_t="$1"
  string__last_index_s_len="$(string__len "${string__last_index_s}")"
  if [ "$(string__len "${string__last_index_t}")" -eq 0 ]
  then
    echo "${string__last_index_s_len}"
    return 0
  fi
  string__last_index_last_i=$(( -1 * 1 ))
  string__last_index_rest="${string__last_index_s}"
  while 'true'
  do
    string__last_index_while_9_i="$(string__index "${string__last_index_rest}" "${string__last_index_t}")"
    if [ "${string__last_index_while_9_i}" -lt 0 ]
    then
      break
    fi
    string__last_index_last_i=$(( string__last_index_while_9_i +  (string__last_index_s_len - $(string__len "${string__last_index_rest}") ) ))
    string__last_index_rest="$(string__substr "${string__last_index_rest}" $(( string__last_index_while_9_i + $(string__len "${string__last_index_t}") )) "$(string__len "${string__last_index_rest}")")"
  done
  echo "${string__last_index_last_i}"
  return 0
}
string__len() {
  string__len_s="$1"
  string__len_n=0
   string__len_n=${#string__len_s} 
  echo "${string__len_n}"
  return 0
}
lines() {
  read _cotowali_tmp_28
  lines_s="$_cotowali_tmp_28"
  echo "${lines_s}" | cat
  return 0
}
string__lines() {
  string__lines_s="$1"
  echo "${string__lines_s}" | lines
  return 0
}
string__starts_with() {
  string__starts_with_s="$1"
  shift
  string__starts_with_ss="$1"
  if [ "$(string__len "${string__starts_with_ss}")" -eq 0 ]
  then
    echo 'true'
    return 0
  fi
  if [ "$(string__len "${string__starts_with_ss}")" -gt "$(string__len "${string__starts_with_s}")" ]
  then
    echo 'false'
    return 0
  fi
  if [ "${string__starts_with_ss}"  =  "${string__starts_with_s}" ]
  then
    echo 'true'
    return 0
  fi
  echo "$( [ "$(string__index "${string__starts_with_s}" "${string__starts_with_ss}")" -eq 0 ] && echo 'true' || echo 'false' )"
  return 0
}
string__ends_with() {
  string__ends_with_s="$1"
  shift
  string__ends_with_ss="$1"
  if [ "$(string__len "${string__ends_with_ss}")" -eq 0 ]
  then
    echo 'true'
    return 0
  fi
  if [ "$(string__len "${string__ends_with_ss}")" -gt "$(string__len "${string__ends_with_s}")" ]
  then
    echo 'false'
    return 0
  fi
  if [ "${string__ends_with_ss}"  =  "${string__ends_with_s}" ]
  then
    echo 'true'
    return 0
  fi
  echo "$( [ "$(string__last_index "${string__ends_with_s}" "${string__ends_with_ss}")" -eq $(( $(string__len "${string__ends_with_s}") - $(string__len "${string__ends_with_ss}") )) ] && echo 'true' || echo 'false' )"
  return 0
}
string__trim_prefix() {
  string__trim_prefix_s="$1"
  shift
  string__trim_prefix_prefix="$1"
  if ! { "$(string__starts_with "${string__trim_prefix_s}" "${string__trim_prefix_prefix}")" ; }
  then
    echo "${string__trim_prefix_s}"
    return 0
  fi
  string__substr "${string__trim_prefix_s}" "$(string__len "${string__trim_prefix_prefix}")" "$(string__len "${string__trim_prefix_s}")"
  return 0
}
string__trim_suffix() {
  string__trim_suffix_s="$1"
  shift
  string__trim_suffix_suffix="$1"
  if ! { "$(string__ends_with "${string__trim_suffix_s}" "${string__trim_suffix_suffix}")" ; }
  then
    echo "${string__trim_suffix_s}"
    return 0
  fi
  string__substr "${string__trim_suffix_s}" 0 $(( $(string__len "${string__trim_suffix_s}") - $(string__len "${string__trim_suffix_suffix}") ))
  return 0
}
string__trim_start() {
  string__trim_start_s="$1"
  _cotowali_tmp_29='s/^[[:space:]]*//'

  echo "${string__trim_start_s}" | sed "$_cotowali_tmp_29"
  return 0
}
string__trim_end() {
  string__trim_end_s="$1"
  _cotowali_tmp_30='s/[[:space:]]*$//'

  echo "${string__trim_end_s}" | sed "$_cotowali_tmp_30"
  return 0
}
string__trim() {
  string__trim_s="$1"
  string__trim_end "$(string__trim_start "${string__trim_s}")"
  return 0
}
string__contains() {
  string__contains_s="$1"
  shift
  string__contains_substr="$1"
  echo "$( [ "$(string__index "${string__contains_s}" "${string__contains_substr}")" -ge 0 ] && echo 'true' || echo 'false' )"
  return 0
}
__array__any__len() {
  array_copy "__array__any__len_arr" "$1"
  __array__any__len_n=0
   __array__any__len_n=$(array_len __array__any__len_arr) 
  echo "${__array__any__len_n}"
  return 0
}
__array__string__join() {
  array_copy "__array__string__join_ss" "$1"
  shift
  __array__string__join_sep="$1"
  if [ "$(__array__any__len __array__string__join_ss)" -eq 0 ]
  then
    echo ''
    return 0
  fi
  __array__string__join_ret=
  for _cotowali_tmp_31 in $(range 0 "$(__array__any__len __array__string__join_ss)")
  do
    __array__string__join_for_20_i="$(eval echo $_cotowali_tmp_31)"
    if [ "${__array__string__join_for_20_i}" -gt 0 ]
    then
      __array__string__join_ret="${__array__string__join_ret}""${__array__string__join_sep}"
    fi
    __array__string__join_ret="${__array__string__join_ret}""$(array_get __array__string__join_ss "${__array__string__join_for_20_i}" )"
  done
  echo "${__array__string__join_ret}"
  return 0
}
# file: /home/zakuro/src/github.com/cotowali/cotowali/std/cotowali.li
# file: /home/zakuro/src/github.com/cotowali/cotowali/std/platform.li
# platform.li
# Copyright (c) 2021 zakuro <z@kuro.red>. All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
platform_has_command() {
  platform_has_command_command="$1"
  platform_has_command_code=0
  
      type $platform_has_command_command > /dev/null 2>&1
        platform_has_command_code=$?
    
  echo "$( [ "${platform_has_command_code}" -eq 0 ] && echo 'true' || echo 'false' )"
  return 0
}
platform_require_command() {
  platform_require_command_command="$1"
  if "$(platform_has_command "${platform_require_command_command}")"
  then

    return 0
  fi
  platform_required_command_not_found "${platform_require_command_command}"
}
platform_required_command_not_found() {
  platform_required_command_not_found_command="$1"
  _cotowali_tmp_32="${platform_required_command_not_found_command}: command not found"

  eprintln "$_cotowali_tmp_32"
  exit 127
}
platform_uname() {
   uname -a 
}
platform_system() {
  platform_system_res=''
   platform_system_res="$(uname -s)" 
  echo "${platform_system_res}"
  return 0
}
platform_machine() {
   uname -m 
}
platform_is_windows() {
  _cotowali_tmp_33='Windows'

  echo "$( [ "$(platform_system)"  =  "$_cotowali_tmp_33" ] && echo 'true' || echo 'false' )"
  return 0
}
platform_is_linux() {
  _cotowali_tmp_34='Linux'

  echo "$( [ "$(platform_system)"  =  "$_cotowali_tmp_34" ] && echo 'true' || echo 'false' )"
  return 0
}
platform_is_darwin() {
  _cotowali_tmp_35='Darwin'

  echo "$( [ "$(platform_system)"  =  "$_cotowali_tmp_35" ] && echo 'true' || echo 'false' )"
  return 0
}
platform_is_busybox() {
  if [ $# -eq 0 ]
  then
    platform_is_busybox_name=''
  else
    platform_is_busybox_name="$1"
  fi
  if [ "${platform_is_busybox_name}"  =  '' ]
  then
    _cotowali_tmp_36='realpath'

    platform_is_busybox_name="$_cotowali_tmp_36"
  fi
  if "$(platform_has_command "${platform_is_busybox_name}")"
  then
    platform_is_busybox_if_2_help_text=''
     platform_is_busybox_if_2_help_text=$($platform_is_busybox_name 2>&1 | head -n 1) 
    _cotowali_tmp_37='BusyBox'

    string__contains "${platform_is_busybox_if_2_help_text}" "$_cotowali_tmp_37"
    return 0
  fi
  echo 'false'
  return 0
}
platform_does_not_support_windows() {
  platform_does_not_support_windows_name="$1"
  if "$(platform_is_windows)"
  then
    _cotowali_tmp_38="${platform_does_not_support_windows_name} does not support windows for now"

    eprintln "$_cotowali_tmp_38"
    exit 1
  fi
}
platform_does_not_support_busybox() {
  platform_does_not_support_busybox_name="$1"
  shift
  if [ $# -eq 0 ]
  then
    platform_does_not_support_busybox_command=''
  else
    platform_does_not_support_busybox_command="$1"
  fi
  if "$(platform_is_busybox "${platform_does_not_support_busybox_command}")"
  then
    _cotowali_tmp_39="${platform_does_not_support_busybox_name} does not support busybox for now"

    eprintln "$_cotowali_tmp_39"
    exit 1
  fi
}
platform_shell() {
  _cotowali_tmp_40='sh'

  echo "$_cotowali_tmp_40"
  return 0
}
_cotowali_tmp_41="cotowali_$(platform_system)_$(platform_machine).tar.gz"

cotowali_release_archive_name="$_cotowali_tmp_41"
# file: /home/zakuro/src/github.com/cotowali/cotowali/std/os.li
# os.li
# Copyright (c) 2021 zakuro <z@kuro.red>. All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
array_init "os_args" 0

    array_assign os_args "$0" "$@"
  
os_getenv() {
  os_getenv_key="$1"
  os_getenv_value=''
   os_getenv_value=$(printenv $os_getenv_key) 
  echo "${os_getenv_value}"
  return 0
}
os_setenv() {
  os_setenv_key="$1"
  shift
  os_setenv_value="$1"
   export $os_setenv_key=$os_setenv_value 
}
os_unsetenv() {
  os_unsetenv_key="$1"
   unset -v $os_unsetenv_key 
}
os_symlink() {
  os_symlink_src="$1"
  shift
  os_symlink_dest="$1"
  if "$(platform_is_windows)"
  then
    _cotowali_tmp_42='symlink does not supports windows for now'

    eprintln "$_cotowali_tmp_42"
    exit 1
  fi
  if "$(os_path_exists "${os_symlink_dest}")"
  then
    _cotowali_tmp_43="Filed to create symbolic link \`${os_symlink_dest}\`: File exists"

    echo "$_cotowali_tmp_43" > /dev/null

    return 0
  fi
  _cotowali_tmp_44='-s'

  ln "$_cotowali_tmp_44" "${os_symlink_src}" "${os_symlink_dest}" > /dev/null
}
os_username() {
  _cotowali_tmp_45='whoami'

  if "$(platform_has_command "$_cotowali_tmp_45")"
  then
    whoami
    return 0
  fi
  os_username_name=''
   os_username_name="$USER" 
  echo "${os_username_name}"
  return 0
}
_cotowali_tmp_46='/'

os_path_separator="$_cotowali_tmp_46"
_cotowali_tmp_47=':'

os_path_list_separator="$_cotowali_tmp_47"
if "$(platform_is_windows)"
then
  _cotowali_tmp_48=\\

  os_path_separator="$_cotowali_tmp_48"
  _cotowali_tmp_49=';'

  os_path_list_separator="$_cotowali_tmp_49"
fi
os_path_join() {
  array_assign "_cotowali_tmp_50" "$@"
  array_copy "os_path_join_parts" "_cotowali_tmp_50"
  __array__string__join os_path_join_parts "${os_path_separator}"
  return 0
}
os_path_is_abs() {
  os_path_is_abs_path="$1"
  ( [ "$(string__len "${os_path_is_abs_path}")" -gt 0 ] && [ "$(echo "${os_path_is_abs_path}" | awk -v RS='' -v i=0 '{printf "%s", substr($0, i + 1, 1) }' )"  =  "${os_path_separator}" ] ) && echo 'true' || echo 'false'
  return 0
}
os_path_abs() {
  os_path_abs_path="$1"
  _cotowali_tmp_51='.'

  if [ "${os_path_abs_path}"  =  '' ] || [ "${os_path_abs_path}"  =  "$_cotowali_tmp_51" ]
  then
    pwd9003d1df22eb4d3820015070385194c8
    return 0
  fi
  os_path_abs_abs_path="${os_path_abs_path}"
  if ! { "$(os_path_is_abs "${os_path_abs_path}")" ; }
  then
    os_path_abs_abs_path="$(os_path_join "$(pwd9003d1df22eb4d3820015070385194c8)" "${os_path_abs_path}")"
  fi
  if "$(platform_is_busybox)"
  then
    echo "${os_path_abs_abs_path}"
    return 0
  fi
  _cotowali_tmp_53='realpath'

  _cotowali_tmp_52='python'

  if "$(platform_has_command "$_cotowali_tmp_52")" || "$(platform_has_command "$_cotowali_tmp_53")"
  then
    os_path_abs_abs_path="$(os_path_clean "${os_path_abs_abs_path}")"
  fi
  echo "${os_path_abs_abs_path}"
  return 0
}
os_path_clean() {
  os_path_clean_path="$1"
  _cotowali_tmp_54='os::path::clean'

  platform_does_not_support_busybox "$_cotowali_tmp_54" > /dev/null
  os_path_clean_sep="${os_path_separator}"
  os_path_clean_is_root="$(string__starts_with "${os_path_clean_path}" "${os_path_clean_sep}")"
  _cotowali_tmp_55='realpath'

  if "$(platform_has_command "$_cotowali_tmp_55")"
  then
    if "${os_path_clean_is_root}"
    then
      _cotowali_tmp_56='-sm'

      realpath "$_cotowali_tmp_56" "${os_path_clean_path}"
      return 0
    else
      _cotowali_tmp_59='.'

      _cotowali_tmp_58='--relative-to'

      _cotowali_tmp_57='-sm'

      realpath "$_cotowali_tmp_57" "$_cotowali_tmp_58" "$_cotowali_tmp_59" "${os_path_clean_path}"
      return 0
    fi
  fi
  _cotowali_tmp_60='python'

  if "$(platform_has_command "$_cotowali_tmp_60")"
  then
    _cotowali_tmp_62='import os, sys; print(os.path.normpath(sys.argv[1]))'

    _cotowali_tmp_61='-c'

    python "$_cotowali_tmp_61" "$_cotowali_tmp_62" "${os_path_clean_path}"
    return 0
  fi
}
os_path_exists() {
  os_path_exists_path="$1"
   [ -e "$os_path_exists_path" ] && cotowali_true_value || cotowali_false_value 
}
os_path_is_file() {
  os_path_is_file_path="$1"
   [ -f "$os_path_is_file_path" ] && cotowali_true_value || cotowali_false_value 
}
os_path_is_dir() {
  os_path_is_dir_path="$1"
   [ -d "$os_path_is_dir_path" ] && cotowali_true_value || cotowali_false_value 
}
os_path_is_symlink() {
  os_path_is_symlink_path="$1"
  if ! { "$(os_path_exists "${os_path_is_symlink_path}")" ; }
  then
    echo 'false'
    return 0
  fi
   [ -L "$os_path_is_symlink_path" ] && cotowali_true_value || cotowali_false_value 
}
os_path_home() {
  os_path_home_path=''
   os_path_home_path="$HOME" 
  echo "${os_path_home_path}"
  return 0
}
# file: /home/zakuro/src/github.com/cotowali/cotowali/std/http.li
# http.li
# Copyright (c) 2021 zakuro <z@kuro.red>. All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
http_get() {
  http_get_url="$1"
  _cotowali_tmp_64='wget'

  _cotowali_tmp_63='curl'

  if "$(platform_has_command "$_cotowali_tmp_63")"
  then
    
        curl -sSL --fail "$http_get_url" 2> '/dev/null' || {
          echo 'http error' >&2
          exit 1
        }
      
  elif "$(platform_has_command "$_cotowali_tmp_64")"
  then
    
        wget -q -O - --header 'Accept: */*' "$http_get_url" 2> '/dev/null' || {
          echo 'http error' >&2
          exit 1
        }
      
  else
    _cotowali_tmp_65='curl'

    platform_required_command_not_found "$_cotowali_tmp_65" > /dev/null
  fi
}
# file: /home/zakuro/src/github.com/cotowali/cotowali/std/tar.li
# tar.li
# Copyright (c) 2021 zakuro <z@kuro.red>. All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
tar_internal_prepare_dir() {
  tar_internal_prepare_dir_path="$1"
  if "$(os_path_is_file "${tar_internal_prepare_dir_path}")"
  then
    _cotowali_tmp_66="Fatal error: \`${tar_internal_prepare_dir_path}\` file exits"

    eprintln "$_cotowali_tmp_66"
  fi
  if ! { "$(os_path_exists "${tar_internal_prepare_dir_path}")" ; }
  then
    mkdir_p "${tar_internal_prepare_dir_path}"
  fi
}
_cotowali_tmp_67='tar.exe'

if ! { "$(platform_has_command "$_cotowali_tmp_67")" ; }
then
  _cotowali_tmp_68='tar'

  platform_require_command "$_cotowali_tmp_68"
fi
tar_create() {
  tar_create_file="$1"
   tar -cf '-' $tar_create_file 
}
tar_create_to() {
  tar_create_to_archive="$1"
  shift
  tar_create_to_file="$1"
   tar -cf $tar_create_to_archive $tar_create_to_file 
}
tar_extract() {
   tar -xf '-' 
}
tar_extract_on() {
  tar_extract_on_dir="$1"
  tar_internal_prepare_dir "${tar_extract_on_dir}"
   tar -xf '-' -C $tar_extract_on_dir 
}
tar_extract_file() {
  tar_extract_file_archive="$1"
   tar -xf $tar_extract_file_archive 
}
tar_extract_file_on() {
  tar_extract_file_on_archive="$1"
  shift
  tar_extract_file_on_dir="$1"
  tar_internal_prepare_dir "${tar_extract_file_on_dir}"
   tar -xf $tar_extract_file_on_archive -C $tar_extract_file_on_dir 
}
tar_gz_create() {
  tar_gz_create_file="$1"
   tar -zcf '-' $tar_gz_create_file 
}
tar_gz_create_to() {
  tar_gz_create_to_archive="$1"
  shift
  tar_gz_create_to_file="$1"
   tar -zcf $tar_gz_create_to_archive $tar_gz_create_to_file 
}
tar_gz_extract() {
   tar -zxf '-' 
}
tar_gz_extract_on() {
  tar_gz_extract_on_dir="$1"
  tar_internal_prepare_dir "${tar_gz_extract_on_dir}"
   tar -zxf '-' -C $tar_gz_extract_on_dir 
}
tar_gz_extract_file() {
  tar_gz_extract_file_archive="$1"
   tar -zxf $tar_gz_extract_file_archive 
}
tar_gz_extract_file_on() {
  tar_gz_extract_file_on_archive="$1"
  shift
  tar_gz_extract_file_on_dir="$1"
  tar_internal_prepare_dir "${tar_gz_extract_file_on_dir}"
   tar -zxf $tar_gz_extract_file_on_archive -C $tar_gz_extract_file_on_dir 
}
# file: /home/zakuro/src/github.com/cotowali/cotowali/std/term.li
# term.li
# Copyright (c) 2021 zakuro <z@kuro.red>. All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
term_text() {
  term_text_s="$1"
  echo "${term_text_s}"
  return 0
}
term_format() {
  term_format_text="$1"
  shift
  term_format_open="$1"
  shift
  term_format_close="$1"
  _cotowali_tmp_69="$(printf '\33')[${term_format_open}m${term_format_text}$(printf '\33')[${term_format_close}m"

  echo "$_cotowali_tmp_69"
  return 0
}
term_Text__format() {
  term_Text__format_text="$1"
  shift
  term_Text__format_open="$1"
  shift
  term_Text__format_close="$1"
  term_format "${term_Text__format_text}" "${term_Text__format_open}" "${term_Text__format_close}"
  return 0
}
term_reset() {
  term_reset_msg="$1"
  _cotowali_tmp_71='0'

  _cotowali_tmp_70='0'

  term_format "${term_reset_msg}" "$_cotowali_tmp_70" "$_cotowali_tmp_71"
  return 0
}
term_Text__reset() {
  term_Text__reset_text="$1"
  term_reset "${term_Text__reset_text}"
  return 0
}
term_bold() {
  term_bold_msg="$1"
  _cotowali_tmp_73='22'

  _cotowali_tmp_72='1'

  term_format "${term_bold_msg}" "$_cotowali_tmp_72" "$_cotowali_tmp_73"
  return 0
}
term_Text__bold() {
  term_Text__bold_text="$1"
  term_bold "${term_Text__bold_text}"
  return 0
}
term_dim() {
  term_dim_msg="$1"
  _cotowali_tmp_75='22'

  _cotowali_tmp_74='2'

  term_format "${term_dim_msg}" "$_cotowali_tmp_74" "$_cotowali_tmp_75"
  return 0
}
term_Text__dim() {
  term_Text__dim_text="$1"
  term_dim "${term_Text__dim_text}"
  return 0
}
term_italic() {
  term_italic_msg="$1"
  _cotowali_tmp_77='23'

  _cotowali_tmp_76='3'

  term_format "${term_italic_msg}" "$_cotowali_tmp_76" "$_cotowali_tmp_77"
  return 0
}
term_Text__italic() {
  term_Text__italic_text="$1"
  term_italic "${term_Text__italic_text}"
  return 0
}
term_underline() {
  term_underline_msg="$1"
  _cotowali_tmp_79='24'

  _cotowali_tmp_78='4'

  term_format "${term_underline_msg}" "$_cotowali_tmp_78" "$_cotowali_tmp_79"
  return 0
}
term_Text__underline() {
  term_Text__underline_text="$1"
  term_underline "${term_Text__underline_text}"
  return 0
}
term_inverse() {
  term_inverse_msg="$1"
  _cotowali_tmp_81='27'

  _cotowali_tmp_80='7'

  term_format "${term_inverse_msg}" "$_cotowali_tmp_80" "$_cotowali_tmp_81"
  return 0
}
term_Text__inverse() {
  term_Text__inverse_text="$1"
  term_inverse "${term_Text__inverse_text}"
  return 0
}
term_hidden() {
  term_hidden_msg="$1"
  _cotowali_tmp_83='28'

  _cotowali_tmp_82='8'

  term_format "${term_hidden_msg}" "$_cotowali_tmp_82" "$_cotowali_tmp_83"
  return 0
}
term_Text__hidden() {
  term_Text__hidden_text="$1"
  term_hidden "${term_Text__hidden_text}"
  return 0
}
term_strikethrough() {
  term_strikethrough_msg="$1"
  _cotowali_tmp_85='29'

  _cotowali_tmp_84='9'

  term_format "${term_strikethrough_msg}" "$_cotowali_tmp_84" "$_cotowali_tmp_85"
  return 0
}
term_Text__strikethrough() {
  term_Text__strikethrough_text="$1"
  term_strikethrough "${term_Text__strikethrough_text}"
  return 0
}
term_black() {
  term_black_msg="$1"
  _cotowali_tmp_87='39'

  _cotowali_tmp_86='30'

  term_format "${term_black_msg}" "$_cotowali_tmp_86" "$_cotowali_tmp_87"
  return 0
}
term_Text__black() {
  term_Text__black_text="$1"
  term_black "${term_Text__black_text}"
  return 0
}
term_red() {
  term_red_msg="$1"
  _cotowali_tmp_89='39'

  _cotowali_tmp_88='31'

  term_format "${term_red_msg}" "$_cotowali_tmp_88" "$_cotowali_tmp_89"
  return 0
}
term_Text__red() {
  term_Text__red_text="$1"
  term_red "${term_Text__red_text}"
  return 0
}
term_green() {
  term_green_msg="$1"
  _cotowali_tmp_91='39'

  _cotowali_tmp_90='32'

  term_format "${term_green_msg}" "$_cotowali_tmp_90" "$_cotowali_tmp_91"
  return 0
}
term_Text__green() {
  term_Text__green_text="$1"
  term_green "${term_Text__green_text}"
  return 0
}
term_yellow() {
  term_yellow_msg="$1"
  _cotowali_tmp_93='39'

  _cotowali_tmp_92='33'

  term_format "${term_yellow_msg}" "$_cotowali_tmp_92" "$_cotowali_tmp_93"
  return 0
}
term_Text__yellow() {
  term_Text__yellow_text="$1"
  term_yellow "${term_Text__yellow_text}"
  return 0
}
term_blue() {
  term_blue_msg="$1"
  _cotowali_tmp_95='39'

  _cotowali_tmp_94='34'

  term_format "${term_blue_msg}" "$_cotowali_tmp_94" "$_cotowali_tmp_95"
  return 0
}
term_Text__blue() {
  term_Text__blue_text="$1"
  term_blue "${term_Text__blue_text}"
  return 0
}
term_magenta() {
  term_magenta_msg="$1"
  _cotowali_tmp_97='39'

  _cotowali_tmp_96='35'

  term_format "${term_magenta_msg}" "$_cotowali_tmp_96" "$_cotowali_tmp_97"
  return 0
}
term_Text__magenta() {
  term_Text__magenta_text="$1"
  term_magenta "${term_Text__magenta_text}"
  return 0
}
term_cyan() {
  term_cyan_msg="$1"
  _cotowali_tmp_99='39'

  _cotowali_tmp_98='36'

  term_format "${term_cyan_msg}" "$_cotowali_tmp_98" "$_cotowali_tmp_99"
  return 0
}
term_Text__cyan() {
  term_Text__cyan_text="$1"
  term_cyan "${term_Text__cyan_text}"
  return 0
}
term_white() {
  term_white_msg="$1"
  _cotowali_tmp_101='39'

  _cotowali_tmp_100='37'

  term_format "${term_white_msg}" "$_cotowali_tmp_100" "$_cotowali_tmp_101"
  return 0
}
term_Text__white() {
  term_Text__white_text="$1"
  term_white "${term_Text__white_text}"
  return 0
}
term_bg_black() {
  term_bg_black_msg="$1"
  _cotowali_tmp_103='49'

  _cotowali_tmp_102='40'

  term_format "${term_bg_black_msg}" "$_cotowali_tmp_102" "$_cotowali_tmp_103"
  return 0
}
term_Text__bg_black() {
  term_Text__bg_black_text="$1"
  term_bg_black "${term_Text__bg_black_text}"
  return 0
}
term_bg_red() {
  term_bg_red_msg="$1"
  _cotowali_tmp_105='49'

  _cotowali_tmp_104='41'

  term_format "${term_bg_red_msg}" "$_cotowali_tmp_104" "$_cotowali_tmp_105"
  return 0
}
term_Text__bg_red() {
  term_Text__bg_red_text="$1"
  term_bg_red "${term_Text__bg_red_text}"
  return 0
}
term_bg_green() {
  term_bg_green_msg="$1"
  _cotowali_tmp_107='49'

  _cotowali_tmp_106='42'

  term_format "${term_bg_green_msg}" "$_cotowali_tmp_106" "$_cotowali_tmp_107"
  return 0
}
term_Text__bg_green() {
  term_Text__bg_green_text="$1"
  term_bg_green "${term_Text__bg_green_text}"
  return 0
}
term_bg_yellow() {
  term_bg_yellow_msg="$1"
  _cotowali_tmp_109='49'

  _cotowali_tmp_108='43'

  term_format "${term_bg_yellow_msg}" "$_cotowali_tmp_108" "$_cotowali_tmp_109"
  return 0
}
term_Text__bg_yellow() {
  term_Text__bg_yellow_text="$1"
  term_bg_yellow "${term_Text__bg_yellow_text}"
  return 0
}
term_bg_blue() {
  term_bg_blue_msg="$1"
  _cotowali_tmp_111='49'

  _cotowali_tmp_110='44'

  term_format "${term_bg_blue_msg}" "$_cotowali_tmp_110" "$_cotowali_tmp_111"
  return 0
}
term_Text__bg_blue() {
  term_Text__bg_blue_text="$1"
  term_bg_blue "${term_Text__bg_blue_text}"
  return 0
}
term_bg_magenta() {
  term_bg_magenta_msg="$1"
  _cotowali_tmp_113='49'

  _cotowali_tmp_112='45'

  term_format "${term_bg_magenta_msg}" "$_cotowali_tmp_112" "$_cotowali_tmp_113"
  return 0
}
term_Text__bg_magenta() {
  term_Text__bg_magenta_text="$1"
  term_bg_magenta "${term_Text__bg_magenta_text}"
  return 0
}
term_bg_cyan() {
  term_bg_cyan_msg="$1"
  _cotowali_tmp_115='49'

  _cotowali_tmp_114='46'

  term_format "${term_bg_cyan_msg}" "$_cotowali_tmp_114" "$_cotowali_tmp_115"
  return 0
}
term_Text__bg_cyan() {
  term_Text__bg_cyan_text="$1"
  term_bg_cyan "${term_Text__bg_cyan_text}"
  return 0
}
term_bg_white() {
  term_bg_white_msg="$1"
  _cotowali_tmp_117='49'

  _cotowali_tmp_116='47'

  term_format "${term_bg_white_msg}" "$_cotowali_tmp_116" "$_cotowali_tmp_117"
  return 0
}
term_Text__bg_white() {
  term_Text__bg_white_text="$1"
  term_bg_white "${term_Text__bg_white_text}"
  return 0
}
term_gray() {
  term_gray_msg="$1"
  term_bright_black "${term_gray_msg}"
  return 0
}
term_Text__gray() {
  term_Text__gray_text="$1"
  term_gray "${term_Text__gray_text}"
  return 0
}
term_bright_black() {
  term_bright_black_msg="$1"
  _cotowali_tmp_119='39'

  _cotowali_tmp_118='90'

  term_format "${term_bright_black_msg}" "$_cotowali_tmp_118" "$_cotowali_tmp_119"
  return 0
}
term_Text__bright_black() {
  term_Text__bright_black_text="$1"
  term_bright_black "${term_Text__bright_black_text}"
  return 0
}
term_bright_red() {
  term_bright_red_msg="$1"
  _cotowali_tmp_121='39'

  _cotowali_tmp_120='91'

  term_format "${term_bright_red_msg}" "$_cotowali_tmp_120" "$_cotowali_tmp_121"
  return 0
}
term_Text__bright_red() {
  term_Text__bright_red_text="$1"
  term_bright_red "${term_Text__bright_red_text}"
  return 0
}
term_bright_green() {
  term_bright_green_msg="$1"
  _cotowali_tmp_123='39'

  _cotowali_tmp_122='92'

  term_format "${term_bright_green_msg}" "$_cotowali_tmp_122" "$_cotowali_tmp_123"
  return 0
}
term_Text__bright_green() {
  term_Text__bright_green_text="$1"
  term_bright_green "${term_Text__bright_green_text}"
  return 0
}
term_bright_yellow() {
  term_bright_yellow_msg="$1"
  _cotowali_tmp_125='39'

  _cotowali_tmp_124='93'

  term_format "${term_bright_yellow_msg}" "$_cotowali_tmp_124" "$_cotowali_tmp_125"
  return 0
}
term_Text__bright_yellow() {
  term_Text__bright_yellow_text="$1"
  term_bright_yellow "${term_Text__bright_yellow_text}"
  return 0
}
term_bright_blue() {
  term_bright_blue_msg="$1"
  _cotowali_tmp_127='39'

  _cotowali_tmp_126='94'

  term_format "${term_bright_blue_msg}" "$_cotowali_tmp_126" "$_cotowali_tmp_127"
  return 0
}
term_Text__bright_blue() {
  term_Text__bright_blue_text="$1"
  term_bright_blue "${term_Text__bright_blue_text}"
  return 0
}
term_bright_magenta() {
  term_bright_magenta_msg="$1"
  _cotowali_tmp_129='39'

  _cotowali_tmp_128='95'

  term_format "${term_bright_magenta_msg}" "$_cotowali_tmp_128" "$_cotowali_tmp_129"
  return 0
}
term_Text__bright_magenta() {
  term_Text__bright_magenta_text="$1"
  term_bright_magenta "${term_Text__bright_magenta_text}"
  return 0
}
term_bright_cyan() {
  term_bright_cyan_msg="$1"
  _cotowali_tmp_131='39'

  _cotowali_tmp_130='96'

  term_format "${term_bright_cyan_msg}" "$_cotowali_tmp_130" "$_cotowali_tmp_131"
  return 0
}
term_Text__bright_cyan() {
  term_Text__bright_cyan_text="$1"
  term_bright_cyan "${term_Text__bright_cyan_text}"
  return 0
}
term_bright_white() {
  term_bright_white_msg="$1"
  _cotowali_tmp_133='39'

  _cotowali_tmp_132='97'

  term_format "${term_bright_white_msg}" "$_cotowali_tmp_132" "$_cotowali_tmp_133"
  return 0
}
term_Text__bright_white() {
  term_Text__bright_white_text="$1"
  term_bright_white "${term_Text__bright_white_text}"
  return 0
}
term_bright_bg_black() {
  term_bright_bg_black_msg="$1"
  _cotowali_tmp_135='49'

  _cotowali_tmp_134='100'

  term_format "${term_bright_bg_black_msg}" "$_cotowali_tmp_134" "$_cotowali_tmp_135"
  return 0
}
term_Text__bright_bg_black() {
  term_Text__bright_bg_black_text="$1"
  term_bright_bg_black "${term_Text__bright_bg_black_text}"
  return 0
}
term_bright_bg_red() {
  term_bright_bg_red_msg="$1"
  _cotowali_tmp_137='49'

  _cotowali_tmp_136='101'

  term_format "${term_bright_bg_red_msg}" "$_cotowali_tmp_136" "$_cotowali_tmp_137"
  return 0
}
term_Text__bright_bg_red() {
  term_Text__bright_bg_red_text="$1"
  term_bright_bg_red "${term_Text__bright_bg_red_text}"
  return 0
}
term_bright_bg_green() {
  term_bright_bg_green_msg="$1"
  _cotowali_tmp_139='49'

  _cotowali_tmp_138='102'

  term_format "${term_bright_bg_green_msg}" "$_cotowali_tmp_138" "$_cotowali_tmp_139"
  return 0
}
term_Text__bright_bg_green() {
  term_Text__bright_bg_green_text="$1"
  term_bright_bg_green "${term_Text__bright_bg_green_text}"
  return 0
}
term_bright_bg_yellow() {
  term_bright_bg_yellow_msg="$1"
  _cotowali_tmp_141='49'

  _cotowali_tmp_140='103'

  term_format "${term_bright_bg_yellow_msg}" "$_cotowali_tmp_140" "$_cotowali_tmp_141"
  return 0
}
term_Text__bright_bg_yellow() {
  term_Text__bright_bg_yellow_text="$1"
  term_bright_bg_yellow "${term_Text__bright_bg_yellow_text}"
  return 0
}
term_bright_bg_blue() {
  term_bright_bg_blue_msg="$1"
  _cotowali_tmp_143='49'

  _cotowali_tmp_142='104'

  term_format "${term_bright_bg_blue_msg}" "$_cotowali_tmp_142" "$_cotowali_tmp_143"
  return 0
}
term_Text__bright_bg_blue() {
  term_Text__bright_bg_blue_text="$1"
  term_bright_bg_blue "${term_Text__bright_bg_blue_text}"
  return 0
}
term_bright_bg_magenta() {
  term_bright_bg_magenta_msg="$1"
  _cotowali_tmp_145='49'

  _cotowali_tmp_144='105'

  term_format "${term_bright_bg_magenta_msg}" "$_cotowali_tmp_144" "$_cotowali_tmp_145"
  return 0
}
term_Text__bright_bg_magenta() {
  term_Text__bright_bg_magenta_text="$1"
  term_bright_bg_magenta "${term_Text__bright_bg_magenta_text}"
  return 0
}
term_bright_bg_cyan() {
  term_bright_bg_cyan_msg="$1"
  _cotowali_tmp_147='49'

  _cotowali_tmp_146='106'

  term_format "${term_bright_bg_cyan_msg}" "$_cotowali_tmp_146" "$_cotowali_tmp_147"
  return 0
}
term_Text__bright_bg_cyan() {
  term_Text__bright_bg_cyan_text="$1"
  term_bright_bg_cyan "${term_Text__bright_bg_cyan_text}"
  return 0
}
term_bright_bg_white() {
  term_bright_bg_white_msg="$1"
  _cotowali_tmp_149='49'

  _cotowali_tmp_148='107'

  term_format "${term_bright_bg_white_msg}" "$_cotowali_tmp_148" "$_cotowali_tmp_149"
  return 0
}
term_Text__bright_bg_white() {
  term_Text__bright_bg_white_text="$1"
  term_bright_bg_white "${term_Text__bright_bg_white_text}"
  return 0
}
prepare_dir() {
  prepare_dir_path="$1"
  if "$(os_path_is_file "${prepare_dir_path}")"
  then
    _cotowali_tmp_150="Fatal error: Cannot create ${prepare_dir_path}. File exists"

    eprintln "$_cotowali_tmp_150"
    exit 1
  fi
  if ! { "$(os_path_exists "${prepare_dir_path}")" ; }
  then
    mkdir "${prepare_dir_path}"
  fi
}
_cotowali_tmp_151='.konryu'

konryu_path="$(os_path_join "$(os_path_home)" "$_cotowali_tmp_151")"
prepare_dir "${konryu_path}"
_cotowali_tmp_152='.cache'

konryu_cache="$(os_path_join "${konryu_path}" "$_cotowali_tmp_152")"
prepare_dir "${konryu_cache}"
_cotowali_tmp_153='bin'

konryu_bin_dir="$(os_path_join "${konryu_path}" "$_cotowali_tmp_153")"
prepare_dir "${konryu_bin_dir}"
_cotowali_tmp_154='konryu'

konryu_sh="$(os_path_join "${konryu_bin_dir}" "$_cotowali_tmp_154")"
_cotowali_tmp_155='https://raw.githubusercontent.com/cotowali/konryu/dist/konryu.sh'

konryu_sh_url="$_cotowali_tmp_155"
_cotowali_tmp_156='versions'

versions_path="$(os_path_join "${konryu_path}" "$_cotowali_tmp_156")"
version_path() {
  version_path_version="$1"
  os_path_join "${versions_path}" "${version_path_version}"
  return 0
}
_cotowali_tmp_157='current'

current_version_file_path="$(os_path_join "${konryu_path}" "$_cotowali_tmp_157")"
_cotowali_tmp_158='cotowali'

cotowali_path="$(os_path_join "${konryu_path}" "$_cotowali_tmp_158")"
json_field() {
  json_field_key="$1"
  _cotowali_tmp_161="^${json_field_key}:"

  _cotowali_tmp_160='[", ]'

  _cotowali_tmp_159="\"${json_field_key}\""

  filter "$_cotowali_tmp_159" | replace "$_cotowali_tmp_160" '' | replace "$_cotowali_tmp_161" ''
  return 0
}
get_releases() {
  _cotowali_tmp_163='tag_name'

  _cotowali_tmp_162='https://api.github.com/repos/cotowali/cotowali/releases'

  http_get "$_cotowali_tmp_162" | json_field "$_cotowali_tmp_163"
  return 0
}
print_releases() {
  for _cotowali_tmp_164 in $(get_releases)
  do
    print_releases_for_2_release="$(eval echo $_cotowali_tmp_164)"
    println "${print_releases_for_2_release}"
  done
}
specified_too_many_versions() {
  _cotowali_tmp_165='Too many arguments. Specify just one version'

  eprintln "$_cotowali_tmp_165"
  exit 1
}
is_installed_version() {
  is_installed_version_target_version="$1"
  for _cotowali_tmp_166 in $(get_installed_versions)
  do
    is_installed_version_for_3_version="$(eval echo $_cotowali_tmp_166)"
    if [ "${is_installed_version_for_3_version}"  =  "${is_installed_version_target_version}" ]
    then
      echo 'true'
      return 0
    fi
  done
  echo 'false'
  return 0
}
current_version() {
  if ! { "$(os_path_is_file "${current_version_file_path}")" ; }
  then
    echo ''
    return 0
  fi
  cat "${current_version_file_path}" | first8b04d5e3775d298e78455efc5ca404d5
  return 0
}
switch_version() {
  switch_version_version="$1"
  if "$(os_path_exists "${cotowali_path}")"
  then
    rm_r "${cotowali_path}"
  fi
  _cotowali_tmp_167='cotowali'

  os_symlink "$(os_path_join "$(version_path "${switch_version_version}")" "$_cotowali_tmp_167")" "${cotowali_path}"
  echo "${switch_version_version}" > "${current_version_file_path}"
  _cotowali_tmp_168="switched to cotowali ${switch_version_version}"

  println "$_cotowali_tmp_168"
}
install_version() {
  install_version_version="$1"
  install_version_releases="$(get_releases)"
  _cotowali_tmp_169='latest'

  if [ "${install_version_version}"  =  "$_cotowali_tmp_169" ]
  then
    install_version_version="$(echo "${install_version_releases}" | first8b04d5e3775d298e78455efc5ca404d5 )"
  else
    install_version_else_7_found='false'
    for _cotowali_tmp_170 in ${install_version_releases}
    do
      install_version_else_7_for_7_release="$(eval echo $_cotowali_tmp_170)"
      if [ "${install_version_else_7_for_7_release}"  =  "${install_version_version}" ]
      then
        install_version_else_7_found='true'
        break
      fi
    done
    if ! { "${install_version_else_7_found}" ; }
    then
      _cotowali_tmp_171="Cannot install ${install_version_version}: No such version"

      eprintln "$_cotowali_tmp_171"
      exit 1
    fi
  fi
  install_version_dir="$(version_path "${install_version_version}")"
  _cotowali_tmp_172='https://github.com/cotowali/cotowali/releases/download'

  install_version_url_base="$_cotowali_tmp_172"
  install_version_filename="${cotowali_release_archive_name}"
  _cotowali_tmp_173="Downloading ${install_version_filename} ..."

  println "$_cotowali_tmp_173"
  _cotowali_tmp_174="${install_version_url_base}/${install_version_version}/${install_version_filename}"

  http_get "$_cotowali_tmp_174" | tar_gz_extract_on "${install_version_dir}" > /dev/null
  _cotowali_tmp_175="Successfully installed cotowali ${install_version_version} on ${install_version_dir}"

  println "$_cotowali_tmp_175"
  if [ "$(current_version)"  =  '' ]
  then
    switch_version "${install_version_version}" > /dev/null
  elif [ "$(current_version)"  !=  "${install_version_version}" ]
  then
    _cotowali_tmp_176="Do you want to use ${install_version_version} now?"

    if "$(confirm_default_yes "$_cotowali_tmp_176")"
    then
      switch_version "${install_version_version}"
    fi
  fi
}
confirm_default_yes() {
  confirm_default_yes_message="$1"
  confirm_default_yes_ans=''
  while 'true'
  do
    _cotowali_tmp_177="${confirm_default_yes_message} [Y/n]: "

    confirm_default_yes_ans="$(input_tty "$_cotowali_tmp_177")"
    _cotowali_tmp_182='no'

    _cotowali_tmp_181='N'

    _cotowali_tmp_179='yes'

    _cotowali_tmp_178='Y'

    if [ "${confirm_default_yes_ans}"  =  "$_cotowali_tmp_178" ] || [ "${confirm_default_yes_ans}"  =  "$_cotowali_tmp_179" ] || [ "${confirm_default_yes_ans}"  =  '' ]
    then
      _cotowali_tmp_180='y'

      confirm_default_yes_ans="$_cotowali_tmp_180"
    elif [ "${confirm_default_yes_ans}"  =  "$_cotowali_tmp_181" ] || [ "${confirm_default_yes_ans}"  =  "$_cotowali_tmp_182" ]
    then
      _cotowali_tmp_183='n'

      confirm_default_yes_ans="$_cotowali_tmp_183"
    fi
    _cotowali_tmp_185='n'

    _cotowali_tmp_184='y'

    if [ "${confirm_default_yes_ans}"  =  "$_cotowali_tmp_184" ] || [ "${confirm_default_yes_ans}"  =  "$_cotowali_tmp_185" ]
    then
      break
    fi
    _cotowali_tmp_186='yes or no'

    eprintln "$_cotowali_tmp_186" > /dev/null
  done
  _cotowali_tmp_187='y'

  echo "$( [ "${confirm_default_yes_ans}"  =  "$_cotowali_tmp_187" ] && echo 'true' || echo 'false' )"
  return 0
}
confirm_default_no() {
  confirm_default_no_message="$1"
  confirm_default_no_ans=''
  while 'true'
  do
    _cotowali_tmp_188="${confirm_default_no_message} [y/N]: "

    confirm_default_no_ans="$(input_tty "$_cotowali_tmp_188")"
    _cotowali_tmp_193='no'

    _cotowali_tmp_192='N'

    _cotowali_tmp_190='yes'

    _cotowali_tmp_189='Y'

    if [ "${confirm_default_no_ans}"  =  "$_cotowali_tmp_189" ] || [ "${confirm_default_no_ans}"  =  "$_cotowali_tmp_190" ]
    then
      _cotowali_tmp_191='y'

      confirm_default_no_ans="$_cotowali_tmp_191"
    elif [ "${confirm_default_no_ans}"  =  "$_cotowali_tmp_192" ] || [ "${confirm_default_no_ans}"  =  "$_cotowali_tmp_193" ] || [ "${confirm_default_no_ans}"  =  '' ]
    then
      _cotowali_tmp_194='n'

      confirm_default_no_ans="$_cotowali_tmp_194"
    fi
    _cotowali_tmp_196='n'

    _cotowali_tmp_195='y'

    if [ "${confirm_default_no_ans}"  =  "$_cotowali_tmp_195" ] || [ "${confirm_default_no_ans}"  =  "$_cotowali_tmp_196" ]
    then
      break
    fi
    _cotowali_tmp_197='yes or no'

    eprintln "$_cotowali_tmp_197" > /dev/null
  done
  _cotowali_tmp_198='y'

  echo "$( [ "${confirm_default_no_ans}"  =  "$_cotowali_tmp_198" ] && echo 'true' || echo 'false' )"
  return 0
}
download_konryu_sh() {
  _cotowali_tmp_199="Downloading konryu ..."

  println "$_cotowali_tmp_199"
  http_get "${konryu_sh_url}" > "${konryu_sh}"
  _cotowali_tmp_200='+x'

  chmod "$_cotowali_tmp_200" "${konryu_sh}" > /dev/null
}
cmd_install_konryu() {
  download_konryu_sh
  _cotowali_tmp_201='Successfully installed konryu'

  println "$_cotowali_tmp_201"
  println ''
  _cotowali_tmp_202="Do you want to install cotowali now?"

  if "$(confirm_default_yes "$_cotowali_tmp_202")"
  then
    println ''
    _cotowali_tmp_203='latest'

    install_version "$_cotowali_tmp_203"
  fi
  println ''
  _cotowali_tmp_204="Add \`${konryu_bin_dir}\` to your PATH to use konryu command"

  println "$_cotowali_tmp_204"
  _cotowali_tmp_205="export PATH=\"${konryu_bin_dir}:\${PATH}\""

  println "$_cotowali_tmp_205"
  println ''
  _cotowali_tmp_206='Then write `eval "$(konryu init)"` in your shell config like .bashrc to configure environment'

  println "$_cotowali_tmp_206"
}
cmd_update_konryu() {
  download_konryu_sh
  _cotowali_tmp_207='Successfully updated konryu'

  println "$_cotowali_tmp_207"
}
cmd_destroy() {
  _cotowali_tmp_208='WARNING: Konryu and all installed cotowali files will be deleted'

  term_bright_red "$_cotowali_tmp_208"
  _cotowali_tmp_209='Are you sure ?'

  if "$(confirm_default_no "$_cotowali_tmp_209")"
  then
    rm_r "${konryu_path}"
    _cotowali_tmp_210='Successfully deleted konryu and cotowali'

    println "$_cotowali_tmp_210"
    println ''
    _cotowali_tmp_211='Thank you for using cotowali so far.'

    println "$_cotowali_tmp_211"
    _cotowali_tmp_212='If you want to use cotowali again, visit https://cotowali.org'

    println "$_cotowali_tmp_212"
    _cotowali_tmp_213="Goodbye. But we hope to see you again."

    println "$_cotowali_tmp_213"
  else
    _cotowali_tmp_214='Canceled'

    println "$_cotowali_tmp_214"
  fi
}
cmd_init() {
  _cotowali_tmp_216='bin'

  _cotowali_tmp_215="$(os_path_join "${cotowali_path}" "$_cotowali_tmp_216"):\${PATH}"

  cmd_init_new_path="$_cotowali_tmp_215"
  _cotowali_tmp_217='# usage: eval "$(konryu init)"'

  println "$_cotowali_tmp_217"
  _cotowali_tmp_218="export PATH=\"${cmd_init_new_path}\""

  println "$_cotowali_tmp_218"
  exit 0
}
cmd_releases() {
  print_releases
  exit 0
}
cmd_current() {
  cmd_current_version="$(current_version)"
  if [ "${cmd_current_version}"  !=  '' ]
  then
    println "${cmd_current_version}"
  else
    _cotowali_tmp_219='cotowali is not enabled'

    println "$_cotowali_tmp_219"
  fi
  exit 0
}
cmd_install() {
  array_copy "cmd_install_args" "$1"
  _cotowali_tmp_220='latest'

  cmd_install_version="$_cotowali_tmp_220"
  if [ "$(__array__any__len cmd_install_args)" -gt 1 ]
  then
    specified_too_many_versions
  elif [ "$(__array__any__len cmd_install_args)" -gt 0 ]
  then
    cmd_install_version="$(array_get cmd_install_args 0 )"
  fi
  install_version "${cmd_install_version}"
  exit 0
}
cmd_uninstall() {
  array_copy "cmd_uninstall_args" "$1"
  if [ "$(__array__any__len cmd_uninstall_args)" -eq 0 ]
  then
    _cotowali_tmp_221='No version is specified'

    eprintln "$_cotowali_tmp_221"
    exit 1
  elif [ "$(__array__any__len cmd_uninstall_args)" -gt 1 ]
  then
    specified_too_many_versions
  fi
  cmd_uninstall_version="$(array_get cmd_uninstall_args 0 )"
  if ! { "$(is_installed_version "${cmd_uninstall_version}")" ; }
  then
    _cotowali_tmp_222="Cannot uninstall ${cmd_uninstall_version}: No such version"

    eprintln "$_cotowali_tmp_222"
    exit 1
  fi
  rm_r "$(version_path "${cmd_uninstall_version}")"
  _cotowali_tmp_223="Uninstalled cotowali ${cmd_uninstall_version}"

  println "$_cotowali_tmp_223"
}
get_installed_versions() {
  for _cotowali_tmp_224 in $(ls "${versions_path}")
  do
    get_installed_versions_for_25_path="$(eval echo $_cotowali_tmp_224)"
    echo "${get_installed_versions_for_25_path}"
  done
}
cmd_versions() {
  for _cotowali_tmp_225 in $(get_installed_versions)
  do
    cmd_versions_for_26_path="$(eval echo $_cotowali_tmp_225)"
    println "${cmd_versions_for_26_path}"
  done
  exit 0
}
cmd_use() {
  array_copy "cmd_use_args" "$1"
  if [ "$(__array__any__len cmd_use_args)" -eq 0 ]
  then
    _cotowali_tmp_226='No version is specified'

    eprintln "$_cotowali_tmp_226"
    exit 1
  fi
  if [ "$(__array__any__len cmd_use_args)" -gt 1 ]
  then
    specified_too_many_versions
  fi
  cmd_use_target_version="$(array_get cmd_use_args 0 )"
  cmd_use_installed_versions="$(get_installed_versions)"
  cmd_use_latest_version="$(echo "${cmd_use_installed_versions}" | first8b04d5e3775d298e78455efc5ca404d5 )"
  if [ "${cmd_use_latest_version}"  =  '' ]
  then
    _cotowali_tmp_227='cotowali is not installed'

    eprintln "$_cotowali_tmp_227"
    exit 1
  fi
  _cotowali_tmp_228='latest'

  if [ "${cmd_use_target_version}"  =  "$_cotowali_tmp_228" ]
  then
    cmd_use_target_version="${cmd_use_latest_version}"
  fi
  if ! { "$(is_installed_version "${cmd_use_target_version}")" ; }
  then
    _cotowali_tmp_229="Cannot use ${cmd_use_target_version}: No such version"

    eprintln "$_cotowali_tmp_229"
    exit 1
  fi
  switch_version "${cmd_use_target_version}"
  exit 0
}
has_help_flag='false'
is_error='false'
self=''
command=''
array_init "args" 0 
for _cotowali_tmp_230 in $(array_elements os_args)

do
  for_32_arg="$(eval echo $_cotowali_tmp_230)"
  if [ "${self}"  =  '' ]
  then
    self="${for_32_arg}"
    continue
  fi
  _cotowali_tmp_233='-'

  _cotowali_tmp_232='--help'

  _cotowali_tmp_231='-h'

  if [ "${for_32_arg}"  =  "$_cotowali_tmp_231" ] || [ "${for_32_arg}"  =  "$_cotowali_tmp_232" ]
  then
    has_help_flag='true'
  elif [ "$(echo "${for_32_arg}" | awk -v RS='' -v i=0 '{printf "%s", substr($0, i + 1, 1) }' )"  =  "$_cotowali_tmp_233" ]
  then
    _cotowali_tmp_234="unknown option \`${for_32_arg}\`"

    eprintln "$_cotowali_tmp_234"
    is_error='true'
  elif [ "${command}"  =  '' ]
  then
    command="${for_32_arg}"
  else
    array_assign "_cotowali_tmp_236" "${for_32_arg}"
    array_copy _cotowali_tmp_235 args
    array_push_array _cotowali_tmp_235 _cotowali_tmp_236
    array_copy "args" _cotowali_tmp_235
  fi
done
if ! { "${is_error}" ; }
then
  _cotowali_tmp_246='destroy'

  _cotowali_tmp_245='update'

  _cotowali_tmp_244='init'

  _cotowali_tmp_243='versions'

  _cotowali_tmp_242='current'

  _cotowali_tmp_241='releases'

  _cotowali_tmp_240='use'

  _cotowali_tmp_239='uninstall'

  _cotowali_tmp_238='install'

  _cotowali_tmp_237='help'

  if [ "${command}"  =  '' ]
  then
    if ! { "$(os_path_exists "${konryu_sh}")" ; }
    then
      cmd_install_konryu
    else
      has_help_flag='true'
    fi
  elif [ "${command}"  =  "$_cotowali_tmp_237" ]
  then
    has_help_flag='true'
  elif [ "${command}"  =  "$_cotowali_tmp_238" ]
  then
    cmd_install args
  elif [ "${command}"  =  "$_cotowali_tmp_239" ]
  then
    cmd_uninstall args
  elif [ "${command}"  =  "$_cotowali_tmp_240" ]
  then
    cmd_use args
  elif [ "${command}"  =  "$_cotowali_tmp_241" ]
  then
    cmd_releases
  elif [ "${command}"  =  "$_cotowali_tmp_242" ]
  then
    cmd_current
  elif [ "${command}"  =  "$_cotowali_tmp_243" ]
  then
    cmd_versions
  elif [ "${command}"  =  "$_cotowali_tmp_244" ]
  then
    cmd_init
  elif [ "${command}"  =  "$_cotowali_tmp_245" ]
  then
    cmd_update_konryu
  elif [ "${command}"  =  "$_cotowali_tmp_246" ]
  then
    cmd_destroy
  else
    _cotowali_tmp_247="unknown command \`${command}\`"

    eprintln "$_cotowali_tmp_247"
    is_error='true'
  fi
fi
if "${has_help_flag}" || "${is_error}"
then
  _cotowali_tmp_248='Konryu - Cotowali installer and version manager

Usage: konryu [options] [command] [version]

Options:
  -h --help - Print help message

Commands:
  help      - Print help message
  init      - Print shell code to configure environment
  install   - Install cotowali release
  uninstall - Uninstall specified version
  use       - Use specified version
  releases  - List available cotowali releases
  versions  - List installed cotowali versions

  update  - Update konryu
  destroy - Destroy konryu and all installed files
'

  if_38_msg="$_cotowali_tmp_248"
  if "${is_error}"
  then
    eprint "${if_38_msg}"
    exit 1
  else
    print "${if_38_msg}"
    exit 0
  fi
fi
