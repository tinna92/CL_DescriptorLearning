%% get the patch surrounding feature points first, then evaluate the autoencoder based on one image pairs
% pay attention to that this version is only workable for leftimageindex =1
% 
datasetname = 'graf';
index_leftimage  = 1;
index_rightimage = 2;
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

% % load the ground truth data
savename=[datasetname '_GroundTruth_matches.mat'];
load(savename);

% patch_savename = [datasetname '_HessLap_Patch_img' num2str(index_leftimage) '.mat'];
% load(patch_savename);
% descrs = Patch_HessianLap;
% clear Patch_HessianLap;
% patch_size = 32;
% desc_num1=size(descrs,2);
% 
% patch_savename = [datasetname '_HessLap_Patch_img' num2str(index_rightimage) '.mat'];
% load(patch_savename);
% descrs2 = Patch_HessianLap; 
% desc_num2=size(descrs2,2);
% clear Patch_HessianLap;

% patch_savename = [datasetname '_Hess_Patch_img' num2str(index_leftimage) '.mat'];
patch_savename = [datasetname '_HessLap_Patch_img' num2str(index_leftimage) '.mat'];
load(patch_savename);
% descrs = Patch_Hessian;
descrs = Patch_HessianLap;
% clear Patch_Hessian;
clear Patch_HessianLap;
patch_size = 32;
desc_num1=size(descrs,2);
% 
% patch_savename = [datasetname '_Hess_Patch_img' num2str(index_rightimage) '.mat'];
patch_savename = [datasetname '_HessLap_Patch_img' num2str(index_rightimage) '.mat'];
load(patch_savename);
% descrs2 = Patch_Hessian; 
descrs2 = Patch_HessianLap; 
desc_num2=size(descrs2,2);
% clear Patch_Hessian;
clear Patch_HessianLap;


% convert patches into CNN formed descriptor
% parameterfilename = ('learnedParamaters2510_1_200batches200iterations.mat');
% parameterfilename = ('learnedParamaters2610_5_100batches5epoches500iterations.mat');
% parameterfilename = ('learnedParamaters2506_50_libertytrain500000.mat');
% parameterfilename = ('learnedParamaters1112_80_graf.mat');
% parameterfilename = ('learnedParamaters1311_100_notredame.mat');
parameterfilename = ('learnedParamaters0112_30_batchsize_1000_notredame_validation.mat');

% parameterfilename = ('learnedParamaters2706_50_trainYosemite_Test_Notre.mat');
[CNNdescriptor_left,CNNdescriptor_right] = Chen_GenDescfrom_LearnedsiameseCNNparams(parameterfilename,descrs,descrs2);

% load the sift descriptor for hessianlaplace detector.
sift_hessianlap_desc_name_left=[datasetname '_HessLap_Sift_Desc' num2str(index_leftimage) '.mat'];
load(sift_hessianlap_desc_name_left);
Descriptor_hessianlap_sift_left = descrs_hessianlap_sift;
clear descrs_hessianlap_sift;
sift_hessianlap_desc_name_right=[datasetname '_HessLap_Sift_Desc' num2str(index_rightimage) '.mat'];
load(sift_hessianlap_desc_name_right);
Descriptor_hessianlap_sift_right = descrs_hessianlap_sift;
clear descrs_hessianlap_sift;


% sift_hessianlap_desc_name_left=[datasetname '_Hess_Sift_Desc' num2str(index_leftimage) '.mat'];
% load(sift_hessianlap_desc_name_left);
% Descriptor_hessianlap_sift_left = descrs_hessian_sift;
% clear descrs_hessian_sift;
% sift_hessianlap_desc_name_right=[datasetname '_Hess_Sift_Desc' num2str(index_rightimage) '.mat'];
% load(sift_hessianlap_desc_name_right);
% Descriptor_hessianlap_sift_right = descrs_hessian_sift;
% clear descrs_hessian_sift;

