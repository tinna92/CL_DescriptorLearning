%in this file, extract features in both one and its affine transformed images.
%  A = imread([Imgpath D(iFile).name]);
similarity_threshold = 0.5;
image_name = '000003-111406161250-04.tifresize.png';
 A = imread(image_name);
 if(size(A,3)>1)
     A_Image = rgb2gray(A);
 else
     A_Image = A;
 end
 
 A_Image = single(A_Image);
 [frames_Image, descrs_Image] = vl_covdet(A_Image, 'Method','HarrisLaplace','descriptor', 'Patch','PatchResolution',31,'Doubleimage',false,'Verbose','EstimateAffineShape', true) ;
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
     [frames1, descrs1] = vl_covdet(outputImage, 'Method','HarrisLaplace','descriptor', 'Patch','PatchResolution',31,'Doubleimage',false,'Verbose','EstimateAffineShape', true) ;
     %     vl_plotframe(frames1) ;
     % get the inverse of Transform and map the detected feature points back
     % to the original image coordinates
     inv_T_temp = inv(tform.T);
     current_frames = frames1(1:2,:);
     current_frames(3,:) =1;
     newfeatures = inv_T_temp*current_frames;
     
     Affine_feature{iii} = frames1; % record the current features in a cell
     Affine_featurePatch{iii} = descrs1;
     
     % compute the distance between every pair features,needs to optimize
     Num_1 = size(frames_origin,2); % num of image features in the original images
     Num_2 = size(newfeatures,2); % num of image features in the transformed version image
     for ii = 1:Num_1
         for jj= 1:Num_2
             Dist(ii,jj)=(frames_origin(1,ii)-newfeatures(1,jj))^2+...
                 (frames_origin(2,ii)-newfeatures(2,jj))^2;
             %                  Dist(jj,ii) = Dist(ii,jj);
         end
     end
