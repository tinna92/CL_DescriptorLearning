% read the truncated coarse orientation information from INS, evaluate the
% footprint of every image, analysis the image overlapping and form the
% report.
% 'E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Orientation_Calibration\image_orientation_truncated.txt';

% first read truncated orientation result
[a1,a2,a3,a4,a5,a6,a7]=textread(...
'E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Orientation_Calibration\image_orientation_truncated.txt',...
'%s%f%f%f%f%f%f','headerlines',0);
% orignize the data into exterior parameters form
Num = size(a1,1);
index = 1:Num;
X(index) = a2(index);
Y(index) = a3(index);
Z(index) = a4(index);
row(index) = a5(index)*pi/180;
pitch(index) = a6(index)*pi/180;
kappa(index) = a7(index)*pi/180;

omi(index) = a5(index)*pi/180;
phi(index) = a6(index)*pi/180;
kappa(index) = a7(index)*pi/180;

% 145			82.037		24.419		18.343
% 147			82.045		24.335		18.02
% 148			81.938		24.186		18.185
% 159			81.86		24.348		18.368
% 163 			50.193		18.345  	24.507 nadir camera
k145 = [82.037,0,24.419;0,82.037,18.343;0 0 1];
k147 = [82.045,0,24.335;0,82.045,18.02 ;0 0 1];
k148 = [81.938,0,24.186;0,81.938,18.185 ;0 0 1];
k159 = [81.86,0,24.348;0,81.86,18.368 ;0 0 1];
k163 = [50.193,0,18.345;0,50.193,24.507 ;0 0 1];
k145(1:2,:)= k145(1:2,:)/0.006;
k147(1:2,:)= k147(1:2,:)/0.006;
k148(1:2,:)= k148(1:2,:)/0.006;
k159(1:2,:)= k159(1:2,:)/0.006;
k163(1:2,:)= k163(1:2,:)/0.006;
K{1} = k145;
K{2} = k147;
K{3} = k148;
K{4} = k159;
K{5} = k163;
% fp[0] = a1 = cos(phi)*cos(kappa) - sin(phi)*sin(omiga)*sin(kappa);
% fp[1] = a2 = -cos(phi)*sin(kappa) - sin(phi)*sin(omiga)*cos(kappa);
% fp[2] = a3 = -sin(phi)*cos(omiga);
% 
% fp[3] = b1 = cos(omiga)*sin(kappa);
% fp[4] = b2 = cos(omiga)*cos(kappa);
% fp[5] = b3 = -sin(omiga);
% 
% fp[6] = c1 = sin(phi)*cos(kappa) + cos(phi)*sin(omiga)*sin(kappa);
% fp[7] = c2 = -sin(phi)*sin(kappa) + cos(phi)*sin(omiga)*cos(kappa);
% fp[8] = c3 = cos(phi)*cos(omiga);
for index = 1:Num
    % determine the type of camera
    if(strfind(a1{index},'_145')==8)
        Cam_Type(index) = 1;
    else
        if(strfind(a1{index},'_147')==8)
            Cam_Type(index) = 2;
        else
            if(strfind(a1{index},'_148')==8)
                Cam_Type(index) = 3;
            else
                if(strfind(a1{index},'_159')==8)
                Cam_Type(index) = 4;
                else
                    if(strfind(a1{index},'_163')==8)
                        Cam_Type(index) = 5;
                    end
                end
            end
        end
    end
    
    % calculate R matrix
