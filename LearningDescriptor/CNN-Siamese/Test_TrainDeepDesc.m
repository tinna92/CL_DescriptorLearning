setup ;
x_l = single(rand(32,32,1,100));
x_r = single(rand(32,32,1,100));

a = sqrt(6/1024);
w1 = -a +2*a*(rand(5, 5, 1,5));
a = sqrt(6/196);
w2 = -a +2*a*(rand(5, 5, 5,25));
a = sqrt(6/25);
w3 = -a +2*a*(rand(5, 5, 25,125));

w1 = single(w1);
w2 = single(w2);
w3 = single(w3);
b1 = single(zeros(1,5));
b2 = single(zeros(1,25));
b3 = single(zeros(1,125));

rho2 = 2 ;
resl.x1 = x_l ;
resl.x2 = vl_nnconv(resl.x1, w1, b1) ;
resl.x2n = vl_nnrelu(resl.x2);% increase a nonlinear layer
resl.x3 = vl_nnpool(resl.x2n, rho2,'Stride',2) ; %  
resl.x4 = vl_nnconv(resl.x3, w2, b2) ;
resl.x4n = vl_nnrelu(resl.x4);% increase a nonlinear layer
resl.x5 = vl_nnpool(resl.x4n, rho2,'Stride',2) ; % 
% resl.dx5 = vl_nnpool(resl.x4, rho2) ; %
resl.x6 = vl_nnconv(resl.x5, w3, b3);

resl.dzdx6 = single(rand(1,1,125,100));
[resl.dzdx5,resl.dzdw3,resl.dzdb3] = ...
    vl_nnconv(resl.x5, w3, b3, resl.dzdx6); 
resl.dzdx5o = single(Chen_ResizeDownsamPool(resl.dzdx5,2)); % resize for back propagation
resl.dzdx4n = vl_nnpool(resl.x4n, rho2,resl.dzdx5o);
resl.dzdx4 = vl_nnrelu(resl.x4,resl.dzdx4n);
[resl.dzdx3,resl.dzdw2,resl.dzdb2] = ...
    vl_nnconv(resl.x3, w2, b2, resl.dzdx4); 
resl.dzdx3o = single(Chen_ResizeDownsamPool(resl.dzdx3,2)); % resize for back propagation
resl.dzdx2n = vl_nnpool(resl.x2n, rho2,resl.dzdx3o);
resl.dzdx2 = vl_nnrelu(resl.x2,resl.dzdx2n);
[resl.dzdx1,resl.dzdw1,resl.dzdb1] = ...
    vl_nnconv(resl.x1, w1, b1, resl.dzdx2); 