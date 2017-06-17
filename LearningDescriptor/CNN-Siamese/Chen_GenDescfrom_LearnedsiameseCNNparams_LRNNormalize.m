% this fucntion generates descriptors from learned siamese CNN feature
% learning artecture.

function [CNNdescriptor_left,CNNdescriptor_right] = Chen_GenDescfrom_LearnedsiameseCNNparams_LRNNormalize(parameterfilename,Patch_left,Patch_right)
% if(size(img,3)>1)
%     img_left = rgb2gray(img);
% else
%     img_left = img;
% end
% img_left = single(img_left);
% [frames_left,Patch_left] = chen_extractSIFTpatch_CNN(img_left);
% 
% if(size(img2,3)>1)
%     img_right = rgb2gray(img2);
% else
%     img_right = img2;
% end
% img_right = single(img_right);
% [frames_right,Patch_right] = chen_extractSIFTpatch_CNN(img_right);

patch_size = 32;
desc_left_num = size(Patch_left,2);
desc_right_num = size(Patch_right,2);
patch_descrs_left = zeros(patch_size,patch_size,desc_left_num);
patch_descrs_right = zeros(patch_size,patch_size,desc_right_num);
patch_CNNInput_left = zeros(patch_size,patch_size,1,desc_left_num);
patch_CNNInput_right = zeros(patch_size,patch_size,1,desc_right_num);

for ii=1:desc_left_num
     patch_descrs_left(:,:,ii) = reshape(Patch_left(:,ii),patch_size,patch_size);
     patch_CNNInput_left(:,:,1,ii) =  patch_descrs_left(:,:,ii);
end
for ii=1:desc_right_num
     patch_descrs_right(:,:,ii) = reshape(Patch_right(:,ii),patch_size,patch_size);
     patch_CNNInput_right(:,:,1,ii) =  patch_descrs_right(:,:,ii);
end
% renormalization
for ii=1:desc_left_num
    tmp_xl =  patch_CNNInput_left(:,:,:,ii); 
    patch_CNNInput_left(:,:,:,ii) = (patch_CNNInput_left(:,:,:,ii) - mean(mean(mean(patch_CNNInput_left(:,:,:,ii)))))/std(tmp_xl(:));    
end
for ii=1:desc_right_num
   tmp_xr =  patch_CNNInput_right(:,:,:,ii);
   patch_CNNInput_right(:,:,:,ii) = (patch_CNNInput_right(:,:,:,ii) - mean(mean(mean(patch_CNNInput_right(:,:,:,ii)))))/std(tmp_xr(:));
end

% load the parameter files and get the parameter for descriptor calculation
[w1,b1,w2,b2,w3,b3] = Chen_GetSiameseCNNparamesFromSavedParameterFiles(parameterfilename,1);

[resl,resr] = PatchDesc_DeepCnn_WithNonlinear_sigmoid_LRNNormalize(single(patch_CNNInput_left),single(patch_CNNInput_right), w1, b1,w2,b2,w3,b3);

for ii=1:desc_left_num
    CNNdescriptor_left(:,ii) = resl.x6(1,1,:,ii);
%     patch_CNNInput2(:,:,1,ii) = kron( patch_descrs2(:,:,ii),ones(2));
end

for ii=1:desc_right_num
    CNNdescriptor_right(:,ii) = resr.x6(1,1,:,ii);
%     patch_CNNInput2(:,:,1,ii) = kron( patch_descrs2(:,:,ii),ones(2));
end

end