% training from an trained parameters,
previous_epoch = 40;

shrinkRate = 0.001 ;
% gama = 0.9;
gama = 0.2;
% alpha =  0.00003;
alpha =  0.003;
% alpha =  100*alpha; % test what will happen
alpha_decreaserate_eachEpoch = 0.9;% how learning rate changes in every epoch
beta_momentum = 0.90;
theta = theta;
alpha =  alpha*(alpha_decreaserate_eachEpoch.^previous_epoch);
% x_pos = yosemite_x_pos;
% x_neg = yosemite_x_neg;


Num_Epoches  = 10; % num of iterations( for each training sample)
Num_train_batches = 450;
Num_validation_batches = 50;
BatchSample_status = 1; %set the default status as positive pairs
Size_batches = 500;
Size_trainingSamples = Size_batches*Num_train_batches;
Size_validationSamples = Size_batches*Num_validation_batches;
Size_allSamples = Size_trainingSamples+Size_validationSamples;
% Num_wholesamples = size(x_pos,1); % number of the training samples in the training dataset 
% Num_wholesamples = numel(x_pos)/2; 
r_t = r_t;
v_t =v_t;


% first get the training set
x_pos = cell(Size_trainingSamples,2);
x_neg = cell(Size_trainingSamples,2);
for ii=1:Size_trainingSamples
    x_pos{ii,1} = liberty_x_pos{Training_sampleIndex_pos(ii),1};
    x_pos{ii,2} = liberty_x_pos{Training_sampleIndex_pos(ii),2};
    x_neg{ii,1} = liberty_x_neg{Training_sampleIndex_neg(ii),1};
    x_neg{ii,2} = liberty_x_neg{Training_sampleIndex_neg(ii),2};
end

% calculate the input for validation set
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
% 
valid_y(1:Size_validationSamples)=-1;
valid_y(Size_validationSamples+1:2*Size_validationSamples)=1;
valid_test_y(1:Size_validationSamples)=1;
valid_test_y(Size_validationSamples+1:2*Size_validationSamples)=1;


for iii=previous_epoch+1:previous_epoch+Num_Epoches
    
    SampleIndex_pos = randperm(Size_trainingSamples,Size_trainingSamples); % used to generate the sample indexes
    SampleIndex_neg = randperm(Size_trainingSamples,Size_trainingSamples); % used to generate the sample indexes   
    % SampleIndex = randperm(Num_wholesamples,Size_trainingSamples); % used to generate the sample indexes, change the sample size every time
%     Num_train_batches = floor(Num_train_batches/2);
%     Size_batches = floor(Size_trainingSamples/Num_train_batches);
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
            r_t(idx) = r_replace;
        end
        
        
        v_tplus1 = beta_momentum.*v_t + (alpha./sqrt(r_t)).*grad_theta_tplushalf;
        theta = theta - v_tplus1;
        v_t = v_tplus1;
        
       
    end
    fprintf('Epoch :%d current loss: %f\n',iii,mean(Loss_Rec_batch));
    Loss_Rec(iii) = mean(Loss_Rec_batch);% get the average Loss in the current epoch
    alpha = alpha_decreaserate_eachEpoch*alpha; % update the alpha(it goes smaller when cost goes down)
    hold on
    
    
      % evaluate in the current epoch the validation result
    [valid_Eucl_dist]= Chen_DeepDescTest_WithNonlinear_sigmoid(theta,shrinkRate,test_x_l,test_x_r,valid_test_y,1,10);
    [tpr, tnr, info] = vl_roc(valid_y, valid_Eucl_dist) ;
    Validation_AUC(iii) = info.auc;
    Validation_EER(iii) = info.eer;
    record_theta{iii} = theta;
%     iii;
end
