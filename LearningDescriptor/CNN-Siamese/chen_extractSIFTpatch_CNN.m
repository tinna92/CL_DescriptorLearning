% chen_extractSIFTpatch extract the sift feature point (frames) arounding patch in
% img
function [frames, Patch] = chen_extractSIFTpatch_CNN(img,f)
if nargin > 1
    [frames descrs22] = vl_covdet(img, 'descriptor', 'Patch','PatchResolution',31,'Doubleimage',false,'Frames',f) ;
else
%     [frames descrs22] = vl_covdet(img, 'descriptor', 'Patch','PatchResolution',31,'Doubleimage',false) ;
%     [frames descrs22] = vl_covdet(img, 'Method','DoG','descriptor', 'Patch','PatchResolution',31,'Doubleimage',false,'Verbose','EstimateAffineShape', false) ;
    [frames descrs22] = vl_covdet(img, 'Method','HessianLaplace','descriptor', 'Patch','PatchResolution',31,'Doubleimage',false,'Verbose','EstimateAffineShape', true,'PatchRelativeSmoothing',0.3,'EstimateOrientation',true) ;

end

for i=1:size(descrs22,2)
    Temp_patch=reshape(descrs22(:,i),63,63);
    small_patch=imresize(Temp_patch,[32 32]);
    nn=reshape(small_patch,1,1024);
    Patch(:,i)=nn';
end

end