% this function implements the idea of stacked convolutional auto encoder,
% it could provide a unsupervised feature reconstruction

% 17.06.2015 by Lin Chen
function [res,recons] = Chen_StackedConvolutionAutoEncoder(x, we1, wd1, be1,bd1)

%this function is used to forward propagate the neural network and back
%propagate the delta
pad = [size(we1,1)-1  size(we1,1)-1 size(we1,1)-1 size(we1,1)-1];
rho2 = 2 ;
res.x1 = x;
res.x2 = vl_nnconv(res.x1, we1, be1,'pad',pad) ;
res.x3 = vl_nnpool(res.x2, rho2,'Stride',2) ; 
res.x4 = single(Chen_ResizeDownsamPool_withouttailer(res.x3,2));
res.x5 = vl_nnconv(res.x4, wd1, bd1) ;
recons = res.x3; % the hidden output as hidden descriptor

% % Backward pass (only if passed output derivative)
% if nargin > 8
%     resl.dzdx6 = dzdxl ;
%     [resl.dzdx5,resl.dzdw3,resl.dzdb3] = ...
%         vl_nnconv(resl.x5, w3, b3, resl.dzdx6); 
%     resl.dzdx5o = single(Chen_ResizeDownsamPool(resl.dzdx5,2)); % resize for back propagation
%     resl.dzdx4n = vl_nnpool(resl.x4n, rho2,resl.dzdx5o);
%     resl.dzdx4 = vl_nnrelu(resl.x4,resl.dzdx4n);
%     [resl.dzdx3,resl.dzdw2,resl.dzdb2] = ...
%         vl_nnconv(resl.x3, w2, b2, resl.dzdx4); 
%     resl.dzdx3o = single(Chen_ResizeDownsamPool(resl.dzdx3,2)); % resize for back propagation
%     resl.dzdx2n = vl_nnpool(resl.x2n, rho2,resl.dzdx3o);
%     resl.dzdx2 = vl_nnrelu(resl.x2,resl.dzdx2n);
%     [resl.dzdx1,resl.dzdw1,resl.dzdb1] = ...
%         vl_nnconv(resl.x1, w1, b1, resl.dzdx2); 
% end
end
