% perform multiple transformations to the input image, collect the repeated feature surrounding
% patches. Those patches could be used as training data.


% uncomment this part to resize all the images in the dataset.
% resizeimage_mark = 1;
% Imgpath = 'E:\KarstenData\tif\';
% if(resizeimage_mark)
%     D = dir([Imgpath '*.tif']);
%     nFiles = numel(D);
%     for iFile = 1:nFiles        
%         Chen_imresize([Imgpath D(iFile).name],0.2);
%     end
% end

        
%% first read the original image and detect the DoG features in the original image
% function Chen_Affinetransform_featuresdetect_filefolder()

similarity_threshold = 0.3;
Imgpath = 'E:\KarstenData\tif\';
D = dir([Imgpath '*resize.png']);

nFiles = numel(D);
for iFile = 1:nFiles        
    A = imread([Imgpath D(iFile).name]);
    if(size(A,3)>1)
        A_Image = rgb2gray(A);
    else
        A_Image = A;
    end
    A_Image = single(A_Image);
    [frames_Image, descrs_Image] = vl_covdet(A_Image, 'Method','DoG','descriptor', 'Patch','PatchResolution',31,'Doubleimage',false,'Verbose','EstimateAffineShape', true) ;
    frames_origin = frames_Image(1:2,:);
    % do the transformations in differential tilt
    tilt = [sqrt(2),2,2*sqrt(2),4];
    for iii=1:4
        % do the affine transformation with appropriate tilt
        tform =Chen_AffineTransform( acos(1./tilt(iii)),0,0,1,0,0);
        outputImage = imwarp(A,tform);
        if(size(outputImage,3)>1)
            outputImage = rgb2gray(outputImage);
        end
        imshow(outputImage);
        outputImage = single(outputImage);
        
        % detect the features points in current transformed images
        [frames1, descrs1] = vl_covdet(outputImage, 'Method','DoG','descriptor', 'Patch','PatchResolution',31,'Doubleimage',false,'Verbose','EstimateAffineShape', true) ;
        %     vl_plotframe(frames1) ;
        
        % get the inverse of Transform and map the detected feature points back
        % to the original image coordinates
        inv_T_temp = inv(tform.T);
        current_frames = frames1(1:2,:);
        current_frames(3,:) =1;
        newfeatures = inv_T_temp*current_frames;
        
        Affine_feature{iii} = frames1; % record the current features in a cell
        Affine_featurePatch{iii} = descrs1;
        
        % compute the distance between every pair features
        Num_1 = size(frames_origin,2);
        Num_2 = size(newfeatures,2);
        for ii = 1:Num_1
            for jj= 1:Num_2
                Dist(ii,jj)=(frames_origin(1,ii)-newfeatures(1,jj))^2+...
                    (frames_origin(2,ii)-newfeatures(2,jj))^2;
            end
        end
        
        % find the pair of features that is lied in less than 0.3 pixel (threshold)
        [Dist_min,min_index] = min(Dist);
        min_smallerthan1_index = Dist_min<similarity_threshold;
        
        num_minindex = size(min_index,2);
        min_index_2nd = 1:num_minindex;
        SelectedPair_index_1st = min_index(min_smallerthan1_index);
        SelectedPair_index_2nd = min_index_2nd(min_smallerthan1_index);
        num_min_smallerthan1_index = sum(min_smallerthan1_index); % get the number of marks which are smaller than the threshold
        
        
        for jjj=1:num_min_smallerthan1_index
            ii = SelectedPair_index_2nd(jjj);
            kk = SelectedPair_index_1st(jjj);
            xx = floor(reshape(descrs1(:,ii),[63,63]));
            yy = floor(reshape(descrs_Image(:,kk),[63,63]));
            col_num = mod(jjj,16);
            row_num = mod(jjj,16);
            col_index = floor(jjj/16);
            row_index = floor(jjj/16);
            orig_left = col_index*63*2 + 1;
            orig_right = orig_left + 62;
            orig_top = row_num*63 + 1;
            orig_bottom = row_num*63 + 63;
            patchpair_image(orig_left:orig_right,orig_top:orig_bottom) =  uint8(xx);
            patchpair_image(orig_right+1:orig_right+63,orig_top:orig_bottom) =   uint8(yy);
        end
    
        pair_index_first{iii} = SelectedPair_index_1st;
        pair_index_second{iii} = SelectedPair_index_2nd;
        pair_image{iii} = patchpair_image;

        imshow(patchpair_image);% still need to write them into files
        imwrite(patchpair_image,[Imgpath D(iFile).name '-' int2str(iii) '-' 'pair.jpg']); 
        clear SelectedPair_index_1st;
        clear SelectedPair_index_2nd;
        clear Dist Dist_min min_index;
        clear descrs1;clear frames1;
        clear min_smallerthan1_index;
        clear patchpair_image;

    end
    save([Imgpath D(iFile).name 'Affine_feature.mat'], 'Affine_feature');
    save([Imgpath D(iFile).name 'Affine_featurePatch.mat'], 'Affine_featurePatch');
    
    
    save([Imgpath D(iFile).name 'pair_index_first.mat'], 'pair_index_first');
    save([Imgpath D(iFile).name 'pair_index_second.mat'], 'pair_index_second');
    
    save([Imgpath D(iFile).name 'frames_Image.mat'], 'frames_Image');
    save([Imgpath D(iFile).name 'descrs_Image.mat'], 'descrs_Image');
    
    clear Affine_feature Affine_featurePatch;
    clear pair_index_first pair_index_second;
    clear frames_Image descrs_Image frames_origin; 
    clear A;
    
end
% end


