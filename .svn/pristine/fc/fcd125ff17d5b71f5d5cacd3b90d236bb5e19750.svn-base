% calculate image coordinates according to colinear equation
function[x,y] =  Chen_calculateimagecoordfromColinerequation(X_Cam,X_3D,Rot,f,px,py)
ZZ = Rot(1,3)*(X_3D(1)-X_Cam(1))+Rot(2,3)*(X_3D(2)-X_Cam(2))+Rot(3,3)*(X_3D(3)-X_Cam(3));
x = px-f*(Rot(1,1)*(X_3D(1)-X_Cam(1))+Rot(2,1)*(X_3D(2)-X_Cam(2))+Rot(3,1)*(X_3D(3)-X_Cam(3)))...
    /ZZ;
y = py-f*(Rot(1,2)*(X_3D(1)-X_Cam(1))+Rot(2,2)*(X_3D(2)-X_Cam(2))+Rot(3,2)*(X_3D(3)-X_Cam(3)))...
    /ZZ;
end