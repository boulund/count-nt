#!/usr/bin/env python3.4
# Fredrik Boulund 2014-05-21
# Counts nucleotides (stupid) in FASTA files.


from sys import stdin, exit, argv

if len(argv)<2:
    print("usage: count.py [-] [FILE]")

total = 0
if "-" in argv:
    for line in stdin:
        if not line.startswith(">"):
            total += len(line.strip())
else:
    with open(argv[1]) as file:
        for line in file:
            if not line.startswith(">"):
                total += len(line.strip())
print(total)
