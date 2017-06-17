% pfx = fullfile(vl_root,'data','spots.jpg') ;
% I = imread(pfx) ;
I = imread('G0026678_scaled.JPG');
imshow(I) ;
if(size(I,3)>1)
    I = uint8(rgb2gray(I));
end
% I = uint8(rgb2gray(I)) ;
[r,f] = vl_mser(I,'MinDiversity',0.7,...
                'MaxVariation',0.2,...
                'MinArea',0.00005,...
                'Delta',10) ;
            f = vl_ertr(f) ;
vl_plotframe(f) ;

M = zeros(size(I)) ;
for x=r'
 s = vl_erfill(I,x) ;
 M(s) = M(s) + 1;
end

figure(2) ;
clf ; imagesc(I) ; hold on ; axis equal off; colormap gray ;
[c,h]=contour(M,(0:max(M(:)))+.5) ;
set(h,'color','y','linewidth',1) ;