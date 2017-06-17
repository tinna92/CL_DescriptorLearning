% conduct affine transformation
% latitude,longitude    the selected latitude and longitude of affine
% transformation
% camera_rotation
% lamda = scale changing 
% t1,t2 = translation
% See: Lin, Chen, Jin Liu, and Liang Cao. "Image matching by affine speed-up robust features." Seventh International Symposium 
% on Multispectral Image Processing and Pattern Recognition (MIPPR2011). International Society for Optics and Photonics, 2011.
function [out_affinematrix] =  Chen_AffineTransform(latitude,longitude,camera_rotation,lamda,t1,t2)

lam_t = [lamda,0;0,lamda];
camrot_t = [cos(camera_rotation),-sin(camera_rotation);sin(camera_rotation),cos(camera_rotation)];
t_t = [abs(1/cos(latitude)),0;0,1];
long_t = [cos(longitude),-sin(longitude);sin(longitude),cos(longitude)];

affinematrix = lam_t*camrot_t*t_t*long_t;
% affinematrix = lam_t*long_t*t_t*camrot_t;
% out_affinematrix(1:2,1:2)=affinematrix;
out_affinematrix(1:2,1:2)=affinematrix';
out_affinematrix(1:2,3)=[t1;t2];
out_affinematrix(3,1:3)=[0,0,1];

% out_affinematrix = projective2d(out_affinematrix);
out_affinematrix = affine2d(out_affinematrix);


end


% A = imread('pout.tif');
%  theta = 10;
%  tform = affine2d([cosd(theta) -sind(theta) 0; sind(theta) cosd(theta) 0; 0 0 1]);
%  outputImage = imwarp(A,tform);
%  figure, imshow(outputImage);
 
 