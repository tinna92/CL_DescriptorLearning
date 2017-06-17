% x_limfinal, y_limfinal is the coordinates in imwarp for better fitting to
% intergral coordinates
% x_scale and y_scale is the scale factor for converting world coordintes
% back to original affined image coordinates.
% outputRef: the ref used in imwarp for resampling and image generating
function [xlim_final,ylim_final,x_scale, y_scale,outputRef] = Chen_Get_Map_FromWarpedImagetoAffinedImageCoord(size_img,aff_T)
width = size_img(2);
height = size_img(1);
% corners = [1,1;width,1;width,height;1,height];
aff_T = affine2d(aff_T);
[xlim,ylim] = outputLimits(aff_T,[0.5 width+0.5],[0.5 height+0.5]);
numCols = ceil(diff(xlim));
numRows = ceil(diff(ylim));
xNudge = (ceil( diff(xlim))-diff(xlim))/2;
yNudge = (ceil( diff(ylim))-diff(ylim))/2;
xlim_final = xlim + [-xNudge xNudge];
ylim_final = ylim + [-yNudge yNudge];
x_center = xlim(1) + diff(xlim)/2;
y_center = ylim(1) + diff(ylim)/2;
% [xxx, yyy] = intrinsicToWorld(outputRef,100.5,200.5);
% 
% xtrans = 0.5-xlim_final(1);
% ytrans = 0.5-ylim_final(1);
x_scale = (xlim_final(1) - x_center)/(xlim(1) - x_center);
y_scale = (ylim_final(1) - y_center)/(ylim(1) - y_center);

% get the ref2d of mapping from transformed image coordinate to
% affined image coordinate
outputImageSize = [numRows numCols];
outputRef = imref2d(outputImageSize,xlim_final,ylim_final);

% xtrans = 0.5 - xlim(1);
% ytrans = 0.5 - ylim(1);
end



% aff_T = affine2d(aff_mat{3,2});
% [xlim ylim] = outputLimits(aff_T,[1 666],[1 999]);
% 
% width = size_img(2);
% height = size_img(1);
% corners = [1,1;width,1;width,height;1,height];
% corners(:,3) = 1;
% corners*aff_T.T;

% 
% void GetTransByAngle(double a[2][2],int ws,int hs,int *width,int *height,double *t1,double *t2)
% {	
% 	//利用线性变换因子计算角点坐标
% 	double coner_x[4],coner_y[4];
% 	coner_x[0]=a[0][0]*ws+a[0][1]*hs;coner_y[0]=a[1][0]*ws+a[1][1]*hs;
% 	coner_x[1]=a[0][0]*0 +a[0][1]*hs;coner_y[1]=a[1][0]*0 +a[1][1]*hs;
% 	coner_x[2]=a[0][0]*0 + a[0][1]*0;coner_y[2]=a[1][0]*0 + a[1][1]*0;
% 	coner_x[3]=a[0][0]*ws+a[0][1]*0 ;coner_y[3]=a[1][0]*ws +a[1][1]*0;
% 	
% 	//得到边界点并计算新图像的大小
% 	double xmax=MAX(MAX(coner_x[0],coner_x[1]),MAX(coner_x[2],coner_x[3]));
% 	double xmin=MIN(MIN(coner_x[0],coner_x[1]),MIN(coner_x[2],coner_x[3]));
% 	double ymax=MAX(MAX(coner_y[0],coner_y[1]),MAX(coner_y[2],coner_y[3]));
% 	double ymin=MIN(MIN(coner_y[0],coner_y[1]),MIN(coner_y[2],coner_y[3]));
% 	
% 	*width =(int)(xmax-xmin);
% 	*height=(int)(ymax-ymin);//新图像宽高度
% 	*t1=0-xmin;
% 	*t2=0-ymin;//2*3仿射矩阵中的平移向量
% 	
% }