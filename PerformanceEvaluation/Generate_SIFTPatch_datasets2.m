% directly use the vl_covdet to get patches, this should be faster and more
% accurate than self sampling
function Generate_SIFTPatch_datasets2(datasetname)


vl_setup
addpath('E:\Image Matching\Code\vlfeat-0.9.17-bin\vlfeat-0.9.17\toolbox\');
addpath('E:\Deep Learning\deeplearn\stanford_dl_ex-master\cnn\');
addpath('E:\DescriptorEvaluation\vlbenchmakrs-1.0-beta\vlbenchmakrs-1.0-beta\');

import datasets.*;
import benchmarks.*;
% A detector repeatability is measured against a benchmark. In this
% case we create an instance of the VGG Affine Testbed (graffity
% sequence).

dataset = VggAffineDataset('category',datasetname);
for i=1:dataset.NumImages
    img = imread(dataset.getImagePath(i));
    if(size(img,3)>1)
        img = rgb2gray(img);
    end
    img = im2single(img);
    [frames, descrs] = vl_sift(img);    
    Patch2 = chen_extractSIFTpatch2(img,frames);
    patch_image2 = chen_ShowPatch(Patch2,100,20); % show the extracted patch in figure
    Patch_uint2 = uint8(Patch2);
    patch_savename = [datasetname '_Patch_img' num2str(i) '.mat'];
    save(patch_savename,'Patch_uint2');
    frames_name=[datasetname '_frames' num2str(i) '.mat'];
    save(frames_name,'frames');
end
end


