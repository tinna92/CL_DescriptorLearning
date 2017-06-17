image_name = '000003-111406161250-04.tifresize.png';
 A = imread(image_name);
 if(size(A,3)>1)
     A_Image = rgb2gray(A);
 else
     A_Image = A;
 end
[aff_img] =  Chen_fullyaff_images_generate(A_Image,sqrt(2),72,6);