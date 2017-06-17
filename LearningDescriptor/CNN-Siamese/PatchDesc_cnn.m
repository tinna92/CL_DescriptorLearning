function [resl,resr] = PatchDesc_cnn(x_l,x_r, w, b, dzdxl,dzdxr)
% TINYCNN  A very simple CNN
%   RES = TINYCNN(X, W, B) evaluates a CNN with two layers: linear
%   filtering and max pooling. W is a QxQ filter and B its (scalar) bias
%   and X a MxN input image.
%
%   RES = TINYCNN(X, W, B, DZDY) backpropagates the CNN loss derivative DZDY
%   thorugh the network.
%
%   RES.X1, RES.X2, and RES.X3 contain the input of the first and second
%   CNN layers and of the CNN loss. RES.DZDX1, RES.DZDX2, and RES.DZDX3
%   contain the corresponding derivatives. RES.DZDW and RES.DZDB contain
%   the derivatives of the loss with respect to the parameters W and B.

% Author: Andrea Vedaldi


rho2 = 2 ;

% Forward pass
resl.x1 = x_l ;
resl.x2 = vl_nnconv(resl.x1, w, b) ;
resl.x3 = vl_nnpool(resl.x2, rho2) ; % 

resr.x1 = x_r ;
resr.x2 = vl_nnconv(resr.x1, w, b) ;
resr.x3 = vl_nnpool(resr.x2, rho2) ; % 


% Backward pass (only if passed output derivative)
if nargin > 5
  resl.dzdx3 = dzdxl ;
  resl.dzdx2 = vl_nnpool(resl.x2, rho2, resl.dzdx3) ;
  
  resr.dzdx3 = dzdxr;
  resr.dzdx2 = vl_nnpool(resr.x2, rho2, resr.dzdx3) ;
  
%   resl.dzdx2 = resl.dzdx2+resr.dzdx2;
%   resr.dzdx2 = resl.dzdx2;
%   
  [resl.dzdx1, resl.dzdw, resl.dzdb] = ...
    vl_nnconv(resl.x1, w, b, resl.dzdx2) ; %why this form shape the backward pass process

  [resr.dzdx1, resr.dzdw, resr.dzdb] = ...
    vl_nnconv(resr.x1, w, b, resr.dzdx2) ; %why this form shape the backward pass process

% resl.dzdw = resl.dzdw + resr.dzdw;
%  resr.dzdw = resl.dzdw;
%  resl.dzdb = resl.dzdb + resr.dzdb;
%  resr.dzdb = resl.dzdb;
%  
%  [resl.dzdx1, resl.dzdw, resl.dzdb] = ...
%     vl_nnconv(resl.x1, w, b, resl.dzdx2) ; %why this form shape the backward pass process
% 
%   [resr.dzdx1, resr.dzdw, resr.dzdb] = ...
%     vl_nnconv(resr.x1, w, b, resr.dzdx2) ; %why this form shape the backward pass process
end