for i=1:40
    % evaluate for hessianlap feature with siamCNN descriptor
    match_ratio = 0.80 + i*0.2;
    % do the match according to match_ratio
    [matches_spaCNN, scores_spaCNN] = vl_ubcmatch(CNNdescriptor_left, CNNdescriptor_right,match_ratio);
    
    % evaluate the recall and 1-precision
    Match_Single = zeros(1,desc_num1);
    match_num = size(matches_spaCNN,2);
    for ii=1:match_num
        Match_Single(1,matches_spaCNN(1,ii))=matches_spaCNN(2,ii);
    end
    Match_Grt_1_i = GroundTruth_matches{3,index_rightimage};
    nnn=(Match_Grt_1_i==Match_Single);
    mmm=(Match_Grt_1_i(nnn)~=0);
    CorrectMatch_num_AutoECNN(i) = sum(mmm);
    Match_num(i) = sum(Match_Single~=0);
    Num_correspondence(i) = sum(Match_Grt_1_i~=0);
    recall(i)=CorrectMatch_num_AutoECNN(i)/Num_correspondence(i);
    one_minus_precision(i) = (Match_num(i)-CorrectMatch_num_AutoECNN(i))/Match_num(i);
    clear Match_Grt_1_i;
    clear Match_Single;
    
    
    %% evaluate for hessianlap feature with SIFT descriptor
    match_ratio = 0.80 + i*0.2;
    % do the match according to match_ratio
    [matches_HessianLap_Sift, scores_HessianLap_Sift] = vl_ubcmatch(Descriptor_hessianlap_sift_left, Descriptor_hessianlap_sift_right,match_ratio);
    
    % evaluate the recall and 1-precision
    Match_Single_HessianLap_Sift = zeros(1,desc_num1);
    match_num = size(matches_HessianLap_Sift,2);
    for ii=1:match_num
        Match_Single_HessianLap_Sift(1,matches_HessianLap_Sift(1,ii))=matches_HessianLap_Sift(2,ii);
    end
    
    Match_Grt_1_i = GroundTruth_matches{3,index_rightimage};
    
    nnn=(Match_Grt_1_i==Match_Single_HessianLap_Sift);
    mmm=(Match_Grt_1_i(nnn)~=0);
    CorrectMatch_num_HessianLap_Sift(i) = sum(mmm);
    Match_num_HessianLap_Sift(i) = sum(Match_Single_HessianLap_Sift~=0);
    Num_correspondence_HessianLap_Sift(i) = sum(Match_Grt_1_i~=0);
    recall_HessianLap_Sift(i)=CorrectMatch_num_HessianLap_Sift(i)/Num_correspondence_HessianLap_Sift(i);
    one_minus_precision_HessianLap_Sift(i) = (Match_num_HessianLap_Sift(i)-CorrectMatch_num_HessianLap_Sift(i))/Match_num_HessianLap_Sift(i);
    clear Match_Grt_1_i;
    clear Match_Single_HessianLap_Sift;
    
    
%     clear descrs2;
end

% [CorrectMatch_num_SIFT,Match_num_SIFT,recall_SIFT,one_minus_precision_SIFT,Num_correspondence_SIFT] = Chen_EvaluateSIFTDescriptor2(datasetname,index_leftimage,index_rightimage);

plot(one_minus_precision,recall,'bs-','linewidth', 2); hold on ;
%  plot(one_minus_precision8,recall8,'m-','linewidth', 2); hold on ;
% plot(one_minus_precision9,recall9,'k-','linewidth', 2); hold on ;
% plot(one_minus_precision_SIFT,recall_SIFT,'g-','linewidth', 2); hold on ;
plot(one_minus_precision_HessianLap_Sift,recall_HessianLap_Sift,'g*-','linewidth', 2); hold on ;
title([datasetname ' dataset: img' num2str(index_leftimage) '-img' num2str(index_rightimage)],'fontsize',20);
ylabel(['#correct / ' num2str(Num_correspondence_HessianLap_Sift(1))],'fontsize',16);
xlabel('1-precision','fontsize',16);
grid on;
x_start= max(min(min(one_minus_precision),min(one_minus_precision_HessianLap_Sift))-0.1,0);
x_end = min(max(max(one_minus_precision),max(one_minus_precision_HessianLap_Sift))+0.1,1);
y_start = max(min(min(recall_HessianLap_Sift),min(recall))-0.1,0);
y_end = min(max(max(recall_HessianLap_Sift),max(recall))+0.1,1);

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


%     % convert patches into CNN formed descriptor
%     % parameterfilename = ('learnedParamaters2510_1_200batches200iterations.mat');
%     % parameterfilename = ('learnedParamaters2610_5_100batches5epoches500iterations.mat');
%     % parameterfilename = ('learnedParamaters2506_50_libertytrain500000.mat');
%     % parameterfilename = ('learnedParamaters1112_80_graf.mat');
%     % parameterfilename = ('learnedParamaters1311_100_notredame.mat');
%     parameterfilename = ('learnedParamaters0112_30_batchsize_1000_notredame_validation.mat');
%     % parameterfilename = ('learnedParamaters2706_50_trainYosemite_Test_Notre.mat');
% 
% parameterfilename = ('learnedParamaters2206_100_batchsize_1000_liberty_validation.mat');
% parameterfilename = ('learnedParamaters1203_30_batchsize_1000_train_om_liberty_Yosimate_validation.mat');
% parameterfilename = ('learnedParamaters2403_80_batchsize_1000_train_om_liberty_Yosimate_validation_withoutMining.mat');
parameterfilename = ('learnedParamaters0104_30_batchsize_1000_train_om_liberty_Yosimate_validation_withMining.mat');
 patch_savename = [datasetname '_HessLap_Patch_img' num2str(index_leftimage) '.mat'];
 load(patch_savename);
 % descrs = Patch_Hessian;
 descrs = Patch_HessianLap;
 % clear Patch_Hessian;
 clear Patch_HessianLap;
 patch_size = 32;
 desc_num1=size(descrs,2);
%  
 sift_hessianlap_desc_name_left=[datasetname '_HessLap_Sift_Desc' num2str(index_leftimage) '.mat'];
 load(sift_hessianlap_desc_name_left);
 Descriptor_hessianlap_sift_left = descrs_hessianlap_sift;
 clear descrs_hessianlap_sift;
    
