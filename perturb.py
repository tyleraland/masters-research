import json
import sys
import csv
import re
import os
from glob import glob
from random import random

# Assume: .jplace files are all of the form COGs/gene/sample.jplace
# Usage: ./perturb.py iterations gene outdir
# **NOTE: outdir must include trailing '/' **

iters = int(sys.argv[1])
gene = sys.argv[2]
outdir = sys.argv[3]

# Tracks number of moved placements
statfile = open(os.path.dirname(outdir) + "/" + "statfile", 'w') 
writer = csv.writer(statfile, delimiter=',') 
writer.writerow(["sample", "moved", "total"])

treefile = open(os.path.dirname(outdir) + "/" + gene + "_tree", 'w') # For later calculating branch lengths
empty_tree = True

files = glob("COGs/" + gene + "/*.jplace")
for iter in range(1,iters+1):
    for filename in files:
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
                coin -= cand[3]
                if coin <= 0:
                    coin = 1.0
                    cand[3] = 1
                    candl = [cand]
                    break
            if candl[0] != orig:
                moved += 1
        sample = os.path.basename(filename)[:-7] + "_" + str(iter)
        writer.writerow([os.path.basename(sample), moved, str(len(data["placements"]))])
        #print("Moved " + str(moved) + " of " + str(len(data["placements"])) + " total placements for " + sample)
        #print("outdir: " + outdir)
        #print("sample: " + sample)
        outpath = os.path.dirname(outdir) + "/" + sample + ".jplace"
        #print("outpath: " + outpath)
        out = open(outpath, 'w')
        out.write(json.dumps(data))
        out.close()
statfile.close()
