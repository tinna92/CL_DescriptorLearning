% used to extract orientated features and eliminate repeated featuers that
% are multiple orientated version of a same single feature
function[frames,Patch_Resamp] = Chen_extractedFeature_Only1OrientationEachFeature(img)
[frames,Patch] = vl_covdet(img, 'descriptor', 'Patch','Method','Hessian','PatchResolution',31,'Doubleimage',false,'EstimateOrientation', true,'PatchRelativeSmoothing',0.3) ;
[index_if_deletefeat_left,feat_repeaty_left] =  Chen_EliminateRepeatedFeat_withMultiOrientations(frames);
delete_index_left = find(index_if_deletefeat_left == 1);
% delete those features with more than 1 orientations
frames(:,delete_index_left)=[];
Patch(:,delete_index_left)=[]; 
for i=1:size(Patch,2)
    Temp_patch=reshape(Patch(:,i),63,63);
    small_patch=imresize(Temp_patch,[32 32]);
    nn=reshape(small_patch,1,1024);
    Patch_Resamp(:,i)=nn';
end
end