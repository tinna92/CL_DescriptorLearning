
function Cropped_xx =  Crop_img(iput_path, crop_start_height)
xx = imread(iput_path);
img_size = size(xx);
img_height = img_size(1);
xx(1:crop_start_height,:,:) = 0;
Cropped_xx = xx;
imshow(Cropped_xx);
imwrite(Cropped_xx,strcat(iput_path,'cropped.png'));
end