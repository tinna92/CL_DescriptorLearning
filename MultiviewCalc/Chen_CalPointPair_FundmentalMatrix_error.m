function [currentError] = Chen_CalPointPair_FundmentalMatrix_error(F_matrix,Points_2D_pic_a,Points_2D_pic_b)
Epipolar_line_a = Points_2D_pic_b*F_matrix;
Epipolar_line_b = Points_2D_pic_a*F_matrix';
Match_Num = size(Points_2D_pic_b,1);
for ii=1:Match_Num
    a = Epipolar_line_a(ii,1);
    b = Epipolar_line_a(ii,2);
    c = Epipolar_line_a(ii,3);
    error = abs(Epipolar_line_a(ii,:)*Points_2D_pic_a(ii,1:3)');
    currentError(ii) = error/sqrt(a.^2+b.^2);
    
    a = Epipolar_line_b(ii,1);
    b = Epipolar_line_b(ii,2);
    c = Epipolar_line_b(ii,3);
    error = abs(Epipolar_line_b(ii,:)*Points_2D_pic_b(ii,1:3)');
    
    currentError(ii) = currentError(ii) + error/sqrt(a.^2+b.^2);
%     fprintf('%f, ', error);
end
end