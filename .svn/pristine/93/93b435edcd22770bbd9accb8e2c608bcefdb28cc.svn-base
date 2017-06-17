% -------------------------------------------------------------------------
% Part 3: Learning a simple CNN
% -------------------------------------------------------------------------

% first set the required document directories
setup ;

% -------------------------------------------------------------------------
% then load data and set paremeters for learning
% -------------------------------------------------------------------------
% load('notryose_pos.mat');
% load('notryose_neg.mat');
Num_Pos_valid_set = 100;% number of positive or negative samples in validation sets
Num_pos = 5000;% number of postive(negative) examples for tarining datasets 
Start_pos = 0; % start position for validation set extraction begin point in x_pos and x_neg
Num_valid_set = Num_Pos_valid_set*2;% the real number of samples in validation sets

% -------------------------------------------------------------------------
% Set parameters for training, including the batch size and epoches
% -------------------------------------------------------------------------
Size_batches = 1280; % size of the batch
Num_batches = 1; % how many batches are used for training
BatchSample_status = 1; %set the default status as positive pairs
Size_trainingSamples = Size_batches*Num_batches;
Num_wholesamples = size(x_pos,1); % number of the training samples in the training dataset 
SampleIndex = randperm(Num_wholesamples,Size_trainingSamples); % used to generate the sample indexes

% -------------------------------------------------------------------------
% Initialize the training parameters
% -------------------------------------------------------------------------
% w1 = 0.05*randn(5, 5, 1,5) ;
% w2 = 0.05*randn(5, 5, 5,25) ;
% w3 = 0.05*randn(5, 5, 25,125) ;
w1 = 0.05*randn(5, 5, 1,5) ;
w2 = 0.05*randn(5, 5, 5,25) ;
w3 = 0.05*randn(5, 5, 25,125) ;
for t=1:5
    w1(:,:,1,t) = single(w1(:,:,1,t) - mean(mean(mean(w1(:,:,1,t))))) ;
end
for t=1:25
    for tt = 1:5
        w2(:,:,tt,t) = single(w2(:,:,tt,t) - mean(mean(mean(w2(:,:,tt,t))))) ;
    end
end
for t=1:125
    for tt = 1:25
        w3(:,:,tt,t) = single(w3(:,:,tt,t) - mean(mean(mean(w3(:,:,tt,t))))) ;
    end
end
w1 = single(w1);
w2 = single(w2);
w3 = single(w3);
b1 = single(zeros(1,5));
b2 = single(zeros(1,25));
b3 = single(zeros(1,125));

numIterations = 30 ;
% rate = 5 ;
rate = 0.05;
momentum = 0.9 ;
% shrinkRate = 0.0001 ;
 shrinkRate = 0.00001 ;
plotPeriod = 10 ;

batch_ground = 1;
for ii=1:Size_batches
    x_l(:,:,1,ii) = single(x_pos{SampleIndex((batch_ground-1)*Size_batches+ii),1});
    x_r(:,:,1,ii) = single(x_pos{SampleIndex((batch_ground-1)*Size_batches+ii),2});
    x_l(:,:,1,ii+Size_batches) = single(x_neg{SampleIndex((batch_ground-1)*Size_batches+ii),1});
    x_r(:,:,1,ii+Size_batches) = single(x_neg{SampleIndex((batch_ground-1)*Size_batches+ii),2});
end
y(1:Size_batches)=1;
y(Size_batches+1:2*Size_batches)=0;

for i=1:Size_batches*2
    tmp_xl =  x_l(:,:,:,i);
    tmp_xr =  x_r(:,:,:,i);
    x_l(:,:,:,i) = (x_l(:,:,:,i) - mean(mean(mean(x_l(:,:,:,i)))))/std(tmp_xl(:));
    x_r(:,:,:,i) = (x_r(:,:,:,i) - mean(mean(mean(x_r(:,:,:,i)))))/std(tmp_xr(:));
end

w1 = 0.05*randn(5, 5, 1,5) ;
w2 = 0.05*randn(5, 5, 5,25) ;
w3 = 0.05*randn(5, 5, 25,125) ;
for t=1:5
    w1(:,:,1,t) = single(w1(:,:,1,t) - mean(mean(mean(w1(:,:,1,t))))) ;
end
for t=1:25
    for tt = 1:5
        w2(:,:,tt,t) = single(w2(:,:,tt,t) - mean(mean(mean(w2(:,:,tt,t))))) ;
    end
end
for t=1:125
    for tt = 1:25
        w3(:,:,tt,t) = single(w3(:,:,tt,t) - mean(mean(mean(w3(:,:,tt,t))))) ;
    end
end

w1 = single(w1);
w2 = single(w2);
w3 = single(w3);
b1 = single(zeros(1,5));
b2 = single(zeros(1,25));
b3 = single(zeros(1,125));

addpath minFunc/
options.Method = 'qnewton'; % Here, we use L-BFGS to optimize our cost
                          % function. Generally, for minFunc to work, you
                          % need a function pointer with two outputs: the
                          % function value and the gradient. In our problem,
                          % sparseAutoencoderCost.m satisfies this.
options.maxIter = 100;	  % Maximum number of iterations of L-BFGS to run 
options.display = 'on';
options.DerivativeCheck = 'on';

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

[opttheta, cost] = minFunc( @(p) Chen_DeepDescTrainingCost(p, ...
                                   shrinkRate,...
                                   x_l,x_r,y), ...
                              theta, options);
opttheta = opttheta';
%%======================================================================
%% STEP 5: Visualization 

w1 = reshape(opttheta(1:totalsizew1(4)),sizew1(1),sizew1(2),sizew1(3),sizew1(4));
b1 = reshape(opttheta(totalsizew1(4)+1:totalsizeb1(2)+totalsizew1(4)),sizeb1(1),sizeb1(2));
mark1 = totalsizeb1(2)+totalsizew1(4);
w2 = reshape(opttheta(mark1+1:mark1+totalsizew2(4)),sizew2(1),sizew2(2),sizew2(3),sizew2(4));
b2 = reshape(opttheta(mark1+totalsizew2(4)+1:mark1+totalsizew2(4)+totalsizeb2(2)),sizeb2(1),sizeb2(2));
mark2 = mark1+totalsizew2(4)+totalsizeb2(2);
w3 = reshape(opttheta(mark2+1:mark2+totalsizew3(4)),sizew3(1),sizew3(2),sizew3(3),sizew3(4));
b3 = reshape(opttheta(mark2+totalsizew3(4)+1:mark2+totalsizew3(4)+totalsizeb3(2)),sizeb3(1),sizeb3(2));

save('opttheta_DeepCNNpatchDesc_32_32_125_0511_2015.mat','opttheta');