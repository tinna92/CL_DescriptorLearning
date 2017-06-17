
% 1) read the data and resize them into 32 by 32 pixels
ISPRSObliqu_img_Dir = 'E:\Photogrammetric_image_block\';
Camera_Pathes = {'01_Nordblick\','02_Ostblick\','03_Suedblick\','04_Westblick\','05_Nadirblick\'};
PatchsaveDir = 'E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block/resizeimg/';
% D = dir([PatchsaveDir '*.png']);


% disp('start reading patches data');
for ii = 1:1
    D = dir([ISPRSObliqu_img_Dir Camera_Pathes{1,ii} '*.tif']);
    Camera_Pathes(ii) 
    nFiles = numel(D);
        
    for iFile=1:nFiles
        PatchImg = rgb2gray(imread([ISPRSObliqu_img_Dir  Camera_Pathes{1,ii} D(iFile).name]));
        img_resize1 = imresize(PatchImg,[800 600]);
        imwrite(img_resize1,[PatchsaveDir  D(iFile).name 'resize.png']);
        img_resize2 = imresize(PatchImg,[32 32]);
        Descrs(:,iFile) = reshape(img_resize2,1024,1);
%         for ii=2:11
%             PatchImg = imread([PatchDir D_origin(index(ii,iFile)).name]);
%             img_resize1 = imresize(PatchImg,[900 600]);
%             imwrite(img_resize1,[Patch_graphrelation  D(iFile).name 'resize_' int2str(ii-1) 'st_neighbour.png']);
%         end
    end      
    Desc{ii} = Descrs;
    clear Descrs;
end

% then calculate the descriptor according to trained network
parameterfilename = ('learnedParamaters1311_100_notredame.mat');
for ii=1:5
    [CNNdescriptor_ObliqueISPRSBenchMarkL,CNNdescriptor_ObliqueISPRSBenchMarkR] = Chen_GenDescfrom_LearnedsiameseCNNparams(parameterfilename,Desc{ii},Desc{ii});
    CNNdescriptor_ObliqueISPRSBenchMark_Descriptor{ii} = CNNdescriptor_ObliqueISPRSBenchMarkL;
end


% Now test for the Nord blick cameras 
kdtree_left = vl_kdtreebuild(CNNdescriptor_ObliqueISPRSBenchMark_Descriptor{1,1});
[index_obli, distance_obli] = vl_kdtreequery(kdtree_left,CNNdescriptor_ObliqueISPRSBenchMark_Descriptor{1,1} ,CNNdescriptor_ObliqueISPRSBenchMark_Descriptor{1,2},'NumNeighbors', 63) ;

% [CNNdescriptor_ObliqueImgL,CNNdescriptor_ObliqueImgR] = Chen_GenDescfrom_LearnedsiameseCNNparams(parameterfilename,Descrs,Descrs);
% kdtree_left = vl_kdtreebuild(CNNdescriptor_ObliqueImgL);
% [index, distance] = vl_kdtreequery(kdtree_left,CNNdescriptor_ObliqueImgL ,CNNdescriptor_ObliqueImgL,'NumNeighbors', 20) ;

% the last step is to print result
Patch_graphrelation = './data/oblique aerail images/graphrelation_ISPRSbenchmark1/';
D = dir([ISPRSObliqu_img_Dir Camera_Pathes{1,2} '*.tif']);
nFiles = numel(D);
D_file2 = dir([ISPRSObliqu_img_Dir Camera_Pathes{1,1} '*.tif']);
for iFile=1:10        
    PatchImg = rgb2gray(imread([ISPRSObliqu_img_Dir  Camera_Pathes{1,2} D(iFile).name]));
    img_resize1 = imresize(PatchImg,[800 600]);
    imwrite(img_resize1,[Patch_graphrelation  D(iFile).name 'resize_origin.png']);
    for ii=1:1
        PatchImg = rgb2gray(imread([ISPRSObliqu_img_Dir  Camera_Pathes{1,1} D_file2(index_obli(ii,iFile)).name]));
        img_resize1 = imresize(PatchImg,[800 600]);
        imwrite(img_resize1,[Patch_graphrelation  D(iFile).name 'resize_' int2str(ii) 'st_neighbour.png']);
    end     
%     PatchImg = imread([PatchDir D_origin(iFile).name]);
%     img_resize1 = imresize(PatchImg,[800 600]);
%     imwrite(img_resize1,[Patch_graphrelation  D(iFile).name 'resize_origin.png']);
%     for ii=2:11
%         PatchImg = imread([PatchDir D_origin(index(ii,iFile)).name]);
%         img_resize1 = imresize(PatchImg,[900 600]);
%         imwrite(img_resize1,[Patch_graphrelation  D(iFile).name 'resize_' int2str(ii-1) 'st_neighbour.png']);
%     end
end