function [frames, Patch] = Chen_extractMSERpatch4SiameseCNN(img,frames)
img=im2single(img);

if size(frames,1) > 4
    % Convert frames to disks
    frames = [frames(1,:); frames(2,:); getFrameScale(frames)];
end
if size(frames,1) < 4
    % When no orientation, compute upright SIFT descriptors
    frames = [frames; zeros(1,size(frames,2))];
end

% [frames descrs22] = vl_covdet(img, 'descriptor', 'Patch','PatchResolution',31,'Doubleimage',false,'PatchRelativeExtent',7.5,'PatchRelativeSmoothing',0.5,'Frames',f) ;
[frames, descrs22] = vl_covdet(img, 'descriptor', 'Patch','PatchResolution',31,'Doubleimage',false,'PatchRelativeExtent',2.5,'PatchRelativeSmoothing',0.2,'Frames',frames) ;
for i=1:size(descrs22,2)
    Temp_patch=reshape(descrs22(:,i),63,63);
    small_patch=imresize(Temp_patch,[32 32]);
    nn=reshape(small_patch,1,1024);
    Patch(:,i)=nn';
end

end