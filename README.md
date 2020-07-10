# Iris image annotation tool

## Background

A simple tool in Matlab for annotating iris and eyelid boundaries, eye corners and irregular occlusions. Circular approximations of pupil and iris boundaries are assumed, and parabolic approximations for eyelid shapes are used. This tool was developed to conduct research on diurnal patterns in eyelid apperture and pupil size summarized in: [A. Czajka, K. W. Bowyer and E. Ortiz, "Analysis of diurnal changes in pupil dilation and eyelid aperture," in IET Biometrics, vol. 7, no. 2, pp. 136-144, 3 2018](https://ieeexplore.ieee.org/document/8302681)

## Instructions:

1. Run ‘runSegmentation’ script (no input arguments are needed). You should see the first image read from ‘data-raw’ subfolder.
2. Now you can choose one of four possibilities by pressing:
- ‘p’ for pupil annotation,
- ‘i’ for iris annotation,
- ‘u’ for upper eyelid annotation,
- ‘l’ for lower eyelid annotation.
3. Mark as many points on the boundary as you want. Press RETURN when you’re ready.
4. You can repeat each of the steps shown in 2. many times. For instance, if you have the upper eyelid annotated, but you are not happy with the result, just press ‘u’ again and repeat the annotation.
5. When all four elements are accurately annotated press ‘s’. The results will be saved in ‘data-results’ folder.
6. Press RETURN for the next image.

