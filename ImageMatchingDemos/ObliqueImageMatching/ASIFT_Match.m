% test for affine image matching

% [frames_Aff1,descrs_Aff1] = Chen_ExtractedAffineimageFeatures('000039-111406162434-02.tifresize.png','Hessian','SIFT',3,1.2,72);
% [frames_Aff2,descrs_Aff2] = Chen_ExtractedAffineimageFeatures('000042-111406162417-04.tifresize.png','Hessian','SIFT',3,1.2,72);
% [frames_Aff1,descrs_Aff1] = Chen_ExtractedAffineimageFeatures('E:\software\IPI\exampledata\10affined_image.jpg','Hessian','SIFT',3,1.2,72);
% [frames_Aff2,descrs_Aff2] = Chen_ExtractedAffineimageFeatures('E:\software\IPI\exampledata\34affined_image.jpg','Hessian','SIFT',3,1.2,72);

% [frames_Aff1,descrs_Aff1] = Chen_ExtractedAffineimageFeatures('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\images\003_017_145000238.tifresize.png','Hessian','SIFT',3,1.2,72);
% [frames_Aff2,descrs_Aff2] = Chen_ExtractedAffineimageFeatures('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\images\007_017_163000166.tifresize.png','Hessian','SIFT',3,1.2,72);
% 
% match_ratio  =1.5;
% [matches_Desc, scores_Desc] = vl_ubcmatch(descrs_Aff1, descrs_Aff2,match_ratio);
% % randm_selected = randperm();
% Chen_show_matchresult(rgb2gray(imread('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\images\003_017_145000238.tifresize.png')),...
%     rgb2gray(imread('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\images\007_017_163000166.tifresize.png')),matches_Desc,frames_Aff1,frames_Aff2,0);
% 

img_path1 = 'E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\images\IGI-UM_Soest-City_GSD5cm-Nadir.jpgresize.pngcropped.png';
img_path2 = 'E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\images\IGI-UM_Soest-City_GSD7cm-ObliqueEast.jpgresize.pngcropped.png';
[frames_Aff1,descrs_Aff1,feature_index1] = Chen_ExtractedAffineimageFeatures2(img_path1,'Hessian','SIFT',3,sqrt(2),180);
[frames_Aff2,descrs_Aff2,feature_index2] = Chen_ExtractedAffineimageFeatures2(img_path2,'Hessian','SIFT',3,sqrt(2),180);

match_ratio  = 1.5;
[matches_Desc, scores_Desc] = vl_ubcmatch(descrs_Aff1, descrs_Aff2, match_ratio);

% randm_selected = randperm();
Chen_show_matchresult(rgb2gray(imread(img_path1)),...
    rgb2gray(imread(img_path2)),matches_Desc, frames_Aff1, frames_Aff2, 0 );

