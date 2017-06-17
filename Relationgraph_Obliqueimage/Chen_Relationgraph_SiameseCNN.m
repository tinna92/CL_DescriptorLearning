PatchDir = './data/oblique aerail images/';
PatchsaveDir = './data/oblique aerail images/resizeimg/';
D = dir([PatchsaveDir '*.png']);

nFiles = numel(D);
% disp('start reading patches data');
for iFile = 1:nFiles
    
%         fprintf('%d/%d\n', iFile, nFiles);
        %read the current processing Patch image
        PatchImg = imread([PatchsaveDir D(iFile).name]);
        Descrs(:,iFile) = reshape(PatchImg,1024,1);
        
end  
parameterfilename = ('learnedParamaters1311_100_notredame.mat');
[CNNdescriptor_ObliqueImgL,CNNdescriptor_ObliqueImgR] = Chen_GenDescfrom_LearnedsiameseCNNparams(parameterfilename,Descrs,Descrs);
kdtree_left = vl_kdtreebuild(CNNdescriptor_ObliqueImgL);
[index, distance] = vl_kdtreequery(kdtree_left,CNNdescriptor_ObliqueImgL ,CNNdescriptor_ObliqueImgL,'NumNeighbors', 20) ;

Patch_graphrelation = './data/oblique aerail images/graphrelation/';
D_origin = dir([PatchDir '*.tif']);
for iFile=1:nFiles
    PatchImg = imread([PatchDir D_origin(iFile).name]);
    img_resize1 = imresize(PatchImg,[900 600]);
    imwrite(img_resize1,[Patch_graphrelation  D(iFile).name 'resize_origin.png']);
    for ii=2:11
        PatchImg = imread([PatchDir D_origin(index(ii,iFile)).name]);
        img_resize1 = imresize(PatchImg,[900 600]);
        imwrite(img_resize1,[Patch_graphrelation  D(iFile).name 'resize_' int2str(ii-1) 'st_neighbour.png']);
    end
end