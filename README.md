# CMU 16720 Computer Vision Course Homeworks
This repository maintains my solutions to Spring 2016 Computer Vision course (16-720) homeworks at Carnegie Mellon University (CMU).


**Very Important Note:** This repository is for my own personal use as a backup and is not intended to be used as a ready-to-submit solution for other students in Spring 2016 or future iterations of the Computer Vision course at CMU. However, I am personally OK if my code can help you with solving the problems with your own implementation or in scenarios other than 16720 coursework to the extend that is not considered plagiarism. 


## Current Status of the Homeworks

### Homework 0 (Matlab Practice) 
1. **Color Channel Alignment:** This part is complete.
2. **Image Warping:** It has an issue in the implementation of the warping (compare my results with the results in the description PDF). I will probably solve the issue in the future just to have a correct code in my archive. 


### Homework 1 (Spatial Pyramid Matching for Scene Classification)
This homework is complete with some extra point implementations (review the Writeup.pdf file for more detailed information). The implementation is very efficient. 

TA comment about Q 1.0:

> Missing minor points in explanation.
>
> Comments: The Gaussian filter, filters out high intensity values, thereby removing noise.
The dx/dy filters do vertical/horizontal edges respectively (you didn't mention which derivative for which kind of edges).


### Homework 2 (Feature Descriptor & Homographies & RANSAC)
This homework is complete. however, no extra point problems are implemented due to my time limits (review the Writeup.pdf file for more detailed information). The implementation is very efficient.

TA comment about Q 3.1:

> In (d), failed to mention avoiding the trivial solution (something like ||h||=1)

TA comment about Q 5.1:

> Warping with SSD H looks terrible with Matching ratio 0.001.
> 
> I tried running your code with the following script and the result is not good.
> 
>     close all;
>     img1 = imread('incline_L.png');
>     img2 = imread('incline_R.png');
>     [locs1, desc1] = briefLite(img1);
>     [locs2, desc2] = briefLite(img2); 
>     matches = briefMatch(desc1, desc2, 0.01);
>     p1 = locs1(matches(:, 1), 1:2);
>     p2 = locs2(matches(:, 2), 1:2); 
>     plotMatches(img1, img2, matches, locs1, locs2);
>     H2to1 = computeH(p1,p2);
>     im3 = imageStitching_noClip(img1, img2, H2to1);
>     figure, imshow(im3);
> 
> The attached results in the PDF could have been better, if you had properly inspected the outliers. I think the outlier is because of the the Brief descriptor computation. One way could have been changing the sampling strategy while deciding the descriptor in makeTestPattern. Removing outliers could actually generate results closer to ransacH.


### Homework 3 (Lucas-Kanade Tracking & Background Subtraction)
This homework is complete with some extra point implementations (review the Writeup.pdf file for more detailed information).


### Homework 4 (3D Reconstruction)
Working on the homework right now.