%     R(1,1,index) = cos(row(index))*cos(kappa(index)) - sin(row(index))*sin(pitch(index))*sin(kappa(index));
%     R(1,2,index) = -cos(row(index))*sin(kappa(index)) - sin(row(index))*sin(pitch(index))*cos(kappa(index));
%     R(1,3,index) = -sin(row(index))*cos(pitch(index));
%     R(2,1,index) = cos(row(index))*sin(kappa(index));
%     R(2,2,index) = cos(row(index))*cos(kappa(index));
%     R(2,3,index) = -sin(row(index));
%     R(3,1,index) = sin(row(index))*cos(kappa(index)) + cos(row(index))*sin(pitch(index))*sin(kappa(index));
%     R(3,2,index) = -sin(row(index))*sin(kappa(index)) + cos(row(index))*sin(pitch(index))*cos(kappa(index));
%     R(3,3,index) = cos(row(index))*cos(pitch(index));
% [R] = Chen_getrotationmatrix(omi,phi,kappa);
R(1,1,index) = cos(phi(index))*cos(kappa(index));
R(1,2,index) = -cos(phi(index))*sin(kappa(index)) ;
R(1,3,index) = sin(phi(index)) ;
R(2,1,index) = sin(omi(index))*sin(phi(index))*cos(kappa(index))+cos(omi(index))*sin(kappa(index));
R(2,2,index) = -sin(omi(index))*sin(phi(index))*sin(kappa(index))+cos(omi(index))*cos(kappa(index));
R(2,3,index) = -sin(omi(index))*cos(phi(index));
R(3,1,index) = -cos(omi(index))*sin(phi(index))*cos(kappa(index)) + sin(omi(index))*sin(kappa(index));
R(3,2,index) = cos(omi(index))*sin(phi(index))*sin(kappa(index)) + sin(omi(index))*cos(kappa(index));
R(3,3,index) = cos(omi(index))*cos(phi(index));
% R(1,3,index) = sin(kappa(index))*sin(pitch(index))-cos(row(index));
% R(1,1,index) = cos(row(index))*cos(kappa(index)) - sin(row(index))*sin(pitch(index))*sin(kappa(index));
%     R(1,2,index) = -cos(row(index))*sin(kappa(index)) - sin(row(index))*sin(pitch(index))*cos(kappa(index));
%     R(1,3,index) = -sin(row(index))*cos(pitch(index));
%     R(2,1,index) = cos(row(index))*sin(kappa(index));
%     R(2,2,index) = cos(row(index))*cos(kappa(index));
%     R(2,3,index) = -sin(row(index));
%     R(3,1,index) = sin(row(index))*cos(kappa(index)) + cos(row(index))*sin(pitch(index))*sin(kappa(index));
%     R(3,2,index) = -sin(row(index))*sin(kappa(index)) + cos(row(index))*sin(pitch(index))*cos(kappa(index));
%     R(3,3,index) = cos(row(index))*cos(pitch(index));
    
    C_Matrix(1:3,4,index) = -K{Cam_Type(index)}*R(:,:,index)*[X(index) Y(index) Z(index)]';
    C_Matrix(1:3,1:3,index) = K{Cam_Type(index)}*R(:,:,index);
    
    
end
% 013_005_163000070,mtpGCP43,3234.8986,570.6551
% GCP28 = [391533.354,5708796.414,125.133]';
% GCP43 = [391533.354,5708796.414,125.133]';
% 001_017_163000274,mtpGCP34,2207.3888,5219.3221
GCP34 = [394768.762,5706840.905,162.493,1]';
C_Matrix(:,:,236)*GCP34
R236 = R(:,:,236);
[xxx, yyy] = Chen_calculateimagecoordfromColinerequation([X(236) Y(236) Z(236)],GCP34, R(:,:,236),k163(1,1),k163(1,3),k163(2,3));

% 005_017_163000202,mtpGCP57,4461.2192,5972.7393
% why this point is not correct??
GCP57 = [394851.604,5707811.982,138.227,1]';
[xxx, yyy] = Chen_calculateimagecoordfromColinerequation([X(164) Y(164) Z(164)],GCP57, R(:,:,164),k163(1,1),k163(1,3),k163(2,3))

% 007_001_163000182,mtpGCP42,4627.2021,2806.3850
GCP42= [391630.781,5708186.637,124.454,1]';
[xxx, yyy] = Chen_calculateimagecoordfromColinerequation([X(144) Y(144) Z(144)],GCP42, R(:,:,144),k163(1,1),k163(1,3),k163(2,3))


% mtpGCP57,394851.604,5707811.982,138.227
% 013_017_159000058,mtpGCP57,2235.5208,452.6411
% 013_017_159000058   394651 5709105      977 -44.   0. -179.

[xxx, yyy] = Chen_calculateimagecoordfromColinerequation([X(524) Y(524) Z(524)],GCP57, R(:,:,524),k159(1,1),k159(1,3),k159(2,3));
x236 = k163(1,3)-k163(1,1)*(R236(1,1)*(GCP34(1)-X(236))+R236(2,1)*(GCP34(2)-Y(236))+R236(3,1)*(GCP34(3)-Z(236)))...
    /(R236(1,3)*(GCP34(1)-X(236))+R236(2,3)*(GCP34(2)-Y(236))+R236(3,3)*(GCP34(3)-Z(236)));
y236 = k163(2,3)-k163(1,1)*(R236(1,2)*(GCP34(1)-X(236))+R236(2,2)*(GCP34(2)-Y(236))+R236(3,2)*(GCP34(3)-Z(236)))...
    /(R236(1,3)*(GCP34(1)-X(236))+R236(2,3)*(GCP34(2)-Y(236))+R236(3,3)*(GCP34(3)-Z(236)));
