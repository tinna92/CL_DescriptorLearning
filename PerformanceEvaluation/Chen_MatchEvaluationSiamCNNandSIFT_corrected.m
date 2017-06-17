%% get the patch surrounding feature points first, then evaluate the autoencoder based on one image pairs
% pay attention to that this version is only workable for leftimageindex =1
% 
datasetname = 'graf';
index_leftimage  = 1;
index_rightimage = 4;
% addpath('E:\Image Matching\Code\vlfeat-0.9.17-bin\vlfeat-0.9.17\toolbox\');
% addpath('E:\Deep Learning\deeplearn\stanford_dl_ex-master\cnn\');
addpath('E:\DescriptorEvaluation\vlbenchmakrs-1.0-beta\vlbenchmakrs-1.0-beta\');
% addpath('E:\Deep Learning\sparseae_exercise\starter\');
% vl_setup
import datasets.*;
import benchmarks.*;
dataset = VggAffineDataset('category',datasetname);

% load the image patch for 1st image
patch_savename = [datasetname '_Patch_img' num2str(index_leftimage) '.mat'];
load(patch_savename);
patch_savename = [datasetname '_Patch_img' num2str(index_rightimage) '.mat'];
load(patch_savename);
load([datasetname '_Patch_img_4SiamCNN_' num2str(index_leftimage) '.mat']); % load for siamCNN
load([datasetname '_Patch_img_4SiamCNN_' num2str(index_rightimage) '.mat']); % load for siamCNN

load([datasetname 'Groundtruth_match_SiamCNN.mat']);% ground truth match for siamese Architecture
% parameterfilename = ('learnedParamaters1112_80_graf.mat');
descrs = Patch_left;
desc_num1=size(descrs,2);
descrs2 = Patch_right; 
desc_num2=size(descrs2,2);

% convert patches into CNN formed descriptor
% parameterfilename = ('learnedParamaters2510_1_200batches200iterations.mat');
% parameterfilename = ('learnedParamaters2610_5_100batches5epoches500iterations.mat');
parameterfilename = ('learnedParamaters1311_100_notredame.mat');
% parameterfilename = ('learnedParamaters1112_80_graf.mat');
[CNNdescriptor_left,CNNdescriptor_right] = Chen_GenDescfrom_LearnedsiameseCNNparams(parameterfilename,descrs,descrs2);

for i=1:30
    match_ratio = 0.801 + i*0.2;
    
    % do the match according to match_ratio
    [matches_spaCNN, scores_spaCNN] = vl_ubcmatch(CNNdescriptor_left, CNNdescriptor_right,match_ratio);
%     Chen_show_matchresult(uint8(255*img_left),uint8(255*img_right),matches_spaCNN,frames_left,frames_right,0);
    % evaluate the recall and 1-precision
    Match_Single = zeros(1,desc_num1);
    match_num = size(matches_spaCNN,2);
    for ii=1:match_num
        Match_Single(1,matches_spaCNN(1,ii))=matches_spaCNN(2,ii);
    end
    Match_Grt_1_i = Groundtruth_match_SiamCNN{1,index_rightimage};% load the match from siamCNN ground truth match
    nnn=(Match_Grt_1_i==Match_Single);
    mmm=(Match_Grt_1_i(nnn)~=0);
    CorrectMatch_num_AutoECNN(i) = sum(mmm);
    Match_num(i) = sum(Match_Single~=0);
    Num_correspondence(i) = sum(Match_Grt_1_i~=0);
    recall(i)=CorrectMatch_num_AutoECNN(i)/Num_correspondence(i);
    one_minus_precision(i) = (Match_num(i)-CorrectMatch_num_AutoECNN(i))/Match_num(i);
    clear Match_Grt_1_i;
    clear Match_Single;
    clear matches_spaCNN;
%     clear descrs2;
end

[CorrectMatch_num_SIFT,Match_num_SIFT,recall_SIFT,one_minus_precision_SIFT,Num_correspondence_SIFT] = Chen_EvaluateSIFTDescriptor2(datasetname,index_leftimage,index_rightimage);

plot(one_minus_precision,recall,'b-','linewidth', 2); hold on ;
%  plot(one_minus_precision8,recall8,'m-','linewidth', 2); hold on ;
% plot(one_minus_precision9,recall9,'k-','linewidth', 2); hold on ;
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
% legend(...
%     'AUTOENCODER DESCRIPTOR, 64D ','AUTOENCODER DESCRIPTOR, 128D ',...
%     'AUTOENCODER DESCRIPTOR, 32D ','SIFT, 128D','Location','SouthOutside');
legend(...
    'CNN Siamese DESCRIPTOR, 125D ','SIFT, 128D','Location','SouthEast');
set(gca, 'fontsize', 16);
set(gca, 'XMinorTick', 'on');
saveas(gcf,'a.jpg');
axis([x_start, x_end, y_start, y_end]);
print(gcf, '-depsc2', [datasetname 'dataset-img' num2str(index_leftimage) '-img' num2str(index_rightimage) '.eps']);








