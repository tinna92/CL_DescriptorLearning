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
Num_Epoches  = 30;
Size_batches = 100;
Num_batches = 1000;


% generate training data randomly 
% Num_Pos_valid_set = 1000;
for ii=1:Num_Pos_valid_set
    x_l(:,:,1,ii) = single(x_pos{ii+Start_pos,1});
    x_r(:,:,1,ii) = single(x_pos{ii+Start_pos,2});
end

% for ii=1:Num_Pos_valid_set
%     x_l(:,:,1,ii+Num_Pos_valid_set) = single(x_pos{ii+Num_Pos_valid_set+Start_pos,1});
%     x_r(:,:,1,ii+Num_Pos_valid_set) = single(x_pos{ii+Num_Pos_valid_set+Start_pos,2});
% end



% get negetive samples
for ii=1:Num_Pos_valid_set
    x_l(:,:,1,ii+Num_Pos_valid_set) = single(x_neg{ii+Start_pos,1});
    x_r(:,:,1,ii+Num_Pos_valid_set) = single(x_neg{ii+Start_pos,2});
end

% generate the correct label that indicates matching or nonmatching for
% each image pair
y(1:Num_Pos_valid_set)=1;
y(Num_Pos_valid_set+1:2*Num_Pos_valid_set)=0;

% x_l = single(abs(randn(16,16,1,1000)));
% x_r = single(abs(randn(16,16,1,1000)));
% % Ml = median(x_l);
for i=1:2*Num_Pos_valid_set
    tmp_xl =  x_l(:,:,:,i);
    tmp_xr =  x_r(:,:,:,i);
    x_l(:,:,:,i) = (x_l(:,:,:,i) - mean(mean(mean(x_l(:,:,:,i)))))/std(tmp_xl(:));
    x_r(:,:,:,i) = (x_r(:,:,:,i) - mean(mean(mean(x_r(:,:,:,i)))))/std(tmp_xr(:));
end

% suppose w and b in the system
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
% for t=1:5
%     w1(:,:,1,t) = single(w1(:,:,1,t) - mean(mean(mean(w1(:,:,1,t))))) ;
%     w2(:,:,1,t) = single(w2(:,:,1,t) - mean(mean(mean(w2(:,:,1,t))))) ;
%     w3(:,:,1,t) = single(w3(:,:,1,t) - mean(mean(mean(w3(:,:,1,t))))) ;
% end
w1 = single(w1);
w2 = single(w2);
w3 = single(w3);
b1 = single(zeros(1,5));
b2 = single(zeros(1,25));
b3 = single(zeros(1,125));

% compute the disired descriptor and distance
[resl,resr] = PatchDesc_DeepCnn(x_l,x_r, w1, b1,w2,b2,w3,b3);

% [resl,resr] = PatchDesc_cnn(x_l,x_r, w, b) ;


% -------------------------------------------------------------------------
% Part 3.3: Learning with stochastic gradient descent
% -------------------------------------------------------------------------

% SGD parameters:
% - numIterations: maximum number of iterations
% - rate: learning rate
% - momentum: momentum rate
% - shrinkRate: shrinkage rate (or coefficient of the L2 regulariser)
% - plotPeriod: how often to plot

numIterations = 40 ;
% rate = 5 ;
rate = 0.005;
momentum = 0.90 ;
shrinkRate = 0.0005 ;
plotPeriod = 10 ;

% Initial momentum
w_momentum1 = zeros('like', w1) ;
b_momentum1 = zeros('like', b1) ;
w_momentum2 = zeros('like', w2) ;
b_momentum2 = zeros('like', b2) ;
w_momentum3 = zeros('like', w3) ;
b_momentum3 = zeros('like', b3) ;

Dist_fun = @(xl,xr)(sum((xl-xr).*(xl-xr),2));


