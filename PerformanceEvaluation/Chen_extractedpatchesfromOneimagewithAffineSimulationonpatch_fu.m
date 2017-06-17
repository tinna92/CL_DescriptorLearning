%in this file, extract features in both one and its affine transformed
%images. orignize them into positive and negative patch pairs
%  A = imread([Imgpath D(iFile).name]);
function [affine_patch_pos,affine_patch_neg]=Chen_extractpatchesfromoneimagewithAffSimuonpatch_func(image_name,feature_detector_type,n,a,b,similarity_threshold)
% similarity_threshold = 0.5;
% image_name = '000003-111406161250-04.tifresize.png';
% feature_detector_type = 'DoG';
% n=4;
% a=sqrt(2);
% b=72;
% similarity_threshold = 1.0;
 A = imread(image_name);
 if(size(A,3)>1)
     A_Image = rgb2gray(A);
 else
     A_Image = A;
 end
 
 size_img = size(A_Image);
% first detect features in original image.
if (strcmp(feature_detector_type,'fast12')~=1)&&(strcmp(feature_detector_type,'mser')~=1)
    A_Image = im2single(A_Image);
    [frames_origin, descrs_origin] = vl_covdet(A_Image, 'Method',feature_detector_type,'descriptor', 'Patch','PatchResolution',31,'Doubleimage',false,'Verbose','EstimateAffineShape', false,'EstimateOrientation', true) ;
else
    if strcmp(feature_detector_type,'fast12')==1
        c12 = fast12(A_Image, 30,1);
        frames_origin = c12(:,1:2)';
    end
    if strcmp(feature_detector_type,'mser')==1
        [r,fmser] = vl_mser(A_Image,'MinDiversity',0.7,...
                'MaxVariation',0.2,...
                'MinArea',0.00005,...
                'Delta',10);
            fmser = vl_ertr(fmser) ;
            frames_origin = fmser(1:2,:);        
    end
end

 
[aff_img] =  Chen_fullyaff_images_generate(A_Image,a,b,n);

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
        
        % detect features in the current affined image
        if (strcmp(feature_detector_type,'fast12')~=1)&&(strcmp(feature_detector_type,'mser')~=1)
            current_affimg = im2single(current_affimg);
            [frames, descrs] = vl_covdet(current_affimg, 'Method',feature_detector_type,'descriptor', 'Patch','PatchResolution',31,'Doubleimage',false,'Verbose','EstimateAffineShape', false,'EstimateOrientation', true) ;
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
            [frames_c(1,kkk) frames_c(2,kkk)]=outputRef.intrinsicToWorld(frames(1,kkk),frames(2,kkk));
            [affine_frames(1,kkk) affine_frames(2,kkk)] = transformPointsInverse(tform,frames_c(1,kkk),frames_c(2,kkk));
        end
        
        % here we record the repeated features for every pair of affined and
        % original image
        [index_ifrepeat_1stimg,repeated_feature_index_2ndimg] = Chen_analy_repeatedfeatures_in_2Images2(frames_origin, affine_frames,tform.T,similarity_threshold);
%         index_ifrepeated_1stimgmark{ii,jj}=index_ifrepeat_1stimg;
%         index_feature_repeatedfeaturein2ndimg{ii,jj}=repeated_feature_index_2ndimg;
        
        
        clear frames_c;
        frames_aff{ii,jj} = frames;
        descrs_aff{ii,jj} = descrs;
%         descrs_aff{ii,jj} = descrs;
        aff_mat{ii,jj} = tform.T;%jj means the rotation around latitude
        repeat_score(ii,jj) = sum(index_ifrepeat_1stimg)/min(size(frames,2),size(frames_origin,2));
        index_origin_image{ii,jj} = index_ifrepeat_1stimg;
        index_aff_image{ii,jj} = repeated_feature_index_2ndimg;
        clear affine_frames;clear repeated_feature_index_2ndimg;
        clear index_ifrepeat_1stimg;
        clear frames; clear descrs;
    end
end
save([image_name 'index_origin_image' '.mat'],'index_origin_image');
save([image_name 'index_aff_image' '.mat'],'index_aff_image');
save([image_name 'repeat_score' '.mat'],'repeat_score');
save([image_name 'descrs_aff' '.mat'],'descrs_aff');

% calculate the repeated times of every features
Repeat_timeoffeatures = zeros(size(index_origin_image{1,1}));
Num_originfeatures = size(frames_origin,2);
col_index = 1;
for iii=1:n
    for jjj=1:k(iii)
        AAA = double(index_origin_image{iii,jjj});
        Repeat_timeoffeatures = Repeat_timeoffeatures + AAA;
        Repeat_index(iii,jjj,1:Num_originfeatures)= 0;
        Repeat_index(iii,jjj,index_origin_image{iii,jjj})= index_aff_image{iii,jjj};
%         for kkk = 1:Num_originfeatures
%             
%         end
    end
end
hist(Repeat_timeoffeatures,21,1);

