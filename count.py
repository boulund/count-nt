#!/usr/bin/env python3.4
# Fredrik Boulund 2014-05-21
# Counts nucleotides (stupid) in FASTA files.


from sys import stdin, exit, argv

if len(argv)<2:
    print("usage: count.py [-] [FILE]")

total = 0
count = 0
if "-" in argv:
    for line in stdin:
        if line.startswith(">"):
            total += count
            count = 0
        else:
            count += len(line.strip())
    total += count
else:
    with open(argv[1]) as file:
        for line in file:
            if line.startswith(">"):
                total += count
                count = 0
            else:
                count += len(line.strip())
        total += count

print(total)
