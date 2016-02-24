function testPanorama

% Initialize parameters
path1 = '../data/incline_L.png';
path2 = '../data/incline_R.png';

% Read the images
im1 = imread(path1);
im2 = imread(path2); 

% Generate panorama
panoImg = generatePanorama(im1, im2);

% Write resulted panorama to file
% imwrite(panoImg, '../results/q5_1_pan.jpg');
% imwrite(panoImg, '../results/q5_2_pan.jpg');
imwrite(panoImg, '../results/q6_1.jpg');
figure; imshow(panoImg);
