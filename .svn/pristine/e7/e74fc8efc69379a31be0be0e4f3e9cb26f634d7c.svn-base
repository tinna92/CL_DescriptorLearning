% img = imread('E:\KarstenData\apartimg\000002-111406161256-11.tifresize.png');
% img2 = imread('E:\KarstenData\apartimg\000003-111406161250-04.tifresize.png');
parameterfilename = ('learnedParamaters2506_50_libertytrain500000.mat');
% parameterfilename = ('learnedParamaters2610_5_199batches5epoches199iterations.mat');
% parameterfilename = ('learnedParamaters1011_3.mat');
% parameterfilename = ('learnedParamaters1112_80_graf.mat');
img = imread('E:\software\IPI\Data\graf\img1.ppm');
img2 = imread('E:\software\IPI\Data\graf\img5.ppm');
% img2 = imrotate(img2,90);
% img = imread('libertyab_z.jpg');
% img2 = imread('statue-of-liberty.jpg');
% extract the patches first
if(size(img,3)>1)
    img_left = rgb2gray(img);
else
    img_left = img;
end
img_left = im2single(img_left);
% [frames_left_vlsift descrs_left_vlsift] =  vl_sift(img_left,'Verbose');
% [frames_left,Patch_left] = chen_extractSIFTpatch_CNN(img_left,frames_left_vlsift);
[frames_left,Patch_left] = chen_extractSIFTpatch_CNN(img_left);
if(size(img2,3)>1)
    img_right = rgb2gray(img2);
else
    img_right = img2;
end
img_right = im2single(img_right);
% [frames_right_vlsift descrs_right_vlsift] =  vl_sift(img_left,'Verbose');
% [frames_right,Patch_right] = chen_extractSIFTpatch_CNN(img_right,frames_right_vlsift);
[frames_right,Patch_right] = chen_extractSIFTpatch_CNN(img_right);
% convert patches into CNN formed descriptor
[CNNdescriptor_left,CNNdescriptor_right] = Chen_GenDescfrom_LearnedsiameseCNNparams(parameterfilename,Patch_left,Patch_right);

match_ratio  =1.5;
clear matches_CNN_Desc scores_CNN_Desc;

% match them by 1st/2nd nearest distance threshold
[matches_CNN_Desc, scores_CNN_Desc] = vl_ubcmatch(CNNdescriptor_left, CNNdescriptor_right,match_ratio);
% randm_selected = randperm();
Chen_show_matchresult(uint8(255*img_left),uint8(255*img_right),matches_CNN_Desc,frames_left,frames_right,0);

% filtering false matches by evaluating fundmental matrix using RANSAC
[F_matrix,inlinear_index] = Chen_estimateFundmentalmatrix_RANSAC(frames_left,frames_right,matches_CNN_Desc,1.5,20000);
Initial_MatchNum = size(matches_CNN_Desc,2);
img_coord1 = frames_left(1:2,matches_CNN_Desc(1,:));
img_coord2 = frames_right(1:2,matches_CNN_Desc(2,:));
correct_Match_coord1 = img_coord1(1:2,inlinear_index);
correct_Match_coord2 = img_coord2(1:2,inlinear_index);
draw_epipolar_lines(F_matrix,uint8(255*img_left),uint8(255*img_right),correct_Match_coord1',correct_Match_coord2');
Chen_show_matchresult(uint8(255*img_left),uint8(255*img_right), matches_CNN_Desc(1:2,inlinear_index),frames_left,frames_right,0);