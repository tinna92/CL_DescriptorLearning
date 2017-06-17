% get testing data for descriptor performance

% To allow researchers to replicate our learning results (if desired), we have include the match files that we used to generate the results in the paper. 
% These are name "m50_n1_n2.txt" where n1 and n2 are the number of matches and non-matches present in the file. The format of the file is as follows:
% 
%     patchID1   3DpointID1   unused1   patchID2   3DpointID2   unused2
%     ... 
% 
% "matches" have the same 3DpointID, and correspond to interest points that were detected with 5 pixels in position, and agreeing to 0.25 octaves of scale
% and pi/8 radians in angle. "non-matches" have different 3DpointID's, and correspond to interest points lying outside a range of 10 pixels in position, 
% 0.5 octaves of scale and pi/4 radians in angle. 

% More information please visit % http://www.cs.ubc.ca/~mbrown/patchdata/patchdata.html 
% and check the following papers: 
% [1] S. Winder and M. Brown. Learning Local Image Descriptors. To appear International Conference on Computer Vision and Pattern Recognition (CVPR2007) (pdf 300Kb)
% [2] Discriminant Learning of Local Image Descriptors. M. Brown, G. Hua and S. Winder.IEEE Transactions on Pattern Analysis and Machine Intelligence. 2010.

% to test the trained descriptor, please see the following paper:
% [3] Simo-Serra, Edgar, et al. "Discriminative learning of deep convolutional feature point descriptors." Proceedings of the IEEE International Conference on Computer Vision. 2015.
% the basic idea is that by testing on skewed testing data with 1000
% negative and 1 positive pairs, the performance is more like in a real
% image matching problem.
%%
PatchDir = 'E:\software\IPI\Data\notredame\patches';
patchinfoFileName = '/info.txt';
train_patch_info = load([PatchDir patchinfoFileName]);

[Num_Patch,nn] = size(train_patch_info);
Current_PointID=1;
 point_Num =0;
for i=1:Num_Patch
    Point_ID = train_patch_info(i,1)+1;
   
    if(Point_ID~=Current_PointID)
        NN(Current_PointID,1)=i-point_Num;   %the index of the first patch for the nth 3D point
        NN(Current_PointID,2)=point_Num; % record the number of patches
        Current_PointID = Point_ID;        
        point_Num =1;
    else
        point_Num = point_Num + 1;% count the number of patches attached to each 3D point
    end
end
NN(Current_PointID,1)=i+1-point_Num;   %the index of the first patch for the nth 3D point
NN(Current_PointID,2)=point_Num; % record the number of patches

% generate the 1:1000 test dataset.
Num_3Dpint = Current_PointID;
Pos_num = 1000;
Neg_each_pos = 1000;
NN_selected_3DpointID = randperm(Num_3Dpint,Pos_num);



for i=1:Pos_num
    Index = NN_selected_3DpointID(i);
    Randon_neg = randperm(Num_3Dpint,1001);
    if any(Randon_neg==Index)
        [Zero_index]= find(Randon_neg==Index);
        Randon_neg(Zero_index) = [];        
    end
    Negative_Index(i,1:1000) = Randon_neg(1:1000);
end

for i=1:Pos_num
    C_PosIndex = NN_selected_3DpointID(i);
    XX_index = randperm(NN(C_PosIndex,2),2);
    Positive_Patch_Index(i,1)= NN(C_PosIndex,1)+ XX_index(1) -1;
    Positive_Patch_Index(i,2)= NN(C_PosIndex,1)+ XX_index(2) -1;
    for j=1:Neg_each_pos
        C_NNIndex = Negative_Index(i,j) ;
        Negative_Patch_Index(i,j)= NN(C_NNIndex,1)+ randperm(NN(C_NNIndex,2),1) -1;
        Negative_Patch_Index_pos(i,j) = NN(C_PosIndex,1)+ randperm(NN(C_PosIndex,2),1) -1;
    end
end


% load patches and read corresponding patches to form patch data
PatchesPath = [PatchDir '/patches.mat'];
load(PatchesPath);
skewed_patch_pos = cell(Pos_num,2);
skewed_patch_neg = cell(Pos_num*1000,2);
for i=1:Pos_num
    skewed_patch_pos{i,1}=Patches{Positive_Patch_Index(i,1)};
    skewed_patch_pos{i,2}=Patches{Positive_Patch_Index(i,2)};    
end

for i=1:Pos_num
    for j=1:Neg_each_pos
        neg_count = (i-1)*1000+j;
        skewed_patch_neg{neg_count,1}=Patches{int32(Negative_Patch_Index(i,j))};
        skewed_patch_neg{neg_count,2}=Patches{int32(Negative_Patch_Index_pos(i,j))};   
    end
end


for ii=1:Pos_num
    test_x_l(:,:,1,ii) = single(skewed_patch_pos{ii,1});
    test_x_r(:,:,1,ii) = single(skewed_patch_pos{ii,2});
   
