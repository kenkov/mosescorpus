#! /usr/bin/env python
# coding:utf-8

from __future__ import division
import re


def substitute(text):
    re_strs = [(ur'\[', u"("),
               (ur'\]', u")"),
               (ur'(http|https)://[a-zA-Z0-9-./"#$%&\':?=_~]+', u""),
               ]
    for re_str in re_strs:
        re_obj = re.compile(re_str[0])
        text = re_obj.sub(re_str[1], text)
    return text


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
            text = substitute(line)
            #if is_ignore_line(text):
            #    continue
            #else:
            print text.strip().encode('utf-8')
