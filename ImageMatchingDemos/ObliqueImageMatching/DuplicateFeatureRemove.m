% filtered_outmatches = Chen_DuplicateFileteringforViewSphereMatching(frames_Aff1,frames_Aff2,matches_Desc,1.0,1.0);

[filtered_outmatches] = Chen_DuplicateFileteringforViewSphereMatching(frames_Aff1,frames_Aff2,matches_Desc,1,1);
[filtered_outmatches] = Chen_DuplicateMatchFiletering(matches_Desc);

[sharedVals,idxsIntoA] = intersect(unrepeated_1',filtered_outmatches(1,:)');
nnn = unrepeated_1(idxsIntoA);
[sharedVals,idxsIntoA] = intersect(unrepeated_2',filtered_outmatches(2,:)');
nnn = unrepeated_2(idxsIntoA);

Chen_show_matchresult(rgb2gray(imread(img_path1)),...
    rgb2gray(imread(img_path2)), filtered_outmatches,frames_Aff1,frames_Aff2,0);
[F_matrix,inlinear_index] = Chen_estimateFundmentalmatrix_RANSAC(frames_Aff1,frames_Aff2,filtered_outmatches,2,30000);

Chen_show_matchresult(rgb2gray(imread(img_path1)),...
    rgb2gray(imread(img_path2)), filtered_outmatches(:,inlinear_index),frames_Aff1,frames_Aff2,0);