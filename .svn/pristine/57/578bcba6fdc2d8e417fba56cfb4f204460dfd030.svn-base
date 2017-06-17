A = imread('000006-111406161233-04.tifresize.png');
% theta = 10;
% tform =Chen_AffineTransform(2,1,0,1,0,0);
% outputImage = imwarp(A,tform);
% figure, imshow(outputImage);

tform =Chen_AffineTransform( acos(1./1.4),0,0,1,0,0);
outputImage = imwarp(A,tform);
imshow(outputImage);

if(size(img,3)>1)
    img = rgb2gray(img);
end
img = single(img);
[frames, descrs] = vl_sift(img);

for ii=1:3
    for jj = 1:3
        theta = acos(1/(ii*5+5));
%         theta = acos(1/((ii-1)*5 + jj*2));
         tform =Chen_AffineTransform(theta,jj*pi/8,0,1,0,0);
%         tform =Chen_AffineTransform(theta,0,0,1,0,0);
        outputImage = imwarp(A,tform);
        subplot(3,3,(ii-1)*3 + jj);
        imshow(outputImage);
    end
end