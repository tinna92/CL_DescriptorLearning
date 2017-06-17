Size_test_allSamples = 250000;
Size_testSamples = 50000;
TestSampleIndex = randperm(Size_test_allSamples,Size_testSamples); % generate the random sample index
% TestSampleIndex = TestSampleIndex + Size_trainingSamples;
load('notredame_x_neg.mat');
load('notredame_x_pos.mat');
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
[test_Eucl_dist]= Chen_DeepDescTest_WithNonlinear_sigmoid_LRNNormalize(theta,shrinkRate,test_x_l,test_x_r,test_y,0,10);
test_y(1:Size_testSamples)=-1;
test_y(Size_testSamples+1:2*Size_testSamples)=1;
vl_roc(test_y', test_Eucl_dist') ;
% get the distribution of the two classes
subplot(3,1,2);
[n,x] = hist(test_Eucl_dist(1:Size_testSamples), 200);
plot(x, n/length(test_Eucl_dist(1:Size_testSamples)),'g'); hold on;
[n1,x1] = hist(test_Eucl_dist(Size_testSamples+1:2*Size_testSamples), 200);
plot(x1, n1/length(test_Eucl_dist(Size_testSamples+1:2*Size_testSamples)),'r');
xlabel('patch pairs'' distance');
ylabel('probablity of appearance');



Size_test_allSamples = 250000;
Size_testSamples = 50000;
TestSampleIndex = randperm(Size_test_allSamples,Size_testSamples); % generate the random sample index
% TestSampleIndex = TestSampleIndex + Size_trainingSamples;
% load('yosemite_x_neg.mat');
% load('yosemite_x_pos.mat');
x_neg_test =yosemite_x_neg;
x_pos_test = yosemite_x_pos;
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
[test_Eucl_dist]= Chen_DeepDescTest_WithNonlinear_sigmoid_LRNNormalize(theta,shrinkRate,test_x_l,test_x_r,test_y,0,10);
test_y(1:Size_testSamples)=-1;
test_y(Size_testSamples+1:2*Size_testSamples)=1;
vl_roc(test_y', test_Eucl_dist') ;
% get the distribution of the two classes
subplot(3,1,2);
[n,x] = hist(test_Eucl_dist(1:Size_testSamples), 200);
plot(x, n/length(test_Eucl_dist(1:Size_testSamples)),'g'); hold on;
[n1,x1] = hist(test_Eucl_dist(Size_testSamples+1:2*Size_testSamples), 200);
plot(x1, n1/length(test_Eucl_dist(Size_testSamples+1:2*Size_testSamples)),'r');
xlabel('patch pairs'' distance');
ylabel('probablity of appearance');
