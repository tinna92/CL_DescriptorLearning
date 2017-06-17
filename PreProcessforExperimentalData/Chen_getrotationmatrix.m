% get the rotation matrix from rotation angles
function [R] = Chen_getrotationmatrix(omi,phi,kappa)
Num = size(omi,2);
index = 1:Num;
R(1,1,index) = cos(phi(index))*cos(kappa(index));
R(1,2,index) = -cos(phi(index))*sin(kappa(index)) ;
R(1,3,index) = sin(phi(index)) ;
R(2,1,index) = sin(omi(index))*sin(phi(index))*cos(kappa(index))+cos(omi(index))*sin(kappa(index));
R(2,2,index) = -sin(omi(index))*sin(phi(index))*sin(kappa(index))+cos(omi(index))*cos(kappa(index));
R(2,3,index) = -sin(omi(index))*cos(phi(index));
R(3,1,index) = -cos(omi(index))*sin(phi(index))*cos(kappa(index)) + sin(omi(index))*sin(kappa(index));
R(3,2,index) = cos(omi(index))*sin(phi(index))*sin(kappa(index)) + sin(omi(index))*cos(kappa(index));
R(3,3,index) = cos(omi(index))*cos(phi(index));
end