% [aff_img] =  Chen_fullyaff_images_generate(rgb2gray(imread(img_name1)),a,b,n);
% [aff_img] =  Chen_fullyaff_images_generate(rgb2gray(imread('hzcover2.jpg')),a,b,n);
a = sqrt(2);
b = 72;
n =4;


lamda=1; camera_rotation = 0;
% t = acos(1./3);
t=1;
longitude = 2;
t1 = 0; t2 =0;
% [aff_img] =  Chen_fullyaff_images_generate(rgb2gray(imread(img_name1)),a,b,n);
lam_t = [lamda,0;0,lamda];
camrot_t = [cos(camera_rotation),-sin(camera_rotation);sin(camera_rotation),cos(camera_rotation)];
t_t = [abs(1/cos(t)),0;0,1];
long_t = [cos(longitude),-sin(longitude);sin(longitude),cos(longitude)];
% affinematrix = lam_t'*camrot_t'*t_t'*long_t';out_affinematrix(1:2,1:2)=affinematrix;
 affinematrix = lam_t*camrot_t*t_t*long_t;
 out_affinematrix(1:2,1:2)=affinematrix';
out_affinematrix(1:2,3)=[t1;t2];
out_affinematrix(3,1:3)=[0,0,1];
out_affinematrix_t = affine2d(out_affinematrix);
outputImage = imwarp(rgb2gray(imread('hzcover2.jpg')),out_affinematrix_t);
imshow(outputImage);


% the following part is from ASIFT matlab code 
% http://www.mathworks.com/matlabcentral/fileexchange/29004-feature-points-in-image--keypoint-extraction/content/FPS_in_image/FPS%20in%20image/Help%20Functions/Demos,%20scripts/demoASIFT.m

phiAngle=2;
% phiAngle = deg2rad( phi );
% defining tilt and longitude affine simulation matrix
T = zeros( 3 );
T(3,3)=1;
Tilt = eye(2);
Tilt(1) = 1.8508;
R = [ cos(phiAngle) -sin(phiAngle); sin(phiAngle) cos(phiAngle) ];
Aff = Tilt*R;
T( 1:2, 1:2 ) =  Aff';
Tf = maketform('affine',T); % affine transformation for view-simulation 
[ imgSimulated, xdata, ydata ] = imtransform( rgb2gray(imread('hzcover2.jpg')), Tf );
imshow(imgSimulated)

