% -------------------------------------------------------------------------
% Part 3: Learning a simple CNN
% -------------------------------------------------------------------------

setup ;
% load('notryose_pos.mat');
% load('notryose_neg.mat');
Num_Pos_valid_set = 500;% number of positive or negative samples in validation sets
Num_pos = 5000;% number of postive(negative) examples for tarining datasets 
Start_pos = 0; % start position for validation set extraction begin point in x_pos and x_neg
Num_valid_set = Num_Pos_valid_set*2;% the real number of samples in validation sets
% -------------------------------------------------------------------------
% Part 3.1: Load an example image and generate its labels
% -------------------------------------------------------------------------
% 
% % Load an image
% im = rgb2gray(im2single(imread('dots.jpg'))) ;

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
w = randn(9, 9, 1,20) ;
for t=1:10
    w(:,:,1,t) = single(w(:,:,1,t) - mean(mean(mean(w(:,:,1,t))))) ;
end
w = single(w);
b = single(zeros(1,20));

% compute the disired descriptor and distance
[resl,resr] = PatchDesc_cnn(x_l,x_r, w, b) ;


% -------------------------------------------------------------------------
% Part 3.3: Learning with stochastic gradient descent
% -------------------------------------------------------------------------

% SGD parameters:
% - numIterations: maximum number of iterations
% - rate: learning rate
% - momentum: momentum rate
% - shrinkRate: shrinkage rate (or coefficient of the L2 regulariser)
% - plotPeriod: how often to plot

numIterations = 30 ;
% rate = 5 ;
rate = 0.1 ;
momentum = 0.9 ;
shrinkRate = 0.0001 ;
plotPeriod = 10 ;

% Initial momentum
w_momentum = zeros('like', w) ;
b_momentum = zeros('like', b) ;

for t = 1:numIterations

  % Forward pass
  [resl,resr] = PatchDesc_cnn(x_l,x_r, w, b) ;

  dist = (resl.x3-resr.x3).*(resl.x3-resr.x3);
  t = 1:2*Num_Pos_valid_set;
  
  % calculate the distance for each pair.
  Eucl_dist(t) = sqrt(sum(sum(sum(dist(:,:,:,t)))));
  
  pos_indic = (y==1);
  neg_indic = (y==0);
  
  Ew_func = @(x1,x2)(sum(abs(x1-x2),1));
  
  % Loss  
  L = y.*max(0,Eucl_dist-100)+(1-y).*max(0,500-Eucl_dist);
  disp(mean(L));
%   dist_indic = Eucl_dist<1000;
%   Y_1 = y-1;
  dLdD = single((y)&(Eucl_dist>100)) +  single((y-1) & (Eucl_dist<500)); 
 
  % change the form of resl.x3 and resr.x3 into vector
  for t = 1:2*Num_Pos_valid_set
      dDdx3l(:,:,:,t) = (resl.x3(:,:,:,t)-resr.x3(:,:,:,t))/Eucl_dist(t);
      dLdxl(:,:,:,t) = dLdD(t)*dDdx3l(:,:,:,t);
%        dLdxl(:,:,:,t) = resl.x3(:,:,:,t) - dLdxl(:,:,:,t) ;
      dDdx3r(:,:,:,t) = (resr.x3(:,:,:,t)-resl.x3(:,:,:,t))/Eucl_dist(t);
      dLdxr(:,:,:,t) = dLdD(t)*dDdx3r(:,:,:,t);
%        dLdxr(:,:,:,t) = resr.x3(:,:,:,t) - dLdxr(:,:,:,t) ;
  end
  
%    dLdxl = resl.x3 - dLdxl ;
%    dLdxr = resr.x3 - dLdxr ;
%   dLdxl = dLdxl + dLdxr;
  
  [resl,resr] = PatchDesc_cnn(x_l,x_r, w, b,dLdxl,dLdxr) ;
%   dLdxl = dLdD*dDdx3l;
%   dLdxr = dLdD*dDdx3r;
   % Update momentum
   
%    res.dzdw = resl.dzdw + resr.dzdw;
%    res.dzdb = resl.dzdb + resr.dzdb;

% check if the gradient computation is right?
    ex = randn(size(x_l), 'single') ;
    eta = 0.0001 ;
    xp_l = x_l + eta * ex  ;
    [resxl,resxr] = PatchDesc_cnn(xp_l,x_r, w, b) ;
    dzdx_empirical = sum(dLdxl(:) .* (resxl.x3(:) - resl.x3(:)) / eta) ;
    dzdx_computed = sum(resl.dzdx1(:) .* ex(:)) ;
    fprintf(...
        'der: empirical: %f, computed: %f, error: %.2f %%\n', ...
        dzdx_empirical, dzdx_computed, ...
        abs(1 - dzdx_empirical/dzdx_computed)*100) ;
    
    
    res.dzdw = (resl.dzdw + resr.dzdw)/size(resl.x1,4);
    res.dzdb = (resl.dzdb + resr.dzdb)/ size(resl.x1,4);
       
%     res.dzdw = (resl.dzdw + resr.dzdw);
%     res.dzdb = (resl.dzdb + resr.dzdb);
    resl.dzdw = res.dzdw;
    resr.dzdw = res.dzdw;
    resl.dzdb = res.dzdb;
    resl.dzdb = res.dzdb;
   w_momentum = momentum * w_momentum + rate * (res.dzdw + shrinkRate * w) ;
%    w_momentum = momentum * w_momentum + rate * res.dzdw  ;
%    b_momentum = momentum * b_momentum + rate * 0.1 * res.dzdb ;
    b_momentum = momentum * b_momentum + rate * res.dzdb ;

   % Gradient step
   w = w - w_momentum ;
   b = b - b_momentum ;
end