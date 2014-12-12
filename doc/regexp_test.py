#coding: utf8
import re
import string

text = "JGood is a handsome boy, he is cool, clever, and so on..."
content1 = "hello.cpp"
def match_case(content, regexpstr):
    prog = re.compile(regexpstr)
    res = re.match(prog, content)
    if res:
        print "true"
        print res.group(), "--", res.groups()
    else:
        print "false"
#you can test regexp in emacs
def test_regexp_for_emacs():
    #match_case(content1, r"(\w+).(cpp)") # group "()" is only valid in python 
    match_case(content1, r"\w+[.]cpp") 
#    match_case(text, r"(\w+)\s")
#    match_case("translate(57.077812,12.405725) scale(1.530265,1.530265)", "(\S+)\((\S+),(\S+)\)\s+(\S+)\((\S+),(\S+)\)")

if __name__ == "__main__":
    test_regexp_for_emacs()
