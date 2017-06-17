% derive the orientation parameters from P
function [X0,Rot,K] = DerOriParaFromP(P)
    A=P(1:3,1:3);% the right 3 by 3 matrix is A
    a = P(:,4); % the 4th column of P is a
    X0 = -(inv(A))*a;
    [Q,R]=qr(inv(A));
    Rot=Q;
    K1=inv(R);% this is lamda*K
    factor = 1/K1(3,3);
    K = factor*K1;
end