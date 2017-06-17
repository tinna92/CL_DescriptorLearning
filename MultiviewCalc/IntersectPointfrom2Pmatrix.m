% compute 3D point from 2 projection matrixs and identical points 
function [X] = IntersectPointfrom2Pmatrix(P1,P2,x1,x2)

dims = size(x1);
for i=1:dims(2)
    sx1 = axiator(x1(:,i));
    sx2 = axiator(x2(:,i));
    A(1:3,:)=sx1*P1;
    A(4:6,:)=sx2*P2;
    [U,S,V] = svd(A); 
%     X(:,i)=V(:,4);
    X(1:4,i)=V(1:4,4);
%     X(1,i)=V(1,4)/V(4,4);
%     X(2,i)=V(2,4)/V(4,4);
%     X(3,i)=V(3,4)/V(4,4);
end
end