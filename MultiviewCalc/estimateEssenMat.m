

[img1,img2,GCP,x0,y0,c,s,m,xneu1,xneu2] = import_data_group_5();

% compose K from interior parameters
[K] = DeriveKfromIntParam(c,x0,y0,m,s);

%s first normalise coordinates by K matrix
invK = inv(K);
img1_Knorm = invK*img1;
img2_Knorm = invK*img2;

x = img1_Knorm';
X = img2_Knorm';
dims = size(img1_Knorm);
for i=1:dims(2)
    A(i,:)=kron(x(i,:),X(i,:));%kroneck product for image and 
  
end

% solve E using SVD decomp.
[U,S,V] = svd(A);
% get the rightmost column of V as vec(E')
%??3×3???E
vec_E = V(:,9)';
vec_E33(1:3,1)=vec_E(1:3);
vec_E33(1:3,2)=vec_E(4:6);
vec_E33(1:3,3)=vec_E(7:9);

a = det(vec_E33);
% force to get F because det(F) != 0
[U1,S1,V1] = svd(vec_E33);

S1(3,3)=0;%force the smallest singular value to be 0
delta = (S1(1,1)+S1(2,2))/2;
S1(1,1) = delta;
S1(2,2) = delta;
vec_E = U1*S1*V1';
det(vec_E)

img2_Knorm(:,2)'*vec_E*img1_Knorm(:,2) 

[U2,S2,V2]= svd(vec_E);

E = vec_E;
[U,S,V] = svd(E);
W = [0 -1 0;1 0 0;0 0 1];
X01 = V(:,3);
X02 = -V(:,3);
R01 = V*W*U';
R02 = V*W'*U';
SX01 = axiator(X01);
SX02 = axiator(X02);

X = [0 -1 0;1 0 0;0 0 1];
R = [0 -1 0;1 0 0;0 0 1];

if (sign(SX02*invK*img1_Knorm(:,1)) == 1)
    disp('ssssss');
end


disp('ssssss');
sign1 = sign(SX01*invK*img1(:,3));
sign2 = sign(SX01*R01*invK*img2(:,3));
sign3 =sign(SX01*invK*img1(:,3));
sign4 =sign(SX01*R02*invK*img2(:,3));
sign5 =sign(SX02*invK*img1(:,3));
sign6 =sign(SX02*R01*invK*img2(:,3));
sign7 =sign(SX02*invK*img1(:,3));
sign8 =sign(SX02*R02*invK*img2(:,3));

% choose the correct solution from 4 S/R combination
if (sign(SX01*invK*img1(:,1))== sign(SX01*R01*invK*img2(:,1)))
    R = R01;
else if(sign(SX01*invK*img1(:,1))== sign(SX01*R02*invK*img2(:,1)))
    R = R02;
    end
end

if(sign(SX01*invK*img1(:,1))==[1;1;1])
    if(sign(SX01*R*invK*img2(:,1))==[1;1;1])
        X = X01;
    end
end

if(sign(SX02*invK*img1(:,1))==[1;1;1])
    if(sign(SX02*R*invK*img2(:,1))==[1;1;1])
        X = X02;
    end
end



