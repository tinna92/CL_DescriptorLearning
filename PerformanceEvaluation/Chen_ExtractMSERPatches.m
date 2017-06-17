vl_setup
addpath('E:\Image Matching\Code\vlfeat-0.9.17-bin\vlfeat-0.9.17\toolbox\');
addpath('E:\Deep Learning\deeplearn\stanford_dl_ex-master\cnn\');
addpath('E:\DescriptorEvaluation\vlbenchmakrs-1.0-beta\vlbenchmakrs-1.0-beta\');
addpath('E:\DescriptorEvaluation\vlbenchmakrs-1.0-beta\vlbenchmakrs-1.0-beta\+localFeatures\+helpers\');
import localFeatures.*;
import datasets.*;
import benchmarks.*;
datasetname = 'graf';
dataset = VggAffineDataset('category',datasetname);

mserDetector = VlFeatMser('MinDiversity',0.5);
mserFrames = mserDetector.extractFeatures(dataset.getImagePath(1)) ;

% img= rgb2gray(imread(dataset.getImagePath(1)));
% Patch2 = chen_extractSIFTpatch4SiameseCNN(img,mserFrames);
% patch_image2 = chen_ShowPatch2(Patch2,3,3); % show the extracted patch in figure
% 
% I = uint8(rgb2gray(imread(dataset.getImagePath(1)))) ;
% [r,f] = vl_mser(I,'MinDiversity',0.5,'MinArea',0.001) ;
% f = vl_ertr(f) ;
% Patch2 = chen_extractSIFTpatch4SiameseCNN(img,f);
% figure(2);
% patch_image2 = chen_ShowPatch2(Patch2,3,3);
% figure(3);
% imshow(imread(dataset.getImagePath(1)));
% sfH = vl_plotframe(mserFrames(:,1:3),'g');
% figure(4);
% imshow(imread(dataset.getImagePath(1)));
% sfH = vl_plotframe(f(:,1:3),'g');
% % bssfH = vl_plotframe(bigScaleSiftFrames,'r');
% % legend([sfH bssfH],'SIFT','Big Scale SIFT');
% 
% 
% mserFrames = mserDetector.extractFeatures(dataset.getImagePath(1)) ;
% % mserFrames = vl_ertr(mserFrames) ;
% Patch_MSER = chen_extractSIFTpatch4SiameseCNN(rgb2gray(imread(dataset.getImagePath(1))),mserFrames);
% mserFrames2 = mserDetector.extractFeatures(dataset.getImagePath(2)) ;
% Patch_MSER2 = chen_extractSIFTpatch4SiameseCNN(rgb2gray(imread(dataset.getImagePath(2))),mserFrames2);
% parameterfilename = ('learnedParamaters2506_50_libertytrain500000.mat');
% % parameterfilename = ('learnedParamaters1112_80_graf.mat');
% % parameterfilename = ('learnedParamaters1311_100_notredame.mat');
% [CNNdescriptor_left,CNNdescriptor_right] = Chen_GenDescfrom_LearnedsiameseCNNparams(parameterfilename,Patch_MSER,Patch_MSER2);
% [matches_spaCNN, scores_spaCNN] = vl_ubcmatch(CNNdescriptor_left, CNNdescriptor_right,1.01);
% Chen_show_matchresult(rgb2gray(imread(dataset.getImagePath(1))),rgb2gray(imread(dataset.getImagePath(2))),matches_spaCNN,mserFrames,mserFrames2,0);
% figure(4);
% imshow(imread(dataset.getImagePath(1)));
% sfH = vl_plotframe(mserFrames(:,1:10),'g');
% figure(5);
% imshow(imread(dataset.getImagePath(2)));
% sfH = vl_plotframe(mserFrames2(:,1:10),'g');
% load(['graf' '_MSER_Patch_img' num2str(2) '.mat']);
% load(['graf' '_GroundTruth_matches.mat']);
% figure(4);
% imshow(imread(dataset.getImagePath(1)));
% sfH = vl_plotframe(mserFrames(:,7),'g');
% figure(5);
% imshow(imread(dataset.getImagePath(2)));
% sfH = vl_plotframe(mserFrames2(:,14),'g');
% 
% figure(6);
% patch_image2 = chen_ShowPatch2(Patch_MSER(:,7),1,1);
% figure(7);
% patch_image2 = chen_ShowPatch2(Patch_MSER2(:,14),1,1);
% 
% % for ii=1:100
% %     index(1,ii) = 
% % end
% 
% A = eye(2) ;
% T = [0;0] ;
% f = [T ; A(:)] ;
% vl_plotframe(mserFrames2(:,14)) ;
% % vl_plotframe(mserFrames2(:,14)) ;
% fff= vl_frame2oell(mserFrames2(:,14));
% vl_plotframe(fff) ;
% 
% siftDetector = VlFeatSift(); mser = VlFeatMser('MinDiversity',0.5);
% mserWithSift = DescriptorAdapter(mser, siftDetector);
% mesrwithsiftframe=mserWithSift.extractFeatures(dataset.getImagePath(1)) ;


mser = VlFeatMser('MinDiversity',0.5);
mserWithSift = DescriptorAdapter(mser, siftDetector);

frames= mserWithSift.extractFeatures(dataset.getImagePath(1)) ;
img = imread(dataset.getImagePath(1));
imgSize = size(img);
if imgSize(3) > 1
    img = rgb2gray(img);
end
img = single(img);
if size(frames,1) > 4
    % Convert frames to disks
    frames = [frames(1,:); frames(2,:); getFrameScale(frames)];
end
if size(frames,1) < 4
    % When no orientation, compute upright SIFT descriptors
    frames = [frames; zeros(1,size(frames,2))];
end
% Compute the descriptors (using scale space).
% [frames, descriptors] = vl_sift(img,'Frames',frames);
% [frames, descriptors] = vl_sift(img,'Frames',frames);
img=im2single(img);
[frames descrs22] = vl_covdet(img, 'descriptor', 'Patch','PatchResolution',31,'Doubleimage',false,'PatchRelativeExtent',2,'PatchRelativeSmoothing',0.2,'Frames',frames) ;
for i=1:size(descrs22,2)
    Temp_patch=reshape(descrs22(:,i),63,63);
    small_patch=imresize(Temp_patch,[32 32]);
    nn=reshape(small_patch,1,1024);
    Patch(:,i)=nn';
end
patch_image2 = chen_ShowPatch2(Patch,100,20); 
figure(6);
patch_image2 = chen_ShowPatch2(Patch(:,7),1,1);
figure(4);
imshow(imread(dataset.getImagePath(1)));
sfH = vl_plotframe(mserFrames(:,7),'g');



img2 = imread(dataset.getImagePath(2));
frames2= mserWithSift.extractFeatures(dataset.getImagePath(2)) ;
imgSize = size(img2);
if imgSize(3) > 1
    img2 = rgb2gray(img2);
end
img2 = single(img2);
if size(frames2,1) > 4
    % Convert frames to disks
    frames2 = [frames2(1,:); frames2(2,:); getFrameScale(frames2)];
end
if size(frames2,1) < 4
    % When no orientation, compute upright SIFT descriptors
    frames2 = [frames2; zeros(1,size(frames2,2))];
end
% Compute the descriptors (using scale space).
% [frames, descriptors] = vl_sift(img,'Frames',frames);
% [frames, descriptors] = vl_sift(img,'Frames',frames);
img2=im2single(img2);
[frames2 descrs222] = vl_covdet(img2, 'descriptor', 'Patch','PatchResolution',31,'Doubleimage',false,'PatchRelativeExtent',2,'PatchRelativeSmoothing',0.2,'Frames',frames2) ;
for i=1:size(descrs222,2)
    Temp_patch=reshape(descrs222(:,i),63,63);
    small_patch=imresize(Temp_patch,[32 32]);
    nn=reshape(small_patch,1,1024);
    Patch2(:,i)=nn';
end


figure(5);
imshow(imread(dataset.getImagePath(2)));
sfH = vl_plotframe(mserFrames2(:,14),'g');
figure(8);
patch_image2 = chen_ShowPatch2(Patch2(:,14),1,1);


[frames, Patch] = Chen_extractMSERpatch4SiameseCNN(img,frames);
figure(6);
patch_image2 = chen_ShowPatch2(Patch(:,7),1,1);