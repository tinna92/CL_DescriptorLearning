PatchDir='E:\Deep Learning\sparseae_exercise\starter\data\datasets\vggAffineDataset\graf\';
D = dir([PatchDir '*.ppm']);
nFiles = numel(D);
% info = load([PatchDir infoFileName]);
% nPatches = size(info, 1);
k = 0;
% 
% image_name = '000003-111406161250-04.tifresize.png';
feature_detector_type = 'DoG';
n=6;
% a=sqrt(2);
a=1.35;
b=72;
similarity_threshold = 1.0;


% extract patches from the first image to the last image
disp('start reading patches data');
Whole_Num = 0;
for iFile = 1:nFiles
    %         fprintf('%d/%d\n', iFile, nFiles);
        %read the current processing Patch image
%         PatchImg = imread([PatchDir D(iFile).name]);
        [affine_patch_pos,affine_patch_neg]=Chen_extractedaffinedpatchesfromOneimage_func3([PatchDir D(iFile).name],feature_detector_type,n,a,b,similarity_threshold,8);
        CurrentNum = size(affine_patch_pos,1);
        for iii=1:CurrentNum
            Patch_pos{Whole_Num+iii,1} = affine_patch_pos{iii,1};
            Patch_pos{Whole_Num+iii,2} = affine_patch_pos{iii,2};
            Patch_neg{Whole_Num+iii,1} = affine_patch_neg{iii,1};
            Patch_neg{Whole_Num+iii,2} = affine_patch_neg{iii,2};
        end
        
        fprintf('%d image, whole %d image, current training data size: %d\n',iFile,nFiles,Whole_Num);
        Whole_Num = CurrentNum+Whole_Num;
end

 save('aff_pos_evauation_1026.mat','Patch_pos');save('aff_neg_evauation_1026.mat','Patch_neg');