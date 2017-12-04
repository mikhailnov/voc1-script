This script '**voc1-script**' helps to **find synonyms and antonyms for specific words** and grep them by mask (useful when solving a crossword-puzzle)

Installation (Linux, FreeBSD):
```
git clone https://github.com/mikhailnov/voc1-script.git
sudo mv -v voc1-script.sh /usr/local/bin/voc1-script
sudo chmod +x /usr/local/bin/voc1-script
```

Usage:
```
$ voc1-script [syn|ant] [word] [grep mask]
```
ant - antonyms
syn - synonyms

Example:
```voc1-script ant finalize co...e..``` will find all antonyms for the word 'finalize' which match the mask 'co...e..', where '.' means any 1 symbol. You can add '$' in the end to show the end of line (that the word must not have any more symbols) or '^' in the beginning to show that there must not me any letters/symbols befire the first letter of our regular expression, e.g.:
```voc1-script ant finalize ^co...e..$```
The answer is 'complete'

See the screen video demo of ```voc1-script``` in real life usage.
[![IMAGE ALT TEXT](http://img.youtube.com/vi/W21oNV25odU/0.jpg)](http://www.youtube.com/watch?v=W21oNV25odU "voc1-script demo")

Dependencies:
```sudo apt install sdcv wordnet-base lynx```
+ a startdict dictionary 'Oxford Synonyms & Antonyms', find it and see ```man sdcv``` where it should be located (or write its location in an environmental variable, as written in ```man sdcv```)

As voc1-script also parses thesaurus.com, you may probably work without an sdcv's dictionary.
