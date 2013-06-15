#! /bin/sh
# coding:utf-8

# how to use
# ./train.sh project_name source_lang target_lang
# [example]
# $ ./train.sh project_name ja en

project_name=$1
source_lang=$2
target_lang=$3
# method must be "phrase" or "hier"
method=$4
if [ $method != "phrase" ] -a [ $method != "hier" ]; then
    exit 1
fi
current_path=`pwd`

mkcorpus() {
  case $1 in
    en)
      ~/mosesdecoder/scripts/tokenizer/tokenizer.perl -l en < ${current_path}/corpus/${project_name}.en > ${current_path}/corpus/${project_name}.tok.en
    ;;
    ja)
      mecab -O wakati < ${current_path}/corpus/${project_name}.$1 > ${current_path}/corpus/${project_name}.tok.$1
    ;;
    tworig)
      mecab -O wakati < ${current_path}/corpus/${project_name}.$1 > ${current_path}/corpus/${project_name}.tok.$1
    ;;
    twrep)
      mecab -O wakati < ${current_path}/corpus/${project_name}.$1 > ${current_path}/corpus/${project_name}.tok.$1
    ;;
    *)
      echo "please specify en or ja for language"
    ;;
  esac
}

phrase_model() {
  ## model training
  ~/mosesdecoder/scripts/training/train-model.perl \
    -root-dir ${current_path}/train \
    -corpus ${current_path}/corpus/${project_name}.clean \
    -f $source_lang \
    -e $target_lang \
    -reordering hier-msd-bidirectional-fe \
    -alignment grow-diag-final-and \
    -lm 0:3:${current_path}/lm/${project_name}.blm.${target_lang}:8 \
    -external-bin-dir ~/mosesdecoder/tools \
    -cores 2 > ${current_path}/train/training.out
}

hier_model() {
  ## model training
  ~/mosesdecoder/scripts/training/train-model.perl \
    -root-dir ${current_path}/train \
    -corpus ${current_path}/corpus/${project_name}.clean \
    -f $source_lang \
    -e $target_lang \
    -alignment grow-diag-final-and \
    -lm 0:3:${current_path}/lm/${project_name}.blm.${target_lang}:8 \
    -hierarchical \
    -glue-grammar \
    -external-bin-dir ~/mosesdecoder/tools \
    -cores 2 > ${current_path}/train/training.out
}

## make directories
mkdir ${current_path}/{lm,train}

## make corpus
mkcorpus $source_lang
mkcorpus $target_lang

# make clear corpus (filter sentences whose length is between 1 and 80)
~/mosesdecoder/scripts/training/clean-corpus-n.perl \
    ${current_path}/corpus/${project_name}.tok \
    $source_lang $target_lang ${current_path}/corpus/${project_name}.clean \
    1 80

## Language model training
~/irstlm/bin/add-start-end.sh < ${current_path}/corpus/${project_name}.${target_lang} > ${current_path}/lm/${project_name}.sb.${target_lang}
env IRSTLM=$HOME/irstlm ~/irstlm/bin/build-lm.sh \
    -i ${current_path}/lm/${project_name}.sb.${target_lang} \
    -t ${current_path}/lm/tmp -p -s improved-kneser-ney \
    -o ${current_path}/lm/${project_name}.lm.${target_lang}
~/irstlm/bin/compile-lm --text yes ${current_path}/lm/${project_name}.lm.${target_lang}.gz ${current_path}/lm/${project_name}.arpa.${target_lang}
# binalize
~/mosesdecoder/bin/build_binary  ${current_path}/lm/${project_name}.arpa.${target_lang}  ${current_path}/lm/${project_name}.blm.${target_lang}

## model training
if [ $method = hier ]; then
    hier_model
elif [ $method = phrase ]; then
    phrase_model
fi
