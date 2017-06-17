% -------------------------------------------------------------------------
% training the descriptor with a siamese architecture using rmsprop with
% momentum, but using different learning rate in different layer.
% -------------------------------------------------------------------------

% first set the required document directories
setup ;

% -------------------------------------------------------------------------
% then load data and set paremeters for learning
% -------------------------------------------------------------------------
% load('liberty_x_neg.mat');
% load('liberty_x_pos.mat');
% load('yosemite_x_neg.mat');
% load('yosemite_x_pos.mat');
% load('notredame_x_pos.mat');
% load('notredame_x_neg.mat');
% load('aff_neg.mat');
% load('aff_pos.mat');
% load('aff_pos_evauation_1026.mat');
% load('aff_neg_evauation_1026.mat');
% x_pos = yosemite_x_pos;
% x_neg = yosemite_x_neg;
Num_Pos_valid_set = 100000;% number of positive or negative samples in validation sets
Num_pos = 5000;% number of postive(negative) examples for tarining datasets 
Start_pos = 0; % start position for validation set extraction begin point in x_pos and x_neg
Num_valid_set = Num_Pos_valid_set*2;% the real number of samples in validation sets

% -------------------------------------------------------------------------
% Set parameters for training, including the batch size and epoches
% -------------------------------------------------------------------------
Num_Epoches  = 1; % num of iterations( for each training sample)
Size_batches = 500; % size of the batch
% Num_batches = 500; % how many batches are used for training
Num_train_batches = 10;
Num_validation_batches = 2;
BatchSample_status = 1; %set the default status as positive pairs
Size_trainingSamples = Size_batches*Num_train_batches;
Size_validationSamples = Size_batches*Num_validation_batches;
Size_allSamples = Size_trainingSamples+Size_validationSamples;
% Num_wholesamples = size(x_pos,1); % number of the training samples in the training dataset 
% Num_wholesamples = numel(x_pos)/2; 
% SampleIndex = randperm(Num_wholesamples,Size_trainingSamples); % used to generate the sample indexes

% -------------------------------------------------------------------------
% Initialize the training parameters with uniform distribution
% -------------------------------------------------------------------------
a = sqrt(6/1024);
w1 = -a +2*a*(rand(5, 5, 1,5));
a = sqrt(6/196);
w2 = -a +2*a*(rand(5, 5, 5,25));
a = sqrt(6/25);
w3 = -a +2*a*(rand(5, 5, 25,125));

w1 = single(w1);
w2 = single(w2);
w3 = single(w3);
b1 = single(zeros(1,5));
b2 = single(zeros(1,25));
b3 = single(zeros(1,125));

% rate = 5 ;
rate = 0.05;
momentum = 0.95 ;
shrinkRate = 0.001 ;
%  shrinkRate = 0.001 ;
plotPeriod = 10 ;

% Initial momentum
w_momentum1 = zeros('like', w1) ;
b_momentum1 = zeros('like', b1) ;
w_momentum2 = zeros('like', w2) ;
b_momentum2 = zeros('like', b2) ;
w_momentum3 = zeros('like', w3) ;
b_momentum3 = zeros('like', b3) ;

% -------------------------------------------------------------------------
% now begin to do the real job in every epoch
% -------------------------------------------------------------------------
% gama = 0.9;
% alpha =  0.00003;
% alpha =  0.00003;
gama = 0.9;
alpha =  0.003;
alpha_decreaserate_eachEpoch = 0.9;
% alpha_decreaserate_eachEpoch = 0.99;
beta_momentum = 0.90;
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
theta = [reshape(w1,1,totalsizew1(4)) reshape(b1,1,totalsizeb1(2)) reshape(w2,1,totalsizew2(4))...
    reshape(b2,1,totalsizeb2(2)) reshape(w3,1,totalsizew3(4)) reshape(b3,1,totalsizeb3(2))];
theta = theta'; % must be column vector


% load and split the set into training and validation set, which are two separate sets.
% get the validation set and they will not be used in training
% anymore

SampleIndex_pos = randperm(Size_allSamples,Size_allSamples);
SampleIndex_neg = randperm(Size_allSamples,Size_allSamples);
% TestSampleIndex = randperm(Size_test_allSamples,Size_testSamples); % generate the random sample index
% set the first Size_validationSamples samples as validation set
Validation_SampleIndex_pos = SampleIndex_pos(1:Size_validationSamples);
Validation_SampleIndex_neg = SampleIndex_neg(1:Size_validationSamples);
Training_sampleIndex_pos = SampleIndex_pos(Size_validationSamples+1:Size_allSamples);
Training_sampleIndex_neg = SampleIndex_neg(Size_validationSamples+1:Size_allSamples);

