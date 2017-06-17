img = imread('E:\KarstenData\apartimg\000002-111406161256-11.tifresize.png');
img2 = imread('E:\KarstenData\apartimg\000003-111406161250-04.tifresize.png');


% extract the patches first

[frames_Aff1,descrs_Aff1] = Chen_ExtractedAffineimageFeatures('E:\KarstenData\apartimg\000002-111406161256-11.tifresize.png','DoG','Patch',4,pi,180);
[frames_Aff2,descrs_Aff2] = Chen_ExtractedAffineimageFeatures('E:\KarstenData\apartimg\000003-111406161250-04.tifresize.png','DoG','Patch',4,pi,180);

for i=1:size(descrs_Aff1,2)
    Temp_patch=reshape(descrs_Aff1(:,i),63,63);
    small_patch=imresize(Temp_patch,[32 32]);
    nn=reshape(small_patch,1,1024);
    Patch_left(:,i)=nn';
end

for i=1:size(descrs_Aff2,2)
    Temp_patch=reshape(descrs_Aff2(:,i),63,63);
    small_patch=imresize(Temp_patch,[32 32]);
    nn=reshape(small_patch,1,1024);
    Patch_right(:,i)=nn';
end

% convert patches into CNN formed descriptor
% parameterfilename = ('learnedParamaters2610_5_100batches5epoches500iterations.mat');
parameterfilename = ('learnedParamaters1112_80_graf.mat');
[CNNdescriptor_left,CNNdescriptor_right] = Chen_GenDescfrom_LearnedsiameseCNNparams(parameterfilename,Patch_left,Patch_right);

match_ratio  =1.5;
clear matches_CNN_Desc scores_CNN_Desc;

% match them by 1st/2nd nearest distance threshold
[matches_CNN_Desc, scores_CNN_Desc] = vl_ubcmatch(CNNdescriptor_left, CNNdescriptor_right,match_ratio);
% randm_selected = randperm();
Chen_show_matchresult(uint8(img),uint8(img2),matches_CNN_Desc,frames_Aff1,frames_Aff2,0);

% duplicate filtering
% [filtered_outmatches] = Chen_DuplicateFileteringforViewSphereMatching(frames_Aff1,frames_Aff2,matches_CNN_Desc,2,sqrt(2));
% Chen_show_matchresult(uint8(img),uint8(img2),filtered_outmatches,frames_Aff1,frames_Aff2,0);



% filtering false matches by evaluating fundmental matrix using RANSAC
clear F_matrix inlinear_index img_coord1 img_coord2 correct_Match_coord1 correct_Match_coord2;
[F_matrix,inlinear_index] = Chen_estimateFundmentalmatrix_RANSAC(frames_Aff1,frames_Aff2,matches_CNN_Desc,1,20000);
Initial_MatchNum = size(matches_CNN_Desc,2);
img_coord1 = frames_Aff1(1:2,matches_CNN_Desc(1,:));
img_coord2 = frames_Aff2(1:2,matches_CNN_Desc(2,:));
correct_Match_coord1 = img_coord1(1:2,inlinear_index);
correct_Match_coord2 = img_coord2(1:2,inlinear_index);
% draw_epipolar_lines(F_matrix,uint8(img_left),uint8(img_right),correct_Match_coord1',correct_Match_coord2');
Chen_show_matchresult(uint8(img),uint8(img2), matches_CNN_Desc(1:2,inlinear_index),frames_Aff1,frames_Aff2,0);