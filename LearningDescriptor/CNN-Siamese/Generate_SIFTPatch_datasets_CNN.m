function Generate_SIFTPatch_datasets_CNN(datasetname)
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
    img = single(img);
    [frames, descrs] = vl_sift(img);    
    Patch2 = chen_extractSIFTpatch_CNN(img,frames);
%     patch_image2 = chen_ShowPatch(Patch2,100,20); % show the extracted patch in figure
    Patch_uint2 = uint8(Patch2);
    patch_savename = [datasetname '_Patch_img_CNN' num2str(i) '.mat'];
    save(patch_savename,'Patch_uint2');
    frames_name=[datasetname '_frames' num2str(i) '.mat'];
    save(frames_name,'frames');
end
end


% import datasets.*;
% import benchmarks.*;
% 
% % A detector repeatability is measured against a benchmark. In this
% % case we create an instance of the VGG Affine Testbed (graffity
% % sequence).
% 
% dataset = VggAffineDataset('category','graf');
% for i=1:dataset.NumImages
%     img = imread(dataset.getImagePath(i));
%     if(size(img,3)>1)
%         img = rgb2gray(img);
%     end
%     img = single(img);
%     [frames, descrs] = vl_sift(img);    
%     Patch2 = chen_extractSIFTpatch(img,frames);
%     patch_image2 = chen_ShowPatch(Patch2,100,20); % show the extracted patch in figure
%     Patch_uint2 = uint8(Patch2);
%     patch_savename = ['graf_Patch_img' num2str(i) '.mat'];
%     save(patch_savename,'Patch_uint2');
%     frames_name=['graf_frames' num2str(i) '.mat'];
%     save(frames_name,'frames');
% end