for trainround = 1:numIterations

  % Forward pass
  [resl,resr] = PatchDesc_DeepCnn(x_l,x_r, w1, b1,w2,b2,w3,b3);
  
  t = 1:2*Num_Pos_valid_set;
  
  % calculate the distance for each pair.
  MM = size(resl.x6,3);
  NN = size(resl.x6,4);
  xNNl = reshape(resl.x6,[MM NN]);
  xNNr = reshape(resr.x6,[MM NN]);
  dist = (xNNl-xNNr).*(xNNl-xNNr);
  Eucl_dist(t) = sqrt(sum(dist(:,t)));
%   Eucl_dist(t) = sqrt(sum(sum(sum(dist(:,:,:,t)))));
  
  pos_indic = (y==1);
  neg_indic = (y==0);
  
  Ew_func = @(x1,x2)(sum(abs(x1-x2),1));
  
  % Loss  
%   L = y.*max(0,Eucl_dist-0.6)+(1-y).*max(0,2-Eucl_dist);
    L = 0.5*y.*(max(0,Eucl_dist-0.6).^2)+0.5*(1-y).*(max(0,2-Eucl_dist).^2);% change the loss function into square of Euclidean distance
  % change the form of resl.x3 and resr.x3 into vector
%   L = y.*Eucl_dist+(1-y).*max(0,2-Eucl_dist);
  disp(mean(L));
  Temp_L(trainround) = mean(L);

  % if the Loss is greater than the last round, then the learning rate is
  % halved; if the decreasing rate is too low, then increase the learning
  % rate by times 2
  if trainround>2
      if Temp_L(trainround-1)>Temp_L(trainround);
          rate = 0.5*rate;
      else
          if trainround > 3
              if (Temp_L(trainround-1)-Temp_L(trainround))/Temp_L(trainround-2)<0.02
                   rate = 2*rate;
              end
          end             
      end
  end
%   dist_indic = Eucl_dist<1000;
%   Y_1 = y-1;
% dLdD = single(y) +  single((y-1) & (Eucl_dist<2)); 
%   dLdD = single((y)&(Eucl_dist>0.6)) +  single((y-1) & (Eucl_dist<2)); 
     dLdD = single((y.*(Eucl_dist-0.6))&(Eucl_dist>0.6)) +  single((y-1).*(Eucl_dist-2) & (Eucl_dist<2));
  dLdxl = zeros(size(resl.x6)) ;
  dDdx6l  = zeros(size(resl.x6)) ;
  dLdxr = zeros(size(resl.x6)) ;
  dDdx6r = zeros(size(resl.x6)) ;

  for t = 1:2*Num_Pos_valid_set
%       dDdx6l(:,:,:,t) = (resl.x6(:,:,:,t)-resr.x6(:,:,:,t))/Eucl_dist(t);
      dDdx6l(:,:,:,t) = 2*(resl.x6(:,:,:,t)-resr.x6(:,:,:,t));
      dLdxl(:,:,:,t) = dLdD(t)*dDdx6l(:,:,:,t);
%        dLdxl(:,:,:,t) = resl.x3(:,:,:,t) - dLdxl(:,:,:,t) ;
      dDdx6r(:,:,:,t) = 2*(resr.x6(:,:,:,t)-resl.x6(:,:,:,t));
%       dDdx6r(:,:,:,t) = (resr.x6(:,:,:,t)-resl.x6(:,:,:,t))/Eucl_dist(t);
      dLdxr(:,:,:,t) = dLdD(t)*dDdx6r(:,:,:,t);
%        dLdxr(:,:,:,t) = resr.x3(:,:,:,t) - dLdxr(:,:,:,t) ;
  end
  dLdxl = single(dLdxl);
  dLdxr = single(dLdxr);
  
  [resl,resr] = PatchDesc_DeepCnn(x_l,x_r, w1, b1,w2,b2,w3,b3,dLdxl,dLdxr);
%   [resl,resr] = PatchDesc_cnn(x_l,x_r, w, b,dLdxl,dLdxr) ;

