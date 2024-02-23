import ants
import sys

fi = ants.image_read('data/fixed_slice_2d.nii.gz')
mi = ants.image_read('data/moving_slice_2d.nii.gz')

iteration = int(sys.argv[1])

reg = ants.registration(fixed=fi, moving=mi, type_of_transform='SyN')

deformed_mi = ants.apply_transforms(fixed=fi, moving=mi, transformlist=reg['fwdtransforms'])

ants.image_write(deformed_mi, 'output/antspy_no_loop/moving_deformed_iteration_{:04d}.nii.gz'.format(iteration))
