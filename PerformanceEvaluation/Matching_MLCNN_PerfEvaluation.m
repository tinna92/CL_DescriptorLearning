%% get the patch surrounding feature points first, then evaluate the autoencoder based on one image pairs
% pay attention to that this version is only workable for leftimageindex =1
% 
datasetname = 'ubc';
index_leftimage  = 1;
index_rightimage = 2;
firstimageindex = index_leftimage;
secondimageindex = index_rightimage;

% addpath('E:\Image Matching\Code\vlfeat-0.9.17-bin\vlfeat-0.9.17\toolbox\');
% addpath('E:\Deep Learning\deeplearn\stanford_dl_ex-master\cnn\');
addpath('E:\DescriptorEvaluation\vlbenchmakrs-1.0-beta\vlbenchmakrs-1.0-beta\');
% addpath('E:\Deep Learning\sparseae_exercise\starter\');
vl_setup
import datasets.*;
import benchmarks.*;
dataset = VggAffineDataset('category',datasetname);

% load the learned parameters for descriptors
load('learnedParamaters2506_50_libertytrain500000.mat');
% addpath(genpath('E:\MATCONVNET\matconvnet-1.0-beta10\'));


% load the image patch for 1st image
% patch_savename = [datasetname '_Patch_img_CNN' num2str(index_leftimage) '.mat'];
patch_savename = [datasetname '_Patch_img' num2str(index_leftimage) '.mat'];
load(patch_savename);
descrs = Patch_uint2;
clear Patch_uint2;
descrs = normalizeData2(double(descrs));
patch_size = 32;
desc_num1=size(descrs,2);
patch_descrs1 = zeros(patch_size,patch_size,desc_num1);
for i=1:desc_num1
     patch_descrs1(:,:,i) = reshape(descrs(:,i),patch_size,patch_size);
     patch_CNNInput1(:,:,1,i) =  patch_descrs1(:,:,i);
%     patch_CNNInput1(:,:,1,i) = kron( patch_descrs1(:,:,i),ones(2));
end




% load the ground truth data
savename=[datasetname '_GroundTruth_matches.mat'];
load(savename);

% load the right image
img = imread(dataset.getImagePath(index_rightimage));
if(size(img,3)>1)
    img = rgb2gray(img);
end
img = single(img);
patch_savename = [datasetname '_Patch_img_CNN' num2str(index_rightimage) '.mat'];
load(patch_savename);
descrs2 = Patch_uint2; 
descrs2 = normalizeData2(double(descrs2));
desc_num2=size(descrs2,2);
patch_descrs2 = zeros(patch_size,patch_size,desc_num2);
for ii=1:desc_num2
     patch_descrs2(:,:,ii) = reshape(descrs2(:,ii),patch_size,patch_size);
%     patch_CNNInput2(:,:,1,ii) = kron( patch_descrs2(:,:,ii),ones(2));
     patch_CNNInput2(:,:,1,ii) =  patch_descrs2(:,:,ii);
end

% renormalization
for i=1:desc_num1
    tmp_xl =  patch_CNNInput1(:,:,:,i); 
    patch_CNNInput1(:,:,:,i) = (patch_CNNInput1(:,:,:,i) - mean(mean(mean(patch_CNNInput1(:,:,:,i)))))/std(tmp_xl(:));    
end
for i=1:desc_num2
   tmp_xr =  patch_CNNInput2(:,:,:,i);
   patch_CNNInput2(:,:,:,i) = (patch_CNNInput2(:,:,:,i) - mean(mean(mean(patch_CNNInput2(:,:,:,i)))))/std(tmp_xr(:));
end
% setup ;
 
sizew1 = [5 5 1 5];
sizeb1 = [1 5];
sizew2 = [5 5 5 25];
sizeb2 = [1 25];
sizew3 = [5 5 25 125];
sizeb3 = [1 125];
totalsizew1 = cumprod(sizew1);
totalsizeb1 = cumprod(sizeb1);
totalsizew2 = cumprod(sizew2);
totalsizeb2 = cumprod(sizeb2);
totalsizew3 = cumprod(sizew3);
totalsizeb3 = cumprod(sizeb3);
% theta = theta';
w1 = reshape(theta(1:totalsizew1(4)),sizew1(1),sizew1(2),sizew1(3),sizew1(4));
b1 = reshape(theta(totalsizew1(4)+1:totalsizeb1(2)+totalsizew1(4)),sizeb1(1),sizeb1(2));
mark1 = totalsizeb1(2)+totalsizew1(4);
w2 = reshape(theta(mark1+1:mark1+totalsizew2(4)),sizew2(1),sizew2(2),sizew2(3),sizew2(4));
b2 = reshape(theta(mark1+totalsizew2(4)+1:mark1+totalsizew2(4)+totalsizeb2(2)),sizeb2(1),sizeb2(2));
mark2 = mark1+totalsizew2(4)+totalsizeb2(2);
w3 = reshape(theta(mark2+1:mark2+totalsizew3(4)),sizew3(1),sizew3(2),sizew3(3),sizew3(4));
b3 = reshape(theta(mark2+totalsizew3(4)+1:mark2+totalsizew3(4)+totalsizeb3(2)),sizeb3(1),sizeb3(2));

[resl,resr] = PatchDesc_DeepCnn_WithNonlinear_sigmoid(single(patch_CNNInput1),single(patch_CNNInput2), w1, b1,w2,b2,w3,b3);

% convert the CNN output into vl_ubcmatch required form
for ii=1:desc_num1
    CNNdescriptor_left(:,ii) = resl.x6(1,1,:,ii);
%     patch_CNNInput2(:,:,1,ii) = kron( patch_descrs2(:,:,ii),ones(2));
end

for ii=1:desc_num2
    CNNdescriptor_right(:,ii) = resr.x6(1,1,:,ii);
%     patch_CNNInput2(:,:,1,ii) = kron( patch_descrs2(:,:,ii),ones(2));
end

for i=1:30
    match_ratio = 0.81 + i*0.1;
    
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
    clear Match_Single;
    clear descrs2;
end


[CorrectMatch_num_SIFT,Match_num_SIFT,recall_SIFT,one_minus_precision_SIFT,Num_correspondence_SIFT] = Chen_EvaluateSIFTDescriptor2(datasetname,firstimageindex,secondimageindex);

plot(one_minus_precision,recall,'b-','linewidth', 2); hold on ;
plot(one_minus_precision_SIFT,recall_SIFT,'g-','linewidth', 2); hold on ;
title([datasetname ' dataset: img' num2str(firstimageindex) '-img' num2str(secondimageindex)],'fontsize',20);
ylabel(['#correct / ' num2str(Num_correspondence_SIFT(1))],'fontsize',16);%? why ????
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
    'CNN DESCRIPTOR, 125D ','SIFT, 128D','Location','SouthEast');
set(gca, 'fontsize', 16);
set(gca, 'XMinorTick', 'on');
saveas(gcf,'a.jpg');
axis([x_start, x_end, y_start, y_end]);
print(gcf, '-depsc2', [datasetname 'dataset-img' num2str(firstimageindex) '-img' num2str(secondimageindex) '.eps']);
