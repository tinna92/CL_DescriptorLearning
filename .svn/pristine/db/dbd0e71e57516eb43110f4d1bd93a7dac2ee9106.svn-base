% this function test also the nonlinear sigmoid function, which is followed 
% after each convolution operation, in the CNN architecture.

% Theoritical speaking, adding nonlinearity will increase the
% descriminative ability of the whole system.

% 19.06.2015 by Lin Chen
function [resl,resr] = PatchDesc_DeepCnn_WithNonlinear_RELU(x_l,x_r, w1, b1,w2,b2,w3,b3, dzdxl,dzdxr)
%this function is used to forward propagate the neural network and back
%propagate the delta
rho2 = 2 ;

% if nargin <= 8
    % Forward pass
    resl.x1 = x_l ;
    resl.x2 = vl_nnconv(resl.x1, w1, b1) ;
    resl.x2norm = vl_nnconv(resl.x2, w1, b1) ;
%     resl.x2n = vl_nnsigmoid(resl.x2);% increase a nonlinear layer
    resl.x2n = vl_nnrelu(resl.x2);% increase a nonlinear layer

%     vl_nnsigmoid(x,dzdy);
    resl.x3 = vl_nnpool(resl.x2n, rho2,'Stride',2) ; %  
    resl.x3nn = vl_nnnormalize(resl.x3,[5 2 1.0000e-04 0.75]);
    resl.x4 = vl_nnconv(resl.x3nn, w2, b2) ;
%     resl.x4n = vl_nnsigmoid(resl.x4);% increase a nonlinear layer
    resl.x4n = vl_nnrelu(resl.x4);% increase a nonlinear layer
    
    resl.x5 = vl_nnpool(resl.x4n, rho2,'Stride',2) ; % 
    resl.x5nn = vl_nnnormalize(resl.x5,[5 2 1.0000e-04 0.75]);
    % resl.dx5 = vl_nnpool(resl.x4, rho2) ; %
    resl.x6 = vl_nnconv(resl.x5nn, w3, b3);
    
    resr.x1 = x_r ;
    resr.x2 = vl_nnconv(resr.x1, w1, b1) ;
%     resr.x2n = vl_nnsigmoid(resr.x2);% increase a nonlinear layer
    resr.x2n = vl_nnrelu(resr.x2);% increase a nonlinear layer
    
    resr.x3 = vl_nnpool(resr.x2n, rho2,'Stride',2) ; % 
    resr.x3nn = vl_nnnormalize(resr.x3,[5 2 1.0000e-04 0.75]);
    resr.x4 = vl_nnconv(resr.x3nn, w2, b2) ;
%     resr.x4n = vl_nnsigmoid(resr.x4);% increase a nonlinear layer
    resr.x4n = vl_nnrelu(resr.x4);% increase a nonlinear layer
    
    resr.x5 = vl_nnpool(resr.x4n, rho2,'Stride',2) ; % 
    resr.x5nn = vl_nnnormalize(resr.x5,[5 2 1.0000e-04 0.75]);
    resr.x6 = vl_nnconv(resr.x5nn, w3, b3);
% end


% Backward pass (only if passed output derivative)
if nargin > 8
    resl.dzdx6 = dzdxl ;
    [resl.dzdx5,resl.dzdw3,resl.dzdb3] = ...
        vl_nnconv(resl.x5, w3, b3, resl.dzdx6); 
    resl.dzdx5nn = vl_nnnormalize(resl.x5nn, [5 2 1.0000e-04 0.75],resl.dzdx5);
    resl.dzdx5o = single(Chen_ResizeDownsamPool(resl.dzdx5nn,2)); % resize for back propagation    
    resl.dzdx4n = vl_nnpool(resl.x4n, rho2,resl.dzdx5o);    
    resl.dzdx4 = vl_nnrelu(resl.x4,resl.dzdx4n);
    [resl.dzdx3,resl.dzdw2,resl.dzdb2] = ...
        vl_nnconv(resl.x3, w2, b2, resl.dzdx4); 
    resl.dzdx3nn = vl_nnnormalize(resl.x3nn, [5 2 1.0000e-04 0.75],resl.dzdx3);    
    resl.dzdx3o = single(Chen_ResizeDownsamPool(resl.dzdx3nn,2)); % resize for back propagation   
    resl.dzdx2n = vl_nnpool(resl.x2n, [5 2 1.0000e-04 0.75],resl.dzdx3o);    
    resl.dzdx2 = vl_nnrelu(resl.x2,resl.dzdx2n);
    [resl.dzdx1,resl.dzdw1,resl.dzdb1] = ...
        vl_nnconv(resl.x1, w1, b1, resl.dzdx2); 
    
    resr.dzdx6 = dzdxr ;
    [resr.dzdx5,resr.dzdw3,resr.dzdb3] = ...
        vl_nnconv(resr.x5, w3, b3, resr.dzdx6); 
    resr.dzdx5nn = vl_nnnormalize(resr.x5nn, [5 2 1.0000e-04 0.75],resr.dzdx5);
    resr.dzdx5o = single(Chen_ResizeDownsamPool(resr.dzdx5nn,2)); % resize for back propagation
    resr.dzdx4n = vl_nnpool(resr.x4n, rho2,resr.dzdx5o);
    resr.dzdx4 = vl_nnrelu(resr.x4, resr.dzdx4n);
%     resr.dzdx4 = vl_nnpool(resr.x4, rho2,'Stride',2,resr.dzdx5);
    [resr.dzdx3,resr.dzdw2,resr.dzdb2] = ...
        vl_nnconv(resr.x3, w2, b2, resr.dzdx4); 
    resr.dzdx3nn = vl_nnnormalize(resr.x3nn, [5 2 1.0000e-04 0.75],resr.dzdx3);    
    resr.dzdx3o = single(Chen_ResizeDownsamPool(resr.dzdx3nn,2)); % resize for back propagation
    resr.dzdx2n = vl_nnpool(resr.x2n, rho2,resr.dzdx3o);
%     resr.dzdx2nn = vl_nnnormalize(resr.x2nn, [5 2 1.0000e-04 0.75],resr.dzdx2n);
    resr.dzdx2 = vl_nnrelu(resr.x2,resr.dzdx2n);
    [resr.dzdx1,resr.dzdw1,resr.dzdb1] = ...
        vl_nnconv(resr.x1, w1, b1, resr.dzdx2); 
    
end
