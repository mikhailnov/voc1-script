This script '**voc1-script**' helps to **find synonyms and antonyms for specific words** and grep them by mask (useful when solving a crossword-puzzle)

Installation (Linux, FreeBSD):
```
git clone https://github.com/mikhailnov/voc1-script.git
sudo mv -v voc1-script.sh /usr/local/bin/voc1-script
sudo chmod +x /usr/local/bin/voc1-script
```
Dependencies: <br>
```sudo apt install sdcv wordnet-base lynx p7zip``` <br>
\+ a startdict dictionary 'Oxford Synonyms & Antonyms', find it and see ```man sdcv``` where it should be located (or write its location in an environmental variable, as written in ```man sdcv```) <br>
Extract ```oxford_dictionary_of_synonyms_and_antonyms_for_stardict_gold.7z``` to ```~/.stardict/dic/``` to have a working dictionary for sdcv (this dictionary is distributed here for testing purposes only).

Usage:
```
$ voc1-script [syn|ant] [word] [[grep mask]]
```
ant - antonyms, syn - synonyms <br>
The grep mask may be not specified (empty).

Example: <br>
```voc1-script ant finalize co...e..``` will find all antonyms for the word 'finalize' which match the mask 'co...e..', where '.' means any 1 symbol. You can add '$' in the end to show the end of line (that the word must not have any more symbols) e.g.: <br>
```voc1-script ant finalize co...e..$``` <br>

Another example: <br>
```voc1-script syn finalize co...e..$``` : will do the same, but find synonyms for the word 'finalize', not antonyms. The answer is 'complete'.

See the screen video demo of ```voc1-script``` in real life usage. <br>
[![CLICK HERE TO WATCH THE VIDEO DEMO](http://img.youtube.com/vi/W21oNV25odU/0.jpg)](http://www.youtube.com/watch?v=W21oNV25odU "voc1-script demo")

As voc1-script also parses thesaurus.com, you may probably work without an sdcv's dictionary.
