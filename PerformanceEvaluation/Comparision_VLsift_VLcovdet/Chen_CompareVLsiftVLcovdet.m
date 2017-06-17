% experiment 1: test how vlsift works
img = rgb2gray(imread('img3.jpg'));
img1 = single(img);
[frames_vlfeat descrs_vlfeat,info_vlfeat] = vl_covdet(img1, 'Method','DoG','descriptor', 'Patch','PatchResolution',31,'PatchRelativeExtent',6,'Doubleimage',false,'Verbose','EstimateAffineShape', false, 'PeakThreshold',0,'EstimateOrientation', true) ;
vl_plotss(info_vlfeat.css);
[frames_vlsift descrs_vlsift] =  vl_sift(img1,'Verbose');


% experiment: test if vlcovdet detect the same features and build the same
% descriptors with sift
[frames_vlfeat1 descrs_vlfeat1,info_vlfeat1] = vl_covdet(img1,'descriptor', 'Patch',...
'PatchResolution',31,'Doubleimage',false,'Verbose','EstimateAffineShape', false, 'PeakThreshold',0,'PatchRelativeExtent',7.5,'PatchRelativeSmoothing',1.0, 'frames',frames_vlsift) ;
% [frames_vlfeat1 descrs_vlfeat1,info_vlfeat1] = vl_covdet(img1,'descriptor', 'Patch',...
% 'Doubleimage',false,'Verbose','EstimateAffineShape', false, 'PeakThreshold',0,'PatchRelativeExtent',6.0, 'PatchRelativeSmoothing',1.0, 'frames',frames_vlsift) ;
% [frames_vlfeat1 descrs_vlfeat1,info_vlfeat1] = vl_covdet(img1,'descriptor', 'Patch',...
% 'PatchResolution',31,'Doubleimage',false,'Verbose','EstimateAffineShape', false, 'PeakThreshold',0,'EstimateOrientation', true,'frames',frames_vlsift) ;

% [frames_vlfeat1 descrs_vlfeat1,info_vlfeat1] = vl_covdet(img1,'descriptor', 'SIFT',...
% 'Doubleimage',false,'Verbose','EstimateAffineShape', false, 'PeakThreshold',0,'PatchRelativeExtent',6.0, 'PatchRelativeSmoothing',1.0, 'frames',frames_vlsift) ;

imshow(img);
% vl_plotframe(frames_vlsift(:,16));
vl_plotframe(frames_vlfeat1(:,14:30));
h32 = vl_plotsiftdescriptor(descrs_vlsift(:,14:30),frames_vlsift(:,14:30)) ;
set(h32,'color','r') ;
figure(2);
Patch2 = chen_extractSIFTpatch4SiameseCNN(img,frames_vlsift);
patch_image2 = chen_ShowPatch2(Patch2(:,14:30),17,17);
% h33 = vl_plotsiftdescriptor(descrs_vlsift(:,17),frames_vlsift(:,17)) ;
% set(h32,'color','r') ;
% vl_plotframe(frames_vlfeat1);

figure(2);imshow(img);
vl_plotframe(frames_vlsift(:,16));


kdtree1 = vl_kdtreebuild(frames_vlsift(1:2,:)) ;
% [index, distance] = vl_kdtreequery(kdtree, frames_origin, newfeatures) ;
% first_dropout_index = find(distance>1); % first find the obvious wrong points, whose nearst neighbor is more than 1 pixel
% newfeatures(:,first_dropout_index)=[];
[index_vlsift, distance_vlsift] = vl_kdtreequery(kdtree1, frames_vlsift(1:2,:), frames_vlsift(1:2,:),'NUMNEIGHBORS', 5) ;
test_index_vlsift = find(distance_vlsift(1,:)<1.0); % why get different result
% test_index = distance(1,:)<1.0;
repeated_feature_index_2ndimg1_vlsift = index_vlsift(1,test_index);
index_ifrepeat_1stimg1_vlsift = distance_vlsift(1,:)<1.0;
sum(distance_vlsift(2,:)==0)
sum(distance_vlsift(3,:)==0)


kdtree2 = vl_kdtreebuild(frames_vlfeat(1:2,:)) ;
% [index, distance] = vl_kdtreequery(kdtree, frames_origin, newfeatures) ;
% first_dropout_index = find(distance>1); % first find the obvious wrong points, whose nearst neighbor is more than 1 pixel
% newfeatures(:,first_dropout_index)=[];
[index_vlfeat, distance_vlfeat] = vl_kdtreequery(kdtree2, frames_vlfeat(1:2,:), frames_vlfeat(1:2,:),'NUMNEIGHBORS', 5) ;
test_index_vlfeat = find(distance_vlfeat(1,:)<1.0); % why get different result
% test_index = distance(1,:)<1.0;
repeated_feature_index_2ndimg1_vlfeat = index_vlfeat(1,test_index_vlfeat);
index_ifrepeat_1stimg1_vlfeat = distance_vlfeat(1,:)<1.0;
sum(distance_vlfeat(2,:)==0)
sum(distance_vlfeat(3,:)==0)


kdtree1 = vl_kdtreebuild(frames_vlsift(1:2,:)) ;
% [index, distance] = vl_kdtreequery(kdtree, frames_origin, newfeatures) ;
% first_dropout_index = find(distance>1); % first find the obvious wrong points, whose nearst neighbor is more than 1 pixel
% newfeatures(:,first_dropout_index)=[];
[index_vlsift, distance_vlsift] = vl_kdtreequery(kdtree1, frames_vlsift(1:2,:), frames_vlsift(1:2,:),'NUMNEIGHBORS', 5) ;
test_index_vlsift = find(distance_vlsift(1,:)<1.0); % why get different result
% test_index = distance(1,:)<1.0;
repeated_feature_index_2ndimg1_vlsift = index_vlsift(1,test_index);
index_ifrepeat_1stimg1_vlsift = distance_vlsift(1,:)<1.0;
sum(distance_vlsift(2,:)==0)
sum(distance_vlsift(3,:)==0)
sum(distance_vlsift(4,:)==0)

[index_vlfeat_vlsift, distance_vlfeat_vlsift] = vl_kdtreequery(kdtree1, frames_vlsift(1:2,:), frames_vlfeat(1:2,:),'NUMNEIGHBORS', 5) ;
test_index_vlfeat_vlsift = find(distance_vlfeat_vlsift(1,:)<0.5); % why get different result
index_ifrepeat_1stimg1_vlfeat_vlsift = distance_vlfeat_vlsift(1,:)<0.5;
sum(index_ifrepeat_1stimg1_vlfeat_vlsift)
sum(distance_vlfeat_vlsift(2,:)==0)
sum(distance_vlfeat_vlsift(3,:)==0)
sum(distance_vlfeat_vlsift(4,:)==0)

