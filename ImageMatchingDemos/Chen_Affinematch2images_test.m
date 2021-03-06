% test for affine image matching

% [frames_Aff1,descrs_Aff1] = Chen_ExtractedAffineimageFeatures('000039-111406162434-02.tifresize.png','Hessian','SIFT',3,1.2,72);
% [frames_Aff2,descrs_Aff2] = Chen_ExtractedAffineimageFeatures('000042-111406162417-04.tifresize.png','Hessian','SIFT',3,1.2,72);
% [frames_Aff1,descrs_Aff1] = Chen_ExtractedAffineimageFeatures('E:\software\IPI\exampledata\10affined_image.jpg','Hessian','SIFT',3,1.2,72);
% [frames_Aff2,descrs_Aff2] = Chen_ExtractedAffineimageFeatures('E:\software\IPI\exampledata\34affined_image.jpg','Hessian','SIFT',3,1.2,72);

% [frames_Aff1,descrs_Aff1] = Chen_ExtractedAffineimageFeatures('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\images\003_017_145000238.tifresize.png','Hessian','SIFT',3,1.2,72);
% [frames_Aff2,descrs_Aff2] = Chen_ExtractedAffineimageFeatures('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\images\007_017_163000166.tifresize.png','Hessian','SIFT',3,1.2,72);
% 
% match_ratio  =1.5;
% [matches_Desc, scores_Desc] = vl_ubcmatch(descrs_Aff1, descrs_Aff2,match_ratio);
% % randm_selected = randperm();
% Chen_show_matchresult(rgb2gray(imread('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\images\003_017_145000238.tifresize.png')),...
%     rgb2gray(imread('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\images\007_017_163000166.tifresize.png')),matches_Desc,frames_Aff1,frames_Aff2,0);
% 


[frames_Aff1,descrs_Aff1,feature_index1] = Chen_ExtractedAffineimageFeatures2('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\images\IGI-UM_Soest-City_GSD5cm-Nadir.jpgresize.png','Hessian','SIFT',3,sqrt(2),180);
[frames_Aff2,descrs_Aff2,feature_index2] = Chen_ExtractedAffineimageFeatures2('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\images\IGI-UM_Soest-City_GSD7cm-ObliqueEast.jpgresize.png','Hessian','SIFT',3,sqrt(2),180);

match_ratio  =1.3;
[matches_Desc, scores_Desc] = vl_ubcmatch(descrs_Aff1, descrs_Aff2,match_ratio);
% randm_selected = randperm();
Chen_show_matchresult(rgb2gray(imread('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\images\IGI-UM_Soest-City_GSD5cm-Nadir.jpgresize.png')),...
    rgb2gray(imread('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\images\IGI-UM_Soest-City_GSD7cm-ObliqueEast.jpgresize.png')),matches_Desc,frames_Aff1,frames_Aff2,0);

clear F_matrix inlinear_index img_coord1 img_coord2 correct_Match_coord1 correct_Match_coord2;
[F_matrix,inlinear_index] = Chen_estimateFundmentalmatrix_RANSAC(frames_Aff1,frames_Aff2,matches_Desc,2,30000);
Initial_MatchNum = size(matches_Desc,2);
img_coord1 = frames_Aff1(1:2,matches_Desc(1,:));
img_coord2 = frames_Aff2(1:2,matches_Desc(2,:));
correct_Match_coord1 = img_coord1(1:2,inlinear_index);
correct_Match_coord2 = img_coord2(1:2,inlinear_index);
draw_epipolar_lines(F_matrix,rgb2gray(imread('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\images\IGI-UM_Soest-City_GSD5cm-Nadir.jpgresize.png')),...
    rgb2gray(imread('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\images\IGI-UM_Soest-City_GSD7cm-ObliqueEast.jpgresize.png')),correct_Match_coord1',correct_Match_coord2');
Chen_show_matchresult(rgb2gray(imread('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\images\IGI-UM_Soest-City_GSD5cm-Nadir.jpgresize.png')),...
    rgb2gray(imread('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\images\IGI-UM_Soest-City_GSD7cm-ObliqueEast.jpgresize.png')), matches_Desc(1:2,inlinear_index),frames_Aff1,frames_Aff2,0);
% Chen_show_matchresult(uint8(img_left),uint8(img_right), matches_CNN_Desc(1:2,inlinear_index),frames_Aff1,frames_Aff2,0);