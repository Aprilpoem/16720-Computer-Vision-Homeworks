clc;
close all;

% List of test images
images = [ 'test0.jpg'
           'test1.jpg'  ];

for i = 1 : size(images, 1)

    % Load the test image
    I = imread(['../data/' images(i, :)]);

    % Convert the test image to grayscale
    I = rgb2gray(I);

    % Convert image to double
    I = im2double(I);

    % Compute the histogram of gradient orientations
    ohist = hog(I);

    % Visualize the HoG
    figure;
    % colormap('gray');
    imagesc(hogdraw(ohist));
    axis off;
    title(['Histogram of gradient otientations for ' images(i, :)]);

end