% first get the training set
x_pos = cell(Size_trainingSamples,2);
x_neg = cell(Size_trainingSamples,2);
for ii=1:Size_trainingSamples
    x_pos{ii,1} = liberty_x_pos{Training_sampleIndex_pos(ii),1};
    x_pos{ii,2} = liberty_x_pos{Training_sampleIndex_pos(ii),2};
    x_neg{ii,1} = liberty_x_neg{Training_sampleIndex_neg(ii),1};
    x_neg{ii,2} = liberty_x_neg{Training_sampleIndex_neg(ii),2};
end

% % calculate the input for validation set
for ii=1:Size_validationSamples
    test_x_l(:,:,1,ii) = single(liberty_x_pos{Validation_SampleIndex_pos(ii),1});
    test_x_r(:,:,1,ii) = single(liberty_x_pos{Validation_SampleIndex_pos(ii),2});
    test_x_l(:,:,1,ii+Size_validationSamples) = single(liberty_x_neg{Validation_SampleIndex_neg(ii),1});
    test_x_r(:,:,1,ii+Size_validationSamples) = single(liberty_x_neg{Validation_SampleIndex_neg(ii),2});
end

for i=1:Size_validationSamples*2
    tmp_xl =  test_x_l(:,:,:,i);
    tmp_xr =  test_x_r(:,:,:,i);
    test_x_l(:,:,:,i) = (test_x_l(:,:,:,i) - mean(mean(mean(test_x_l(:,:,:,i)))))/std(tmp_xl(:));
    test_x_r(:,:,:,i) = (test_x_r(:,:,:,i) - mean(mean(mean(test_x_r(:,:,:,i)))))/std(tmp_xr(:));
end

valid_y(1:Size_validationSamples)=-1;
valid_y(Size_validationSamples+1:2*Size_validationSamples)=1;
valid_test_y(1:Size_validationSamples)=1;
valid_test_y(Size_validationSamples+1:2*Size_validationSamples)=1;

for iii=1:Num_Epoches
    
    SampleIndex_pos = randperm(Size_trainingSamples,Size_trainingSamples); % used to generate the sample indexes
    SampleIndex_neg = randperm(Size_trainingSamples,Size_trainingSamples); % used to generate the sample indexes   
    % SampleIndex = randperm(Num_wholesamples,Size_trainingSamples); % used to generate the sample indexes, change the sample size every time
    
    % first try to train in every mini-batch
    for batch_ground =1:Num_train_batches 
        if mod(batch_ground,2)==1
            BatchSample_status = 1 ;
        else
            BatchSample_status = 0 ;
        end
        
        % read the data
        for ii=1:Size_batches
            x_l(:,:,1,ii) = single(x_pos{SampleIndex_pos((batch_ground-1)*Size_batches+ii),1});
            x_r(:,:,1,ii) = single(x_pos{SampleIndex_pos((batch_ground-1)*Size_batches+ii),2});
            x_l(:,:,1,ii+Size_batches) = single(x_neg{SampleIndex_neg((batch_ground-1)*Size_batches+ii),1});
            x_r(:,:,1,ii+Size_batches) = single(x_neg{SampleIndex_neg((batch_ground-1)*Size_batches+ii),2});
        end
        y(1:Size_batches)=1;
        y(Size_batches+1:2*Size_batches)=0;
        
        % central normalize the training data 
        for i=1:Size_batches*2
            tmp_xl =  x_l(:,:,:,i);
            tmp_xr =  x_r(:,:,:,i);
            x_l(:,:,:,i) = (x_l(:,:,:,i) - mean(mean(mean(x_l(:,:,:,i)))))/std(tmp_xl(:));
            x_r(:,:,:,i) = (x_r(:,:,:,i) - mean(mean(mean(x_r(:,:,:,i)))))/std(tmp_xr(:));
        end
               
        if iii==1 && batch_ground ==1
            r_t = zeros('like', theta) ;% initialize r_t
            v_t = zeros('like', theta) ;% initialize v_t
        end
        
        [cost,grad]= Chen_DeepDescTrainingCost_WithNonlinear_sigmoid(theta,shrinkRate,x_l,x_r,y,1,10); % test with nonlinear here
        Loss_Rec_batch(batch_ground) = mean(cost);
        fprintf('%d - %f  ',batch_ground,Loss_Rec_batch(batch_ground));
