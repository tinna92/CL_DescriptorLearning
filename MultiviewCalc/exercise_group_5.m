%function  exercise_group_5()
% 
clear all
format 'long' g;
[img1,img2,GCP,x0,y0,c,s,m,xneu1,xneu2] = import_data_group_5();

% your implementation:
[P,BacPro_RMS,X0,Rot,K,c,x0,y0,m,s] = EstP_GCPImagepoints(img1,GCP);%estimate projective matrix and calculate corresponding outputs
[P2,BacPro_RMS2,X02,Rot2,K2,c2,x02,y02,m2,s2] = EstP_GCPImagepoints(img2,GCP);

%estimate Essential matrix and fundenmental matrix whihc represent two-view geometry
[E,X,R] = estimateEssenMatFromimagePoints(img1,img2,c,x0,y0,m,s);
[F] = estimateFundMatFromimagePoints(img1,img2);
% intersect for new identical points
% add some noise to test if nonlinear optimization works
% img1 = img1 + 0.2*randn(3,29);
% img2 = img2 + 0.2*randn(3,29);
[F] = estimateFundMatFromimagePoints(img1,img2);

X = IntersectPointfrom2Pmatrix(P,P2,xneu1,xneu2);
X/X(4);




% % for the second exercise
% % cal gravity
%     imgC1 = mean(img1')';    
%     imgC2  = mean(img2')';
% 
%     % cal the average distance for all points from the centres of gravity
%     Simg1 = AvedisFromgravityCenter(img1);   
%     Simg2 = AvedisFromgravityCenter(img2);
% 
%     % cal the scaling factor
%     S_2D1 = 2^0.5/Simg1;   
%     S_2D2  = 2^0.5/Simg1;
% 
%     % construct matrix T2d for img1 and img2
%     T_2D1 = [S_2D1,0,-S_2D1*imgC1(1);0,S_2D1,-S_2D1*imgC1(2);0,0,1];
%     T_2D2 = [S_2D2,0,-S_2D2*imgC2(1);0,S_2D2,-S_2D2*imgC1(2);0,0,1];
% 
%     % centralization according to gravity and scaling according to distance
%     img1_NCOG = T_2D1*(img1);
%     img2_NCOG = T_2D2*(img2);
%     
%     % build equation Af=0 for solving F
%     x = img1_NCOG';
%     X = img2_NCOG';
% [P_1,P_2]=Build_P_fromFundMat(F);
% IntersectPointfrom2Pmatrix(P1,P2,img1_NCOG,img2_NCOG);
