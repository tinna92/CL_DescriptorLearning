% image_name = '000003-111406161250-04.tifresize.png';
% % image_name = 'box.png';
% % image_name = 'test.PNG';
similarity_threshold = 1.0;
feature_detector_type = 'DoG';
n=3;
a=sqrt(2);
b=72;
% [repeat_score_2originimage1,repeat_score_tilt2rotate1] = Chen_imagerepeatability_inoneImage_analysis3(image_name,feature_detector_type,n,a,b,similarity_threshold);
% 
% [frames_Aff,descrs_Aff,feature_inwhichview] = Chen_ExtractedAffineimageFeatures_2(img_path,feature_detector_type,descriptor_type,n,a,b);
img_name1 = 'E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\images\003_017_145000238.tifresize.png';
img_name2 = 'E:\MultiPlatform Photogrammetry dataset\RELEASE_FOLDER_IMAGE_ORIENTATION\Photogrammetric_image_block\images\007_017_163000166.tifresize.png';

% frames_Aff1 indicates the frame features (all on original image or mapping back to it); descrs_Aff1 are the
% corresponding descriptors. feature_index: which affine image is the
% feature located(which tilt and which rotation). frames_insimulatedimage_index1: index in the affine
% image for current features.
[frames_Aff1,descrs_Aff1,feature_index1,frames_insimulatedimage_index1] = Chen_ExtractedAffineimageFeatures2(img_name1,'DoG','SIFT',3,sqrt(2),72);
[frames_Aff2,descrs_Aff2,feature_index2,frames_insimulatedimage_index2] = Chen_ExtractedAffineimageFeatures2(img_name2,'DoG','SIFT',3,sqrt(2),72);


%% this part is used to match directly on the ensambled extracted features
match_ratio  =1.3;
[matches_Desc, scores_Desc] = vl_ubcmatch(descrs_Aff1, descrs_Aff2,match_ratio); % if we run it only on the collected image features, then the calculation is very expensive!!!
% randm_selected = randperm();
Chen_show_matchresult(rgb2gray(imread(img_name1)),...
    rgb2gray(imread(img_name2)),matches_Desc,frames_Aff1,frames_Aff2,0);
clear F_matrix inlinear_index img_coord1 img_coord2 correct_Match_coord1 correct_Match_coord2;
[F_matrix,inlinear_index] = Chen_estimateFundmentalmatrix_RANSAC(frames_Aff1,frames_Aff2,matches_Desc,2,30000);
Initial_MatchNum = size(matches_Desc,2);
img_coord1 = frames_Aff1(1:2,matches_Desc(1,:));
img_coord2 = frames_Aff2(1:2,matches_Desc(2,:));
correct_Match_coord1 = img_coord1(1:2,inlinear_index);
correct_Match_coord2 = img_coord2(1:2,inlinear_index);
draw_epipolar_lines(F_matrix,rgb2gray(imread(img_name1)),...
    rgb2gray(imread(img_name2)),correct_Match_coord1',correct_Match_coord2');
Chen_show_matchresult(rgb2gray(imread(img_name1)),rgb2gray(imread(img_name2)), matches_Desc(1:2,inlinear_index),frames_Aff1,frames_Aff2,0);


%% in this part, the features are matched across different versions of
% affine transformed images. 

% get the number of feature points in each affined version
a = sqrt(2); n = 3; b = 72;
for ii=1:n+1
    t(ii)=a^(ii-1);
    k(ii) = floor(t(ii)*180/b)+1;
end
num_features = zeros(n,k(n));
num_features2 = zeros(n,k(n));

for nn = 1:size(feature_index1,1)
    ii = feature_index1(nn,1);
    jj = feature_index1(nn,2);
    num_features(ii,jj) =num_features(ii,jj)+ 1; 
end

for nn = 1:size(feature_index2,1)
    ii = feature_index2(nn,1);
    jj = feature_index2(nn,2);
    num_features2(ii,jj) =num_features2(ii,jj)+ 1; 
end

