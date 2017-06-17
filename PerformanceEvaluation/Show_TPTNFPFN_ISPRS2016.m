% load('learnedParamaters1612_30_batchsize_1000_train_om_liberty_Yosimate_validation.mat');
load('learnedParamaters2612_30_batchsize_1000_liberty_validation.mat');
Size_test_allSamples = 250000;
Size_testSamples = 50000;
TestSampleIndex = randperm(Size_test_allSamples,Size_testSamples); % generate the random sample index
% TestSampleIndex = TestSampleIndex + Size_trainingSamples;
% load('notredame_x_neg.mat');
% load('notredame_x_pos.mat');

x_neg_test = notredame_x_neg;
x_pos_test = notredame_x_pos;
for ii=1:Size_testSamples
    test_x_l(:,:,1,ii) = single(x_pos_test{TestSampleIndex(ii),1});
    test_x_r(:,:,1,ii) = single(x_pos_test{TestSampleIndex(ii),2});
    test_x_l(:,:,1,ii+Size_testSamples) = single(x_neg_test{TestSampleIndex(ii),1});
    test_x_r(:,:,1,ii+Size_testSamples) = single(x_neg_test{TestSampleIndex(ii),2});
end

for i=1:Size_testSamples*2
    tmp_xl =  test_x_l(:,:,:,i);
    tmp_xr =  test_x_r(:,:,:,i);
    test_x_l(:,:,:,i) = (test_x_l(:,:,:,i) - mean(mean(mean(test_x_l(:,:,:,i)))))/std(tmp_xl(:));
    test_x_r(:,:,:,i) = (test_x_r(:,:,:,i) - mean(mean(mean(test_x_r(:,:,:,i)))))/std(tmp_xr(:));
end

test_y(1:Size_testSamples)=1;
test_y(Size_testSamples+1:2*Size_testSamples)=0;
[test_Eucl_dist]= Chen_DeepDescTest_WithNonlinear_sigmoid(theta,0.00001,test_x_l,test_x_r,test_y,0,10);

test_y(1:Size_testSamples)=-1;
test_y(Size_testSamples+1:2*Size_testSamples)=1;
vl_roc(test_y', test_Eucl_dist') ;
vl_pr(test_y', test_Eucl_dist') ;

% randomly find 5 True Postive, False Positive, True Negative and False
% Negative.

mean(test_Eucl_dist(1:50000));
max(test_Eucl_dist(1:50000));
min(test_Eucl_dist(50001:100000));

% set the threshold as 5, then we could see some true positive,TN FP and FN
[Value,index_TP] = find(test_Eucl_dist(1:50000)<4.5);
[Value,index_FP] = find(test_Eucl_dist(50001:100000)<4.5);
[Value,index_FN] = find(test_Eucl_dist(1:50000)>4.5);
[Value,index_TN] = find(test_Eucl_dist(50001:100000)>4.5);
% index_FP = index_FP+50000;
% index_TN = index_TN+50000;

Pick_Num = 5;
TP_randomChoosed_id = randperm(numel(index_TP),Pick_Num);
FP_randomChoosed_id = randperm(numel(index_FP),Pick_Num);
FN_randomChoosed_id = randperm(numel(index_FN),Pick_Num);
TN_randomChoosed_id = randperm(numel(index_TN),Pick_Num);

for i=1:Pick_Num
    idx_dataset_tp = TestSampleIndex(TP_randomChoosed_id(i));
    TP_image(1:32,i*34-33:i*34-2)=x_pos_test{idx_dataset_tp,1};
    TP_image(35:66,i*34-33:i*34-2)=x_pos_test{idx_dataset_tp,2};
    
    idx_dataset_fp = TestSampleIndex(FP_randomChoosed_id(i));
    FP_image(1:32,i*34-33:i*34-2)=x_neg_test{idx_dataset_fp,1};
    FP_image(35:66,i*34-33:i*34-2)=x_neg_test{idx_dataset_fp,2};
    
    idx_dataset_fn = TestSampleIndex(FN_randomChoosed_id(i));
    FN_image(1:32,i*34-33:i*34-2)=x_pos_test{idx_dataset_fn,1};
    FN_image(35:66,i*34-33:i*34-2)=x_pos_test{idx_dataset_fn,2};
    
    idx_dataset_tn = TestSampleIndex(TN_randomChoosed_id(i));
    TN_image(1:32,i*34-33:i*34-2)=x_neg_test{idx_dataset_tn,1};
    TN_image(35:66,i*34-33:i*34-2)=x_neg_test{idx_dataset_tn,2};
end
subplot(2,2,1);imshow(TP_image);title('TP');
subplot(2,2,2);imshow(FP_image);title('FP');
subplot(2,2,3);imshow(FN_image);title('FN');
subplot(2,2,4);imshow(TN_image);title('TN');
imwrite(TP_image,'TP.jpg');
imwrite(FP_image,'FP.jpg');
imwrite(TN_image,'TN.jpg');
imwrite(FN_image,'FN.jpg');