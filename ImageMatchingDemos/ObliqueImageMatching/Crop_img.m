
function Cropped_xx =  Crop_img(iput_path, crop_start_height)
xx = imread(iput_path);
img_size = size(xx)
img_height = img_size(1) 
Cropped_xx = xx(crop_start_height:img_height,:,:);
imshow(Cropped_xx);
imwrite(Cropped_xx,strcat(iput_path,'cropped.png'))
end