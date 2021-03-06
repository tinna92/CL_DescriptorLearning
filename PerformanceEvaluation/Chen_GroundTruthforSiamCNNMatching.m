% there is a big difference between SIFT descriptor and SiameseCNN. In
% SIFT, the dominent direction is calculated and any other direction that
% is over 80% of the most dominent direction will also be assigned as
% dominant directions. In this case, there will be more than 1 dominent
% directions for some feature and hence more than one descirptors for some
% feature. However, in Siamese CNN, the dominant direction is not
% considered in the training data, at least not seriously, so there is a
% need to make some special ground truth matching data for SiameCNN
% architecture since it has only one descriptor for each detector.

% to get these ground truth, 1) get the homography matrix in the data;
% 2)calculate the point correspondence of each feature in the first image
% and get its corresponding feature index by comparision using eucalidean
% distances. 3) build the ground truth matching data for each pair of
% images. The comparison is only based on coordinate difference so far.

Maindir = 'E:\software\IPI\Data\';
Dataset_Name = 'graf';
Homofile_Name = {'H1to2p','H1to3p','H1to4p','H1to5p','H1to6p'};

% first read the homography matrix 
for ii=1:5
    fid = fopen(Homofile_Name{ii});
    Homo_temp{ii} = fscanf(fid,'%f',[3,inf])';
    fclose(fid);
end

% then extract features and originse them into patches.
D = dir([Maindir Dataset_Name '\*.ppm']);
nFiles = numel(D);
img_left = imread([Maindir Dataset_Name '\' D(1).name]);
% [PatchDir D(iFile).name];
if(size(img_left,3)>1)
    img_left = rgb2gray(img_left);
else
    img_left = img_left;
end
img_left = im2single(img_left);
% [frames_left,Patch_left] = chen_extractSIFTpatch_CNN(img_left);
[frames_left,Patch_left] = Chen_extractedFeature_Only1OrientationEachFeature(img_left);
Frame_Coord_left = frames_left(1:2,:);
Frame_Coord_left(3,:) = 1;
% kdtree_left = vl_kdtreebuild(Frame_Coord_left(1:2,:)) ;
save([Dataset_Name '_Patch_img_4SiamCNN_' num2str(1) '.mat'],'Patch_left');
for ii=2:6
    Homo_Mat = Homo_temp{ii-1}; % get homography matrix
    
    %read and get features and Patches
    img_right = imread([Maindir Dataset_Name '\' D(ii).name]);
    if(size(img_right,3)>1)
        img_right = rgb2gray(img_right);
    else
        img_right = img_right;
    end
    img_right = im2single(img_right);
%     [frames_right,Patch_right] = chen_extractSIFTpatch_CNN(img_right); 
    [frames_right,Patch_right] = Chen_extractedFeature_Only1OrientationEachFeature(img_right); 
    Frame_Coord_right = frames_right(1:2,:);
    Frame_Coord_right(3,:) = 1;
   
    % transformation and comparison
%     Frames_Coord_left2right = Homo_Mat*Frame_Coord_left;
    Frames_Coord_right2left = inv(Homo_Mat)*Frame_Coord_right;
    for index = 1:size(Frames_Coord_right2left,2)
%         Frames_Coord_left2right(1:3,index)= Frames_Coord_left2right(1:3,index)/Frames_Coord_left2right(3,index);
        Frames_Coord_right2left(1:3,index)= Frames_Coord_right2left(1:3,index)/Frames_Coord_right2left(3,index);
    end
    kdtree_right = vl_kdtreebuild(Frames_Coord_right2left(1:2,:)) ;
    [index, distance] = vl_kdtreequery(kdtree_right, Frames_Coord_right2left(1:2,:), Frame_Coord_left(1:2,:),'NumNeighbors', 3) ;
%     [index1, distance1] = vl_kdtreequery(kdtree_left,  Frame_Coord_left(1:2,:),Frames_Coord_right2left(1:2,:)) ;
    index_groundth = find(distance(1,:)<1);
    for kk=1:numel(index_groundth)
        matches_groundtruth(1,kk) = index_groundth(kk);
        matches_groundtruth(2,kk) = index(1,index_groundth(kk));
    end
    Chen_show_matchresult(uint8(255*img_left),uint8(255*img_right), matches_groundtruth,frames_left,frames_right,0);
    truth_match_index = index(1,:);
    index_groundthnonmatch = find(distance(1,:)>1);
    truth_match_index(index_groundthnonmatch)=0;
    Groundtruth_match_SiamCNN{ii} = truth_match_index;
    save([Dataset_Name '_Patch_img_4SiamCNN_' num2str(ii) '.mat'],'Patch_right'); % record the patch for evaluation
    clear matches_groundtruth;
end
save([Dataset_Name 'Groundtruth_match_SiamCNN' '.mat'],'Groundtruth_match_SiamCNN');
% draw one pair of ground truth matching for visual checking
