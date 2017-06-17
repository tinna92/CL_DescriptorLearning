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

% get negetive samples
for ii=1:Num_Pos_valid_set
    x_l(:,:,1,ii+Num_Pos_valid_set) = single(x_neg{ii+Start_pos,1});
    x_r(:,:,1,ii+Num_Pos_valid_set) = single(x_neg{ii+Start_pos,2});
end

% x_l = single(abs(randn(16,16,1,1000)));
% x_r = single(abs(randn(16,16,1,1000)));
% % Ml = median(x_l);
for i=1:2*Num_Pos_valid_set
    x_l(:,:,:,i) = x_l(:,:,:,i) - mean(mean(mean(x_l(:,:,:,i))));
    x_r(:,:,:,i) = x_r(:,:,:,i) - mean(mean(mean(x_r(:,:,:,i))));
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

% generate the correct label that indicates matching or nonmatching for
% each image pair
y(1:Num_Pos_valid_set)=1;
y(Num_Pos_valid_set+1:2*Num_Pos_valid_set)=0;
% -------------------------------------------------------------------------
% Part 3.3: Learning with stochastic gradient descent
% -------------------------------------------------------------------------

% SGD parameters:
% - numIterations: maximum number of iterations
% - rate: learning rate
% - momentum: momentum rate
% - shrinkRate: shrinkage rate (or coefficient of the L2 regulariser)
% - plotPeriod: how often to plot

numIterations = 10 ;
% rate = 5 ;
rate = 0.15 ;
momentum = 0.9 ;
shrinkRate = 0.0001 ;
plotPeriod = 10 ;

% Initial momentum
w_momentum = zeros('like', w) ;
b_momentum = zeros('like', b) ;

% define some function that will be used intensively later
Ew_func = @(x1,x2)(sum(abs(x1-x2),1));
L_fun = @(Ew,t)(t*Ew+(1-t)*max(0,100-Ew));
dLdEw = @()

for t = 1:numIterations

  % Forward pass
  [resl,resr] = PatchDesc_cnn(x_l,x_r, w, b) ;

  dist = (resl.x3-resr.x3).*(resl.x3-resr.x3);
  t = 1:2*Num_Pos_valid_set;
  
  % calculate the distance for each pair.
  Eucl_dist(t) = sqrt(sum(sum(sum(dist(:,:,:,t)))));
  
  pos_indic = (y==1);
  neg_indic = (y==0);
  
  
  
  
  
  % Loss  
  L = y.*Eucl_dist+(1-y).*max(0,12670-Eucl_dist);
  disp(mean(L));
  dist_indic = Eucl_dist<1600;
  Y_1 = y-1;
  dLdD = single(y) +  single((y-1) & (Eucl_dist<12670)); 
 
  % change the form of resl.x3 and resr.x3 into vector
  for t = 1:2*Num_Pos_valid_set
      dDdx3l(:,:,:,t) = (resl.x3(:,:,:,t)-resr.x3(:,:,:,t))/Eucl_dist(t);
      dLdxl(:,:,:,t) = dLdD(t)*dDdx3l(:,:,:,t);
%        dLdxl(:,:,:,t) = resl.x3(:,:,:,t) - dLdxl(:,:,:,t) ;
      dDdx3r(:,:,:,t) = (resr.x3(:,:,:,t)-resl.x3(:,:,:,t))/Eucl_dist(t);
      dLdxr(:,:,:,t) = dLdD(t)*dDdx3r(:,:,:,t);
%        dLdxr(:,:,:,t) = resr.x3(:,:,:,t) - dLdxr(:,:,:,t) ;
  end
  
%   dLdxl = resl.x3 - dLdxl ;
%   dLdxr = resr.x3 - dLdxr ;
  
  
  [resl,resr] = PatchDesc_cnn(x_l,x_r, w, b,dLdxl,dLdxr) ;
