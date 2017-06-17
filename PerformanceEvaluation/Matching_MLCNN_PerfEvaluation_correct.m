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

% load the learned parameters for descriptors
% load('E:\MATCONVNET\matconvnet-1.0-beta10\learnedParamaters0705.mat');
% addpath(genpath('E:\MATCONVNET\matconvnet-1.0-beta10\'));
% load('learnedParamaters2506_50_libertytrain500000.mat');
% load('learnedParamaters2310_20.mat');
% load('learnedParamaters2706_50_trainYosemite_Test_Notre.mat');
% load('learnedParamaters2610_3epoch_60iterations_20batchesineachEpoch.mat');
% load('learnedParamaters2610_10epoch_1510iterations_151batchesineachEpoch.mat');
% load('learnedParamaters2610_10epoch_300iterations_30batchesineachEpoch.mat');
% load('learnedParamaters2610_10epoch_300iterations_30batchesineachEpoch.mat');
% load the image patch for 1st image
patch_savename = [datasetname '_Patch_img' num2str(index_leftimage) '.mat'];
load(patch_savename);
descrs = Patch_uint2;
clear Patch_uint2;
% descrs = normalizeData2(double(descrs));
patch_size = 32;
desc_num1=size(descrs,2);
% patch_descrs1 = zeros(patch_size,patch_size,desc_num1);
% for i=1:desc_num1
%      patch_descrs1(:,:,i) = reshape(descrs(:,i),patch_size,patch_size);
% %     patch_CNNInput1(:,:,1,i) = kron( patch_descrs1(:,:,i),ones(2));
% end
% 
% 
% % load the ground truth data
savename=[datasetname '_GroundTruth_matches.mat'];
load(savename);
% 
% % load the right image
% img = imread(dataset.getImagePath(index_rightimage));
% if(size(img,3)>1)
%     img = rgb2gray(img);
% end
% img = single(img);
patch_savename = [datasetname '_Patch_img' num2str(index_rightimage) '.mat'];
load(patch_savename);
descrs2 = Patch_uint2; 
% descrs2 = normalizeData2(double(descrs2));
desc_num2=size(descrs2,2);
% patch_descrs2 = zeros(patch_size,patch_size,desc_num2);
% for ii=1:desc_num2
%      patch_descrs2(:,:,ii) = reshape(descrs2(:,ii),patch_size,patch_size);
% %      patch_CNNInput2(:,:,1,ii) = kron( patch_descrs2(:,:,ii),ones(2));
% end


% for i=1:size(descrs_Aff1,2)
%     Temp_patch=reshape(descrs_Aff1(:,i),63,63);
%     small_patch=imresize(Temp_patch,[32 32]);
%     nn=reshape(small_patch,1,1024);
%     Patch_left(:,i)=nn';
% end
% 
% for i=1:size(descrs_Aff2,2)
%     Temp_patch=reshape(descrs_Aff2(:,i),63,63);
%     small_patch=imresize(Temp_patch,[32 32]);
%     nn=reshape(small_patch,1,1024);
%     Patch_right(:,i)=nn';
% end

% convert patches into CNN formed descriptor
% parameterfilename = ('learnedParamaters2510_1_200batches200iterations.mat');
% parameterfilename = ('learnedParamaters2610_5_100batches5epoches500iterations.mat');
% parameterfilename = ('learnedParamaters2506_50_libertytrain500000.mat');
% parameterfilename = ('learnedParamaters1112_80_graf.mat');
parameterfilename = ('learnedParamaters1311_100_notredame.mat');
[CNNdescriptor_left,CNNdescriptor_right] = Chen_GenDescfrom_LearnedsiameseCNNparams(parameterfilename,descrs,descrs2);



for i=1:40
    match_ratio = 0.80 + i*0.1;
    
    % do the match according to match_ratio
    [matches_spaCNN, scores_spaCNN] = vl_ubcmatch(CNNdescriptor_left, CNNdescriptor_right,match_ratio);
    
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
    clear Match_Grt_1_i;
     clear Match_Single;
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








