#! /usr/bin/env python
# coding:utf-8

from __future__ import division
import re


def substitute(text):
    re_strs = [ur'^\s+$',
               ur'\s+$',
               ur'^\s+',
               ]
    for re_str in re_strs:
        re_obj = re.compile(re_str)
        text = re_obj.sub("", text)
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
    try:
        input_file = sys.argv[1]
        sys.stdin = open(input_file, "r")
    except IndexError:
        pass

    with sys.stdin as f:
        for line in f.readlines():
            text = substitute(line)
            text = line.strip()
            if is_ignore_line(text):
                continue
            else:
                print text
