# You must set your project name and a decoding method.
# The method variable can be chosen in phrase and hier.
project = jec
method = hier

# If you translate sentences written in a file,
# please specifiy next filenames
translation_file = testset.en
translation_output = mt-output

# if you score translation with BLEU, please set
# the following variables for files.
bleu_ref = testset.ja
bleu_mt_output = $(translation_output)

moses_path = ~/mosesdecoder
corpus_path = corpus
model_path = train/model

moses_bin_path = $(moses_path)/bin

ja2en:
	./train.sh $(project) ja en $(method)

en2ja:
	./train.sh $(project) en ja $(method)

ja2ja:
	./train.sh $(project) ja ja $(method)

tw:
	./train.sh twitter tworig twrep $(method)

hier-ondisk:
	gunzip $(model_path)/rule-table.gz
	$(moses_bin_path)/CreateOnDiskPt 1 1 5 20 2 $(model_path)/rule-table $(model_path)/rule-table.folder
	mv $(model_path)/moses.ini $(model_path)/moses.ini.orig
	sed -e "s%6 0 0 5 `pwd`/$(model_path)/rule-table\.gz%2 0 0 5 `pwd`/$(model_path)/rule-table\.folder%g" $(model_path)/moses.ini.orig >$(model_path)/moses.ini

trans:
	$(moses_path)/bin/moses_chart -f $(model_path)/moses.ini <$(translation_file) >$(translation_output)

bleu:
	$(moses_path)/scripts/generic/multi-bleu.perl $(bleu_ref) <$(bleu_mt_output)

.PHONY : clean

clean:
	rm -r lm train
	rm $(corpus_path)/$(project).clean.*
	rm $(corpus_path)/$(project).tok.*
