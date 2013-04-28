project = project_name

ja2en:
	./train.sh $(project) ja en

en2ja:
	./train.sh $(project) en ja

ja2ja:
	./train.sh $(project) ja ja

tw:
	./train.sh twitter tworig twrep

.PHONY : clean

clean:
	rm -r lm train
	rm corpus/$(project).clean.*
	rm corpus/$(project).tok.*
