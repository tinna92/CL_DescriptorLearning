img = rgb2gray(imread('undistorted_image_243_DSC05692.tif'));
img2 = rgb2gray(imread('undistorted_image_298_DSC05747.tif'));
img = imresize(img,[1500 1000]);
img2 = imresize(img2,[1500 1000]);
imwrite(img,['undistorted_image_243_DSC05692' 'resize.png']);
imwrite(img2,['undistorted_image_298_DSC05747' 'resize.png']);


% img = imread('E:\KarstenData\apartimg\000002-111406161256-11.tifresize.png');
% img2 = imread('E:\KarstenData\apartimg\000003-111406161250-04.tifresize.png');
parameterfilename = ('learnedParamaters2911_60_batchsize_1000_yosemite_validation.mat');
% vl_setup
addpath('E:\Image Matching\Code\vlfeat-0.9.17-bin\vlfeat-0.9.17\toolbox\');
addpath('E:\Deep Learning\deeplearn\stanford_dl_ex-master\cnn\');
addpath('E:\DescriptorEvaluation\vlbenchmakrs-1.0-beta\vlbenchmakrs-1.0-beta\');
import datasets.*;
import benchmarks.*;
import localFeatures.*;
mserDetector = VlFeatMser('MinDiversity',0.5);
HessianLap_Detector = VlFeatCovdet('method', 'hessianlaplace', ...
                                 'estimateaffineshape', true, ...
                                 'estimateorientation', true, ...
                                 'peakthreshold',0.0035,...
                                 'doubleImage', false);
Hessian_Detector = VlFeatCovdet('method', 'Hessian', ...
                                 'estimateaffineshape', true, ...
                                 'estimateorientation', false, ...
                                 'peakthreshold',0.0035,...
                                 'doubleImage', false);

% parameterfilename = ('learnedParamaters2610_5_199batches5epoches199iterations.mat');
% parameterfilename = ('learnedParamaters1011_3.mat');
% parameterfilename = ('learnedParamaters1112_80_graf.mat');
% img = imread('E:\KarstenData\apartimg\000002-111406161256-11.tifresize.png');
% img2 = imread('E:\KarstenData\apartimg\000003-111406161250-04.tifresize.png');
% img = imread('E:\software\IPI\Data\graf\img1.ppm');
% img2 = imread('E:\software\IPI\Data\graf\img5.ppm');
% % img2 = imrotate(img2,90);
% % img = imread('libertyab_z.jpg');
% % img2 = imread('statue-of-liberty.jpg');
% % extract the patches first
% if(size(img,3)>1)
%     img_left = rgb2gray(img);
% else
%     img_left = img;
% end
% img_left = im2single(img_left);
% % [frames_left_vlsift descrs_left_vlsift] =  vl_sift(img_left,'Verbose');
% % [frames_left,Patch_left] = chen_extractSIFTpatch_CNN(img_left,frames_left_vlsift);
% [frames_left,Patch_left] = chen_extractSIFTpatch_CNN(img_left);
% if(size(img2,3)>1)
%     img_right = rgb2gray(img2);
% else
%     img_right = img2;
% end
% img_right = im2single(img_right);

Hessframse_left = HessianLap_Detector.extractFeatures(['undistorted_image_243_DSC05692' 'resize.png']);
[hessianframes_left, Patch_Hessian_left] = Chen_extractHessianLappatch4SiameseCNN(im2single(img),Hessframse_left); 
[frames_left, descrs_hessian_sift_left] = vl_covdet(im2single(img), 'descriptor', ...
    'SIFT','PatchResolution',31,'Doubleimage',false,'PatchRelativeExtent',7.5,'PatchRelativeSmoothing',0.3,'Frames',hessianframes_left,'EstimateAffineShape', false) ;
% [hessianframes_left, Patch_Hessian_left] = Chen_extractHessianLappatch4SiameseCNN(im2single(rgb2gray(img)),Hessframse_left); 
% [frames_left, descrs_hessian_sift_left] = vl_covdet(im2single(rgb2gray(img)), 'descriptor', ...
%     'SIFT','PatchResolution',31,'Doubleimage',false,'PatchRelativeExtent',7.5,'PatchRelativeSmoothing',0.3,'Frames',hessianframes_left,'EstimateAffineShape', true) ;

Hessframse_right = HessianLap_Detector.extractFeatures(['undistorted_image_298_DSC05747' 'resize.png']);
[hessianframes_right, Patch_Hessian_right] = Chen_extractHessianLappatch4SiameseCNN(im2single(img2),Hessframse_right); 
[frames_right, descrs_hessian_sift_right] = vl_covdet(im2single(img2), 'descriptor', ...
    'SIFT','PatchResolution',31,'Doubleimage',false,'PatchRelativeExtent',7.5,'PatchRelativeSmoothing',0.3,'Frames',hessianframes_right,'EstimateAffineShape', false) ;
% [hessianframes_right, Patch_Hessian_right] = Chen_extractHessianLappatch4SiameseCNN(im2single(rgb2gray(img2)),Hessframse_right); 
% [frames_right, descrs_hessian_sift_right] = vl_covdet(im2single(rgb2gray(img2)), 'descriptor', ...
%     'SIFT','PatchResolution',31,'Doubleimage',false,'PatchRelativeExtent',7.5,'PatchRelativeSmoothing',0.3,'Frames',hessianframes_right,'EstimateAffineShape', true) ;
% [frames_right_vlsift descrs_right_vlsift] =  vl_sift(img_left,'Verbose');
% [frames_right,Patch_right] = chen_extractSIFTpatch_CNN(img_right,frames_right_vlsift);
% [frames_right,Patch_right] = chen_extractSIFTpatch_CNN(img_right);
% convert patches into CNN formed descriptor




[CNNdescriptor_left,CNNdescriptor_right] = Chen_GenDescfrom_LearnedsiameseCNNparams(parameterfilename,Patch_Hessian_left,Patch_Hessian_right);
clear index_match distance_match matches_dis_SiamCNN current_match_1st current_match_2nd match_distanc;
kdtree_left = vl_kdtreebuild(CNNdescriptor_left);
[index_match, distance_match] = vl_kdtreequery(kdtree_left,CNNdescriptor_left ,CNNdescriptor_right,'NumNeighbors', 10) ;
Max_distance = max(max(distance_match));
Min_distance = min(min(distance_match));
% [current_match_index,dis] = find(distance_match(:)<10);
Test_distance = Min_distance + 0.10*(Max_distance-Min_distance);
[current_match_1st,current_match_2nd,match_distanc] = find(distance_match<Test_distance);
% Chen_show_matchresult(uint8(rgb2gray(img)),uint8(rgb2gray(img2)),matches_sift,frames_left,frames_right,0);
for i=1:numel(current_match_2nd)
    matches_dis_SiamCNN(1,i) = index_match(current_match_1st(i),current_match_2nd(i));
    matches_dis_SiamCNN(2,i) = current_match_2nd(i);
end
Chen_show_matchresult(uint8(img),uint8(img2),matches_dis_SiamCNN,frames_left,frames_right,0);
% Chen_show_matchresult(uint8(rgb2gray(img)),uint8(rgb2gray(img2)),matches_dis_SiamCNN,frames_left,frames_right,0);

clear index_match_sift distance_match_sift matches_dis_sift;
kdtree_left_sift = vl_kdtreebuild(descrs_hessian_sift_left);
[index_match_sift, distance_match_sift] = vl_kdtreequery(kdtree_left_sift,descrs_hessian_sift_left ,descrs_hessian_sift_right,'NumNeighbors', 10) ;
Max_distance_sift = max(max(distance_match_sift));
Min_distance_sift = min(min(distance_match_sift));
Test_distance_sift = Min_distance_sift + 0.05*(Max_distance_sift-Min_distance_sift);
% [current_match_index,dis] = find(distance_match(:)<10);
[current_match_1st_sift,current_match_2nd_sift,match_distanc_sift] = find(distance_match_sift<Test_distance_sift);
% Chen_show_matchresult(uint8(rgb2gray(img)),uint8(rgb2gray(img2)),matches_sift,frames_left,frames_right,0);
for i=1:numel(current_match_2nd_sift)
    matches_dis_sift(1,i) = index_match_sift(current_match_1st_sift(i),current_match_2nd_sift(i));
    matches_dis_sift(2,i) = current_match_2nd_sift(i);
end
Chen_show_matchresult(uint8(img),uint8(img2),matches_dis_sift,frames_left,frames_right,0);
% Chen_show_matchresult(uint8(rgb2gray(img)),uint8(rgb2gray(img2)),matches_dis_sift,frames_left,frames_right,0);





match_ratio  =1.2;
clear matches_CNN_Desc scores_CNN_Desc;

% match them by 1st/2nd nearest distance threshold
[matches_CNN_Desc, scores_CNN_Desc] = vl_ubcmatch(CNNdescriptor_left, CNNdescriptor_right,match_ratio);
[matches_sift, scores_sift] = vl_ubcmatch(descrs_hessian_sift_left, descrs_hessian_sift_right,match_ratio);
% randm_selected = randperm();
Chen_show_matchresult(uint8(rgb2gray(img)),uint8(rgb2gray(img2)),matches_CNN_Desc,frames_left,frames_right,0);
Chen_show_matchresult(uint8(rgb2gray(img)),uint8(rgb2gray(img2)),matches_sift,frames_left,frames_right,0);

% filtering false matches by evaluating fundmental matrix using RANSAC
[F_matrix,inlinear_index] = Chen_estimateFundmentalmatrix_RANSAC(frames_left,frames_right,matches_CNN_Desc,1.5,20000);
Initial_MatchNum = size(matches_CNN_Desc,2);
img_coord1 = frames_left(1:2,matches_CNN_Desc(1,:));
img_coord2 = frames_right(1:2,matches_CNN_Desc(2,:));
correct_Match_coord1 = img_coord1(1:2,inlinear_index);
correct_Match_coord2 = img_coord2(1:2,inlinear_index);
draw_epipolar_lines(F_matrix,uint8(255*img_left),uint8(255*img_right),correct_Match_coord1',correct_Match_coord2');
Chen_show_matchresult(uint8(255*img_left),uint8(255*img_right), matches_CNN_Desc(1:2,inlinear_index),frames_left,frames_right,0);