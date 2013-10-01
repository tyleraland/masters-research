#!/bin/sh
#$ -S /bin/sh
#$ -cwd

PATH=$SGE_O_PATH:$PATH
echo $PATH
ls /home/landt/bin/
Rscript /home/landt/Code/research/dummy.R
#/home/landt/bin/Rscript
