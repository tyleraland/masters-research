import json
import sys
import csv
import re
import os
from glob import glob
import random

# Assume: .jplace files are all of the form HOME/analysis/gene/sample.jplace
# Usage: ./perturb.py iterations gene outdir
# **NOTE: outdir must include trailing '/' **

# Tracks number of moved placements
iters = int(sys.argv[1])
gene = sys.argv[2]
outdir = sys.argv[3]
rseed = int(sys.argv[4])
random.seed(rseed)


#statfile = open(os.environ['HOME'] + "/" + os.path.dirname(outdir) + "/" + "statfile", 'w') 
statfile = open(outdir + "statfile", 'w')
statwriter = csv.writer(statfile, delimiter=',') 
statwriter.writerow(["sample", "moved", "total"])

#treefile = open(os.environ['HOME'] + "/" + os.path.dirname(outdir) + "/" + gene + "_tree", 'w') # For later calculating branch lengths
treefile = open(outdir + gene + "_tree", 'w') # For later calculating branch lengths
empty_tree = True

files = glob(os.environ['HOME'] + "/COGs/" + gene + "/*.jplace")
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
            coin = random.random()
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
        statwriter.writerow([os.path.basename(sample), moved, str(len(data["placements"])), str(rseed)])
        #print("Moved " + str(moved) + " of " + str(len(data["placements"])) + " total placements for " + sample)
        #print("outdir: " + outdir)
        #print("sample: " + sample)
        #outpath = os.environ['HOME'] + "/" + os.path.dirname(outdir) + "/" + sample + ".jplace"
        outpath = outdir + sample + ".jplace"
        #print("outpath: " + outpath)
        out = open(outpath, 'w')
        out.write(json.dumps(data))
        out.close()
statfile.close()
