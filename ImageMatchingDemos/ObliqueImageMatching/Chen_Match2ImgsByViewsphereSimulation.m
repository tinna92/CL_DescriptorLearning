% conduct the viewsphere simualtion based image matching with geometric
% verification (Ransac based Fundamental matrix estimation) 
% @param: img_path1, img_path2 -- the path of input images to match
% @param: opts -- the parameters that are used for viewsphere simulation
%               (n, a, b, detector_type, descriptor_type..)
% output: out_match -- the returned match
%         out_features1, out_features2 -- the returned features
%         out_desc1, out_desc2 -- the returned descriptors
function [out_match, out_features1, out_features2, out_desc1, out_desc2] = Chen_Match2ImgsByViewsphereSimulation(img_path1, img_path2, opts)
n = opts.n; 
a = opts.a; 
b = opts.b;
[frames_Aff1,descrs_Aff1,feature_index1] = Chen_ExtractedAffineimageFeatures2(img_path1,opts.detector_type,opts.descriptor_type,n,a,b);
[frames_Aff2,descrs_Aff2,feature_index2] = Chen_ExtractedAffineimageFeatures2(img_path2,opts.detector_type,opts.descriptor_type,n,a,b);

match_ratio  = 1.5;
[matches_Desc, scores_Desc] = vl_ubcmatch(descrs_Aff1, descrs_Aff2, match_ratio);

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
% remove the duplicated matches
% there are some one to many and many to one feature correpondence, so
% they must be filtered..
[filtered_outmatches] = Chen_DuplicateMatchFiletering(yyyy);

[unrepeated_1, IA1, IC1] = unique(Re_index1','rows');
[unrepeated_2, IA2, IC2] = unique(Re_index2','rows');

% find the index of filtered matches in unrepeated feature sets
for qq = 1:size(filtered_outmatches, 2)
    nnnn(qq,1) = find(unrepeated_1 == filtered_outmatches(1,qq));
    nnnn(qq,2) = find(unrepeated_2 == filtered_outmatches(2,qq));
end
match_unrepeated = nnnn';
frames_unrepeated_1 = frames_Aff1(:, unrepeated_1);
frames_unrepeated_2 = frames_Aff2(:, unrepeated_2);
descrs_unrepeated_1 = descrs_Aff1(:, unrepeated_1);
descrs_unrepeated_2 = descrs_Aff2(:, unrepeated_2);
% Chen_show_matchresult(rgb2gray(imread(img_path1)),...
%     rgb2gray(imread(img_path2)), match_unrepeated,frames_unrepeated_1,frames_unrepeated_2,0);
clear F_matrix inlinear_index img_coord1 img_coord2 correct_Match_coord1 correct_Match_coord2;
[F_matrix_final,inlinear_index] = Chen_estimateFundmentalmatrix_RANSAC(frames_unrepeated_1,frames_unrepeated_2,match_unrepeated,2,30000);
% Chen_show_matchresult(rgb2gray(imread(img_path1)),...
%     rgb2gray(imread(img_path2)), match_unrepeated(1:2,inlinear_index),frames_unrepeated_1,frames_unrepeated_2,0);

% now form the output of features
out_match = match_unrepeated(1:2,inlinear_index);
out_features1 = frames_unrepeated_1;
out_features2 = frames_unrepeated_2;
out_desc1 = descrs_unrepeated_1;
out_desc2 = descrs_unrepeated_2;

end