%      if Num_2>Num_1
%          for ii = 1:Num_1
%              for jj= ii:Num_2
%                  Dist(ii,jj)=(frames_origin(1,ii)-newfeatures(1,jj))^2+...
%                      (frames_origin(2,ii)-newfeatures(2,jj))^2;
%                  Dist(jj,ii) = Dist(ii,jj);
%              end
%          end
%      else
%          for jj = 1:Num_2
%              for ii= jj:Num_1
%                  Dist(ii,jj)=(frames_origin(1,ii)-newfeatures(1,jj))^2+...
%                      (frames_origin(2,ii)-newfeatures(2,jj))^2;
%                  Dist(jj,ii) = Dist(ii,jj);
%              end
%          end         
%      end
     
     % find the pair of features that is lied in less than 0.3 pixel (threshold)
     [Dist_min,min_index] = min(Dist');
     min_smallerthan1_index = Dist_min<similarity_threshold; % this is the index for the orignal image
     
     num_minindex = size(min_index,2);
     min_index_2nd = 1:num_minindex;
     second_image_index = min_index.*min_smallerthan1_index;
     second_image_index_group(iii,:) = second_image_index;
     SelectedPair_index_2nd = min_index(min_smallerthan1_index);
     SelectedPair_index_1st = min_index_2nd(min_smallerthan1_index);
     num_min_smallerthan1_index = sum(min_smallerthan1_index); % get the number of marks which are smaller than the threshold
     
%      [Dist_min,min_index] = min(Dist);
%      min_smallerthan1_index = Dist_min<similarity_threshold;
%      
%      num_minindex = size(min_index,2);
%      min_index_2nd = 1:num_minindex;
%      SelectedPair_index_1st = min_index(min_smallerthan1_index);
%      SelectedPair_index_2nd = min_index_2nd(min_smallerthan1_index);
%      num_min_smallerthan1_index = sum(min_smallerthan1_index); % get the number of marks which are smaller than the threshold
     
%      for jjj=1:num_min_smallerthan1_index
%          ii = SelectedPair_index_2nd(jjj);
%          kk = SelectedPair_index_1st(jjj);
%          xx = floor(reshape(descrs1(:,ii),[63,63]));
%          yy = floor(reshape(descrs_Image(:,kk),[63,63]));
%          col_num = mod(jjj,16);
%          row_num = mod(jjj,16);
%          col_index = floor(jjj/16);
%          row_index = floor(jjj/16);
%          orig_left = col_index*63*2 + 1;
%          orig_right = orig_left + 62;
%          orig_top = row_num*63 + 1;
%          orig_bottom = row_num*63 + 63;
%          patchpair_image(orig_left:orig_right,orig_top:orig_bottom) =  uint8(xx);
%          patchpair_image(orig_right+1:orig_right+63,orig_top:orig_bottom) =   uint8(yy);
%      end
     
     pair_index_first{iii} = SelectedPair_index_1st;% for the first image
     pair_index_second{iii} = SelectedPair_index_2nd;
     smaller_thanthreshold_index {iii} = min_smallerthan1_index;
%      second_image_index_group{iii} =  second_image_index;
%      pair_image{iii} = patchpair_image;
%      descrs_affineimage{iii} = descrs1;
%      imshow(patchpair_image);% still need to write them into files
%      imwrite(patchpair_image,[Imgpath D(iFile).name '-' int2str(iii) '-' 'pair.jpg']); 
     clear SelectedPair_index_1st;
     clear SelectedPair_index_2nd;
     clear Dist Dist_min min_index;
     clear descrs1;clear frames1;
     clear min_smallerthan1_index;
%      clear patchpair_image;
 
 end
%  save([Imgpath D(iFile).name 'Affine_feature.mat'], 'Affine_feature');
%  save([Imgpath D(iFile).name 'Affine_featurePatch.mat'], 'Affine_featurePatch');
%  
%  save([Imgpath D(iFile).name 'pair_index_first.mat'], 'pair_index_first');
%  save([Imgpath D(iFile).name 'pair_index_second.mat'], 'pair_index_second');
%  
%  save([Imgpath D(iFile).name 'frames_Image.mat'], 'frames_Image');
%  save([Imgpath D(iFile).name 'descrs_Image.mat'], 'descrs_Image');
 
%  clear Affine_feature Affine_featurePatch;
%  clear pair_index_first pair_index_second;
%  clear frames_Image descrs_Image frames_origin; 
%  clear A;

% find the repeat score of every feature in the original image
Repeat_Score = zeros(size(smaller_thanthreshold_index{1}));

for iii = 1:4
    AAA = double(smaller_thanthreshold_index{iii});
    Repeat_Score = Repeat_Score + AAA;
end

% find the one appears in all 4 images
% highest_score_index = Repeat_Score>3;
highest_score_index = find(Repeat_Score==4);
Num = numel(highest_score_index);
% [highest_socre,highest_score_index] = find(Repeat_Score==4);
for jjj=1:Num
    ii = highest_score_index(jjj);
    index_origin_image(jjj) = ii;
    index_affined_image(:,jjj) = second_image_index_group(:,ii);
end

for jjj=1:Num
    ii = index_origin_image(jjj);
    jj = index_affined_image(:,jjj);    
    xx = floor(reshape(descrs_Image(:,ii),[63,63])); % for patch in original image
    
    orig_top = (jjj-1)*63 + 1;
    orig_bottom = jjj*63;
    patchpair_image(orig_top:orig_bottom,1:63) = uint8(xx);
    for kkk=1:4
        k_index = jj(kkk);
        yy = floor(reshape(Affine_featurePatch{kkk}(:,k_index),[63,63]));
        orig_left = kkk*63 + 1;
        orig_right = (kkk+1)*63;
        patchpair_image(orig_top:orig_bottom,orig_left:orig_right) = uint8(yy);
    end
end
imshow(patchpair_image);
imwrite(patchpair_image,[image_name 'patch_image1_HarrisLaplace.jpg']);

% show the repeated features in original image
draw_color = ['g','r','c','m','y','k'];
draw_color_index =  mod(randperm(Num,Num),6)+1;
[Tag_ori_left,Tag_ori_right,Tag_ori_top,Tag_ori_bottom] = Chen_Getcrossmark(frames_Image,5);% for showing positions
figure(2);
imshow(A);
hold on;
% get the point coordinates for cross marks drawing
for jjj=1:Num
    ii = index_origin_image(jjj);
    plot([Tag_ori_left(1,ii),Tag_ori_right(1,ii)],[Tag_ori_left(2,ii),Tag_ori_right(2,ii)],draw_color(draw_color_index(jjj)),'linewidth',1);
    plot([Tag_ori_top(1,ii),Tag_ori_bottom(1,ii)],[Tag_ori_top(2,ii),Tag_ori_bottom(2,ii)],draw_color(draw_color_index(jjj)),'linewidth',1);
end