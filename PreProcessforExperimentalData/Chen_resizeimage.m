
PatchDir='E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\images\';
D = dir([PatchDir '*.tif']);
nFiles = numel(D);
resize_ratio = 0.15;

% extract patches from the first image to the last image
disp('start doing job');
for iFile = 1:nFiles
    %         fprintf('%d/%d\n', iFile, nFiles);
       
        Chen_imresize([PatchDir D(iFile).name],resize_ratio);
        fprintf('%d image down\n',iFile);
end