%         r_tminus1 = r_t; % r_tminus1 equals to the r calculated in the last time 
%         r_t = (1-gama)*(grad.^2)+gama*r_tminus1;
%         % this setup is important for avoiding being divided by 0
%         idx = find(r_t == 0);
%         r_t(idx) = 1;
%         v_tplus1 = (alpha./sqrt(r_t)).*grad;
%         theta = theta - v_tplus1;  
        r_tminus1 = r_t; % r(t-1) = last r(t)
        theta_tplusahalf = theta - beta_momentum.*v_t;
        [cost,grad_theta_tplushalf]= Chen_DeepDescTrainingCost_WithNonlinear_sigmoid(theta_tplusahalf,shrinkRate,x_l,x_r,y,1,10);
        r_t = (1-gama)*(grad_theta_tplushalf.^2)+gama*r_tminus1;   
        idx = find(r_t == 0);
        
        % if there is any one element in r_t is equal to 0, then replace it
        % with mean value of r_t
        if sum(idx(:))>0
            r_replace = mean(abs(r_t(:))) + 0.000000000000000000001;
        end
        r_t(idx) = r_replace;
        
        v_tplus1 = beta_momentum.*v_t + (alpha./sqrt(r_t)).*grad_theta_tplushalf;
        theta = theta - v_tplus1;
        v_t = v_tplus1;
        
       
    end
    fprintf('Epoch :%d current loss: %f\n',iii,mean(Loss_Rec_batch));
    Loss_Rec(iii) = mean(Loss_Rec_batch);% get the average Loss in the current epoch
    alpha = alpha_decreaserate_eachEpoch*alpha; % update the alpha(it goes smaller when cost goes down)
    
%     hold on;
    
    % evaluate in the current epoch the validation result
    [valid_Eucl_dist]= Chen_DeepDescTrainingCost_WithNonlinear_sigmoid(theta,shrinkRate,test_x_l,test_x_r,valid_test_y,1,10);
    [tpr, tnr, info] = vl_roc(valid_y, valid_Eucl_dist) ;
    Validation_AUC(iii) = info.auc;
    Validation_EER(iii) = info.eer;
    record_theta{iii} = theta;
%     if(iii>5)
%         if(Validation_AUC(iii)<Validation_AUC(iii-1)&Validation_AUC(iii)<Validation_AUC(iii-2))
%             fprintf('\n performance on validation set drops for 2 epoches\n');
%             break;
%         end
%     end
%     iii;
end


% draw the downwards of cost
subplot(3,1,1);
% Loss_Rec_RMSPROP = [7.94 5.81 5.21 4.92 4.73];

% load('Loss_standardgradient_momentum_isprs.mat');Loss_stdGra_mom=Loss_Rec;
% load('Loss_standardgradient_isprs.mat');Loss_stdGra=Loss_Rec;
% load('Loss_rmsprop_isprs.mat');Loss_rmsprop=Loss_Rec;

% plot(Loss_stdGra,'-dr');hold on;
% plot(Loss_stdGra_mom,'-ob');hold on;
% plot(Loss_rmsprop,'-sg');
% xlabel('Epoch Number');
% ylabel('Average Loss');
% axis([1, 10, 3, 9]);
% set(gca,'xtick', 1:1:10);
% legend(...
%     'Standard Gradient Descent ','Standard Gradient Descent with Momentum','Method in Our Paper');
% hold on

% test the performance of the current learned parameters using another
% dataset

