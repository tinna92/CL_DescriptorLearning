function [frames, Patch] = Chen_extractHessianLappatch4SiameseCNN(img,frames)
img=im2single(img);

% [frames descrs22] = vl_covdet(img, 'descriptor', 'Patch','PatchResolution',31,'Doubleimage',false,'PatchRelativeExtent',7.5,'PatchRelativeSmoothing',0.5,'Frames',f) ;
[frames, descrs22] = vl_covdet(img, 'descriptor', 'Patch','PatchResolution',31,'Doubleimage',false,'PatchRelativeExtent',7.5,'PatchRelativeSmoothing',0.3,'Frames',frames,'EstimateAffineShape', true) ;
for i=1:size(descrs22,2)
    Temp_patch=reshape(255*descrs22(:,i),63,63);
    small_patch=imresize(Temp_patch,[32 32]);
    nn=reshape(small_patch,1,1024);
    Patch(:,i)=nn';
end

end