PatchDir = './data/oblique aerail images/';
D = dir([PatchDir '*.tif']);
PatchsaveDir = './data/oblique aerail images/resizeimg/';
nFiles = numel(D);
% disp('start reading patches data');
for iFile = 1:nFiles
    
%         fprintf('%d/%d\n', iFile, nFiles);
        %read the current processing Patch image
        PatchImg = imread([PatchDir D(iFile).name]);
        img_resize1 = imresize(PatchImg,[32 32]);
        imwrite(img_resize1,[PatchsaveDir  D(iFile).name 'resize.png']);
end       
% Chen_imresize('oblique aerail images/000002-111406161256-02.tif',0.2);
% Chen_imresize('TestImagePair/000006-111406161233-04.tif',0.2);
% img1 = imread(imagepath);
% img_resize1 = imresize(img1,resize_ratio);
% imwrite(img_resize1,[imagepath 'resize.png']);