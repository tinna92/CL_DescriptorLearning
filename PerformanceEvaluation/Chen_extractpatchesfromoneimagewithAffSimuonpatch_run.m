PatchDir='E:\Deep Learning\sparseae_exercise\starter\data\datasets\vggAffineDataset\graf\';
D = dir([PatchDir '*.ppm']);
nFiles = numel(D);
% info = load([PatchDir infoFileName]);
% nPatches = size(info, 1);
k = 0;
% 
% image_name = '000003-111406161250-04.tifresize.png';
feature_detector_type = 'DoG';
n=4;
a=sqrt(2);
b=72;
similarity_threshold = 1.0;

disp('start reading patches data');
Whole_Num = 0;
for iFile = 1:nFiles
    %         fprintf('%d/%d\n', iFile, nFiles);
        %read the current processing Patch image
%         PatchImg = imread([PatchDir D(iFile).name]);
        [affine_patch_pos,affine_patch_neg]=Chen_extractpatchesfromoneimagewithAffSimuonpatch_func([PatchDir D(iFile).name],feature_detector_type,n,a,b,similarity_threshold);
end
