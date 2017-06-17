% this file is a sample for implementing 3D reconstruction using resources in Matlab

I = imread('concordaerial.png');
I1 = I(:,:,2);
I2 = imresize(imrotate(I1,-20),1.2);

%find the SURF features
points1 = detectSURFFeatures(I1);
points2 = detectSURFFeatures(I2);

%extract the features
[f1,vpts1] = extractFeatures(I1,points1);
[f2,vpts2] = extractFeatures(I2,points2);

% retrieve the locations of matched points, the SURF feature vectors are
% already normalized
indexPairs = matchFeatures(f1,f2,'Prenormalized',true);
matched_pts1 = vpts1(indexPairs(:,1));
matched_pts2 = vpts1(indexPairs(:,2));

figure;showMatchFeatures(I1,I2,matched_pts1,matched_pts2);
legend('matched points 1','matched points 2');