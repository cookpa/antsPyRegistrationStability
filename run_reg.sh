#!/bin/bash

ITS=1

if [[ $# -eq 0 ]]; then
    echo "Usage: $0 <iterations>"
    exit 1
fi

ITERS=$1

mkdir -p output

mkdir -p output/ants_reg_syn
mkdir -p output/antspy_loop
mkdir -p output/antspy_no_loop
mkdir -p output/stacks

for i in `seq -w 0 $((ITERS-1))`; do
  antsRegistrationSyN.sh \
       -d 2 \
       -f data/fixed_slice_2d.nii.gz \
       -m data/moving_slice_2d.nii.gz \
       -t s \
       -o output/ants_reg_syn/moving_to_fixed_${i}_
done

c3d output/ants_reg_syn/moving_to_fixed_*_Warped.nii.gz -tile z -o output/stacks/stack_cmd.nii.gz

python reg_loop.py $ITERS

c3d output/antspy_loop/moving_deformed_iteration_*.nii.gz -tile z -o output/stacks/stack_loop.nii.gz

counter=0
for i in `seq -w 0 $((ITERS-1))`; do
    python reg_no_loop.py $i
    counter=$((counter+1))
    if [[ $(( counter % (ITERS/10) )) -eq 0 ]]; then
        echo "Done $counter iterations"
    fi
done

c3d output/antspy_no_loop/moving_deformed_iteration_*.nii.gz -tile z -o output/stacks/stack_no_loop.nii.gz


# MeasureImageSimilarity
mkdir -p output/similarity

ants_reg_syn_cc=output/similarity/ants_reg_syn_cc_similarity.txt

echo "ants_reg_syn_cc" > $ants_reg_syn_cc

for output in `ls output/ants_reg_syn/moving_to_fixed_*_Warped.nii.gz`; do
    MeasureImageSimilarity \
        -d 2 \
        -m CC[ data/fixed_slice_2d.nii.gz , $output , 1, 4 ] >> $ants_reg_syn_cc
done

antspy_loop_cc=output/similarity/antspy_loop_cc_similarity.txt

echo "antspy_loop_cc" > $antspy_loop_cc

for output in `ls output/antspy_loop/moving_deformed_iteration_*.nii.gz`; do
    MeasureImageSimilarity \
        -d 2 \
        -m CC[ data/fixed_slice_2d.nii.gz , $output , 1, 4 ] >> $antspy_loop_cc
done

antspy_no_loop_cc=output/similarity/antspy_no_loop_cc_similarity.txt

echo "antspy_no_loop_cc" > $antspy_no_loop_cc

for output in `ls output/antspy_no_loop/moving_deformed_iteration_*.nii.gz`; do
    MeasureImageSimilarity \
        -d 2 \
        -m CC[ data/fixed_slice_2d.nii.gz , $output , 1, 4 ] >> $antspy_no_loop_cc
done
