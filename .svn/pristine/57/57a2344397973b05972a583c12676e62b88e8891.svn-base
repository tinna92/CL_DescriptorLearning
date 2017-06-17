% analyze how much repeated features between a image and its affine transformed image
% frames_origin: feature in original image
% frames_aff: feature in affine transformed images
% aff_T: affine transformation matrix
% similarity_threshold: a thershold to judge 2 features as similar or
% dissimilar pairs.

function [index_ifrepeat_1stimg,repeated_feature_index_2ndimg] = Chen_analy_repeatedfeatures_in_2Images2(frames_origin, frames_aff,aff_T,similarity_threshold)
inv_T_temp = inv(aff_T);
current_frames = frames_aff(1:2,:);
current_frames(3,:) =1;

% before transformation, must exchange the x and y coordinates in
% the first and second row, this is due to the different coordinate
% used in vlfeat and matlab
% 
% NNframe = current_frames;
% NNframe(1,:)= current_frames(2,:);
% NNframe(2,:)= current_frames(1,:);
% NNframe(3,:)=1;
% newfeatures1 = inv_T_temp*NNframe;%         newfeatures = inv_T_temp*current_frames;
% 
% % convert the frames back into original image keypoint coordinates
% newfeatures(1,:) = newfeatures1(2,:);
% newfeatures(2,:) = newfeatures1(1,:);


% newfeatures = inv_T_temp*current_frames;


newfeatures = frames_aff;

% newfeatures1 = inv_T_temp*current_frames;
% newfeatures(1,:) = newfeatures1(2,:);
% newfeatures(2,:) = newfeatures1(1,:);

% compute the distance between every pair features,needs to optimize
Num_1 = size(frames_origin,2);  
Num_2 = size(newfeatures,2); % num of image features in the transformed version image
for ii = 1:Num_1
    for jj= 1:Num_2
        Dist(ii,jj)=(frames_origin(1,ii)-newfeatures(1,jj))^2+...
            (frames_origin(2,ii)-newfeatures(2,jj))^2;
    end
end

% find the pair of features that is lied in less than 0.3 pixel (threshold)
[Dist_min,min_index] = min(Dist');
min_smallerthan1_index = Dist_min<similarity_threshold; % this is the index for the orignal image
num_minindex = size(min_index,2);
min_index_2nd = 1:num_minindex;
second_image_index = min_index.*min_smallerthan1_index;
SelectedPair_index_2nd = min_index(min_smallerthan1_index);
SelectedPair_index_1st = min_index_2nd(min_smallerthan1_index);

index_ifrepeat_1stimg = min_smallerthan1_index;
repeated_feature_index_2ndimg = SelectedPair_index_2nd;
end