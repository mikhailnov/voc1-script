#!/bin/bash 
# Нет желания писать скрипт полностью нормально, работает, и ладно
# Dependencies: sudo apt install sdcv wordnet-core
# ...+ a startdict dictionary 'Oxford Synonyms & Antonyms', find it and see man sdcv where it should be located (or write its location in an environmental variable, as written in man sdcv)

# while writing this script I used spellcheck for statical analysis of my code, and helped to write it faster

# switch to English language to correctly parse the output if the program is able to work in another language
export LANG=c
cd /tmp || return
# clean junk files from previous runs
rm -fv voc1*.list

# the path to the text file from which we have to solve the crossword puzzle is stored in the environmental variable
# it allows to specify it only once in the session and reuse it automatically for all following words

if [[ -z "$VOC1_INPUT_TEXT_PATH" ]]
	then
		echo "input the path to the input text file and press enter"
		read VOC1_INPUT_TEXT_PATH_ORIG
		# when copying a file in the dolphin file manager and then pasting to the text field, the output has a prefix 'file://', it should be automatically removed
		VOC1_INPUT_TEXT_PATH="$(echo "VOC1_INPUT_TEXT_PATH_ORIG" | awk -F 'file://' '{print $2}')"
fi
input_text="$VOC1_INPUT_TEXT_PATH"

cat "$input_text" | sed "s/[^a-zA-Z']/ /g" | tr ' ' '\n' | sed '/^\s*$/d' | sort | uniq >voc1-0text.list

type="$1"
word="$2"
if [[ $type = "ant" ]]
	then
		type_grep="Ant"
fi
if [[ $type = "syn" ]]
	then
		type_grep="Syn"
fi

while read line
do
	rm -fv voc1-1.list voc1-2.list voc1-3.list voc1-4.list
	# first, list all word's synonyms or antonyms to a file line-by-line
	## sdcv -n "launches" | grep "Syn:" -A1 | grep -v 'Syn:' | grep -v '\-\-'
	sdcv -n "$word" | grep "${type_grep}:" -A1 | grep -v "${type_grep}:" | grep -v '\-\-' | tr ',' ' ' | tr ';' ' ' | tr '/' ' ' | tr ',' ' ' | tr ' ' "\n" | sed '/^\s*$/d' | sort | uniq >voc1-1.list
	## tail -n 1 | tr ',' ' ' | tr ';' ' ' | tr '/' ' ' | tr ',' ' ' | tr ' ' "\n" | sed '/^\s*$/d' | sort | uniq >voc1-1.list

	# now find synonyms for every previously found word to enlarge the word base
	while read -r line
	do
		sdcv -n "$line" | grep "Syn:" -A1 | grep -v "Syn:" | grep -v '\-\-' | tr ',' ' ' | tr ';' ' ' | tr '/' ' ' | tr ',' ' ' | tr ' ' "\n" | sed '/^\s*$/d' | sort | uniq >>voc1-2.list
		## sdcv -n "$line" | grep 'Syn:' -A1 | tail -n 1 | tr ',' ' ' | tr ';' ' ' | tr '/' ' ' | tr ',' ' ' | tr ' ' "\n" | sed '/^\s*$/d' | sort | uniq >>voc1-2.list
	done < voc1-1.list

	# now find synonyms for each of already found words from 2 previous iterations using WordNet to enlarge our word base even more
	while read -r line
	do
		wn "$line" -synsv -synsn -synsa -synsa | grep '=>' | awk -F '=> ' '{print $2}' | tr ', ' '\n' | sed '/^\s*$/d' | sort | uniq >>voc1-3.list
	done < voc1-2.list

	# oh, and now we will find for each word's synonym in our first dictionary
	while read -r line
	do
		sdcv -n "$line" | grep "Syn:" -A1 | grep -v "Syn:" | grep -v '\-\-' | tr ',' ' ' | tr ';' ' ' | tr '/' ' ' | tr ',' ' ' | tr ' ' "\n" | sed '/^\s*$/d' | sort | uniq >>voc1-4.list
		## sdcv -n "$line" | grep 'Syn:' -A1 | tail -n 1 | tr ',' ' ' | tr ';' ' ' | tr '/' ' ' | tr ',' ' ' | tr ' ' "\n" | sed '/^\s*$/d' | sort | uniq >>voc1-4.list
	done < voc1-3.list
done < voc1-0text.list

cat voc1-4.list >>voc1-5total.list

# now we have many words one-by-line in the file voc1-3.list (in /tmp/voc1-3.list, if the directory /tmp exists)
# now we will grep them using our mask to list the ones that match the crossword clue
# in case no words have been found, we will warn the user about this and output all words from voc1-3.list line-by-line (and the user can parse them using cli utils)

# echo "Usage: $0 ant|syn word, example: $0 ant beautiful" 
