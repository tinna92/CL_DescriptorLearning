image_name = '000003-111406161250-04.tifresize.png';
% image_name = 'box.png';
% image_name = 'test.PNG';
similarity_threshold = 2.0;
A = imread(image_name);
if(size(A,3)>1)
    A_Image = rgb2gray(A);
else
    A_Image = A;
end
A_Image = im2single(A_Image);
size_img = size(A_Image);
% first detect features in original image.
[frames_origin, descrs_origin] = vl_covdet(A_Image, 'Method','HessianLaplace','descriptor', 'Patch','PatchResolution',31,'Doubleimage',false,'Verbose','EstimateAffineShape', true) ;
% generate the fully affined images according to ASIFT paper
% n = 6;
% a = sqrt(2);
% b = 72;
n = 5;
a = sqrt(2);
b = 80;
[aff_img] =  Chen_fullyaff_images_generate(A_Image,sqrt(2),b,n);

% generate features in training samples
for ii=1:n+1
    t(ii)=a^(ii-1);
    k(ii) = floor(t(ii)*180/b)+1;
end

for ii=1:n
    for jj=1:k(ii)
        lat = t(ii);
        log = (jj-1)*b*pi/(180*lat);
        tform =Chen_AffineTransform( acos(1./lat),log,0,1,0,0);
        current_affimg = aff_img{ii,jj};
        current_affimg = im2single(current_affimg);
        % detect features in the current affined image
        [frames, descrs] = vl_covdet(current_affimg, 'Method','HessianLaplace','descriptor', 'Patch','PatchResolution',31,'Doubleimage',false,'Verbose','EstimateAffineShape', true) ;
%         [xtrans, ytrans] = Chen_Get_Trans_By_Angle(size_img,tform.T);
        [xlim_final,ylim_final,x_scale, y_scale,outputRef] = Chen_Get_Map_FromWarpedImagetoAffinedImageCoord(size_img,tform.T);
        x_center = xlim_final(1) + diff(xlim_final)/2;
        y_center = ylim_final(1) + diff(ylim_final)/2;
        frames(1,:) = (frames(1,:)-y_center)*(1.0/y_scale) + y_center;
        frames(2,:) = (frames(2,:)-x_center)*(1.0/x_scale) + x_center;
% %         frames(:,1) = frames(:,1)-xtrans;
% %         frames(:,2) = frames(:,2)-ytrans;% translate the coordinate to original affined version image
%         frames(1,:) = frames(1,:)-ytrans;
%         frames(2,:) = frames(2,:)-xtrans;% translate the coordinate to original affined version image
        [index_ifrepeat_1stimg,repeated_feature_index_2ndimg] = Chen_analy_repeatedfeatures_in_2Images(frames_origin, frames,tform.T,similarity_threshold);
        frames_aff{ii,jj} = frames;
        descrs_aff{ii,jj} = descrs;
        aff_mat{ii,jj} = tform.T;%jj means the rotation around latitude
        repeat_score(ii,jj) = sum(index_ifrepeat_1stimg)/min(size(frames,2),size(frames_origin,2));
        index_origin_image{ii,jj} = index_ifrepeat_1stimg;
        index_aff_image{ii,jj} = repeated_feature_index_2ndimg;
    end
end
% analyze repeated features between image pairs

%% the next step, show the repeated features in different images
% from this process we can see if we have get the right features
index_ifrepeat_1stimg = index_origin_image{4,1};
% get the point coordinates for cross marks drawing
Num = sum(index_ifrepeat_1stimg);
draw_color = ['g','r','c','m','y','k'];
draw_color_index =  mod(randperm(Num,Num),6)+1;
[Tag_ori_left,Tag_ori_right,Tag_ori_top,Tag_ori_bottom] = Chen_Getcrossmark(frames_origin,5);% for showing positions
figure(1);
imshow(A);
hold on;

if Num>0
    [xxx,index_oriimage] = find(index_ifrepeat_1stimg==1);
    for jjj=1:Num
        ii = index_oriimage(jjj);
        plot([Tag_ori_left(1,ii),Tag_ori_right(1,ii)],[Tag_ori_left(2,ii),Tag_ori_right(2,ii)],draw_color(draw_color_index(jjj)),'linewidth',1);
        plot([Tag_ori_top(1,ii),Tag_ori_bottom(1,ii)],[Tag_ori_top(2,ii),Tag_ori_bottom(2,ii)],draw_color(draw_color_index(jjj)),'linewidth',1);
    end
end

figure(2);
imshow(uint8(255*aff_img{4,1}));
[Tag_aff_left,Tag_aff_right,Tag_aff_top,Tag_aff_bottom] = Chen_Getcrossmark(frames_aff{4,1},5);% for showing positions
hold on;% get the point coordinates for cross marks drawing
if Num>0
    for jjj=1:Num
        ii = index_aff_image{4,1}(jjj);
        plot([Tag_aff_left(1,ii),Tag_aff_right(1,ii)],[Tag_aff_left(2,ii),Tag_aff_right(2,ii)],draw_color(draw_color_index(jjj)),'linewidth',1);
        plot([Tag_aff_top(1,ii),Tag_aff_bottom(1,ii)],[Tag_aff_top(2,ii),Tag_aff_bottom(2,ii)],draw_color(draw_color_index(jjj)),'linewidth',1);
    end
end

