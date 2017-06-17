% + 1-x_bottom or 0-x_bottom, I am not so sure on this point.
% change to 0-x_bottom : 18.08.2015. but the first image appears wrong!
% first compute limit, then adjust the center to center (changed
% 18.08.2015)
function [xtrans, ytrans] = Chen_Get_Trans_By_Angle(size_img,aff_T)
width = size_img(2);
height = size_img(1);
% corners = [1,1;width,1;width,height;1,height];
aff_T = affine2d(aff_T);
[xlim,ylim] = outputLimits(aff_T,[0.5 width+0.5],[0.5 height+0.5]);

xNudge = (ceil( diff(xlim))-diff(xlim))/2;
yNudge = (ceil( diff(ylim))-diff(ylim))/2;
xlim_final = xlim + [-xNudge xNudge];
ylim_final = ylim + [-yNudge yNudge];
xtrans = 0.5-xlim_final(1);
ytrans = 0.5-ylim_final(1);

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