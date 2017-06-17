% derive K matrix from interior parameters
% @param c,x0,y0,m,s: focal length, prinple point coord, ?? 
function [K]=DeriveKfromIntParam(c,x0,y0,m,s)
    K(1,1)= -c;
    K(1,3) = x0;
    K(2,3) = y0;
    K(2,2) = K(1,1)*m;
    K(1,2) = K(1,1)*s;
    K(2,1) = 0;
    K(3,1) = 0;
    K(3,2) = 0;
    K(3,3) = 1;
end