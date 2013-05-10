ja_files = $(shell ls *.ja)
en_files = $(shell ls *.en)

run:
	cat $(ja_files) > _archwiki.ja
	cat $(en_files) > _archwiki.en
	python format.py _archwiki.ja >archwiki.ja
	python format.py _archwiki.en >archwiki.en
	rm _archwiki.ja _archwiki.en

test:
	echo "archwiki.ja: `wc -l archwiki.ja` lines"
	echo "archwiki.en: `wc -l archwiki.en` lines"

.PHONY : clean

clean:
	rm archwiki.ja archwiki.en
