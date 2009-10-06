#!/bin/bash

TMP=/tmp/eo-en
CRP=corpa/eo.crp.txt
NOVA=testcache/corpus_eo-en_nova_traduko.txt
ORIGINA=testcache/corpus_eo-en_origina_traduko.txt

make -s -j 3 && cat $CRP | apertium -d . eo-en > $NOVA || exit
echo
grep '#' $NOVA && echo -e "^ Estis mankoj eo la cellingva dix, montrata supre ^\n"
grep '@' $NOVA && echo -e "^ Estis mankoj eo la dulingva dix, montrata supre ^\n"

if [ -e $ORIGINA ]
then
	diff -w $ORIGINA $NOVA | grep -r '[<>]' > $TMP-crpdiff.txt && for i in `cut -c3-8 $TMP-crpdiff.txt | sort -un`; do echo  --- $i ---; grep -r "^ *$i\." $CRP; grep -r "^. *$i\." $TMP-crpdiff.txt; done > testcorpus_eo-en.txt
	echo "Estis `cut -c3-8 $TMP-crpdiff.txt | sort -un | wc -l` difereoco(j) - rigardu eo: testcorpus_eo-en.txt"
	echo
fi

echo "Se vi volas uzi la nunan version por kompari veoontajn versiojn, voku nun:"
echo "mv $NOVA $ORIGINA"
echo