% extract the feature descriptors for every version of images
count_n1 = 0;
count_n2 = 0;
for ii=1:n
    for jj=1:k(ii)
        feature_Desc1{ii,jj} = descrs_Aff1(:,count_n1+1:count_n1+num_features(ii,jj));
        feature_1{ii,jj} = frames_Aff1(:,count_n1+1:count_n1+num_features(ii,jj));
        count_n1 = count_n1+num_features(ii,jj);
        feature_Desc2{ii,jj} = descrs_Aff2(:,count_n2+1:count_n2+num_features2(ii,jj));
        feature_2{ii,jj} = frames_Aff2(:,count_n1+1:count_n1+num_features(ii,jj));
        count_n2 = count_n2+num_features2(ii,jj);
    end
end

% match them (use image to image)and preserve the result in a struct of
% Num x Num form, where Num represents the number of affine image versions
match_ratio = 1.7;
count_out =1;
count_in = 1;
match_num =0;
for ii=1:n
    for jj=1:k(ii)
        for iii = 1:n
            for jjj = 1:k(iii)
%                 [matches_Desc, scores_Desc] = vl_ubcmatch(descrs_Aff1, descrs_Aff2,match_ratio); 
                [matches_Desc_af{count_out,count_in},scores_Desc_af{count_out,count_in}] = ...
                    vl_ubcmatch(feature_Desc1{ii,jj}, feature_Desc2{iii,jjj},match_ratio);
                match_num = match_num + numel(scores_Desc_af{count_out,count_in}) ; % record the number of matches
                count_in = count_in +1;
            end
        end 
        count_in = 1;
        count_out = count_out +1;
    end
end

% calculate the number of matches and put all the match in an unified
% structure (store them in Match_corresp, a 2 x matching_points_num matrix)
matches_Desc_af_cp = matches_Desc_af;
count_out =1;
count_in = 1;
match_num =0;
count_n1 = 0;
count_n2 = 0;
for ii=1:n
    for jj=1:k(ii)
        for iii = 1:n
            for jjj = 1:k(iii)
                matches_Desc_af_cp{count_out,count_in}(1,:) = matches_Desc_af_cp{count_out,count_in}(1,:) + count_n1;
                matches_Desc_af_cp{count_out,count_in}(2,:) = matches_Desc_af_cp{count_out,count_in}(2,:) + count_n2;
                count_n2 = count_n2+num_features2(iii,jjj);
                Match_corresp(1:2,match_num+1:match_num + numel(scores_Desc_af{count_out,count_in})) =...
                    matches_Desc_af_cp{count_out,count_in}; % record the matching as a direct 2 x match_num form
                match_num = match_num + numel(scores_Desc_af{count_out,count_in}) ; % record the matching number
                count_in = count_in + 1;
            end
        end 
        count_in = 1;
        count_out = count_out +1;
        count_n1 = count_n1+num_features(ii,jj);
        count_n2 = 0;
    end
end

% Ransac feature matching points filtering
Chen_show_matchresult(rgb2gray(imread(img_name1)),rgb2gray(imread(img_name2)), Match_corresp,frames_Aff1,frames_Aff2,0);
[F_matrix,inlinear_index] = Chen_estimateFundmentalmatrix_RANSAC(frames_Aff1,frames_Aff2,Match_corresp,2,30000);
Initial_MatchNum = size(Match_corresp,2);
img_coord1 = frames_Aff1(1:2,Match_corresp(1,:));
img_coord2 = frames_Aff2(1:2,Match_corresp(2,:));
correct_Match_coord1 = img_coord1(1:2,inlinear_index);
correct_Match_coord2 = img_coord2(1:2,inlinear_index);
draw_epipolar_lines(F_matrix,rgb2gray(imread(img_name1)),...
    rgb2gray(imread(img_name2)),correct_Match_coord1',correct_Match_coord2');
Chen_show_matchresult(rgb2gray(imread(img_name1)),rgb2gray(imread(img_name2)), Match_corresp(1:2,inlinear_index),frames_Aff1,frames_Aff2,0);

% % analyze the features, see the repeatablity of them between the features
% % on the original image and the affine versions
% for ii=1:n
%     for jj=1:k(ii)
%         lat = t(ii);
%         log = (jj-1)*b*pi/(180*lat);
%         tform =Chen_AffineTransform( acos(1./lat),log,0,1,0,0);
%         [index_ifrepeat_1stimg{ii,jj},repeated_feature_index_2ndimg{ii,jj}] = ...
%             Chen_analy_repeatedfeatures_in_2Images2_quadtree(feature_1{1,1}, feature_1{ii,jj},tform.T,1);
%     end
% end

