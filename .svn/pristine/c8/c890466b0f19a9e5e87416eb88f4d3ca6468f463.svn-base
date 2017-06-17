% [frames_Aff1,descrs_Aff1] = Chen_ExtractedAffineimageFeatures('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\images\003_017_145000238.tifresize.png',...
%     'DoG','SIFT',3,1.2,72);
% [frames_Aff2,descrs_Aff2] = Chen_ExtractedAffineimageFeatures('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\images\007_017_163000166.tifresize.png',...
%     'DoG','SIFT',3,1.2,72);
% match_ratio  =1.5;
% [matches_Desc, scores_Desc] = vl_ubcmatch(descrs_Aff1, descrs_Aff2,match_ratio);
% % randm_selected = randperm();
% Chen_show_matchresult(rgb2gray(imread('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\images\003_017_145000238.tifresize.png')),...
%     rgb2gray(imread('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\images\007_017_163000166.tifresize.png')),matches_Desc,frames_Aff1,frames_Aff2,0);
% Chen_show_matchresult(rgb2gray(imread('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\images\003_017_145000238.tifresize.png')),...
%     rgb2gray(imread('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\images\007_017_163000166.tifresize.png')),...
%     matches_Desc,frames_Aff1,frames_Aff2,0);
% 
% 
[F_matrix,inlinear_index] = Chen_estimateFundmentalmatrix_RANSAC(frames_Aff1,frames_Aff2,matches_Desc,1,50000);
Initial_MatchNum = size(matches_Desc,2);
img_coord1 = frames_Aff1(1:2,matches_Desc(1,:));
img_coord2 = frames_Aff2(1:2,matches_Desc(2,:));
correct_Match_coord1 = img_coord1(1:2,inlinear_index);
correct_Match_coord2 = img_coord2(1:2,inlinear_index);
draw_epipolar_lines(F_matrix,imread('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\images\003_017_145000238.tifresize.png')...
    ,imread('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\images\007_017_163000166.tifresize.png')...
    ,correct_Match_coord1',correct_Match_coord2');
Chen_show_matchresult(rgb2gray(imread('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\images\003_017_145000238.tifresize.png')),...
    rgb2gray(imread('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\images\007_017_163000166.tifresize.png')),...
    matches_Desc(1:2,inlinear_index),frames_Aff1,frames_Aff2,0);

% show the correct matched patches from ASIFT
% the next step is trying to collect the matched patches and see how they
% look like
% [frames_Aff1,descrs_Aff1] = Chen_ExtractedAffineimageFeatures('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\images\003_017_145000238.tifresize.png',...
%     'DoG','Patch',3,1.2,72);
% [frames_Aff2,descrs_Aff2] = Chen_ExtractedAffineimageFeatures('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\images\007_017_163000166.tifresize.png',...
%     'DoG','Patch',3,1.2,72);
matched_descrs_Aff1 = descrs_Aff1(:,matches_Desc(1,:));
matched_descrs_Aff2 = descrs_Aff2(:,matches_Desc(2,:));
correct_Match_desc1 = matched_descrs_Aff1(:,inlinear_index);
correct_Match_desc2 = matched_descrs_Aff2(:,inlinear_index);
col_index =1;
Num_correctMatch = size(correct_Match_desc1,2);
for ii= 1:Num_correctMatch
%     current_index = inlinear_index(ii);
    if mod(ii,16)~=0
        top_coord = (col_index-1)*126+1;
        bot_coord = (col_index)*126;
        left_coord = (mod(ii,16)-1)*63+1;
        right_coord = mod(ii,16)*63;
    else
        top_coord = (col_index-1)*126+1;
        bot_coord = (col_index)*126;
        left_coord = (16-1)*63+1;
        right_coord = 16*63;
        col_index = col_index +1;
    end
    Patch_Img(top_coord:top_coord+62,left_coord:right_coord)= reshape(correct_Match_desc1(:,ii),[63 63]);
    Patch_Img(top_coord+63:bot_coord,left_coord:right_coord)= reshape(correct_Match_desc2(:,ii),[63 63]);
end
imwrite(uint8(255*Patch_Img),'1910_patch.tif');
