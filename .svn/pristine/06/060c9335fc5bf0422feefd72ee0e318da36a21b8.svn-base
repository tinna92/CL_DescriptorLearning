image_name = 'G0026678_scaled.JPG';
A = imread(image_name);
if(size(A,3)>1)
    A_Image = rgb2gray(A);
else
    A_Image = A;
end
img = A_Image;
size_img = size(A_Image);
n = 4;a=1.2;b=72;
% [aff_img] =  Chen_fullyaff_images_generate(A_Image,a,b,n);
feature_detector_type = 'DoG';
[frames_origin, descrs_origin] = vl_covdet(single(A_Image), 'Method',feature_detector_type,'descriptor', 'Patch',...
    'PatchResolution',31,'Doubleimage',false,'Verbose','EstimateAffineShape', true) ;


for ii=1:n+1
    t(ii)=a^(ii-1);
    k(ii) = floor(t(ii)*180/b)+1;
end

for iii=1:n
    for jj=1:k(iii)
        lat = t(iii);
        log = (jj-1)*b*pi/(180*lat);
        tform =Chen_AffineTransform( acos(1./lat),log,0,1,0,0);
        lamda =1;
        latitude = acos(1./lat);
        longitude=log;
        camera_rotation=0;
        t1=0;t2=0;
        lam_t = [lamda,0;0,lamda];
        camrot_t = [cos(camera_rotation),-sin(camera_rotation);sin(camera_rotation),cos(camera_rotation)];
        t_t = [abs(1/cos(latitude)),0;0,1];
        long_t = [cos(longitude),-sin(longitude);sin(longitude),cos(longitude)];
        affinematrix = lam_t*camrot_t*t_t*long_t;
        out_affinematrix(1:2,1:2)=affinematrix;
        out_affinematrix(1:2,3)=[t1;t2];
        out_affinematrix(3,1:3)=[0,0,1];
        
        
        
        
        outputImage = imwarp(img,tform);
        [xlim_final,ylim_final,x_scale, y_scale,outputRef] = Chen_Get_Map_FromWarpedImagetoAffinedImageCoord(size_img,tform.T);
%         t1 = -outputRef.XWorldLimits(1)+0.5;
%         t2 = -outputRef.YWorldLimits(1)+0.5;
%         out_affinematrix(1:2,3)=[t1;t2];
%         inv_affinematrix = inv(out_affinematrix);
        aff_img{iii,jj} = outputImage;
        imwrite(uint8(outputImage),[num2str(iii) num2str(jj-1) 'affined_image.jpg']);
        current_affimg = aff_img{iii,jj};
        current_affimg = im2single(current_affimg);
        [frames, descrs] = vl_covdet(current_affimg, 'Method',feature_detector_type,'descriptor', 'Patch','PatchResolution',31,'Doubleimage',false,'Verbose','EstimateAffineShape', true) ;
        Num_currentFeatures = size(frames,2);  
        for kkk = 1:Num_currentFeatures
            [frames_c(1,kkk) frames_c(2,kkk)]=outputRef.intrinsicToWorld(frames(1,kkk),frames(2,kkk));
            [affine_frames(1,kkk) affine_frames(2,kkk)] = transformPointsInverse(tform,frames_c(1,kkk),frames_c(2,kkk));
%             affine_frames(1,kkk) = frames(1,kkk)*inv_affinematrix(1,1) + frames(2,kkk)*inv_affinematrix(1,2)+inv_affinematrix(1,3);
%             affine_frames(2,kkk) = frames(1,kkk)*inv_affinematrix(2,1) + frames(2,kkk)*inv_affinematrix(2,2)+inv_affinematrix(2,3);
%             affine_frames(1,kkk) = frames_c(1,kkk)*inv_affinematrix(1,1) + frames_c(2,kkk)*inv_affinematrix(1,2)+inv_affinematrix(1,3);
%             affine_frames(2,kkk) = frames_c(1,kkk)*inv_affinematrix(2,1) + frames_c(2,kkk)*inv_affinematrix(2,2)+inv_affinematrix(2,3);
        end
        
        Num = Num_currentFeatures;        
        draw_color = ['g','r','c','m','y','k'];
        draw_color_index =  mod(randperm(Num,Num),6)+1;
        [Tag_ori_left,Tag_ori_right,Tag_ori_top,Tag_ori_bottom] = Chen_Getcrossmark(affine_frames,5);% for showing positions
        figure(1);
        imshow(A,[0 1]);
        hold on;
        qqq = randperm(Num,5);
        if Num>0
            for nnn=1:5
                ii = qqq(nnn);
                plot([Tag_ori_left(1,ii),Tag_ori_right(1,ii)],[Tag_ori_left(2,ii),Tag_ori_right(2,ii)],draw_color(draw_color_index(ii)),'linewidth',1);
                plot([Tag_ori_top(1,ii),Tag_ori_bottom(1,ii)],[Tag_ori_top(2,ii),Tag_ori_bottom(2,ii)],draw_color(draw_color_index(ii)),'linewidth',1);
            end
        end
        
        f = getframe(gcf);              %# Capture the current window
        imwrite(f.cdata,([num2str(iii) num2str(jj) 'original.jpg']));  %# Save the frame data
%         imsave(uint8(255*outputImage),[num2str(ii) num2str(jj-1) 'affined_image.jpg']);
        close 1;
        figure(2);
        imshow(current_affimg,[0 1]);
        [Tag_aff_left,Tag_aff_right,Tag_aff_top,Tag_aff_bottom] = Chen_Getcrossmark(frames,5);% for showing positions
        hold on;% get the point coordinates for cross marks drawing
        if Num>0
            for nnn=1:5   
                ii = qqq(nnn);
                plot([Tag_aff_left(1,ii),Tag_aff_right(1,ii)],[Tag_aff_left(2,ii),Tag_aff_right(2,ii)],draw_color(draw_color_index(ii)),'linewidth',1);
                plot([Tag_aff_top(1,ii),Tag_aff_bottom(1,ii)],[Tag_aff_top(2,ii),Tag_aff_bottom(2,ii)],draw_color(draw_color_index(ii)),'linewidth',1);
            end
        end 
        
        f = getframe(gcf);              %# Capture the current window
        imwrite(f.cdata,([num2str(iii) num2str(jj) 'onaffined.jpg']));  %# Save the frame data
        
        clear frames_c;
        close 2;
        
    end
end