% analyze the repeatable features in each feature set by the function Chen_analyze_repeatable_features
Re_index1 = Chen_analyze_repeatable_features(frames_Aff1,32); %analyze how much of the features are repeatable features 
Re_index2 = Chen_analyze_repeatable_features(frames_Aff2,32);
Re_Match_cp(1,:) = Re_index1(Match_corresp(1,:));
Re_Match_cp(2,:) = Re_index2(Match_corresp(2,:));

yyyy = unique(Re_Match_cp','rows'); % find how many of them are repeated features with other ones
Chen_show_matchresult(rgb2gray(imread(img_name1)),rgb2gray(imread(img_name2)), yyyy',frames_Aff1,frames_Aff2,0);
yyyy =yyyy';

% find the inlinears of matchng points by RANSAC
clear inlinear_index;
[F_matrix,inlinear_index] = Chen_estimateFundmentalmatrix_RANSAC(frames_Aff1,frames_Aff2,yyyy,2,30000);
Initial_MatchNum = size(Match_corresp,2);
clear img_coord1 img_coord2 correct_Match_coord1 correct_Match_coord2;
img_coord1 = yyyy(1:2,Match_corresp(1,:));
img_coord2 = yyyy(1:2,Match_corresp(2,:));
correct_Match_coord1 = img_coord1(1:2,inlinear_index);
correct_Match_coord2 = img_coord2(1:2,inlinear_index);

% draw epipolar lines and show matching result.
draw_epipolar_lines(F_matrix,rgb2gray(imread(img_name1)),...
    rgb2gray(imread(img_name2)),correct_Match_coord1',correct_Match_coord2');
Chen_show_matchresult(rgb2gray(imread(img_name1)),rgb2gray(imread(img_name2)), yyyy(1:2,inlinear_index),frames_Aff1,frames_Aff2,0);



% % remove the duplicate features in the 2 images by using the repeat table 
% % anylyze the features in frames_Aff1
% Num_1 = size(frames_Aff1,2);  
% Num_2 = size(frames_Aff1,2); 
% X_frames(1:Num_1) = frames_Aff1(1,:);
% Y_frames(1:Num_1) = frames_Aff1(2,:);
% % X_frames(Num_1+1:Num_1+Num_2) = feature_1{ii,jj}(1,:);
% % Y_frames(Num_1+1:Num_1+Num_2) = feature_1{ii,jj}(2,:);
% ss = ones(1,Num_1);
% [ind,bx,by,Nb,lx,ly] = quadtree(X_frames,Y_frames,ss,32); % how kdtree works?
% plot(lx(:,[1 2 2 1 1])',ly(:,[1 1 2 2 1])');
% % seek the repeat in every block of quadtree cells
% Re_index = 1:numel(X_frames);
% for kk = 1:max(ind)
%     qq = find(ind==kk);
%     xx = find(ind==kk);
%     Num_overlapp = size(xx,2);
%     if Num_overlapp>1 % if there are more than 1 points in the current grid , then it need to be check
%         XX = pdist([X_frames(xx);Y_frames(xx)]');
%         Dist = squareform(XX);
%         Dist_smallthan1 = Dist<1;
%         for ii = 1:Num_overlapp
%             for jj = 1:Num_overlapp
%                 if Dist_smallthan1(ii,jj)==1
%                     C_index(ii)=min(xx(ii),xx(jj));
%                     xx(jj) = C_index(ii);
%                 end
%             end
%         end
%         Re_index(qq) = C_index;
%         clear xx qq XX Dist Dist_smallthan1 C_index;
%     end
% end




XX = pdist([X_frames(xx);Y_frames(xx)]');
Z1=squareform(XX);
Z=linkage(Z1)
C2=cophenet(Z,XX);  
T=cluster(Z,'Cutoff',1);
H=dendrogram(Z);
H=dendrogram(Z);

for kk=1:Num_1
    ind1 = ind(kk); % get the index of the quadtree blocks for the point on original image
    xx = find(ind==ind1);
    Num_overlapp = size(xx,2);
    if Num_overlapp~=0
        if Num_overlapp>1
            for ii = 1:Num_overlapp
                c_index = xx(ii);
                Dist(ii,jj) = (X_frames(kk)-X_frames(Num_1 + c_index)).^2 + ...
                    (Y_frames(kk)-Y_frames(Num_1 + c_index)).^2;
            end
            [min_Dist,min_index] = min(Dist);
            if min_Dist<Dist_Threshold
                index_ifrepeat_1stimg(kk)=1;
                Current_repeat_index = Current_repeat_index+1;
                repeated_feature_index_2ndimg(Current_repeat_index) = xx(min_index);
            else
                index_ifrepeat_1stimg(kk)=0;
            end
            clear Dist c_index;
        else % only one in overlapping area
            c_index = xx;
            Dist = (X_frames(kk)-X_frames(Num_1 + c_index)).^2 + (Y_frames(kk)-Y_frames(Num_1 + c_index)).^2;
            if Dist<Dist_Threshold
               Current_repeat_index = Current_repeat_index+1;
               repeated_feature_index_2ndimg(Current_repeat_index) = xx;
               index_ifrepeat_1stimg(kk)=1; 
            else
               index_ifrepeat_1stimg(kk)=0; 
            end
            clear Dist c_index;
        end
    else
        index_ifrepeat_1stimg(kk)=0; 
    end
    clear xx;
end




count_n1 = 0;
for ii=1:n
    for jj=1:k(ii)
        % if the feature is calculated on both images, find them
        if_repeat_index{ii,jj}  = zeros(1,size(feature_1{ii,jj},2));
        if_repeat_index{ii,jj}(repeated_feature_index_2ndimg{ii,jj}) = 1;
        count_n1 = count_n1+num_features(ii,jj);
    end
end

% test how quadtree works

Num_1 = size(feature_1{1,1},2);  
Num_2 = size(feature_1{ii,jj},2); 
X_frames(1:Num_1) = feature_1{1,1}(1,:);
Y_frames(1:Num_1) = feature_1{1,1}(2,:);
X_frames(Num_1+1:Num_1+Num_2) = feature_1{ii,jj}(1,:);
Y_frames(Num_1+1:Num_1+Num_2) = feature_1{ii,jj}(2,:);
ss = ones(1,Num_1+Num_2);
[ind,bx,by,Nb,lx,ly] = quadtree(X_frames,Y_frames,ss,32);
plot(lx(:,[1 2 2 1 1])',ly(:,[1 1 2 2 1])');

% map all the matched features to original image

% IDX = [1,2,3;  
%            2,3,1;  
%            1,2,3;  
%            2,3,1;  
%            1,1,1;  
%            1,1,1];  
% classNo = unique(IDX,'rows');    
% a = [1,2,3];  
% b = [1,5,4];  
% [tfa,loca] = ismember(a,classNo,'rows')  
% [tfb,locb] = ismember(b,classNo,'rows')  
% unique(a','rows')'
%
[repeat_score_2originimage1,repeat_score_tilt2rotate1,index_origin_image1,index_aff_image1] = Chen_imagerepeatability_inoneImage_analysis3(img_name1,feature_detector_type,n,a,b,similarity_threshold);
[repeat_score_2originimage2,repeat_score_tilt2rotate2,index_origin_image2,index_aff_image2] = Chen_imagerepeatability_inoneImage_analysis3(img_name2,feature_detector_type,n,a,b,similarity_threshold);


% test and see how many features are from repeatable fetures and how many
% of them are from unrepeatable features(to the original image)
Feature_Num1 = size(feature_index1,1);
Feature_Num(1:3,1:6)=0;
for kkk = 1:Feature_Num1
    ii = feature_index1(kkk,1); 
    jj = feature_index1(kkk,2);
    Feature_Num(ii,jj)=Feature_Num(ii,jj)+1;
end

% Match_Num = size(matches_Desc,2);

Match_feature_Num(1:3,1:6)=0;
Sum_Feature_Num = 0;
for ii=1:3
    for jj=1:6
        
    end
end
Current_Num = Current_Num+Feature_Num(ii,jj);
Match_Num = size(inlinear_index,2);
Repeat_Count = 0;
Origin_Index = 0;
for kk = 1:Match_Num
%     c_index = matches_Desc(1,kk);
    c_index = matches_Desc(1,inlinear_index(kk));
    ii = feature_index1(c_index,1); jj = feature_index1(c_index,2); % ii:which tilt, jj:which rotation
    Match_feature_Num(ii,jj) = Match_feature_Num(ii,jj)+1;
    Frames_featureinsimulatedImage_index(kk) = frames_insimulatedimage_index1(c_index); % which features in the affined images 
    Current_frame_index = Frames_featureinsimulatedImage_index(kk); %
    if (find(index_aff_image1{ii,jj}==Current_frame_index)) %see if one could find this feature in the affined images
%         NN_index = find(index_aff_image1{ii,jj}==Current_frame_index);
        Repeat_Count = Repeat_Count + 1;
%         Origin_Index(Repeat_Count) = size(find(index_origin_image1{ii,jj},NN_index),2);
        
    end
    
%     ind(index_aff_image1(Frames_featureinsimulatedImage_index(kk)));
end
fprintf('Correct Matched Features:%d \n  features from original image: %d \n repeat ration: %f\n ',Match_Num,Repeat_Count,Repeat_Count/Match_Num);

Match_feature_Num2(1:3,1:6)=0;
Repeat_Count2 = 0;
for kk = 1:Match_Num
%     c_index = matches_Desc(1,kk);
    c_index = matches_Desc(2,inlinear_index(kk));
    ii = feature_index2(c_index,1); jj = feature_index2(c_index,2); % ii:which tilt, jj:which rotation
    Match_feature_Num2(ii,jj) = Match_feature_Num2(ii,jj)+1;
    Frames_featureinsimulatedImage_index2(kk) = frames_insimulatedimage_index2(c_index); % which features in the affined images 
    Current_frame_index = Frames_featureinsimulatedImage_index2(kk); %
    if (find(index_aff_image2{ii,jj}==Current_frame_index)) %see if one could find this feature in the affined images
        Repeat_Count2 = Repeat_Count2 + 1;
    end
    
%     ind(index_aff_image1(Frames_featureinsimulatedImage_index(kk)));
end
fprintf('image 2\n Correct Matched Features:%d \n  features from original image: %d \n repeat ration: %f\n ',Match_Num,Repeat_Count2,Repeat_Count2/Match_Num);

for ii=1:n+1
    t(ii)=a^(ii-1);
    k(ii) = floor(t(ii)*180/b)+1;
end
Repeattimes = zeros(size(index_origin_image1{ii,jj}));

for ii=1:n
    for jj=1:k(ii)
        Repeattimes = Repeattimes+index_origin_image1{ii,jj};
    end
end

hist(Repeattimes,13,1);
% for kkk = 1:Repeat_Count
%     Repeat_MatchedFeature_kkk = ();
% end
% feature_detector_type = {'DoG','Hessian','HessianLaplace','HarrisLaplace','MultiscaleHessian','MultiscaleHarris'};
subplot(2,1,1);bar3(Repeatfactor_alldetector{1,1});set(gca,'ztick',[0:0.1:1]);xlabel('tilt');ylabel('rotation');title('repeatability in Viewsphere for DoG');
subplot(2,1,2);bar3(Repeatfactor_alldetector{2,1});set(gca,'ztick',[0:0.1:1]);xlabel('tilt');ylabel('rotation');title('repeatability in Viewsphere for Hessian');
subplot(2,1,1);bar3(Repeatfactor_alldetector{3,1});set(gca,'ztick',[0:0.1:1]);xlabel('tilt');ylabel('rotation');title('repeatability in Viewsphere for HessianLaplace');
subplot(2,1,2);bar3(Repeatfactor_alldetector{4,1});set(gca,'ztick',[0:0.1:1]);xlabel('tilt');ylabel('rotation');title('repeatability in Viewsphere for HarrisLaplace');
subplot(2,1,1);bar3(Repeatfactor_alldetector{5,1});set(gca,'ztick',[0:0.1:1]);xlabel('tilt');ylabel('rotation');title('repeatability in Viewsphere for MultiscaleHessian');
subplot(2,1,2);bar3(Repeatfactor_alldetector{6,1});set(gca,'ztick',[0:0.1:1]);xlabel('tilt');ylabel('rotation');title('repeatability in Viewsphere for MultiscaleHarris');