% the above steps detect and analyze repeated features in both original and
% simulated affine images, then the patch pairs should be organized into
% the form which could be fed into learning modules
MAX_Repeat = max(Repeat_timeoffeatures);
current_feature_index = 0;
for kkk=2:max(Repeat_timeoffeatures)
    current_score_index{kkk} = find(Repeat_timeoffeatures==kkk);
    num=numel(current_score_index{kkk});
    for qqq=1:num
        current_feature_index=current_feature_index+1;
        current_featrureindex=current_score_index{kkk}(qqq);
        top_coord = (current_feature_index-1)*63+1;
        bottom_coord = current_feature_index*63;
        feature_index =1;
        for iii=1:n
            for jjj=1:k(iii)
                current_repeated_featureindex = Repeat_index(iii,jjj,current_featrureindex);
                if(current_repeated_featureindex>0)
                    left_coord = (feature_index-1)*63+1;
                    right_coord = feature_index*63;
                    patch_img (left_coord:right_coord,top_coord:bottom_coord) = reshape(descrs_aff{iii,jjj}(:,current_repeated_featureindex),[63,63]);
                    feature_index = feature_index+1;
                end
%                 Repeat_index();
            end
        end
    end
    clear current_score_index;
end

imwrite(uint8(patch_img*255),[image_name '_patch.tif']);



% after extract and save the patches in one image, the next step is
% orgnizing them into the form which could be fed into training module


NNN =0;
current_feature_index = 0;
current_score_index{1}=0;
for kkk=2:max(Repeat_timeoffeatures)
    current_score_index{kkk} = find(Repeat_timeoffeatures==kkk);
    num=numel(current_score_index{kkk});
    for qqq=1:num
        current_feature_index=current_feature_index+1;
        Repeated_times(current_feature_index)=kkk;
        current_featrureindex=current_score_index{kkk}(qqq);
        top_coord = (current_feature_index-1)*63+1;
        bottom_coord = current_feature_index*63;
        feature_index =1;
        for iii=1:n
            for jjj=1:k(iii)
                current_repeated_featureindex = Repeat_index(iii,jjj,current_featrureindex);
                if(current_repeated_featureindex>0)
                    left_coord = (feature_index-1)*63+1;
                    right_coord = feature_index*63;
%                     patch_img (left_coord:right_coord,top_coord:bottom_coord) = reshape(descrs_aff{iii,jjj}(:,current_repeated_featureindex),[63,63]);
                    if feature_index>1
                        NNN= NNN+1;
                        affine_patch_pos{NNN,2}=imresize(patch_img(left_coord:right_coord,top_coord:bottom_coord),[32 32]);
                        affine_patch_pos{NNN,1}=imresize(patch_img(1:63,top_coord:bottom_coord),[32 32]);                      
                    end
                    feature_index = feature_index+1;
                end
                %                 Repeat_index();

            end
        end
    end
    clear current_score_index;
end

mis_index = randperm(current_feature_index,current_feature_index);
for iii=1:NNN
    if mod(iii,current_feature_index)>2
        left_patch_index = mis_index(MMM);
        right_patch_index= mis_index(MMM+1);
        selected_left_index = randperm(Repeated_times(left_patch_index),1);
        selected_right_index =  randperm(Repeated_times(right_patch_index),1);
        
        top_coord_1 = (left_patch_index-1)*63+1;
        bottom_coord_1 = left_patch_index*63;
        left_coord_1 = (selected_left_index-1)*63+1;
        right_coord_1 =  selected_left_index*63;
        
        top_coord_2 = (right_patch_index-1)*63+1;
        bottom_coord_2 = right_patch_index*63;
        left_coord_2 = (selected_right_index-1)*63+1;
        right_coord_2 =  selected_right_index*63;
        
        MMM = MMM+1;
%         top_coord = (current_feature_index-1)*63+1;
        affine_patch_neg{iii,1} = imresize(patch_img(left_coord_1:right_coord_1,top_coord_1:bottom_coord_1),[32 32]);
        affine_patch_neg{iii,2} = imresize(patch_img(left_coord_2:right_coord_2,top_coord_2:bottom_coord_2),[32 32]);
%         bottom_coord = current_feature_index*63;
    else
        MMM =1;
        left_patch_index = mis_index(MMM);
        right_patch_index= mis_index(MMM+1);
        selected_left_index = randperm(Repeated_times(left_patch_index),1);
        selected_right_index =  randperm(Repeated_times(right_patch_index),1);
        
        top_coord_1 = (left_patch_index-1)*63+1;
        bottom_coord_1 = left_patch_index*63;
        left_coord_1 = (selected_left_index-1)*63+1;
        right_coord_1 =  selected_left_index*63;
        
        top_coord_2 = (right_patch_index-1)*63+1;
        bottom_coord_2 = right_patch_index*63;
        left_coord_2 = (selected_right_index-1)*63+1;
        right_coord_2 =  selected_right_index*63;
        
        affine_patch_neg{iii,1} = imresize(patch_img(left_coord_1:right_coord_1,top_coord_1:bottom_coord_1),[32 32]);
        affine_patch_neg{iii,2} = imresize(patch_img(left_coord_2:right_coord_2,top_coord_2:bottom_coord_2),[32 32]);
        
        mis_index = randperm(current_feature_index,current_feature_index);
        MMM = MMM+1;
    end
end

save([image_name 'pos.mat'],'affine_patch_pos');
save([image_name 'neg.mat'],'affine_patch_neg');

end