%   dLdxl = dLdD*dDdx3l;
%   dLdxr = dLdD*dDdx3r;
   % Update momentum
   
%    res.dzdw = resl.dzdw + resr.dzdw;
%    res.dzdb = resl.dzdb + resr.dzdb;

% check if the gradient computation is right?
    ex = randn(size(x_l), 'single') ;
    eta = 0.001 ;
    xp_l = x_l + eta * ex  ;
    [resxl,resxr] = PatchDesc_cnn(xp_l,x_r, w, b) ;
    dzdx_empirical = sum(dLdxl(:) .* (resxl.x3(:) - resl.x3(:)) / eta) ;
    dzdx_computed = sum(resl.dzdx1(:) .* ex(:)) ;
    fprintf(...
        'der: empirical: %f, computed: %f, error: %.2f %%\n', ...
        dzdx_empirical, dzdx_computed, ...
        abs(1 - dzdx_empirical/dzdx_computed)*100) ;
    
    
    res.dzdw = resl.dzdw + resr.dzdw;
    res.dzdb = resl.dzdb + resr.dzdb ;
   w_momentum = momentum * w_momentum + rate * (res.dzdw + shrinkRate * w) ;
%    w_momentum = momentum * w_momentum + rate * res.dzdw  ;
   b_momentum = momentum * b_momentum + rate * 0.1 * res.dzdb ;

   % Gradient step
   w = w - w_momentum ;
   b = b - b_momentum ;
  
%   z = 0.5*mean(Eucl_dist(pos_indic)^2)+mean(max(0,50-Eucl_dist(neg_indic))^2);
%  
%   
%   
%   dzde = ...
%       single(Eucl_dist(pos_indic)& pos_indic)...
%       -single(50-Eucl_dist(neg_indic)&Eucl_dist<50);
%   
%   dedx3l = 2*(resl.x3-resr.x3);
%   dedx3r = 2*(resr.x3-resl.x3);
%   
%   dzdx3 = dzde.*dedx3l+dzde.*dedx3r;
% 
%   
%   E(1,t) = ...
%     mean(max(0, 1 - res.x3(pos))) + ...
%     mean(max(0, res.x3(neg))) ;
%   E(2,t) = 0.5 * shrinkRate * sum(w(:).^2) ;% regularization rate of weight parameters
%   E(3,t) = E(1,t) + E(2,t) ;
% 
%   dzdx3 = ...
%     - single(res.x3 < 1 & pos) / sum(pos(:)) + ...
%     + single(res.x3 > 0 & neg) / sum(neg(:)) ;% compute the corresponding output derivatives,only restricted to the first part
% 
%   % Backward pass
%   res = tinycnn(im, w, b, dzdx3) ;
% 
%   % Update momentum
%   w_momentum = momentum * w_momentum + rate * (res.dzdw + shrinkRate * w) ;
%   b_momentum = momentum * b_momentum + rate * 0.1 * res.dzdb ;
% 
%   % Gradient step
%   w = w - w_momentum ;
%   b = b - b_momentum ;
end


% 