% analyze and output index for repeat features
Re_index1 = Chen_analyze_repeatable_features(frames_Aff1, 32);
Re_index2 = Chen_analyze_repeatable_features(frames_Aff2, 32);
% find the unique features in each feature set and save only unrepeatable
% features
unrepeated_1 = unique(Re_index1','rows');
unrepeated_1 = unrepeated_1';
unrepeated_2 = unique(Re_index2','rows');
unrepeated_2 = unrepeated_2';

% get the repeat index of matches
Re_Match_cp(1,:) = Re_index1(matches_Desc(1,:));
Re_Match_cp(2,:) = Re_index2(matches_Desc(2,:));

% get the unique feature match
yyyy = unique(Re_Match_cp','rows');
yyyy = yyyy';
xxxx= unique(yyyy(1,:)','rows'); %note that there are some features appeared more than once in the index (one to many perhaps)
% all those steps cannot deal the many to one and one to many cases, one
% need to filter them out!
[filtered_outmatches] = Chen_DuplicateMatchFiletering(yyyy);

[unrepeated_1, IA1, IC1] = unique(Re_index1','rows');
[unrepeated_2, IA2, IC2] = unique(Re_index2','rows');
% unrepeated_1 = Re_index1(:,IA1)';
% xx = unrepeated_1(IC1,:)'; %xx is actually same to Re_index1
% % [filtered_outmatches] = Chen_DuplicateMatchFiletering(yyyy);

% [sharedVals,idxsIntoA] = intersect(unrepeated_1',filtered_outmatches(1,:)');
% nnn(:,1) = unrepeated_1(idxsIntoA);
% nnn(:,2) = unrepeated_2(idxsIntoA);
% [sharedVals2,idxsIntoA2] = intersect(unrepeated_2',filtered_outmatches(2,:)');
% nnn(:,2) = unrepeated_2(idxsIntoA2);
for qq = 1:size(filtered_outmatches, 2)
    nnnn(qq,1) = find(unrepeated_1 == filtered_outmatches(1,qq));
    nnnn(qq,2) = find(unrepeated_2 == filtered_outmatches(2,qq));
end
match_unrepeated = nnnn';
% there are some one to many and many to one feature correpondence, so
% they must be filtered..
Chen_show_matchresult(rgb2gray(imread(img_path1)),...
    rgb2gray(imread(img_path2)), match_unrepeated,frames_unrepeated_1,frames_unrepeated_2,0);
clear F_matrix inlinear_index img_coord1 img_coord2 correct_Match_coord1 correct_Match_coord2;
[F_matrix,inlinear_index] = Chen_estimateFundmentalmatrix_RANSAC(frames_unrepeated_1,frames_unrepeated_2,match_unrepeated,2,30000);
Chen_show_matchresult(rgb2gray(imread(img_path1)),...
    rgb2gray(imread(img_path2)), match_unrepeated(1:2,inlinear_index),frames_unrepeated_1,frames_unrepeated_2,0);


% the output features for both images are frames_unrepeated_1 and
% frames_unrepeated_2, the match are match_unrepeated(1:2,inlinear_index)


frames_unrepeated_1 = frames_Aff1(1:3, unrepeated_1);
frames_unrepeated_2 = frames_Aff2(1:3, unrepeated_2);
descrs_unrepeated_1 = descrs_Aff1(:, unrepeated_1);
descrs_unrepeated_2 = descrs_Aff1(:, unrepeated_2);




Chen_show_matchresult(rgb2gray(imread(img_path1)),...
    rgb2gray(imread(img_path2)), match_unrepeated(1:2,inlinear_index),frames_Aff1,frames_Aff2,0);

Initial_MatchNum = size(matches_Desc,2);
img_coord1 = frames_Aff1(1:2,matches_Desc(1,:));
img_coord2 = frames_Aff2(1:2,matches_Desc(2,:));
correct_Match_coord1 = img_coord1(1:2,inlinear_index);
correct_Match_coord2 = img_coord2(1:2,inlinear_index);
draw_epipolar_lines(F_matrix,rgb2gray(imread(img_path1)),...
    rgb2gray(imread(img_path2)),correct_Match_coord1',correct_Match_coord2');
Chen_show_matchresult(rgb2gray(imread(img_path1)),...
    rgb2gray(imread(img_path2)), matches_Desc(1:2,inlinear_index),frames_Aff1,frames_Aff2,0);
% Chen_show_matchresult(uint8(img_left),uint8(img_right), matches_CNN_Desc(1:2,inlinear_index),frames_Aff1,frames_Aff2,0);


% frames_unrepeated_1 = frames_Aff1(1:3, unrepeated_1);
% frames_unrepeated_2 = frames_Aff2(1:3, unrepeated_2);
% descrs_unrepeated_1 = descrs_Aff1(:, unrepeated_1);
% descrs_unrepeated_2 = descrs_Aff1(:, unrepeated_2);
% [matches_Desc_unrepeated, scores_Desc_unrepeated] = vl_ubcmatch(descrs_unrepeated_1, descrs_unrepeated_2, match_ratio);
% 
% Chen_show_matchresult(rgb2gray(imread(img_path1)),...
%     rgb2gray(imread(img_path2)), matches_Desc_unrepeated, frames_unrepeated_1, frames_Aff2,0);
% 
% 
% [F_matrix_unrepeat, inlinear_index_unrepeat] = Chen_estimateFundmentalmatrix_RANSAC(frames_unrepeated_1,frames_unrepeated_2, matches_Desc_unrepeated,2,30000);
% 
% Chen_show_matchresult(rgb2gray(imread(img_path1)),...
%     rgb2gray(imread(img_path2)), yyyy(1:2,inlinear_index_unrepeat),frames_Aff1,frames_unrepeated_2,0);


% get the index of feature matches





%analyze and get the unreaptable features
% extract features from all affine version of images  ---- analyze the repeatablity of features, output unrepeatable features in each image --output the feature and matches
Re_index1 = Chen_analyze_repeatable_features(frames_Aff1, 32);
Re_index2 = Chen_analyze_repeatable_features(frames_Aff2, 32);
unrepeated_1 = unique(Re_index1','rows');
unrepeated_1 = unrepeated_1';
unrepeated_2 = unique(Re_index2','rows');
unrepeated_2 = unrepeated_2';
frames_unrepeated_1 = frames_Aff1(1:3, unrepeated_1);
frames_unrepeated_2 = frames_Aff2(1:3, unrepeated_2);
descrs_unrepeated_1 = descrs_Aff1(:, unrepeated_1);
descrs_unrepeated_2 = descrs_Aff1(:, unrepeated_2);
[matches_Desc_unrepeat, scores_Desc_unrepeat] = vl_ubcmatch(descrs_unrepeated_1, descrs_unrepeated_2,match_ratio);
clear F_matrix inlinear_index img_coord1 img_coord2 correct_Match_coord1 correct_Match_coord2;
[F_matrix,inlinear_index] = Chen_estimateFundmentalmatrix_RANSAC(frames_unrepeated_1,frames_unrepeated_2,matches_Desc_unrepeat,2,30000);
Chen_show_matchresult(rgb2gray(imread('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\images\IGI-UM_Soest-City_GSD5cm-Nadir.jpgresize.pngcropped.png')),...
    rgb2gray(imread('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\images\IGI-UM_Soest-City_GSD7cm-ObliqueEast.jpgresize.pngcropped.png')), matches_Desc_unrepeat,frames_unrepeated_1,frames_unrepeated_2,0);
[F_matrix,inlinear_index] = Chen_estimateFundmentalmatrix_RANSAC(frames_unrepeated_1,frames_unrepeated_2,matches_Desc_unrepeat,2,30000);