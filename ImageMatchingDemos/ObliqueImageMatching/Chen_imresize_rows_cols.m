
function Chen_imresize_rows_cols(imagepath,resized_rows,resized_cols)
% img1 = imread('TestImagePair/000039-111406162434-02.tif');
% img_resize1 = imresize(img1,0.2);
% imwrite(img_resize1,['resize' '000039-111406162434-02.tif']);
img1 = imread(imagepath);
img_resize1 = imresize(img1,[resized_rows resized_cols]);
imwrite(img_resize1,[imagepath 'resize.jpg']);
end