% this function is used to extract image features using affine match methods
% return the index of simulated views, where the features locate
function [frames_Aff,descrs_Aff,feature_inwhichview,frames_insimulatedimage_index] = Chen_ExtractedAffineimageFeatures2(img_path,feature_detector_type,descriptor_type,n,a,b)
A = imread(img_path);
if(size(A,3)>1)
    A_Image = rgb2gray(A);
else
    A_Image = A;
end

size_img = size(A_Image);
% first detect features in original image.
% if (strcmp(feature_detector_type,'fast12')~=1)&&(strcmp(feature_detector_type,'mser')~=1)
%     A_Image = im2single(A_Image);
%     [frames_origin, descrs_origin] = vl_covdet(A_Image, 'Method',feature_detector_type,'descriptor', descriptor_type,'PatchResolution',31,'Doubleimage',false,'Verbose','EstimateAffineShape', true) ;
% else
%     if strcmp(feature_detector_type,'fast12')==1
%         c12 = fast12(A_Image, 30,1);
%         frames_origin = c12(:,1:2)';
%     end
%     if strcmp(feature_detector_type,'mser')==1
%         [r,fmser] = vl_mser(A_Image,'MinDiversity',0.7,...
%                 'MaxVariation',0.2,...
%                 'MinArea',0.00005,...
%                 'Delta',10);
%             fmser = vl_ertr(fmser) ;
%             frames_origin = fmser(1:2,:);        
%     end
% end
% 
% for kk = 1:size(frames_origin,2)
%     frames_Aff = frames_origin;
%     descrs_Aff = descrs_origin;
% end


[aff_img] =  Chen_fullyaff_images_generate(A_Image,a,b,n);

% generate features in training samples
for ii=1:n+1
    t(ii)=a^(ii-1);
    k(ii) = floor(t(ii)*180/b)+1;
end

sum_feature_num = 0;

for ii=1:n
    for jj=1:k(ii)
        lat = t(ii);
        log = (jj-1)*b*pi/(180*lat);
        tform =Chen_AffineTransform( acos(1./lat),log,0,1,0,0);
        current_affimg = aff_img{ii,jj};
        
        % detect features in the current affined image
        if (strcmp(feature_detector_type,'fast12')~=1)&&(strcmp(feature_detector_type,'mser')~=1)
            current_affimg = im2single(current_affimg);
            [frames, descrs] = vl_covdet(current_affimg, 'Method',feature_detector_type, 'descriptor', descriptor_type,'PatchResolution',31,'Doubleimage',false,...
                'Verbose','EstimateAffineShape', false, 'EstimateOrientation', true, 'PeakThreshold',0.03) ;
        else
            if strcmp(feature_detector_type,'fast12')==1
                c12a = fast12(current_affimg, 30,1);
                frames = c12a(:,1:2)';
            end
            if strcmp(feature_detector_type,'mser')==1
                [r,fmser1] = vl_mser(A_Image,'MinDiversity',0.7,...
                    'MaxVariation',0.2,...
                    'MinArea',0.00005,...
                    'Delta',10);
                fmser1 = vl_ertr(fmser1) ;
                frames = fmser1(1:2,:);   
                clear fmser1;
            end
        end
%         [xtrans, ytrans] = Chen_Get_Trans_By_Angle(size_img,tform.T);
        [xlim_final,ylim_final,x_scale, y_scale,outputRef] = Chen_Get_Map_FromWarpedImagetoAffinedImageCoord(size_img,tform.T);
        Num_currentFeatures = size(frames,2);  
        for kkk = 1:Num_currentFeatures
            [frames_c(1,kkk) frames_c(2,kkk)] = outputRef.intrinsicToWorld(frames(1,kkk),frames(2,kkk));
            [affine_frames(1,kkk) affine_frames(2,kkk)] = transformPointsInverse(tform,frames_c(1,kkk),frames_c(2,kkk));
        end
        clear frames_c;
%         x_center = xlim_final(1) + diff(xlim_final)/2;
%         y_center = ylim_final(1) + diff(ylim_final)/2;
%        
%         % first convert to the enlarged affine image coordinates
%         frames(1,:) = frames(1,:)+outputRef.XWorldLimits(1)-0.5;
%         frames(2,:) = frames(2,:)+outputRef.YWorldLimits(1)-0.5;
%         
%         % then convert to the original affine image area
%         frames(1,:) = (frames(1,:)-y_center)*(1.0/y_scale) + y_center;
%         frames(2,:) = (frames(2,:)-x_center)*(1.0/x_scale) + x_center;
%         
%         % before transformation, must exchange the x and y coordinates in
%         % the first and second row, this is due to the different coordinate
%         % used in vlfeat and matlab
%         inv_T_temp = inv(tform.T);
%         current_frames = frames(1:2,:);
%         current_frames(3,:) =1;
%         NNframe = current_frames;
%         NNframe(1,:)= current_frames(2,:);
%         NNframe(2,:)= current_frames(1,:);
%         NNframe(3,:)=1;
%         newfeatures = inv_T_temp*NNframe;%         newfeatures = inv_T_temp*current_frames;
%         
%         % convert the frames back into original image keypoint coordinates
%         frames(1,:) = newfeatures(2,:);
%         frames(2,:) = newfeatures(1,:);

%         frames(1:2,:) = newfeatures(1:2,:);
        frames(1,:) = affine_frames(1,:);
        frames(2,:) = affine_frames(2,:);
        % record the features and matches
        current_Numfeatures = size(frames,2);
        for kk = 1:size(frames,2)
            frames_Aff(:,sum_feature_num+kk) = frames(:,kk);
            descrs_Aff(:,sum_feature_num+kk) = descrs(:,kk);
            frames_insimulatedimage_index(:,sum_feature_num+kk)=kk;
        end
        feature_inwhichview(sum_feature_num+1:sum_feature_num+current_Numfeatures,1) = ii;
        feature_inwhichview(sum_feature_num+1:sum_feature_num+current_Numfeatures,2) = jj;
        sum_feature_num = sum_feature_num+current_Numfeatures;
        clear frames;
        clear affine_frames;

% %         frames(:,1) = frames(:,1)-xtrans;
% %         frames(:,2) = frames(:,2)-ytrans;% translate the coordinate to original affined version image
%         frames(1,:) = frames(1,:)-ytrans;
%         frames(2,:) = frames(2,:)-xtrans;% translate the coordinate to original affined version image
%         [index_ifrepeat_1stimg,repeated_feature_index_2ndimg] = Chen_analy_repeatedfeatures_in_2Images(frames_origin, frames,tform.T,similarity_threshold);
%         frames_aff{ii,jj} = frames;
% %         descrs_aff{ii,jj} = descrs;
%         aff_mat{ii,jj} = tform.T;%jj means the rotation around latitude
%         repeat_score(ii,jj) = sum(index_ifrepeat_1stimg)/min(size(frames,2),size(frames_origin,2));
%         index_origin_image{ii,jj} = index_ifrepeat_1stimg;
%         index_aff_image{ii,jj} = repeated_feature_index_2ndimg;
    end
end


end