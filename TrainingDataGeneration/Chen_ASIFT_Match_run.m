
% img_name1 = 'E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\images\003_017_145000238.tifresize.png';
% img_name2 = 'E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\images\007_017_163000166.tifresize.png';
% img_name1 = 'data/000002-111406161256-11.tifresize.png';
% img_name2 = 'data/000003-111406161250-04.tifresize.png';
img_name1 = 'data/IGI-UM_Soest-City_GSD5cm-Nadir.jpgresize.pngcropped.png';
img_name2 = 'data/IGI-UM_Soest-City_GSD7cm-ObliqueEast.jpgresize.pngcropped.png';
opts.similarity_threshold = 1;
opts.detector_type = 'DoG';
opts.descriptor_type = 'SIFT';
opts.n = 3; opts.a = sqrt(2); opts.b = 72;

[frames_Aff1,frames_Aff2,correct_Match_coord1,correct_Match_coord2] = Chen_ASIFT_Match(img_name1,img_name2,opts);