% data needs to be cropped, because there are some marks there.
% function Cropped_xx =  Crop_img(iput_path, crop_start_height)
% xx = imread(iput_path);
% img_size = size(xx)
% img_height = img_size(1) 
% Cropped_xx = xx(crop_start_height:img_height,:,:);
% imshow(Cropped_xx);
% end

% xx = imread('E:\Image Matching\Code\demo_ASIFT_src\demo_ASIFT_src\Debug\IGI-UM_Soest-City_GSD5cm-Nadir.jpgresize.png');
Cropped_xx =  Crop_img('E:\Image Matching\2016-07-07_IGI UrbanMapper\IGI UrbanMapper - Soest City - Sample Images\IGI-UM_Soest-City_GSD5cm-Nadir.jpgresize.png',...
    75);
Cropped_xx =  Crop_img('E:\Image Matching\2016-07-07_IGI UrbanMapper\IGI UrbanMapper - Soest City - Sample Images\IGI-UM_Soest-City_GSD7cm-ObliqueEast.jpgresize.png',...
    75);
Cropped_xx =  Crop_img('E:\Image Matching\2016-07-07_IGI UrbanMapper\IGI UrbanMapper - Soest City - Sample Images\IGI-UM_Soest-City_GSD7cm-ObliqueNorth.jpgresize.png',...
    75);
Cropped_xx =  Crop_img('E:\Image Matching\2016-07-07_IGI UrbanMapper\IGI UrbanMapper - Soest City - Sample Images\IGI-UM_Soest-City_GSD7cm-ObliqueSouth.jpgresize.png',...
    75);
Cropped_xx =  Crop_img('E:\Image Matching\2016-07-07_IGI UrbanMapper\IGI UrbanMapper - Soest City - Sample Images\IGI-UM_Soest-City_GSD7cm-ObliqueWest.jpgresize.png',...
    75);
% img_size = size(xx)
% img_height = img_size(1) 
% crop_start_height = 200
% Cropped_xx = xx(crop_start_height:img_height,:,:);
% imshow(Cropped_xx);

