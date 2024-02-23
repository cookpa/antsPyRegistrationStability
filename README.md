# antsPyRegistrationStability


## Requirements

ANTs
ANTsPy
c3d

## Data

* fixed_slice_2d.nii.gz - from tpl-MNI152NLin2009bAsym T1w image
* moving_slice_2d.nii.gz - from Lüsebrink et al, sub-01_avg-04_T1w.nii.gz, downsampled to
  0.5mm ([source](https://www.nature.com/articles/sdata201732))


## Script

`run_reg.sh` - Repeats the same registration in different ways. Output is a stack of images
representing each mode of execution:

`stack_cmd.nii.gz` - running `antsRegistrationSyN.sh`
`stack_loop.nii.gz` - running Python ants.registration in a for loop
`stack_noloop.nii.gz` - running Python ants.registration in independent calls

