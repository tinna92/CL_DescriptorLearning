function [geodis] = geometric_distance(F,img1_NCOG,img2_NCOG)
    
    [P_1,P_2]=Build_P_fromFundMat(F);
%     global img1_NCOG img2_NCOG;
    % compute points and reproject   
    [X]=IntersectPointfrom2Pmatrix(P_1,P_2,img1_NCOG,img2_NCOG); 
%     x_1 = P_1*X;
%     x_2 = P_2*X;
    
    % get geometric distance
    RMS_1 = Backprojectionerror(img1_NCOG,X,P_1);
    RMS_2 = Backprojectionerror(img2_NCOG,X,P_2);    
    geodis = sqrt(RMS_1^2+RMS_2^2);
    
end
  