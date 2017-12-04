#!/bin/bash 
# Dependencies: sudo apt install sdcv wordnet-core lynx
# ...+ a startdict dictionary 'Oxford Synonyms & Antonyms', find it and see man sdcv where it should be located (or write its location in an environmental variable, as written in man sdcv), but you can probably go without it as voc1-script also parses an online dictionary at Thesaurus.com and uses WordNet

# while writing this script I used spellcheck for statical analysis of my code, and helped to write it faster

# switch to English language to correctly parse the output if the program is able to work in another language
export LANG=c
cd /tmp || return
# clean junk files from previous runs
rm -fv voc1*.list lynx*.txt

word="$2"
grep_exp="$3"

if [[ $type = "ant" ]]
	then
		type_grep_sdcv="Ant"
		type_grep_wn="ants"
		type_grep_th="Antonyms"
	else
		if [[ $type = "syn" ]]
			then
				type_grep_sdcv="Syn"
				type_grep_wn="syns"
				type_grep_th="Synonyms"
		fi
fi
echo "======================="
echo WORD/LINE: $line
echo "======================="

rm -fv voc1-1.list voc1-2.list
# first, list all word's synonyms or antonyms to a file line-by-line
sdcv -n "$word" | grep "${type_grep_sdcv}:" -A1 | grep -v "${type_grep_sdcv}:" | grep -v '\-\-' | tr ',' ' ' | tr ';' ' ' | tr '/' ' ' | tr ',' ' ' | tr ' ' "\n" | sed '/^\s*$/d' | sort | uniq | sed 's~[^[:alnum:]/]\+~~g' >voc1-1.list
wn "$line" -${type_grep_wn}v -${type_grep_wn}n -${type_grep_wn}a -${type_grep_wn}a | grep '=>' | awk -F '=> ' '{print $2}' | tr ', ' '\n' | sed '/^\s*$/d' | sort | uniq | sed 's~[^[:alnum:]/]\+~~g' >>voc1-1.list

# Now let's parse the online Thesaurus dictionary
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
cat lynx-3.txt >> voc1-1.list

# now find synonyms for every previously found word to enlarge the word base
while read -r line
do
	sdcv -n "$line" | grep "Syn:" -A1 | grep -v "Syn:" | grep -v '\-\-' | tr ',' ' ' | tr ';' ' ' | tr '/' ' ' | tr ',' ' ' | tr ' ' "\n" | sed '/^\s*$/d' | sort | uniq | sed 's~[^[:alnum:]/]\+~~g' >>voc1-2.list
	## sdcv -n "$line" | grep 'Syn:' -A1 | tail -n 1 | tr ',' ' ' | tr ';' ' ' | tr '/' ' ' | tr ',' ' ' | tr ' ' "\n" | sed '/^\s*$/d' | sort | uniq >>voc1-2.list
done < voc1-1.list

## now find synonyms for each of already found words from 2 previous iterations using WordNet to enlarge our word base even more
#while read -r line
#do
	#wn "$line" -synsv -synsn -synsa -synsa | grep '=>' | awk -F '=> ' '{print $2}' | tr ', ' '\n' | sed '/^\s*$/d' | sort | uniq | sed 's~[^[:alnum:]/]\+~~g' >>voc1-3.list
#done < voc1-2.list

## oh, and now we will look for for each word's synonym in our first dictionary
#while read -r line
#do
	#sdcv -n "$line" | grep "Syn:" -A1 | grep -v "Syn:" | grep -v '\-\-' | tr ',' ' ' | tr ';' ' ' | tr '/' ' ' | tr ',' ' ' | tr ' ' "\n" | sed '/^\s*$/d' | sort | uniq >>voc1-4.list
	### sdcv -n "$line" | grep 'Syn:' -A1 | tail -n 1 | tr ',' ' ' | tr ';' ' ' | tr '/' ' ' | tr ',' ' ' | tr ' ' "\n" | sed '/^\s*$/d' | sort | uniq >>voc1-4.list
#done < voc1-3.list


cat voc1-2.list | sort | uniq | sed 's~[^[:alnum:]/]\+~~g' >>voc1-5total.list
cat voc1-5total.list | grep ^${grep_exp} | sort -r

# now we have many words one-by-line in the file voc1-3.list (in /tmp/voc1-3.list, if the directory /tmp exists)
# now we will grep them using our mask to list the ones that match the crossword clue
# in case no words have been found, we will warn the user about this and output all words from voc1-3.list line-by-line (and the user can parse them using cli utils)
