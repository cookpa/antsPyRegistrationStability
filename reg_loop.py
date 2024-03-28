import ants
import sys

fi = ants.image_read('data/fixed_slice_2d.nii.gz')
mi = ants.image_read('data/moving_slice_2d.nii.gz')

iterations = int(sys.argv[1])

for i in range(iterations):
    reg = ants.registration(fixed=fi, moving=mi, type_of_transform='antsRegistrationSyNQuickRepro[s]')

    deformed_mi = ants.apply_transforms(fixed=fi, moving=mi, transformlist=reg['fwdtransforms'])

    ants.image_write(deformed_mi, 'output/antspy_loop/moving_deformed_iteration_{:04d}.nii.gz'.format(i))

    if (i + 1) % int(iterations / 10) == 0:
        print(f"Iteration {i + 1}/{iterations} completed.")
