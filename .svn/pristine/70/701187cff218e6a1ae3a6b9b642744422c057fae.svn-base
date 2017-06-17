% deriveinterior parameters from K matrix 
function [c,x0,y0,m,s]=DeriveIntParamfromK(K)
    c=-K(1,1);
    x0 = K(1,3);
    y0 = K(2,3);
    m = K(2,2)/K(1,1);
    s = K(1,2)/K(1,1);
end