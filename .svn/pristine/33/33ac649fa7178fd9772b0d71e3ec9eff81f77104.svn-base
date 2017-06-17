% this function test also the nonlinear sigmoid function, which is followed 
% after each convolution operation, in the CNN architecture.

% Theoritical speaking, adding nonlinearity will increase the
% descriminative ability of the whole system.

% 19.06.2015 by Lin Chen
function [resl,resr] = PatchDesc_DeepCnn_WithNonlinear_sigmoid_4layer(x_l,x_r, w1, b1,w2,b2,w3,b3,w4,b4, dzdxl,dzdxr)
%this function is used to forward propagate the neural network and back
%propagate the delta
rho2 = 2 ;

% if nargin <= 8
    % Forward pass
    resl.x1 = x_l ;
    resl.x2 = vl_nnconv(resl.x1, w1, b1) ;
    resl.x2n = vl_nnsigmoid(resl.x2);% increase a nonlinear layer
%     vl_nnsigmoid(x,dzdy);
    resl.x3 = vl_nnpool(resl.x2n, rho2,'Stride',2) ; %  
    resl.x4 = vl_nnconv(resl.x3, w2, b2) ;
    resl.x4n = vl_nnsigmoid(resl.x4);% increase a nonlinear layer
    resl.x5 = vl_nnpool(resl.x4n, rho2,'Stride',2) ; % 
    % resl.dx5 = vl_nnpool(resl.x4, rho2) ; %
    resl.x6 = vl_nnconv(resl.x5, w3, b3);
    resl.x6n = vl_nnsigmoid(resl.x6);% increase a nonlinear layer
    resl.x7 = vl_nnpool(resl.x6n, rho2,'Stride',2) ; % 
    resl.x8 = vl_nnconv(resl.x7,  w4, b4) ; % 
    
    
    resr.x1 = x_r ;
    resr.x2 = vl_nnconv(resr.x1, w1, b1) ;
    resr.x2n = vl_nnsigmoid(resr.x2);% increase a nonlinear layer
    resr.x3 = vl_nnpool(resr.x2n, rho2,'Stride',2) ; % 
    resr.x4 = vl_nnconv(resr.x3, w2, b2) ;
    resr.x4n = vl_nnsigmoid(resr.x4);% increase a nonlinear layer
    resr.x5 = vl_nnpool(resr.x4n, rho2,'Stride',2) ; % 
    resr.x6 = vl_nnconv(resr.x5, w3, b3);
    resr.x6n = vl_nnsigmoid(resr.x6);% increase a nonlinear layer
    resr.x7 = vl_nnpool(resr.x6n, rho2,'Stride',2) ; % 
    resr.x8 = vl_nnconv(resr.x7,  w4, b4) ; % 
% end


% Backward pass (only if passed output derivative)
if nargin > 10
    resl.dzdx8 = dzdxl ;
    [resl.dzdx7,resl.dzdw4,resl.dzdb4] = ...
        vl_nnconv(resl.x7, w4, b4, resl.dzdx8); 
    resl.dzdx7o = single(Chen_ResizeDownsamPool(resl.dzdx7,2)); % resize for back propagation
    resl.dzdx6n = vl_nnpool(resl.x6n, rho2,resl.dzdx7o);
    resl.dzdx6 = vl_nnsigmoid(resl.x6,resl.dzdx6n);
    
    [resl.dzdx5,resl.dzdw3,resl.dzdb3] = ...
        vl_nnconv(resl.x5, w3, b3, resl.dzdx6); 
    resl.dzdx5o = single(Chen_ResizeDownsamPool(resl.dzdx5,2)); % resize for back propagation
    resl.dzdx4n = vl_nnpool(resl.x4n, rho2,resl.dzdx5o);
    resl.dzdx4 = vl_nnsigmoid(resl.x4,resl.dzdx4n);
    [resl.dzdx3,resl.dzdw2,resl.dzdb2] = ...
        vl_nnconv(resl.x3, w2, b2, resl.dzdx4); 
    resl.dzdx3o = single(Chen_ResizeDownsamPool(resl.dzdx3,2)); % resize for back propagation
    resl.dzdx2n = vl_nnpool(resl.x2n, rho2,resl.dzdx3o);
    resl.dzdx2 = vl_nnsigmoid(resl.x2,resl.dzdx2n);
    [resl.dzdx1,resl.dzdw1,resl.dzdb1] = ...
        vl_nnconv(resl.x1, w1, b1, resl.dzdx2); 
    
    
    resr.dzdx8 = dzdxr ;
    [resr.dzdx7,resr.dzdw4,resr.dzdb4] = ...
        vl_nnconv(resr.x7, w4, b4, resr.dzdx8); 
    resr.dzdx7o = single(Chen_ResizeDownsamPool(resr.dzdx7,2)); % resize for back propagation
    resr.dzdx6n = vl_nnpool(resr.x6n, rho2,resr.dzdx7o);
    resr.dzdx6 = vl_nnsigmoid(resr.x6,resr.dzdx6n);
%     resr.dzdx6 = dzdxr ;
    [resr.dzdx5,resr.dzdw3,resr.dzdb3] = ...
        vl_nnconv(resr.x5, w3, b3, resr.dzdx6); 
    resr.dzdx5o = single(Chen_ResizeDownsamPool(resr.dzdx5,2)); % resize for back propagation
    resr.dzdx4n = vl_nnpool(resr.x4n, rho2,resr.dzdx5o);
    resr.dzdx4 = vl_nnsigmoid(resr.x4, resr.dzdx4n);
%     resr.dzdx4 = vl_nnpool(resr.x4, rho2,'Stride',2,resr.dzdx5);
    [resr.dzdx3,resr.dzdw2,resr.dzdb2] = ...
        vl_nnconv(resr.x3, w2, b2, resr.dzdx4); 
    resr.dzdx3o = single(Chen_ResizeDownsamPool(resr.dzdx3,2)); % resize for back propagation
    resr.dzdx2n = vl_nnpool(resr.x2n, rho2,resr.dzdx3o);
    resr.dzdx2 = vl_nnsigmoid(resr.x2,resr.dzdx2n);
    [resr.dzdx1,resr.dzdw1,resr.dzdb1] = ...
        vl_nnconv(resr.x1, w1, b1, resr.dzdx2); 
    
end
