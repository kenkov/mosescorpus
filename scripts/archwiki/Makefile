ja_files = $(shell ls *.ja)
en_files = $(shell ls *.en)

run:
	cat $(ja_files) > _archwiki.ja
	cat $(en_files) > _archwiki.en
	python pre_format.py _archwiki.ja | python post_format.py >archwiki.ja
	python pre_format.py _archwiki.en | python post_format.py >archwiki.en
	rm _archwiki.ja _archwiki.en

.PHONY : clean

clean:
	rm pre_archwiki.ja \
		pre_archwiki.en \
		archwiki.ja \
		archwiki.en
