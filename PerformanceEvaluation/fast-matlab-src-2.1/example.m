% i = imread('lab.pgm');
i = imread('000002-111406161256-02.tifresize.png');
% i = imread('000006-111406161233-04.tifresize.png');
%Make image greyscale
if length(size(i)) == 3
	im =  double(i(:,:,2));
else
	im = double(i);
end

c9 = fast9(im, 30,1);
axis image
colormap(gray)

imshow(im / max(im(:)));
hold on
plot(c9(:,1), c9(:,2), 'r.')
title('9 point FAST');

c12 = fast12(im, 30,1);
axis image
colormap(gray)

imshow(im / max(im(:)));
hold on
plot(c12(:,1), c12(:,2), 'r.')
title('9 point FAST');