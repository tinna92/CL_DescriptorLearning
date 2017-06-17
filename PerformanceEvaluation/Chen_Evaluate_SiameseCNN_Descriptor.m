%% get the patch surrounding feature points first, then evaluate the autoencoder based on one image pairs
% pay attention to that this version is only workable for leftimageindex =1
% 
function [CorrectMatch_num_AutoECNN,Match_num,recall,one_minus_precision] = Chen_Evaluate_SiameseCNN_Descriptor(datasetname,index_leftimage,index_rightimage,autoencodername,filterdim,Visiblesize,Hiddensize)
vl_setup
addpath('E:\Image Matching\Code\vlfeat-0.9.17-bin\vlfeat-0.9.17\toolbox\');
addpath('E:\Deep Learning\deeplearn\stanford_dl_ex-master\cnn\');
addpath('E:\DescriptorEvaluation\vlbenchmakrs-1.0-beta\vlbenchmakrs-1.0-beta\');

import datasets.*;
import benchmarks.*;
dataset = VggAffineDataset('category',datasetname);

% load the image patch for 1st image
patch_savename = [datasetname '_Patch_img' num2str(index_leftimage) '.mat'];
load(patch_savename);
descrs = Patch_uint2;
clear Patch_uint2;
descrs = normalizeData2(double(descrs));
patch_size = 16;
desc_num1=size(descrs,2);
patch_descrs1 = zeros(patch_size,patch_size,desc_num1);
for i=1:desc_num1
    patch_descrs1(:,:,i) = reshape(descrs(:,i),patch_size,patch_size);
end

% load the image patch for the next images and do matching
visibleSize = Visiblesize;   % number of input units 
hiddenSize = Hiddensize;     % number of hidden units 
% filterdim = filterdim;
% poolDim = Pooldim;
% load opttheta_DOG_9_9_9__0001_0128; 
load(autoencodername);
theta = opttheta;

% load the ground truth data
savename=[datasetname '_GroundTruth_matches.mat'];
load(savename);

% calculate the autoencoder descriptor first
img = imread(dataset.getImagePath(index_rightimage));
if(size(img,3)>1)
    img = rgb2gray(img);
end
img = single(img);
patch_savename = [datasetname '_Patch_img' num2str(index_rightimage) '.mat'];
load(patch_savename);
descrs2 = Patch_uint2; 
descrs2 = normalizeData2(double(descrs2));
desc_num2=size(descrs2,2);
patch_descrs2 = zeros(patch_size,patch_size,desc_num2);
for ii=1:desc_num2
    patch_descrs2(:,:,ii) = reshape(descrs2(:,ii),patch_size,patch_size);
end
[AEdescriptor_left,AEdescriptor_right]= Chen_compute_Descrip_AE(theta,visibleSize,hiddenSize,filterdim,patch_size,patch_descrs1,patch_descrs2);

for i=1:20
    match_ratio = 0.81 + i*0.1;
    
    % do the match according to match_ratio
    [matches_spaCNN, scores_spaCNN] = vl_ubcmatch(AEdescriptor_left, AEdescriptor_right,match_ratio);
    
    % evaluate the recall and 1-precision
    Match_Single = zeros(1,desc_num1);
    match_num = size(matches_spaCNN,2);
    for ii=1:match_num
        Match_Single(1,matches_spaCNN(1,ii))=matches_spaCNN(2,ii);
    end
    Match_Grt_1_i = GroundTruth_matches{1,index_rightimage};
    nnn=(Match_Grt_1_i==Match_Single);
    mmm=(Match_Grt_1_i(nnn)~=0);
    CorrectMatch_num_AutoECNN(i) = sum(mmm);
    Match_num(i) = sum(Match_Single~=0);
    Num_correspondence(i) = sum(Match_Grt_1_i~=0);
    recall(i)=CorrectMatch_num_AutoECNN(i)/Num_correspondence(i);
    one_minus_precision(i) = (Match_num(i)-CorrectMatch_num_AutoECNN(i))/Match_num(i);
    clear Match_Single;
    clear descrs2;
end
end