
% draw the downwards of cost
load('learnedParamaters2506_50_libertytrain500000.mat');
subplot(3,1,1);
plot(Loss_Rec);
xlabel('epoch number');
ylabel('average loss for training samples');
% hold on
% test the performance of the current learned parameters using another
% dataset
Size_test_allSamples = 250000;
Size_testSamples = 50000;
TestSampleIndex = randperm(Size_test_allSamples,Size_testSamples); % generate the random sample index
% TestSampleIndex = TestSampleIndex + Size_trainingSamples;
load('notredame_x_pos.mat');
load('notredame_x_neg.mat');
x_neg = notredame_x_neg;
x_pos = notredame_x_pos;
for ii=1:Size_testSamples
    test_x_l(:,:,1,ii) = single(x_pos{TestSampleIndex(ii),1});
    test_x_r(:,:,1,ii) = single(x_pos{TestSampleIndex(ii),2});
    test_x_l(:,:,1,ii+Size_testSamples) = single(x_neg{TestSampleIndex(ii),1});
    test_x_r(:,:,1,ii+Size_testSamples) = single(x_neg{TestSampleIndex(ii),2});
end

for i=1:Size_testSamples*2
    tmp_xl =  test_x_l(:,:,:,i);
    tmp_xr =  test_x_r(:,:,:,i);
    test_x_l(:,:,:,i) = (test_x_l(:,:,:,i) - mean(mean(mean(test_x_l(:,:,:,i)))))/std(tmp_xl(:));
    test_x_r(:,:,:,i) = (test_x_r(:,:,:,i) - mean(mean(mean(test_x_r(:,:,:,i)))))/std(tmp_xr(:));
end

test_y(1:Size_testSamples)=1;
test_y(Size_testSamples+1:2*Size_testSamples)=0;
[test_Eucl_dist]= Chen_DeepDescTest_WithNonlinear_sigmoid(theta,shrinkRate,test_x_l,test_x_r,test_y,3,15);

% get the distribution of the two classes
subplot(3,1,2);
[n,x] = hist(test_Eucl_dist(1:Size_testSamples), 200);
plot(x, n/length(test_Eucl_dist(1:Size_testSamples)),'g'); hold on;
[n1,x1] = hist(test_Eucl_dist(Size_testSamples+1:2*Size_testSamples), 200);
plot(x1, n1/length(test_Eucl_dist(Size_testSamples+1:2*Size_testSamples)),'r');
xlabel('patch pairs'' distance');
ylabel('probablity of appearance');

% get the ROC curve of descriptors
subplot(3,1,3);
Pos_num = 50000;
Neg_num = 50000;
xxx = [x x1];
size = numel(xxx);
min_x1 = min(x1);
max_x  = max(x);
ROC_points = 100;
range = max_x - min_x1;
iteration_step = range/ROC_points;
for i=1:ROC_points
    thershold = min_x1 + iteration_step*i;
    index_x = x<thershold;
    TP_N = sum(n(index_x));
    FN_N = sum(n(~index_x));
    index_x1 = x1<thershold;
    FP_N = sum(n1(index_x1));
    TN_N = sum(n1(~index_x1));
    TPR(i) = TP_N/(TP_N + FN_N);
    FPR(i) = FP_N/(FP_N + TN_N);
end
plot (FPR,TPR);grid on;
xlabel('false positive rate');
ylabel('true positive rate');
title('ROC curve of descriptor');
