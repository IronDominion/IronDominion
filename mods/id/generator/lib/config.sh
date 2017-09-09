#!/bin/bash

parse_file() {
	CONFIG_SH_VAR="$1"
	CONFIG_SH_FILE="$2"
	
	declare -g -A $CONFIG_SH_VAR
	while IFS='=' read -r -a array; do
		((${#array[@]} >= 2)) || continue
		declare -g $CONFIG_SH_VAR["${array[@]:0:1}"]="${array[@]:1}"
	done < "$CONFIG_SH_FILE"
}