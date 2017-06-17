% estimate fundemental matrix from identical image points
% [F] output fundemental matrix
% img1,img2 identical points in 2 images for fundemental matrix estimation 
function [F] = estimateFundMatFromimagePoints(img1,img2)
% perprocessing of coordinates
    % cal gravity
    imgC1 = mean(img1')';    
    imgC2  = mean(img2')';

    % cal the average distance for all points from the centres of gravity
    Simg1 = AvedisFromgravityCenter(img1);   
    Simg2 = AvedisFromgravityCenter(img2);
        
    % cal the scaling factor
    S_2D1 = 2^0.5/Simg1;   
    S_2D2  = 2^0.5/Simg1;

    % construct matrix T2d for img1 and img2
    T_2D1 = [S_2D1,0,-S_2D1*imgC1(1);0,S_2D1,-S_2D1*imgC1(2);0,0,1];
    T_2D2 = [S_2D2,0,-S_2D2*imgC2(1);0,S_2D2,-S_2D2*imgC1(2);0,0,1];

%     global img1_NCOG img2_NCOG;
    
    % centralization according to gravity and scaling according to distance
    img1_NCOG = T_2D1*(img1);
    img2_NCOG = T_2D2*(img2);
    
    % build equation Af=0 for solving F
    x = img1_NCOG';
    X = img2_NCOG';
    dims = size(img1_NCOG);
    for i=1:dims(2)
%         sx = axiator(x(i,:));        
        A(i,:)=kron(x(i,:),X(i,:));%kroneck product for image and        
    end
    
    % solve P using SVD decomp.
    [U,S,V] = svd(A);

    % get the rightmost column of V as vec(P')
    %??3×3???F
    vec_F = V(:,9)';
    vec_F33(1:3,1)=vec_F(1:3);
    vec_F33(1:3,2)=vec_F(4:6);
    vec_F33(1:3,3)=vec_F(7:9);
    
    % force to get F because det(F) != 0
    [U1,S1,V1] = svd(vec_F33);
    
    S1(3,3)=0;%force the smallest singular value to be 0    
    vec_F = U1*S1*V1';        
    %convert the F matrix for normalized point coord to orinigal coord
    vec_Fimg = T_2D2'*vec_F*T_2D1;
    
    F = vec_Fimg;
    % check the error x2'*F*x1 using the first point pairs
%     img2_NCOG(:,1)'*vec_F*img1_NCOG(:,1)
%     img2(:,1)'*vec_Fimg*img1(:,1)    
    
    %do a nonlinear optimization to improve the result
%     F1 = lsqnonlin(@(x) geometric_distance(x,img1_NCOG,img2_NCOG),vec_F);
%     % the input data is measured or auto matched with high accuracy, so the
%     % result from lsqnonlin dose not improve too much of this result
%     [geometric_distance(vec_F,img1_NCOG,img2_NCOG) geometric_distance(F1,img1_NCOG,img2_NCOG)]
  
end