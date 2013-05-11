project = project_name
method = method_name

ja2en:
	./train.sh $(project) ja en $(method)

en2ja:
	./train.sh $(project) en ja $(method)

ja2ja:
	./train.sh $(project) ja ja $(method)

tw:
	./train.sh twitter tworig twrep

.PHONY : clean

clean:
	rm -r lm train
	rm corpus/$(project).clean.*
	rm corpus/$(project).tok.*
