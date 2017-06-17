%% get the patch surrounding feature points first
% addpath('E:\Image Matching\Code\vlfeat-0.9.17-bin\vlfeat-0.9.17\toolbox\');
% addpath('E:\Deep Learning\deeplearn\stanford_dl_ex-master\cnn\');
% addpath('E:\DescriptorEvaluation\vlbenchmakrs-1.0-beta\vlbenchmakrs-1.0-beta\');
% vl_setup
% 
% import datasets.*;
% import benchmarks.*;
% dataset = VggAffineDataset('category','boat');
% % load the image patch for 1st image
img1 = imread('E:\software\IPI\Data\graf\img1.ppm');
if(size(img1,3)>1)
    img1 = rgb2gray(img1);
end
img1 = im2single(img1);
[frames1, descrs1] = vl_sift(img1);
img2 = imread('E:\software\IPI\Data\graf\img2.ppm');
if(size(img2,3)>1)
    img2 = rgb2gray(img2);
end
img2 = im2single(img2);
[frames2, descrs2] = vl_sift(img2);
[matches_SIFT, scores_SIFT] = vl_ubcmatch(descrs1, descrs2,1.5);

Chen_show_matchresult(uint8(255*img1),uint8(255*img2),matches_SIFT,frames1,frames2,0);


[F_matrix,inlinear_index] = Chen_estimateFundmentalmatrix_RANSAC(frames1,frames2,matches_SIFT,1,20000);
Initial_MatchNum = size(matches_SIFT,2);
img_coord1 = frames1(1:2,matches_SIFT(1,:));
img_coord2 = frames2(1:2,matches_SIFT(2,:));
correct_Match_coord1 = img_coord1(1:2,inlinear_index);
correct_Match_coord2 = img_coord2(1:2,inlinear_index);
draw_epipolar_lines(F_matrix,uint8(255*img1),uint8(255*img2),correct_Match_coord1',correct_Match_coord2');
Chen_show_matchresult(uint8(255*img1),uint8(255*img2), matches_SIFT(1:2,inlinear_index),frames1,frames2,0);


% for i=2:dataset.NumImages
%     imgs2 = imread(dataset.getImagePath(i));
%     if(size(imgs2,3)>1)
%         imgs2 = rgb2gray(imgs2);
%     end
%     imgs2 = single(imgs2);
%     [frames2, descrs2] = vl_sift(imgs2);
%     [matches, scores] = vl_ubcmatch(descrs, descrs2,1.5);
%     Match_Single_sift = zeros(1,size(descrs,2));
%     match_num = size(matches,2);
%     for ii=1:match_num
%         Match_Single_sift(1,matches(1,ii))=matches(2,ii);
%     end
%     Match_Grt_1_i = GroundTruth_matches{1,i};
%     nnn=(Match_Grt_1_i==Match_Single_sift);
%     mmm=(Match_Grt_1_i(nnn)~=0);
%     CorrectMatch_num_SIFT(i) = sum(mmm);
%     Match_num_SIFT(i) = sum(Match_Single_sift~=0);
%     Num_correspondence_SIFT(i) = sum(Match_Grt_1_i~=0);
%     recall_SIFT(i)=CorrectMatch_num_SIFT(i)/Num_correspondence_SIFT(i);
%     one_minus_precision_SIFT(i) = (Match_num_SIFT(i)-CorrectMatch_num_SIFT(i))/Match_num_SIFT(i);
%     clear Match_Single;
%     clear descrs2;
% end


