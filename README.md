# Iris image annotation tool

## Background

A simple tool in Matlab for annotating iris and eyelid boundaries, eye corners and irregular occlusions. Circular approximations of pupil and iris boundaries are assumed, and parabolic approximations for eyelid shapes are used. This tool was developed to conduct research on diurnal patterns in eyelid apperture and pupil size summarized in: [A. Czajka, K. W. Bowyer and E. Ortiz, "Analysis of diurnal changes in pupil dilation and eyelid aperture," in IET Biometrics, vol. 7, no. 2, pp. 136-144, 3 2018](https://ieeexplore.ieee.org/document/8302681)

## Instructions:

1. Run `runSegmentation` script (no input arguments are needed). You should see the first image read from `data-raw` subfolder.
2. Now you can choose one of four possibilities by pressing:
- `p` for pupil annotation,
- `i` for iris annotation,
- `u` for upper eyelid annotation,
- `l` for lower eyelid annotation.
3. Mark as many points on the boundary as you want. Press `RETURN` when you’re ready.
4. You can repeat each of the steps shown in 2. many times. For instance, if you have the upper eyelid annotated, but you are not happy with the result, just press `u` again and repeat the annotation.
5. When all four elements are accurately annotated press `s`. The results will be saved in `data-results` folder.
6. Press `RETURN` for the next image.

All four steps (pupil, iris, upper eyelid and lower eyelid) use the least squares minimization to fit actual curves. Hence the only thing that must be done is selection of points (the more the better) on iris boundaries and eyelids. Good practice is to annotate at least five points when marking the pupil, iris and eyelids, and trying to place them equidistantly on the visible boundaries.

## Extras

You can stop annotations and return to it later — Matlab saves the current state in `savedState.mat` file. So when you run `runSegmentation` again, it will start from the next non-annotated image in `data-raw` folder. If you want to start from scratch, simply delete the `savedState.mat`.

To check that all is correctly saved in files, you can run `visualizeSegmentation.m`.