% check if the gradient computation is right?
    ex = randn(size(x_l), 'single') ;
    eta = 0.0001 ;
    xp_l = x_l + eta * ex  ;
    [resxl,resxr] = PatchDesc_DeepCnn(xp_l,x_r, w1, b1,w2,b2,w3,b3,dLdxl,dLdxr);
    dzdx_empirical = sum(dLdxl(:) .* (resxl.x6(:) - resl.x6(:)) / eta) ;
    dzdx_computed = sum(resl.dzdx1(:) .* ex(:)) ;
    fprintf(...
        'der: empirical: %f, computed: %f, error: %.2f %%\n', ...
        dzdx_empirical, dzdx_computed, ...
        abs(1 - dzdx_empirical/dzdx_computed)*100) ;
    
      
%     res.dzdw1 = (resl.dzdw1 + resr.dzdw1);
%     res.dzdb1 = (resl.dzdb1 + resr.dzdb1);
%     res.dzdw2 = (resl.dzdw2 + resr.dzdw2);
%     res.dzdb2 = (resl.dzdb2 + resr.dzdb2);
%     res.dzdw3 = (resl.dzdw3 + resr.dzdw3);
%     res.dzdb3 = (resl.dzdb3 + resr.dzdb3);
    
    res.dzdw1 = (resl.dzdw1 + resr.dzdw1)/size(resl.x1,4);
    res.dzdb1 = (resl.dzdb1 + resr.dzdb1)/ size(resl.x1,4);
    res.dzdw2 = (resl.dzdw2 + resr.dzdw2)/size(resl.x1,4);
    res.dzdb2 = (resl.dzdb2 + resr.dzdb2)/ size(resl.x1,4);
    res.dzdw3 = (resl.dzdw3 + resr.dzdw3)/size(resl.x1,4);
    res.dzdb3 = (resl.dzdb3 + resr.dzdb3)/ size(resl.x1,4);
    
% %     w_momentum1 = momentum * w_momentum1 + rate * (res.dzdw1 + shrinkRate * w1) ;
%     w_momentum1 = momentum * w_momentum1 + rate * res.dzdw1 ;
% %    w_momentum = momentum * w_momentum + rate * res.dzdw  ;
% %    b_momentum = momentum * b_momentum + rate * 0.1 * res.dzdb ;
% %     b_momentum1 = momentum * b_momentum1 + rate * 0.1* res.dzdb1 ;
%     b_momentum1 = momentum * b_momentum1 + rate *  res.dzdb1 ;
%     
%     w_momentum2 = momentum * w_momentum2 + rate * res.dzdw2  ;
% %     w_momentum2 = momentum * w_momentum2 + rate * (res.dzdw2 + shrinkRate * w2) ;
% %     b_momentum2 = momentum * b_momentum2 + rate * 0.1*res.dzdb2 ;
%     b_momentum2 = momentum * b_momentum2 + rate *res.dzdb2 ;
% %     w_momentum3 = momentum * w_momentum3 + rate * (res.dzdw3 + shrinkRate * w3) ;
%     w_momentum3 = momentum * w_momentum3 + rate * res.dzdw3  ;
% %     b_momentum3 = momentum * b_momentum3 + rate * 0.1* res.dzdb3 ;
%     b_momentum3 = momentum * b_momentum3 + rate * res.dzdb3 ;
    
    % change the form of momentum into the following 
    w_momentum1 = momentum * w_momentum1 + rate * res.dzdw1 ;
    b_momentum1 = momentum * b_momentum1 + rate *  res.dzdb1 ;    
    w_momentum2 = momentum * w_momentum2 + rate * res.dzdw2  ;
    b_momentum2 = momentum * b_momentum2 + rate *res.dzdb2 ;
    w_momentum3 = momentum * w_momentum3 + rate * res.dzdw3  ;
    b_momentum3 = momentum * b_momentum3 + rate * res.dzdb3 ;

   % Gradient step
   w1 = w1 - w_momentum1 ;
   b1 = b1 - b_momentum1 ;
   w2 = w2 - w_momentum2 ;
   b2 = b2 - b_momentum2 ;
   w3 = w3 - w_momentum3 ;
   b3 = b3 - b_momentum3 ;
end