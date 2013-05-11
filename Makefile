project = project_name
method = method_name

corpus_path = corpus
model_path = train/model
moses_bin_path = ~/mosesdecoder/bin

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
	sed -e "s%6 0 0 5 `pwd`/$(model_path)/rule-table\.gz%2 0 0 5 `pwd`/$(model_path)/rule-table\.folder%g" $(model_path)/moses.ini.orig >$(model_path)moses.ini

.PHONY : clean

clean:
	rm -r lm train
	rm $(corpus_path)/$(project).clean.*
	rm $(corpus_path)/$(project).tok.*
