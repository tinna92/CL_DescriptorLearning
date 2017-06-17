%% get the patch surrounding feature points first, then evaluate the autoencoder based on one image pairs
% pay attention to that this version is only workable for leftimageindex =1
% 
datasetname = 'graf';
index_leftimage  = 1;
index_rightimage = 3;
% addpath('E:\Image Matching\Code\vlfeat-0.9.17-bin\vlfeat-0.9.17\toolbox\');
% addpath('E:\Deep Learning\deeplearn\stanford_dl_ex-master\cnn\');
addpath('E:\DescriptorEvaluation\vlbenchmakrs-1.0-beta\vlbenchmakrs-1.0-beta\');
% addpath('E:\Deep Learning\sparseae_exercise\starter\');
% vl_setup
import datasets.*;
import benchmarks.*;
dataset = VggAffineDataset('category',datasetname);
% load the image patch for 1st image
% patch_savename = [datasetname '_HessLap_Patch_img' num2str(index_leftimage) '.mat'];
% load(patch_savename);
% descrs = Patch_HessianLap;
% clear Patch_HessianLap;
% patch_size = 32;
% desc_num1=size(descrs,2);
clear frames_left frames_right;
hessian_frames_name=[datasetname '_Hess_frames' num2str(index_leftimage) '.mat'];
load(hessian_frames_name);
frames_left = hessianframes;
hessian_frames_name=[datasetname '_Hess_frames' num2str(index_rightimage) '.mat'];
load(hessian_frames_name);
frames_right = hessianframes;
patch_hessian_savename = [datasetname '_Hess_Patch_img' num2str(index_leftimage) '.mat'];
load(patch_hessian_savename);
descrs = Patch_Hessian;
clear Patch_Hessian;
patch_hessian_savename = [datasetname '_Hess_Patch_img' num2str(index_rightimage) '.mat'];
load(patch_hessian_savename);
descrs2 = Patch_Hessian;
clear Patch_Hessian;

desc_num1=size(descrs,2);

% % load the ground truth data
savename=[datasetname '_GroundTruth_matches.mat'];
load(savename);

% patch_savename = [datasetname '_HessLap_Patch_img' num2str(index_rightimage) '.mat'];
% load(patch_savename);
% descrs2 = Patch_HessianLap; 
% % descrs2 = normalizeData2(double(descrs2));
% desc_num2=size(descrs2,2);
% clear Patch_HessianLap;

% convert patches into CNN formed descriptor
% parameterfilename = ('learnedParamaters2510_1_200batches200iterations.mat');
% parameterfilename = ('learnedParamaters2610_5_100batches5epoches500iterations.mat');
% parameterfilename = ('learnedParamaters2506_50_libertytrain500000.mat');
% parameterfilename = ('learnedParamaters1611_100_Lieberty.mat');
% parameterfilename = ('learnedParamaters3103_30_batchsize_1000_train_om_liberty_Yosimate_validation_withMining.mat');
parameterfilename = ('learnedParamaters0204_30_batchsize_1000_train_om_liberty_Yosimate_validation_withMining');
[CNNdescriptor_left,CNNdescriptor_right] = Chen_GenDescfrom_LearnedsiameseCNNparams_NN(parameterfilename,descrs,descrs2);

clear index_match distance_match matches_dis_SiamCNN current_match_1st current_match_2nd match_distanc matches_dis_SiamCNN;
kdtree_left = vl_kdtreebuild(CNNdescriptor_left);
[index_match, distance_match] = vl_kdtreequery(kdtree_left,CNNdescriptor_left ,CNNdescriptor_right,'NumNeighbors', 1) ;
Max_distance = max(max(distance_match));
Min_distance = min(min(distance_match));
% [current_match_index,dis] = find(distance_match(:)<10);
Test_distance = Min_distance + 0.1*(Max_distance-Min_distance);
[current_match_1st,current_match_2nd,match_distanc] = find(distance_match<Test_distance);
% Chen_show_matchresult(uint8(rgb2gray(img)),uint8(rgb2gray(img2)),matches_sift,frames_left,frames_right,0);
for i=1:numel(current_match_2nd)
    matches_dis_SiamCNN(2,i) = index_match(current_match_1st(i),current_match_2nd(i));
    matches_dis_SiamCNN(1,i) = current_match_2nd(i);
end

img = imread(dataset.getImagePath(index_leftimage));
img2 = imread(dataset.getImagePath(index_rightimage));
Chen_show_matchresult(uint8(rgb2gray(img)),uint8(rgb2gray(img2)),matches_dis_SiamCNN,frames_left,frames_right,0);

Match_Grt_1_i = GroundTruth_matches{4,index_rightimage};
% zero_index = find(Match_Grt_1_i == 0);
zero_index = find(Match_Grt_1_i~=0);
clear ground_truth_match;
ground_truth_match(1,:) = zero_index;
ground_truth_match(2,:) = Match_Grt_1_i(zero_index);
Chen_show_matchresult(uint8(rgb2gray(img)),uint8(rgb2gray(img2)),ground_truth_match,frames_left,frames_right,0);
% img = imread(dataset.getImagePath(index_leftimage));
% img2 = imread(dataset.getImagePath(index_rightimage));
% Chen_show_matchresult(uint8(rgb2gray(img)),uint8(rgb2gray(img2)),ground_truth_match,frames_left,frames_right,0);
% Chen_show_matchresult(uint8(rgb2gray(img)),uint8(rgb2gray(img2)),matches_dis_SiamCNN,frames_left,frames_right,0);


for i=1:40
    match_ratio = 0.80 + i*0.2;    
    % do the match according to match_ratio
    [matches_spaCNN, scores_spaCNN] = vl_ubcmatch(CNNdescriptor_left, CNNdescriptor_right,match_ratio);
    
    % evaluate the recall and 1-precision
    Match_Single = zeros(1,desc_num1);
    match_num = size(matches_spaCNN,2);
    for ii=1:match_num
        Match_Single(1,matches_spaCNN(1,ii))=matches_spaCNN(2,ii);
    end
    Match_Grt_1_i = GroundTruth_matches{4,index_rightimage};
    nnn=(Match_Grt_1_i==Match_Single);
    mmm=(Match_Grt_1_i(nnn)~=0);
    CorrectMatch_num_AutoECNN(i) = sum(mmm);
    Match_num(i) = sum(Match_Single~=0);
    Num_correspondence(i) = sum(Match_Grt_1_i~=0);
    recall(i)=CorrectMatch_num_AutoECNN(i)/Num_correspondence(i);
    one_minus_precision(i) = (Match_num(i)-CorrectMatch_num_AutoECNN(i))/Match_num(i);
    clear Match_Grt_1_i;
    clear Match_Single;
%     clear descrs2;
end


[CorrectMatch_num_SIFT,Match_num_SIFT,recall_SIFT,one_minus_precision_SIFT,Num_correspondence_SIFT] = Chen_EvaluateSIFTDescriptor2(datasetname,index_leftimage,index_rightimage);
plot(one_minus_precision,recall,'b-','linewidth', 2); hold on ;
plot(one_minus_precision_SIFT,recall_SIFT,'g-','linewidth', 2); hold on ;
title([datasetname ' dataset: img' num2str(index_leftimage) '-img' num2str(index_rightimage)],'fontsize',20);
ylabel(['#correct / ' num2str(Num_correspondence_SIFT(1))],'fontsize',16);
xlabel('1-precision','fontsize',16);
grid on;
x_start= max(min(min(one_minus_precision),min(one_minus_precision_SIFT))-0.1,0);
x_end = min(max(max(one_minus_precision),max(one_minus_precision_SIFT))+0.1,1);
y_start = max(min(min(recall_SIFT),min(recall))-0.1,0);
y_end = min(max(max(recall_SIFT),max(recall))+0.1,1);
% axis([0, 1, 0, 1]);
legend(...
    'CNN Siamese DESCRIPTOR, 125D ','SIFT, 128D','Location','SouthEast');
set(gca, 'fontsize', 16);
set(gca, 'XMinorTick', 'on');
saveas(gcf,'a.jpg');
axis([x_start, x_end, y_start, y_end]);
print(gcf, '-depsc2', [datasetname 'dataset-img' num2str(index_leftimage) '-img' num2str(index_rightimage) '.eps']);




