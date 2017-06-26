imagefiles = dir('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\01_Nordblick\*.tif');      
nfiles = length(imagefiles);    % Number of files found

for ii=1:nfiles    
   currentfilename = imagefiles(ii).name;
%    currentimage = imread(currentfilename);
   Chen_imresize(strcat('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\01_Nordblick\',currentfilename),0.25);
%    images{ii} = currentimage;   
end

% for ii=1:nfiles    
%    currentfilename = imagefiles(ii).name;
% %    currentimage = imread(currentfilename);
% %    Chen_imresize(strcat('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\01_Nordblick\',currentfilename),0.25);
%    Chen_imresize_rows_cols(strcat('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\01_Nordblick\',currentfilename),800,600);
%    disp(ii);
% 
% %    images{ii} = currentimage;   
% end


imagefiles = dir('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\01_Nordblick\*.png');      
nfiles = length(imagefiles);    % Number of files found
opts.detector_type = 'DoG';
opts.descriptor_type = 'SIFT';
opts.n = 3; opts.a = sqrt(2); opts.b = 72;
for ii=1:nfiles    
   currentfilename = imagefiles(ii).name;
   disp('01_Nordblick');
   disp(currentfilename);
   disp(ii);
   img_path = strcat('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\01_Nordblick\',currentfilename);
%    currentimage = imread(currentfilename);
   [frames_Aff,descrs_Aff,feature_index] = Chen_ExtractedAffineimageFeatures2(img_path,opts.detector_type,opts.descriptor_type,opts.n,opts.a,opts.b);
   
   Re_index = Chen_analyze_repeatable_features(frames_Aff, 32);
   unrepeated = unique(Re_index','rows');
   unrepeated = unrepeated';
   frames_unrepeated = frames_Aff(:, unrepeated);
   frame_out = Chen_Derive_ScaOri_from_vlframes(frames_unrepeated);
   out_desc = descrs_Aff(:, unrepeated);
   Chen_Write_Features_for_Colmap(img_path, frame_out, out_desc);

end





imagefiles = dir('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\02_Ostblick\*.tif');      
nfiles = length(imagefiles);    % Number of files found

for ii=1:nfiles    
   currentfilename = imagefiles(ii).name;
%    currentimage = imread(currentfilename);
   Chen_imresize(strcat('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\02_Ostblick\',currentfilename),0.25);
   disp(ii);
%    images{ii} = currentimage;   
end

imagefiles = dir('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\02_Ostblick\*.png');      
nfiles = length(imagefiles);    % Number of files found
opts.detector_type = 'DoG';
opts.descriptor_type = 'SIFT';
opts.n = 3; opts.a = sqrt(2); opts.b = 72;
for ii=1:nfiles    
   currentfilename = imagefiles(ii).name;
   disp('02_Ostblick');
   disp(currentfilename);
   disp(ii);
   img_path = strcat('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\02_Ostblick\',currentfilename);
%    currentimage = imread(currentfilename);
   [frames_Aff,descrs_Aff,feature_index] = Chen_ExtractedAffineimageFeatures2(img_path,opts.detector_type,opts.descriptor_type,opts.n,opts.a,opts.b);
   
   Re_index = Chen_analyze_repeatable_features(frames_Aff, 32);
   unrepeated = unique(Re_index','rows');
   unrepeated = unrepeated';
   frames_unrepeated = frames_Aff(:, unrepeated);
   frame_out = Chen_Derive_ScaOri_from_vlframes(frames_unrepeated);
   out_desc = descrs_Aff(:, unrepeated);
   Chen_Write_Features_for_Colmap(img_path, frame_out, out_desc);
   

end



imagefiles = dir('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\03_Suedblick\*.tif');      
nfiles = length(imagefiles);    % Number of files found

for ii=1:nfiles    
   currentfilename = imagefiles(ii).name;
%    currentimage = imread(currentfilename);
   Chen_imresize(strcat('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\03_Suedblick\',currentfilename),0.25);
   disp(ii);
%    images{ii} = currentimage;   
end

imagefiles = dir('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\03_Suedblick\*.png');      
nfiles = length(imagefiles);    % Number of files found
opts.detector_type = 'DoG';
opts.descriptor_type = 'SIFT';
opts.n = 3; opts.a = sqrt(2); opts.b = 72;
for ii=1:nfiles    
   currentfilename = imagefiles(ii).name;
   disp(currentfilename);
   disp('03_Suedblick');
   disp(ii);
   img_path = strcat('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\03_Suedblick\',currentfilename);
%    currentimage = imread(currentfilename);
   [frames_Aff,descrs_Aff,feature_index] = Chen_ExtractedAffineimageFeatures2(img_path,opts.detector_type,opts.descriptor_type,opts.n,opts.a,opts.b);
   
   Re_index = Chen_analyze_repeatable_features(frames_Aff, 32);
   unrepeated = unique(Re_index','rows');
   unrepeated = unrepeated';
   frames_unrepeated = frames_Aff(:, unrepeated);
   frame_out = Chen_Derive_ScaOri_from_vlframes(frames_unrepeated);
   out_desc = descrs_Aff(:, unrepeated);
   Chen_Write_Features_for_Colmap(img_path, frame_out, out_desc);
   

end



imagefiles = dir('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\04_Westblick\*.tif');      
nfiles = length(imagefiles);    % Number of files found

for ii=1:nfiles    
   currentfilename = imagefiles(ii).name;
%    currentimage = imread(currentfilename);
   Chen_imresize(strcat('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\04_Westblick\',currentfilename),0.25);
   disp(ii);
%    images{ii} = currentimage;   
end
imagefiles = dir('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\04_Westblick\*.png');      
nfiles = length(imagefiles);    % Number of files found
opts.detector_type = 'DoG';
opts.descriptor_type = 'SIFT';
opts.n = 3; opts.a = sqrt(2); opts.b = 72;
for ii=1:nfiles    
   currentfilename = imagefiles(ii).name;
   disp(currentfilename);
   disp('04_Westblick');
   disp(ii);
   img_path = strcat('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\04_Westblick\',currentfilename);
%    currentimage = imread(currentfilename);
   [frames_Aff,descrs_Aff,feature_index] = Chen_ExtractedAffineimageFeatures2(img_path,opts.detector_type,opts.descriptor_type,opts.n,opts.a,opts.b);
   
   Re_index = Chen_analyze_repeatable_features(frames_Aff, 32);
   unrepeated = unique(Re_index','rows');
   unrepeated = unrepeated';
   frames_unrepeated = frames_Aff(:, unrepeated);
   frame_out = Chen_Derive_ScaOri_from_vlframes(frames_unrepeated);
   out_desc = descrs_Aff(:, unrepeated);
   Chen_Write_Features_for_Colmap(img_path, frame_out, out_desc);
   

end


imagefiles = dir('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\05_Nadirblick\*.tif');      
nfiles = length(imagefiles);    % Number of files found

for ii=1:nfiles    
   currentfilename = imagefiles(ii).name;
%    currentimage = imread(currentfilename);
   Chen_imresize(strcat('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\05_Nadirblick\',currentfilename),0.25);
   disp(ii);
%    images{ii} = currentimage;   
end
imagefiles = dir('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\05_Nadirblick\*.png');      
nfiles = length(imagefiles);    % Number of files found
opts.detector_type = 'DoG';
opts.descriptor_type = 'SIFT';
opts.n = 3; opts.a = sqrt(2); opts.b = 72;
for ii=1:nfiles    
   currentfilename = imagefiles(ii).name;
   disp('05_Nadirblick');
   disp(currentfilename);
   disp(ii);
   img_path = strcat('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\05_Nadirblick\',currentfilename);
%    currentimage = imread(currentfilename);
   [frames_Aff,descrs_Aff,feature_index] = Chen_ExtractedAffineimageFeatures2(img_path,opts.detector_type,opts.descriptor_type,opts.n,opts.a,opts.b);
   
   Re_index = Chen_analyze_repeatable_features(frames_Aff, 32);
   unrepeated = unique(Re_index','rows');
   unrepeated = unrepeated';
   frames_unrepeated = frames_Aff(:, unrepeated);
   frame_out = Chen_Derive_ScaOri_from_vlframes(frames_unrepeated);
   out_desc = descrs_Aff(:, unrepeated);
   Chen_Write_Features_for_Colmap(img_path, frame_out, out_desc);
   

end


% for ii=62:63    
%    currentfilename = imagefiles(ii).name;
%    disp('05_Nadirblick');
%    disp(currentfilename);
%    disp(ii);
%    img_path = strcat('E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\05_Nadirblick\',currentfilename);
% %    currentimage = imread(currentfilename);
%    [frames_Aff,descrs_Aff,feature_index] = Chen_ExtractedAffineimageFeatures2(img_path,opts.detector_type,opts.descriptor_type,opts.n,opts.a,opts.b);
%    
%    Re_index = Chen_analyze_repeatable_features(frames_Aff, 32);
%    unrepeated = unique(Re_index','rows');
%    unrepeated = unrepeated';
%    frames_unrepeated = frames_Aff(:, unrepeated);
%    frame_out = Chen_Derive_ScaOri_from_vlframes(frames_unrepeated);
%    out_desc = descrs_Aff(:, unrepeated);
%    Chen_Write_Features_for_Colmap(img_path, frame_out, out_desc);
%    
% 
% end

