function [resl,resr] = PatchDesc_DeepCnn(x_l,x_r, w1, b1,w2,b2,w3,b3, dzdxl,dzdxr)
%this function is used to forward propagate the neural network and back
%propagate the delta
rho2 = 2 ;

% if nargin <= 8
    % Forward pass
    resl.x1 = x_l ;
    resl.x2 = vl_nnconv(resl.x1, w1, b1) ;
    resl.x3 = vl_nnpool(resl.x2, rho2,'Stride',2) ; %  
    resl.x4 = vl_nnconv(resl.x3, w2, b2) ;
    resl.x5 = vl_nnpool(resl.x4, rho2,'Stride',2) ; % 
    % resl.dx5 = vl_nnpool(resl.x4, rho2) ; %
    resl.x6 = vl_nnconv(resl.x5, w3, b3);
    
    resr.x1 = x_r ;
    resr.x2 = vl_nnconv(resr.x1, w1, b1) ;
    resr.x3 = vl_nnpool(resr.x2, rho2,'Stride',2) ; % 
    resr.x4 = vl_nnconv(resr.x3, w2, b2) ;
    resr.x5 = vl_nnpool(resr.x4, rho2,'Stride',2) ; % 
    resr.x6 = vl_nnconv(resr.x5, w3, b3);
% end


% Backward pass (only if passed output derivative)
if nargin > 8
    resl.dzdx6 = dzdxl ;
    [resl.dzdx5,resl.dzdw3,resl.dzdb3] = ...
        vl_nnconv(resl.x5, w3, b3, resl.dzdx6); 
    resl.dzdx5o = single(Chen_ResizeDownsamPool(resl.dzdx5,2)); % resize for back propagation
    resl.dzdx4 = vl_nnpool(resl.x4, rho2,resl.dzdx5o);
    [resl.dzdx3,resl.dzdw2,resl.dzdb2] = ...
        vl_nnconv(resl.x3, w2, b2, resl.dzdx4); 
    resl.dzdx3o = single(Chen_ResizeDownsamPool(resl.dzdx3,2)); % resize for back propagation
    resl.dzdx2 = vl_nnpool(resl.x2, rho2,resl.dzdx3o);
    [resl.dzdx1,resl.dzdw1,resl.dzdb1] = ...
        vl_nnconv(resl.x1, w1, b1, resl.dzdx2); 
    
    resr.dzdx6 = dzdxr ;
    [resr.dzdx5,resr.dzdw3,resr.dzdb3] = ...
        vl_nnconv(resr.x5, w3, b3, resr.dzdx6); 
    resr.dzdx5o = single(Chen_ResizeDownsamPool(resr.dzdx5,2)); % resize for back propagation
    resr.dzdx4 = vl_nnpool(resr.x4, rho2,resr.dzdx5o);
%     resr.dzdx4 = vl_nnpool(resr.x4, rho2,'Stride',2,resr.dzdx5);
    [resr.dzdx3,resr.dzdw2,resr.dzdb2] = ...
        vl_nnconv(resr.x3, w2, b2, resr.dzdx4); 
    resr.dzdx3o = single(Chen_ResizeDownsamPool(resr.dzdx3,2)); % resize for back propagation
    resr.dzdx2 = vl_nnpool(resr.x2, rho2,resr.dzdx3o);
    [resr.dzdx1,resr.dzdw1,resr.dzdb1] = ...
        vl_nnconv(resr.x1, w1, b1, resr.dzdx2); 
    
end