Size_test_allSamples = 250000;
Size_testSamples = 50000;
TestSampleIndex = randperm(Size_test_allSamples,Size_testSamples); % generate the random sample index
% TestSampleIndex = TestSampleIndex + Size_trainingSamples;
% load('notredame_x_neg.mat');
% load('notredame_x_pos.mat');
% 
% x_neg_test = notredame_x_neg;
% x_pos_test = notredame_x_pos;
% for ii=1:Size_testSamples
%     test_x_l(:,:,1,ii) = single(x_pos_test{TestSampleIndex(ii),1});
%     test_x_r(:,:,1,ii) = single(x_pos_test{TestSampleIndex(ii),2});
%     test_x_l(:,:,1,ii+Size_testSamples) = single(x_neg_test{TestSampleIndex(ii),1});
%     test_x_r(:,:,1,ii+Size_testSamples) = single(x_neg_test{TestSampleIndex(ii),2});
% end
% 
% for i=1:Size_testSamples*2
%     tmp_xl =  test_x_l(:,:,:,i);
%     tmp_xr =  test_x_r(:,:,:,i);
%     test_x_l(:,:,:,i) = (test_x_l(:,:,:,i) - mean(mean(mean(test_x_l(:,:,:,i)))))/std(tmp_xl(:));
%     test_x_r(:,:,:,i) = (test_x_r(:,:,:,i) - mean(mean(mean(test_x_r(:,:,:,i)))))/std(tmp_xr(:));
% end
% 
% test_y(1:Size_testSamples)=1;
% test_y(Size_testSamples+1:2*Size_testSamples)=0;
% [test_Eucl_dist]= Chen_DeepDescTest_WithNonlinear_sigmoid(theta,shrinkRate,test_x_l,test_x_r,test_y,0,10);
% 
% % TestSampleIndex = randperm(Size_test_allSamples,Size_testSamples);
% % x_neg_test = yosemite_x_neg;
% % x_pos_test = yosemite_x_pos;
% % for ii=1:Size_testSamples
% %     test_x_l(:,:,1,ii) = single(x_pos_test{TestSampleIndex(ii),1});
% %     test_x_r(:,:,1,ii) = single(x_pos_test{TestSampleIndex(ii),2});
% %     test_x_l(:,:,1,ii+Size_testSamples) = single(x_neg_test{TestSampleIndex(ii),1});
% %     test_x_r(:,:,1,ii+Size_testSamples) = single(x_neg_test{TestSampleIndex(ii),2});
% % end
% % 
% % for i=1:Size_testSamples*2
% %     tmp_xl =  test_x_l(:,:,:,i);
% %     tmp_xr =  test_x_r(:,:,:,i);
% %     test_x_l(:,:,:,i) = (test_x_l(:,:,:,i) - mean(mean(mean(test_x_l(:,:,:,i)))))/std(tmp_xl(:));
% %     test_x_r(:,:,:,i) = (test_x_r(:,:,:,i) - mean(mean(mean(test_x_r(:,:,:,i)))))/std(tmp_xr(:));
% % end
% 
% test_y(1:Size_testSamples)=1;
% test_y(Size_testSamples+1:2*Size_testSamples)=0;
% [test_Eucl_dist]= Chen_DeepDescTest_WithNonlinear_sigmoid(theta,shrinkRate,test_x_l,test_x_r,test_y,0,10);
% 
% test_y(1:Size_testSamples)=-1;
% test_y(Size_testSamples+1:2*Size_testSamples)=1;
% vl_roc(test_y', test_Eucl_dist') ;
% 
% % get the distribution of the two classes
% subplot(3,1,2);
% [n,x] = hist(test_Eucl_dist(1:Size_testSamples), 200);
% plot(x, n/length(test_Eucl_dist(1:Size_testSamples)),'g'); hold on;
% [n1,x1] = hist(test_Eucl_dist(Size_testSamples+1:2*Size_testSamples), 200);
% plot(x1, n1/length(test_Eucl_dist(Size_testSamples+1:2*Size_testSamples)),'r');
% xlabel('patch pairs'' distance');
% ylabel('probablity of appearance');
% 
% % get the ROC curve of descriptors
% subplot(3,1,3);
% Pos_num = 50000;
% Neg_num = 50000;
% xxx = [x x1];
% size = numel(xxx);
% min_x1 = min(x1);
% max_x  = max(x);
% ROC_points = 100;
% range = max_x - min_x1;
% iteration_step = range/ROC_points;
% for i=1:ROC_points
%     thershold = min_x1 + iteration_step*i;
%     index_x = x<thershold;
%     TP_N = sum(n(index_x));
%     FN_N = sum(n(~index_x));
%     index_x1 = x1<thershold;
%     FP_N = sum(n1(index_x1));
%     TN_N = sum(n1(~index_x1));
%     TPR(i) = TP_N/(TP_N + FN_N);
%     FPR(i) = FP_N/(FP_N + TN_N);
% end
% plot (FPR,TPR);grid on;
% xlabel('false positive rate');
% ylabel('true positive rate');
% title('ROC curve of descriptor');
% clear TPR FPR
% save('learnedParamaters0112_30_batchsize_1000_liberty_validation.mat','theta');
% save('Save_v_t_r_t_Loss_alpha_0112_30_batchsize_1000__liberty.mat','r_t','v_t','Loss_Rec','alpha');
