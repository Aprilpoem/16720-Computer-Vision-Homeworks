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

    % Compute gradient magnitude and orientation images
    [mag, ori] = mygradient(I);

    % Visualize the magnitude
    figure;
    colormap('gray');
    imagesc(mag);
    axis off;
    title(['Gradient Magnitude of ' images(i, :)]);
    
    
    % Visualize the orientation
    figure;
    colormap('gray');
    imagesc(ori);
    axis off;
    title(['Gradient Orientation of ' images(i, :)]);
    
end
