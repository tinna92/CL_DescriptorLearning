%% get the patch surrounding feature points first
function [CorrectMatch_num_SIFT,Match_num_SIFT,recall_SIFT,one_minus_precision_SIFT,Num_correspondence_SIFT] = Chen_EvaluateSIFTDescriptor2(datasetname,index_leftimage,index_rightimage)
addpath('E:\Image Matching\Code\vlfeat-0.9.17-bin\vlfeat-0.9.17\toolbox\');
addpath('E:\Deep Learning\deeplearn\stanford_dl_ex-master\cnn\');
addpath('E:\DescriptorEvaluation\vlbenchmakrs-1.0-beta\vlbenchmakrs-1.0-beta\');
vl_setup;

import datasets.*;
import benchmarks.*;
dataset = VggAffineDataset('category',datasetname);
% load the image patch for 1st image
img = imread(dataset.getImagePath(index_leftimage));
if(size(img,3)>1)
    img = rgb2gray(img);
end
img = single(img);
[frames, descrs] = vl_sift(img);

% load ground truth data
savename=[datasetname '_GroundTruth_matches.mat'];
load(savename);
Match_Grt_1_i = GroundTruth_matches{1,index_rightimage};

% load the second image
imgs2 = imread(dataset.getImagePath(index_rightimage));
if(size(imgs2,3)>1)
    imgs2 = rgb2gray(imgs2);
end
imgs2 = single(imgs2);
[frames2, descrs2] = vl_sift(imgs2);  


for i=1:40
    match_ratio = 0.81 + i*0.2;
    
    % do the match according to match_ratio
    [matches_SIFT, scores_SIFT] = vl_ubcmatch(descrs, descrs2,match_ratio);
    
    % evaluate the recall and 1-precision
    Match_Single_sift = zeros(1,size(descrs,2));
    match_num = size(matches_SIFT,2);
    for ii=1:match_num
        Match_Single_sift(1,matches_SIFT(1,ii))=matches_SIFT(2,ii);
    end
    nnn=(Match_Grt_1_i==Match_Single_sift);
    mmm=(Match_Grt_1_i(nnn)~=0);
    CorrectMatch_num_SIFT(i) = sum(mmm);
    Match_num_SIFT(i) = sum(Match_Single_sift~=0);
    Num_correspondence_SIFT(i) = sum(Match_Grt_1_i~=0);
    recall_SIFT(i)=CorrectMatch_num_SIFT(i)/Num_correspondence_SIFT(i);
    one_minus_precision_SIFT(i) = (Match_num_SIFT(i)-CorrectMatch_num_SIFT(i))/Match_num_SIFT(i);
    
    clear Match_Single;
%     clear descrs2;
end
end


