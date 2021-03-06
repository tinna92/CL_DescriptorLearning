% directly use the vl_covdet to get patches, this should be faster and more
% accurate than self sampling
function Generate_SIFTandMESRPatch_datasets4SiameseCNN(datasetname)

vl_setup
addpath('E:\Image Matching\Code\vlfeat-0.9.17-bin\vlfeat-0.9.17\toolbox\');
addpath('E:\Deep Learning\deeplearn\stanford_dl_ex-master\cnn\');
addpath('E:\DescriptorEvaluation\vlbenchmakrs-1.0-beta\vlbenchmakrs-1.0-beta\');
import datasets.*;
import benchmarks.*;
import localFeatures.*;
mserDetector = VlFeatMser('MinDiversity',0.5);
HessianLap_Detector = VlFeatCovdet('method', 'hessianlaplace', ...
                                 'estimateaffineshape', true, ...
                                 'estimateorientation', true, ...
                                 'peakthreshold',0.005,...
                                 'doubleImage', false);
Hessian_Detector = VlFeatCovdet('method', 'Hessian', ...
                                 'estimateaffineshape', false, ...
                                 'estimateorientation', false, ...
                                 'peakthreshold',0.0035,...
                                 'doubleImage', false);
                             
% A detector repeatability is measured against a benchmark. In this
% case we create an instance of the VGG Affine Testbed (graffity
% sequence).

dataset = VggAffineDataset('category',datasetname);
for i=1:dataset.NumImages
    img = imread(dataset.getImagePath(i));
    if(size(img,3)>1)
        img = rgb2gray(img);
    end
    img1 = single(img);
    % detect and save DoG features and patches
    [frames, descrs] = vl_sift(img1,'Orientations'); %actually, Orientation is a default option of vl_sift function   
    Patch2 = chen_extractSIFTpatch4SiameseCNN(img,frames);
    patch_image2 = chen_ShowPatch2(Patch2,100,20); % show the extracted patch in figure
    Patch_uint2 = uint8(Patch2);
    patch_savename = [datasetname '_Patch_img' num2str(i) '.mat'];
    save(patch_savename,'Patch_uint2');
    frames_name=[datasetname '_frames' num2str(i) '.mat'];
    save(frames_name,'frames');
    
    % detect and save mser feature and patches
    mserFrames = mserDetector.extractFeatures(dataset.getImagePath(i)) ;
%     Patch_MSER = chen_extractSIFTpatch4SiameseCNN(img,mserFrames);
    [frames, Patch_MSER] = Chen_extractMSERpatch4SiameseCNN(img,mserFrames);
    patch_mser_savename = [datasetname '_MSER_Patch_img' num2str(i) '.mat'];
    save(patch_mser_savename,'Patch_MSER');
    mser_frames_name=[datasetname '_mser_frames' num2str(i) '.mat'];
    save(mser_frames_name,'mserFrames');
    
    Hesslapframse = HessianLap_Detector.extractFeatures(dataset.getImagePath(i));
    [hessianLapframes, Patch_HessianLap] = Chen_extractHessianLappatch4SiameseCNN(img,Hesslapframse);
    % also extract sift descriptors for evaluation
    [frames, descrs_hessianlap_sift] = vl_covdet(im2single(img), 'descriptor', 'SIFT','PatchResolution',31,'Doubleimage',false,'PatchRelativeExtent',7.5,'PatchRelativeSmoothing',0.3,'Frames',hessianLapframes) ;
    sift_hessianlap_desc_name=[datasetname '_HessLap_Sift_Desc' num2str(i) '.mat'];
    save(sift_hessianlap_desc_name,'descrs_hessianlap_sift');
    figure(2);patch_image2 = chen_ShowPatch2(Patch_HessianLap,100,20);
    patch_mser_savename = [datasetname '_HessLap_Patch_img' num2str(i) '.mat'];
    save(patch_mser_savename,'Patch_HessianLap');
    mser_frames_name=[datasetname '_HessLap_frames' num2str(i) '.mat'];
    save(mser_frames_name,'hessianLapframes');
    
    Hessframse = Hessian_Detector.extractFeatures(dataset.getImagePath(i));
    [hessianframes, Patch_Hessian] = Chen_extractHessianLappatch4SiameseCNN(img,Hessframse); 
    [frames, descrs_hessian_sift] = vl_covdet(im2single(img), 'descriptor', 'SIFT','PatchResolution',31,'Doubleimage',false,'PatchRelativeExtent',7.5,'PatchRelativeSmoothing',0.3,'Frames',hessianframes) ;
    sift_hessian_desc_name=[datasetname '_Hess_Sift_Desc' num2str(i) '.mat'];
    save(sift_hessian_desc_name,'descrs_hessian_sift');
    figure(3);patch_image2 = chen_ShowPatch2(Patch_Hessian,100,20);
    patch_mser_savename = [datasetname '_Hess_Patch_img' num2str(i) '.mat'];
    save(patch_mser_savename,'Patch_Hessian');
    mser_frames_name=[datasetname '_Hess_frames' num2str(i) '.mat'];
    save(mser_frames_name,'hessianframes');
end
end


