import json
import sys
import csv
import re
import os
from random import random

# Usage: Arg1 is prefix, later Arguments are .jplace files for each sample
statfile = open("statfile", 'w')
writer = csv.writer(statfile, delimiter=',')
#writer.writerow(["sample", "moved", "total"])

gene = sys.argv[2].split('.')[0].split('/')[-1]
treefile = open(gene + "_tree", 'w')
empty_tree = True

for filename in sys.argv[2:]:
    moved = 0
    total = 0
    f = open(filename, 'r')
    data = json.loads(f.read())
    if empty_tree:
        tree = data["tree"]
        tree = re.sub(r"{\d+}", "", tree)
        treefile.write(tree)
        treefile.close()
        empty_tree = False
    for read in data["placements"]:
        total += 1
        candl = read["p"]
        coin = random()
        orig = candl[0]
        for cand in candl:
            coin -= cand[2]
            if coin <= 0:
                coin = 1.0
                cand[2] = 1
                candl = [cand]
        if candl[0] != orig:
            moved += 1
    parts = filename.split('.')
    #outfile = '.'.join([parts[0], sys.argv[1], parts[3], parts[5], "jplace"])      # FIX THIS LATER.  Assumes weird file names
    sample = '.'.join([parts[0], sys.argv[1], parts[3], parts[5]])      # FIX THIS LATER.  Assumes weird file names
    writer.writerow([os.path.basename(sample), moved, str(len(data["placements"]))])
    #print("Moved " + str(moved) + " of " + str(len(data["placements"])) + " placements for " + sample)
    
    out = open(sample + ".jplace", 'w')
    out.write(json.dumps(data))
    out.close()
statfile.close()
