#!/bin/bash
type_grep_th="Antonyms"
cd /tmp || return
lynx -dump -nolist http://www.thesaurus.com/browse/get >lynx-1.txt
# sed '1d' removes the fisrt line of input (the first line will always be 'Synonyms' or 'Antonyms')
# sed '/^\s*$/d' removes empty lines
cat lynx-1.txt | grep -m 1 "${type_grep_th} for" -A50000 | sed '1d' | sed '/^\s*$/d' >lynx-2.txt

while read -r line
do
	line_cleaned="$(echo "$line" | grep '* ' | awk -F '* ' '{print $2}')"
	# if line_cleaned not empty
	if [[ ! -z "$line_cleaned" ]]; then
		echo "$line_cleaned" >>lynx-3.txt
	else break
	fi
done < lynx-2.txt



