Warning: "C:\Users\svija\Desktop\OIC_challenge\Code" selected using the Last Working Folder preference could not be accessed.
Using "C:\Users\svija\Documents\MATLAB" as the initial working folder instead. 
% Read an image
[filename, pathname] = uigetfile({'*.jpg;*.png;*.bmp', 'Image Files (*.jpg, *.png, *.bmp)'}, 'Select an Image File');
if isequal(filename,0) || isequal(pathname,0)
    disp('User canceled the operation');
    return;
else
    img = imread(fullfile(pathname, filename));
end

% Display the image
figure;
imshow(img);
title('Draw a polygon to create a mask');

% Ask user to draw a polygon
h = impoly;

% Wait for the user to double-click to finalize the polygon
wait(h);

% Get the position of the polygon vertices
position = getPosition(h);

% Create a binary mask
mask = poly2mask(position(:,1), position(:,2), size(img, 1), size(img, 2));

% Display the mask
figure;
imshow(mask);
title('Binary Mask');

% Save the mask file
[maskFilename, maskPathname] = uiputfile('*.png', 'Save Mask As');
if isequal(maskFilename,0) || isequal(maskPathname,0)
    disp('User canceled the operation');
else
    imwrite(mask, fullfile(maskPathname, maskFilename));
    disp(['Mask saved to ', fullfile(maskPathname, maskFilename)]);
end
Mask saved to Y:\Terrestrial Images\Shako_cho_glacial_lake\Cam-2 -Shako Chao V1\mask\sky_mask.png
