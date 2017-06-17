%estimate fundemental matrix with linear result (initial value) in an nonlinear way
function [F,rms] = estimateFundMat_nonlin(F_initial,img1_NCOG,img2_NCOG)
    %optimize the result with non-linear optimization
    %build a pair of projection matrix from F
%     [P_1,P_2]=Build_P_fromFundMat(vec_F);
%     
%     % compute points and reproject   
%     [X]=IntersectPointfrom2Pmatrix(P_1,P_2,img1_NCOG,img2_NCOG); 
%     x_1 = P_1*X;
%     x_2 = P_2*X;
%     
%     % get geometric distance
%     RMS_1 = Backprojectionerror(img1_NCOG,X,P_1);
%     RMS_2 = Backprojectionerror(img2_NCOG,X,P_2);    
%     geometric_distance = sqrt(RMS_1^2+RMS_2^2);
    
    % do gold standard estimation (From book of Hartley 2004. Page 285 
    %Algorithms 11.3 : The Gold Standard algorithm 
    %for estimating F from image correspondences.)
    F = lsqnonlin(@geometric_distance,F_initial);
%     dis = geometric_distance(vec_F);
%     clear img1_NCOG img2_NCOG;

end