for iii=1:5
   
    index_rightimage = iii+1;
    % patch_savename = [datasetname '_Hess_Patch_img' num2str(index_rightimage) '.mat'];
    patch_savename = [datasetname '_HessLap_Patch_img' num2str(index_rightimage) '.mat'];
    load(patch_savename);
    % descrs2 = Patch_Hessian; 
    descrs2 = Patch_HessianLap; 
    desc_num2=size(descrs2,2);
    % clear Patch_Hessian;
    clear Patch_HessianLap;

%     [CNNdescriptor_left,CNNdescriptor_right] = Chen_GenDescfrom_LearnedsiameseCNNparams(parameterfilename,descrs,descrs2);
    [CNNdescriptor_left,CNNdescriptor_right] = Chen_GenDescfrom_LearnedsiameseCNNparams_LRNNormalize(parameterfilename,descrs,descrs2);
    
    % load the sift descriptor for hessianlaplace detector.

    sift_hessianlap_desc_name_right=[datasetname '_HessLap_Sift_Desc' num2str(index_rightimage) '.mat'];
    load(sift_hessianlap_desc_name_right);
    Descriptor_hessianlap_sift_right = descrs_hessianlap_sift;
    clear descrs_hessianlap_sift;
    
%      match_ratio = 1.25;
        match_ratio = 1.25;
    % do the match according to match_ratio
    [matches_spaCNN, scores_spaCNN] = vl_ubcmatch(CNNdescriptor_left, CNNdescriptor_right,match_ratio);
    
    % evaluate the recall and 1-precision
    Match_Single = zeros(1,desc_num1);
    match_num = size(matches_spaCNN,2);
    for ii=1:match_num
        Match_Single(1,matches_spaCNN(1,ii))=matches_spaCNN(2,ii);
    end
    Match_Grt_1_i = GroundTruth_matches{3,index_rightimage};
    nnn=(Match_Grt_1_i==Match_Single);
    mmm=(Match_Grt_1_i(nnn)~=0);
    CorrectMatch_num_AutoECNN(i) = sum(mmm);
    Match_num(i) = sum(Match_Single~=0);
    Num_correspondence(i) = sum(Match_Grt_1_i~=0);
    recall_siaMeseCNN(iii)=CorrectMatch_num_AutoECNN(i)/Num_correspondence(i);
    one_minus_precision(iii) = (Match_num(i)-CorrectMatch_num_AutoECNN(i))/Match_num(i);

    clear Match_Single;
    
    
    %% evaluate for hessianlap feature with SIFT descriptor
%     match_ratio = 0.80 + i*0.2;
    % do the match according to match_ratio
    [matches_HessianLap_Sift, scores_HessianLap_Sift] = vl_ubcmatch(Descriptor_hessianlap_sift_left, Descriptor_hessianlap_sift_right,match_ratio);
    
    % evaluate the recall and 1-precision
    Match_Single_HessianLap_Sift = zeros(1,desc_num1);
    match_num = size(matches_HessianLap_Sift,2);
    for ii=1:match_num
        Match_Single_HessianLap_Sift(1,matches_HessianLap_Sift(1,ii))=matches_HessianLap_Sift(2,ii);
    end
    
%     Match_Grt_1_i = GroundTruth_matches{3,index_rightimage};
    
    nnn=(Match_Grt_1_i==Match_Single_HessianLap_Sift);
    mmm=(Match_Grt_1_i(nnn)~=0);
    CorrectMatch_num_HessianLap_Sift(i) = sum(mmm);
    Match_num_HessianLap_Sift(i) = sum(Match_Single_HessianLap_Sift~=0);
    Num_correspondence_HessianLap_Sift(i) = sum(Match_Grt_1_i~=0);
    recall_HessianLap_Sift_test(iii)=CorrectMatch_num_HessianLap_Sift(i)/Num_correspondence_HessianLap_Sift(i);
    one_minus_precision_HessianLap_Sift_test(iii) = (Match_num_HessianLap_Sift(i)-CorrectMatch_num_HessianLap_Sift(i))/Match_num_HessianLap_Sift(i);
    clear Match_Grt_1_i;
    clear Match_Single_HessianLap_Sift;
end
viewpointchange=['20�';'30�';'40�';'50�';'60�'];
% h = bar(viewpointchange,[recall_HessianLap_Sift_test(1:5); recall_siaMeseCNN(1:5)]');
h = bar(20:10:60,[recall_HessianLap_Sift_test(1:5); recall_siaMeseCNN(1:5)]');
set(gca,'FontSize',16);
l{1}='SIFT, 128D'; l{2}='Trained CNN Descriptor, 125D';
xlabel('Viewpoint Change (�)','Fontsize',16);
ylabel('Recall Rate','Fontsize',16);
legend(h,l,'Fontsize',16);
set(gcf,'paperpositionmode','auto');
print(gcf,'new_image.eps','-depsc');