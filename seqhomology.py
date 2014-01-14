#!/usr/bin/env python
# http://biostumblematic.wordpress.com
 
import string
import sys
from Bio import AlignIO
from numpy import mean

# Usage: ./seqhomology input.fasta
 
# change input.fasta to match your alignment
input_handle = open(sys.argv[1], "rU")
alignment = AlignIO.read(input_handle, "fasta")
 
j=0 # counts positions in first sequence
i=0 # counts identity hits
identities = []
for record in alignment:
    for amino_acid in record.seq:
        if amino_acid == '-':
            pass
        else:
            if amino_acid == alignment[0].seq[j]:
                i += 1
        j += 1
    j = 0
    seq = str(record.seq)
    gap_strip = seq.replace('-', '')
    percent = 100*i/len(gap_strip)
    identities.append(percent)
    #print record.id+' '+str(percent)
    i=0
print(round(mean(identities), 2))
