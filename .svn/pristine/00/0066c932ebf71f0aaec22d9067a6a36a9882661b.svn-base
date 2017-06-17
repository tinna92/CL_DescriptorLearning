A = imread('000006-111406161233-04.tifresize.png');
%%
% theta = 10;
% tform =Chen_AffineTransform(2,1,0,1,0,0);
% outputImage = imwarp(A,tform);
% figure, imshow(outputImage);

% tform =Chen_AffineTransform( acos(1./1.4),0,0,1,0,0);
% outputImage = imwarp(A,tform);
% imshow(outputImage);
% 
% if(size(outputImage,3)>1)
%     outputImage = rgb2gray(outputImage);
% end
% outputImage = single(outputImage);
% [frames, descrs] = vl_sift(outputImage,'Verbose','PeakThresh',0.01);
% [frames1, descrs1] = vl_covdet(outputImage, 'Method','DoG','descriptor', 'Patch','PatchResolution',31,'Doubleimage',false,'Verbose','peakScores',0) ;
%%


%% uncomment this to detect features in a series of affine transformed images
% tilt = [sqrt(2),2,2*sqrt(2),4];
% for ii=1:4
%     tform =Chen_AffineTransform( acos(1./tilt(ii)),0,0,1,0,0);
%     outputImage = imwarp(A,tform);
%     if(size(outputImage,3)>1)
%         outputImage = rgb2gray(outputImage);
%     end
%     outputImage = single(outputImage);
%     [frames1, descrs1] = vl_covdet(outputImage, 'Method','DoG','descriptor', 'Patch','PatchResolution',31,'Doubleimage',false,'Verbose','EstimateAffineShape', true) ;
% end
%%

%% this part shows the affine transformation estimation result
figure(1) ; clf ;
imshow(A) ; axis image off ;
[frames1, descrs1] = vl_covdet(outputImage, 'Method','DoG','descriptor', 'Patch','PatchResolution',31,'Doubleimage',false,'Verbose','EstimateAffineShape', true) ;hold on ;
vl_plotframe(frames1) ;
%%

%% show the mser feature detectors
% I = uint8(rgb2gray(A)) ;
imshow(A);
[r,f] = vl_mser(A,'MinDiversity',0.7,...
                'MaxVariation',0.2,...
                'Delta',10) ;
f = vl_ertr(f) ;
vl_plotframe(f) ;


%%