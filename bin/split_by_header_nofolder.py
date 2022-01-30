#!/usr/bin/python
"""Split up a FASTQ file based on the first field of the header."""
#Written by Sam Minot: https://gist.github.com/sminot/d5c794c22c48eda8a515cd16bed512f7
#Josh Harrison modified the split statement and changed readline to next to
#to avoid errors due to the read-ahead function of next. Also removed the output
#to a directory that was originally here.

#Usage: split_by_header.py yourfastq

from collections import defaultdict
import gzip
import sys
import os

fp = sys.argv[1]
if not os.path.exists(fp):
    raise Exception("{} does not exist".format(fp))

if fp.endswith('.gz'):
    f = gzip.open(fp)
else:
    f = open(fp)

records = defaultdict(list)
for line in f:
    name = line[1:].split()[0] #modified so that this splits on white space
    records[name].append(line)
    records[name].append(f.next()) #This used to be readline()
    #If you get an error here like this: AttributeError: '_io.TextIOWrapper' object has no attribute 'next'
    #it is because you are using python3. Python really sucks sometimes.
    records[name].append(f.next())
    records[name].append(f.next())

    #This section was in here so that not too much was stored in memory at a time.
    #I am not 100% sure what ratio of write often/hold in memory is most performant,
    # but I suspect that storing as much
    #in memory as possible and then only writing to disk a few times will be
    #faster then writing more often. So, I am bumping up the limits here

    if len(records[name]) > 1000000:
        # print "Writing {} lines".format(len(records[name]))
        with open("{}.fastq".format(name), 'a') as fo:
            fo.write(''.join(records[name]))
        records[name] = []

f.close()

# the a is for append or make new file. The "with" option automatically closes
# the file after writing.
for name in records.keys():
    with open("{}.fastq".format(name), 'a') as fo:
            fo.write(''.join(records[name]))