% 
% % Compute the location of black blobs in the image
% [pos,neg] = extractBlackBlobs(im) ;
% 
% figure(1) ; clf ;
% subplot(1,3,1) ; imagesc(im) ; axis equal ; title('image') ;
% subplot(1,3,2) ; imagesc(pos) ; axis equal ; title('positive points (blob centres)') ;
% subplot(1,3,3) ; imagesc(neg) ; axis equal ; title('negative points (not a blob)') ;
% colormap gray ;
% 
% % -------------------------------------------------------------------------
% % Part 3.2: Image preprocessing
% % -------------------------------------------------------------------------
% 
% % Pre-smooth the image
% im = vl_imsmooth(im,3) ;
% 
% % Subtract median value
% im = im - median(im(:)) ;
% 
% % -------------------------------------------------------------------------
% % Part 3.3: Learning with stochastic gradient descent
% % -------------------------------------------------------------------------
% 
% % SGD parameters:
% % - numIterations: maximum number of iterations
% % - rate: learning rate
% % - momentum: momentum rate
% % - shrinkRate: shrinkage rate (or coefficient of the L2 regulariser)
% % - plotPeriod: how often to plot
% 
% numIterations = 500 ;
% rate = 5 ;
% momentum = 0.9 ;
% shrinkRate = 0.0001 ;
% plotPeriod = 10 ;
% 
% % Initial CNN parameters:
% w = 10 * randn(3, 3, 1) ;
% w = single(w - mean(w(:))) ;
% b = single(0) ;
% 
% % Create pixel-level labes to compute the loss
% y = zeros(size(pos),'single') ;
% y(pos) = +1 ;
% y(neg) = -1 ;
% 
% % Initial momentum
% w_momentum = zeros('like', w) ;
% b_momentum = zeros('like', b) ;
% 
% % SGD with momentum
% for t = 1:numIterations
% 
%   % Forward pass
%   res = tinycnn(im, w, b) ;
% 
%   % Loss
%   z = y .* (res.x3 - 1) ;
% 
%   E(1,t) = ...
%     mean(max(0, 1 - res.x3(pos))) + ...
%     mean(max(0, res.x3(neg))) ;
%   E(2,t) = 0.5 * shrinkRate * sum(w(:).^2) ;% regularization rate of weight parameters
%   E(3,t) = E(1,t) + E(2,t) ;
% 
%   dzdx3 = ...
%     - single(res.x3 < 1 & pos) / sum(pos(:)) + ...
%     + single(res.x3 > 0 & neg) / sum(neg(:)) ;% compute the corresponding output derivatives
% 
%   % Backward pass
%   res = tinycnn(im, w, b, dzdx3) ;
% 
%   % Update momentum
%   w_momentum = momentum * w_momentum + rate * (res.dzdw + shrinkRate * w) ;
%   b_momentum = momentum * b_momentum + rate * 0.1 * res.dzdb ;
% 
%   % Gradient step
%   w = w - w_momentum ;
%   b = b - b_momentum ;
% 
%   % Plots
%   if mod(t-1, plotPeriod) == 0 || t == numIterations
%     fp = res.x3 > 0 & y < 0 ;
%     fn = res.x3 < 1 & y > 0 ;
%     tn = res.x3 <= 0 & y < 0 ;
%     tp = res.x3 >= 1 & y > 0 ;
%     err = cat(3, fp|fn , tp|tn, y==0) ;
% 
%     figure(2) ; clf ;
%     colormap gray ;
% 
%     subplot(2,3,1) ;
%     plot(1:t, E(:,1:t)') ;
%     grid on ; title('objective') ;
%     ylim([0 1.5]) ; legend('error', 'regularizer', 'total') ;
% 
%     subplot(2,3,2) ; hold on ;
%     [h,x]=hist(res.x3(pos(:)),30) ; plot(x,h/max(h),'g') ;
%     [h,x]=hist(res.x3(neg(:)),30) ; plot(x,h/max(h),'r') ;
%     plot([0 0], [0 1], 'b--') ;
%     plot([1 1], [0 1], 'b--') ;
%     xlim([-2 3]) ;
%     title('histograms of scores') ; legend('pos', 'neg') ;
% 
%     subplot(2,3,3) ;
%     vl_imarraysc(w) ;
%     title('learned filter') ; axis equal ;
% 
%     subplot(2,3,4) ;
%     imagesc(res.x3) ;
%     title('network output') ; axis equal ;
% 
%     subplot(2,3,5) ;
%     imagesc(res.x2) ;
%     title('first layer output') ; axis equal ;
% 
%     subplot(2,3,6) ;
%     image(err) ;
%     title('red: pred. error, green: correct, blue: ignore') ;
% 
%     if verLessThan('matlab', '8.4.0')
%       drawnow ;
%     else
%       drawnow expose ;
%     end
%   end
% end