end
for ii=1:Pos_num*Neg_each_pos
    test_x_l(:,:,1,ii+Pos_num) = single(skewed_patch_neg{ii,1});
    test_x_r(:,:,1,ii+Pos_num) = single(skewed_patch_neg{ii,2});
end
for i=1:Pos_num*Neg_each_pos+Pos_num
    tmp_xl =  test_x_l(:,:,:,i);
    tmp_xr =  test_x_r(:,:,:,i);
    test_x_l(:,:,:,i) = (test_x_l(:,:,:,i) - mean(mean(mean(test_x_l(:,:,:,i)))))/std(tmp_xl(:));
    test_x_r(:,:,:,i) = (test_x_r(:,:,:,i) - mean(mean(mean(test_x_r(:,:,:,i)))))/std(tmp_xr(:));
end

test_y(1:Pos_num)=1;
test_y(Pos_num+1:Pos_num*Neg_each_pos+Pos_num)=0;
% load('learnedParamaters0319_30_batchsize_1000_noterme_validation.mat');
% load('learnedParamaters1203_30_batchsize_1000_train_om_liberty_Yosimate_validation.mat');
% load('learnedParamaters2403_30_batchsize_1000_train_om_liberty_Yosimate_validation_withoutMining.mat');
% load('learnedParamaters2903_80_batchsize_1000_train_om_liberty_Yosimate_validation_withoutMining.mat');
% load('learnedParamaters3103_30_batchsize_1000_train_om_liberty_Yosimate_validation_withMining.mat');
% load('learnedParamaters2403_30_batchsize_1000_train_om_liberty_Yosimate_validation');
% load('learnedParamaters0104_30_batchsize_1000_train_om_liberty_Yosimate_validation_withMining');
load('learnedParamaters0204_30_batchsize_1000_train_om_liberty_Yosimate_validation_withMining');
% load('learnedParamaters0319_30_batchsize_1000_noterme_validation.mat');
% [test_Eucl_dist]= Chen_DeepDescTest_WithNonlinear_sigmoid(theta,0.00001,test_x_l,test_x_r,test_y,0,10);

step_size = Pos_num*Neg_each_pos/10;
 test_Eucl_dist(1:Pos_num)=Chen_DeepDescTest_WithNonlinear_sigmoid_LRNNormalize(theta,0.00001,test_x_l(:,:,:,1:Pos_num),test_x_r(:,:,:,1:Pos_num),test_y(1:Pos_num),0,10);
% test_Eucl_dist(1:Pos_num)=Chen_DeepDescTest_WithNonlinear_sigmoid(theta,0.00001,test_x_l(:,:,:,1:Pos_num),test_x_r(:,:,:,1:Pos_num),test_y(1:Pos_num),0,10);
for ii=1:10
    start_index = Pos_num+(ii-1)*step_size+1;
    end_index = Pos_num+ii*step_size;
%     test_Eucl_dist(start_index:end_index)=Chen_DeepDescTest_WithNonlinear_sigmoid_LRNNormalize(theta,0.00001,test_x_l(:,:,:,start_index:end_index),...
%         test_x_r(:,:,:,start_index:end_index),test_y(start_index:end_index),0,10);
test_Eucl_dist(start_index:end_index)=Chen_DeepDescTest_WithNonlinear_sigmoid_LRNNormalize(theta,0.00001,test_x_l(:,:,:,start_index:end_index),...
        test_x_r(:,:,:,start_index:end_index),test_y(start_index:end_index),0,10);
    
end

% [test_Eucl_dist]=Chen_DeepDescTest_WithNonlinear_sigmoid_LRNNormalize(theta,0.00001,test_x_l,test_x_r,test_y,0,10);
test_y(1:Pos_num)=1;
test_y(Pos_num+1:Pos_num*Neg_each_pos+Pos_num)=-1;
% when use the vl_pr function, larger value correspond to positive label,
% so need to set negative label as 1 because it corresponds to larger
% distance..
%  vl_roc(test_y(1:200)', test_Eucl_dist(1:200)') ;
% vl_pr(test_y(1:200)', test_Eucl_dist(1:200)') ;
vl_roc(test_y', -test_Eucl_dist') ;
vl_pr(test_y', 0-test_Eucl_dist') ;
[RECALL, PRECISION, INFO] = vl_pr(test_y', -test_Eucl_dist');

[Value,index_TP] = find(test_Eucl_dist(1:1000)<4.5);
[Value,index_FP] = find(test_Eucl_dist(1001:1001000)<4.5);
[Value,index_FN] = find(test_Eucl_dist(1:1000)>4.5);
[Value,index_TN] = find(test_Eucl_dist(1001:1001000)>4.5);

Recall_Current = numel(index_TP)/(numel(index_TP)+numel(index_FN));
Precison_Current= numel(index_TP)/(numel(index_TP)+ numel(index_FP));
[Recall_Current Precison_Current]
