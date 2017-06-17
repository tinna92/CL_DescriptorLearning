% Estimate P from image and GCP points
% img1,GCP  input data for estimation
% P,BacPro_RMS output projection matrix and BP error
% X0,Rot,K output X0, K matrix and rotation matrix
% c,x0,y0,m,s interior parameters
function [P,BacPro_RMS,X0,Rot,K,c,x0,y0,m,s] = EstP_GCPImagepoints(img1,GCP)
    % perprocessing of coordinates
    % cal gravity
    imgC = mean(img1')';    
    GCPC  = mean(GCP')';

    % cal the average distance for all points from the centres of gravity
    Simg1 = AvedisFromgravityCenter(img1);   
    SGCP = AvedisFromgravityCenter(GCP);

    % cal the scaling factor
    S_2D = 2^0.5/Simg1;   
    S_3D  = 3^0.5/SGCP;

    % construct matrix T2d and T3d
    T_2D = [S_2D,0,-S_2D*imgC(1);0,S_2D,-S_2D*imgC(2);0,0,1];
    T_3D = [S_3D,0,0,-S_3D*GCPC(1);0,S_3D,0,-S_3D*GCPC(2);
        0,0,S_3D,-S_3D*GCPC(3);0,0,0,1];

    % centralization according to gravity and scaling according to distance
    img_NCOG = T_2D*(img1);
    GCP_NCOG = T_3D*(GCP);

    % build equation Ay=0 for solving P'
    x = img_NCOG';
    X = GCP_NCOG';
    dims = size(img_NCOG);
    for i=1:dims(2)
        sx = axiator(x(i,:));
        A(3*i-2:3*i,:)=kron(X(i,:),sx);%kroneck product for image and 
        % GCP point to get each row of A
    end

    % solve P using SVD decomp.
    [U,S,V] = svd(A);

    % get the rightmost column of V as vec(P')
    vec_P = V(:,12)';
    vec_P34(1:3,1)=vec_P(1:3);
    vec_P34(1:3,2)=vec_P(4:6);
    vec_P34(1:3,3)=vec_P(7:9);
    vec_P34(1:3,4)=vec_P(10:12);

    RMS1 = Backprojectionerror(img_NCOG,GCP_NCOG,vec_P34);%check the BP error
        %of projection martix computed from centraized data

    %get P from P'
    P = inv(T_2D)*vec_P34*T_3D;
    [X0,Rot,K] = DerOriParaFromP(P);
    [c,x0,y0,m,s]=DeriveIntParamfromK(K);
    BacPro_RMS = Backprojectionerror(img1,GCP,P);
    

    % PX = P*GCP;% calculate projection point coor
    %     sumEerr =0;
    %     dims = size(x);
    %     for i=1:dims(2)
    %         PX_E(1,i) = PX(1,i)/PX(3,i);
    %         PX_E(2,i) = PX(2,i)/PX(3,i);
    %         PX_E(3,i) = PX(3,i)/PX(3,i);
    %         temp_err = (x(1,i)-PX_E(1,i))^2+(x(2,i)-PX_E(2,i))^2+(x(3,i)-PX_E(3,i))^2;
    %         sumEerr = sumEerr+temp_err;
    %     end
    %     RMS =sqrt(sumEerr/dims(2));

end