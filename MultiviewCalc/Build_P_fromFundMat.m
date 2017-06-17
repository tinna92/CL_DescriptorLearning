% build two projection matrixs P1,P2 from fundamental matrix
function [P1,P2] = Build_P_fromFundMat(F)
P1 = [1,0,0,0;0,1,0,0;0,0,1,0];
[U,S,V] = svd(F);
e = U(:,3);
P2 = [axiator(e)*F e];

end