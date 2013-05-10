#! /usr/bin/env python
# coding:utf-8

from __future__ import division
import re


def substitute(text):
    re_strs = [ur'^\s*\d(\.\d)+\.?\s*',
               ur'note:\s*',
               ur'(日本語)',
               ur'(http|https)://[a-zA-Z0-9-./"#$%&\':?=_]+',
               ]
    for re_str in re_strs:
        re_obj = re.compile(re_str)
        text = re_obj.sub("", text)
    return text


def split(text):
    re_strs = [ur'(:)\s*\S+.*$',
               ur'(;)\s*\S+.*$',
               ur'(\.)\s*\S+.*$',
               ur'(。)\s*\S+.*$',
               ]
    for re_str in re_strs:
        re_obj = re.compile(re_str)
        text = re_obj.sub(u"\\1\n", text)
    return text


def is_ignore_line(text):
    re_strs = [ur'^\s*$',
               ]
    for re_str in re_strs:
        re_obj = re.compile(re_str)
        if re_obj.search(text):
            return True
    else:
        return False


if __name__ == '__main__':
    import sys
    import codecs
    try:
        input_file = sys.argv[1]
        sys.stdin = codecs.open(input_file, "r", 'utf-8')
    except IndexError:
        pass

    with sys.stdin as f:
        for line in (line.strip() for line in f):
            text = split(substitute(line))
            if is_ignore_line(text):
                continue
            else:
                print text.strip().encode('utf-8')
