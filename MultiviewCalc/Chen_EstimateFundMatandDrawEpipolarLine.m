% this file is used to test whether the fundmental matrix estimation is
% correct or not
formatSpec = '%f';
size2d_norm = [2 Inf];

% file_2d_pic_a = fopen('../data/pts2d-pic_a.txt','r');
% file_2d_pic_b = fopen('../data/pts2d-pic_b.txt','r');
file_2d_pic_a = fopen('pts2d-pic_a.txt','r');
file_2d_pic_b = fopen('pts2d-pic_b.txt','r');
Points_2D_pic_a = fscanf(file_2d_pic_a,formatSpec,size2d_norm)';
Points_2D_pic_b = fscanf(file_2d_pic_b,formatSpec,size2d_norm)';
Points_2D_pic_a(:,3)=1;
Points_2D_pic_b(:,3)=1;
% ImgLeft  = imread('../data/pic_a.jpg');
% ImgRight = imread('../data/pic_b.jpg');
ImgLeft  = imread('pic_a.jpg');
ImgRight = imread('pic_b.jpg');

% %(Optional) You might try adding noise for testing purposes:
% Points_2D_pic_a = Points_2D_pic_a + 6*rand(size(Points_2D_pic_a))-0.5;
% Points_2D_pic_b = Points_2D_pic_b + 6*rand(size(Points_2D_pic_b))-0.5;

%% Calculate the fundamental matrix given corresponding point pairs
% !!! You will need to implement estimate_fundamental_matrix. !!!a
F_matrix = estimateFundMatFromimagePoints(Points_2D_pic_a, Points_2D_pic_b');

%% Draw the epipolar lines on the images
draw_epipolar_lines(F_matrix,ImgLeft,ImgRight,Points_2D_pic_a(:,1:2),Points_2D_pic_b(:,1:2));

for ii=1:20
    error = Points_2D_pic_a(ii,1:3)*F_matrix*Points_2D_pic_b(ii,1:3)';
    fprintf('%f, ', error);
end

error = Points_2D_pic_a*F_matrix*(Points_2D_pic_b)';% in the principle dialog direction is the main error.

% ??????????? Pay attention to the multiply oder

Epipolar_line = Points_2D_pic_b*F_matrix;
for ii=1:20
    a = Epipolar_line(ii,1);
    b = Epipolar_line(ii,2);
    c = Epipolar_line(ii,3);
    error = abs(Epipolar_line(ii,:)*Points_2D_pic_a(ii,1:3)');
    error = error/sqrt(a.^2+b.^2);
    fprintf('%f, ', error);
end