% since the brown dataset used only one direction for every patch(every
% feature points), so it is not neccessary to use also multiple
% orientations. 
img_left_path = 'E:\software\IPI\Data\graf\img1.ppm';
img_right_path = 'E:\software\IPI\Data\graf\img3.ppm';
parameterfilename = ('learnedParamaters1311_100_notredame.mat');
img_left = imread(img_left_path);
% [PatchDir D(iFile).name];
if(size(img_left,3)>1)
    img_left = rgb2gray(img_left);
else
    img_left = img_left;
end
img_left = im2single(img_left);

[frames_left,Patch_left] = vl_covdet(img_left, 'descriptor', 'Patch','Method','DoG','PatchResolution',31,'Doubleimage',false,'EstimateOrientation', true,'PatchRelativeSmoothing',0.3) ;
[index_if_deletefeat_left,feat_repeaty_left] =  Chen_EliminateRepeatedFeat_withMultiOrientations(frames_left);
delete_index_left = find(index_if_deletefeat_left == 1);
% delete those features with more than 1 orientations
frames_left(:,delete_index_left)=[];
Patch_left(:,delete_index_left)=[]; 

for i=1:size(Patch_left,2)
    Temp_patch=reshape(Patch_left(:,i),63,63);
    small_patch=imresize(Temp_patch,[32 32]);
    nn=reshape(small_patch,1,1024);
    Patch_left_Resamp(:,i)=nn';
end

img_right = imread(img_right_path);
if(size(img_right,3)>1)
    img_right = rgb2gray(img_right);
else
    img_right = img_right;
end
img_right = im2single(img_right);
[frames_right,Patch_right] = vl_covdet(img_right, 'descriptor', 'Patch','Method','DoG','PatchResolution',31,'Doubleimage',false,'EstimateOrientation', true) ;
[index_if_deletefeat_right,feat_repeaty_right] =  Chen_EliminateRepeatedFeat_withMultiOrientations(frames_right);
delete_index_right = find(index_if_deletefeat_right == 1);
% delete those features with more than 1 orientations
frames_right(:,delete_index_right)=[];
Patch_right(:,delete_index_right)=[]; 

for i=1:size(Patch_right,2)
    Temp_patch=reshape(Patch_right(:,i),63,63);
    small_patch=imresize(Temp_patch,[32 32]);
    nn=reshape(small_patch,1,1024);
    Patch_right_Resamp(:,i)=nn';
end

[CNNdescriptor_left,CNNdescriptor_right] = Chen_GenDescfrom_LearnedsiameseCNNparams(parameterfilename,Patch_left_Resamp,Patch_right_Resamp);

match_ratio  =1.5;
clear matches_CNN_Desc scores_CNN_Desc;

% match them by 1st/2nd nearest distance threshold
[matches_CNN_Desc, scores_CNN_Desc] = vl_ubcmatch(CNNdescriptor_left, CNNdescriptor_right,match_ratio);
% randm_selected = randperm();
Chen_show_matchresult(uint8(255*img_left),uint8(255*img_right),matches_CNN_Desc,frames_left,frames_right,0);

% [frames_right,Patch_right] = chen_extractSIFTpatch_CNN(img_right); 
[F_matrix,inlinear_index] = Chen_estimateFundmentalmatrix_RANSAC(frames_left,frames_right,matches_CNN_Desc,1.5,20000);
Initial_MatchNum = size(matches_CNN_Desc,2);
img_coord1 = frames_left(1:2,matches_CNN_Desc(1,:));
img_coord2 = frames_right(1:2,matches_CNN_Desc(2,:));
correct_Match_coord1 = img_coord1(1:2,inlinear_index);
correct_Match_coord2 = img_coord2(1:2,inlinear_index);
draw_epipolar_lines(F_matrix,uint8(255*img_left),uint8(255*img_right),correct_Match_coord1',correct_Match_coord2');
Chen_show_matchresult(uint8(255*img_left),uint8(255*img_right), matches_CNN_Desc(1:2,inlinear_index),frames_left,frames_right,0);
