#!/usr/bin/python
"""Split up a FASTQ file based on the first field of the header."""
#Written by Sam Minot: https://gist.github.com/sminot/d5c794c22c48eda8a515cd16bed512f7
#Josh Harrison modified the split statement and changed readline to next to
#to avoid errors due to the read-ahead function of next.

#Usage: split_by_header.py yourfastq

from collections import defaultdict
import gzip
import sys
import os

fp = sys.argv[1]
if not os.path.exists(fp):
    raise Exception("{} does not exist".format(fp))

# JH: changing output destination to make things cleaner in Nextflow
# folder = "{}.split".format(fp)

#if not os.path.exists(folder):
#    os.mkdir(folder)

if fp.endswith('.gz'):
    f = gzip.open(fp)
else:
    f = open(fp)

record = []
records = defaultdict(list)
for line in f:
    name = line[1:].split()[0] #modified so that this splits on white space
    records[name].append(line)
    records[name].append(f.next()) #This used to be readline()
    records[name].append(f.next())
    records[name].append(f.next())
    if len(records[name]) > 100000:
        # print "Writing {} lines".format(len(records[name]))
        #with open("{}/{}.fastq".format(folder, name), 'a') as fo:
        with open("{}.fastq".format(name), 'a') as fo:
            fo.write(''.join(records[name]))
        records[name] = []

f.close()

for name in records.keys():
    #with open("{}/{}.fastq".format(folder, name), 'a') as fo:
    with open("{}.fastq".format(name), 'a') as fo:

            fo.write(''.join(records[name]))
