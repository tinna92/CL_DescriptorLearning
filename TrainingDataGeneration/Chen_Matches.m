%% uncomment the following rows to run feature based matching
% img=imread('000002-111406161256-02.tifresize.png');
% img2=imread('000006-111406161233-04.tifresize.png');
% imgs = im2single(img) ;
% imgs2 = im2single(img2) ;
% patchresolution = 9; % give the size of extracted patches from images
% 
% [frames, descrs] = vl_sift(imgs);
% [frames2, descrs2] = vl_sift(imgs2);
% [matches, scores] = vl_ubcmatch(descrs, descrs2,1.5);
% 
% [w1 h1] = size(img);
% [w2 h2] = size(img2);
% num_match = size(matches,2); % get the number of matches
% matchimage(1:w1,1:h1)=img;
% matchimage(w1+11:w1+w2+10,1:h1)=img2;
% if num_match<100
%     num_showmatch = num_match;
% else
%     num_showmatch = 100;
% end
%     
% showindex=randperm(num_match,num_showmatch);
% imshow(matchimage);
% axis on;hold on;
% for i=1:num_showmatch
%    l_index = matches(1,showindex(i));
%    r_index = matches(2,showindex(i));
%    plot([frames(1,l_index),frames2(1,r_index)],[frames(2,l_index),frames2(2,r_index)+w1+11],'r','linewidth',1);
% end
% 
% Match_Single_sift = zeros(1,size(descrs,2));
% match_num = size(matches,2);
% for i=1:match_num
%     Match_Single_sift(1,matches(1,i))=matches(2,i);
% end
%% 

%% first read the original image and detect the DoG features
A = imread('000006-111406161233-04.tifresize.png');
if(size(A,3)>1)
    A_Image = rgb2gray(A);
else
    A_Image = A;
end
A_Image = single(A_Image);
[frames_Image, descrs_Image] = vl_covdet(A_Image, 'Method','DoG','descriptor', 'Patch','PatchResolution',31,'Doubleimage',false,'Verbose','EstimateAffineShape', true) ;
frames_origin = frames_Image(1:2,:);

% do the transformations in differential tilt
tilt = [sqrt(2),2,2*sqrt(2),4];
for ii=1:1
    tform =Chen_AffineTransform( acos(1./tilt(ii)),0,0,1,0,0);
    outputImage = imwarp(A,tform);
    if(size(outputImage,3)>1)
        outputImage = rgb2gray(outputImage);
    end
    imshow(outputImage);
    outputImage = single(outputImage);
    
    [frames1, descrs1] = vl_covdet(outputImage, 'Method','DoG','descriptor', 'Patch','PatchResolution',31,'Doubleimage',false,'Verbose','EstimateAffineShape', true) ;
    vl_plotframe(frames1) ;
    inv_T_temp = inv(tform.T);
    current_frames = frames1(1:2,:);
    current_frames(3,:) =1;
    
    % convert into original images
    newfeatures = inv_T_temp*current_frames;
    
    Tag_left(1,:) =  newfeatures(1,:)-5;
    Tag_left(2,:) =  newfeatures(2,:);
    Tag_right(1,:) =  newfeatures(1,:)+5;
    Tag_right(2,:) =  newfeatures(2,:);
    
    Tag_top(1,:) = newfeatures(1,:);
    Tag_top(2,:) = newfeatures(2,:) + 5;
    Tag_bottom(1,:) = newfeatures(1,:);
    Tag_bottom(2,:) = newfeatures(2,:) - 5;
    figure(2);
    imshow(A);
    hold on;
    num_f = size(newfeatures,2);
    for ii=1:num_f
        plot([Tag_left(1,ii),Tag_right(1,ii)],[Tag_left(2,ii),Tag_right(2,ii)],'r','linewidth',1);
        plot([Tag_top(1,ii),Tag_bottom(1,ii)],[Tag_top(2,ii),Tag_bottom(2,ii)],'r','linewidth',1);
    end
end

%% determine whether the detected points is same to each other.
Num_1 = size(frames_origin,2);
Num_2 = size(newfeatures,2);
for ii = 1:Num_1
    for jj= 1:Num_2
        Dist(ii,jj)=(frames_origin(1,ii)-newfeatures(1,jj))^2+...
            (frames_origin(2,ii)-newfeatures(2,jj))^2;
    end
end
[Dist_min,min_index] = min(Dist);
min_smallerthan1_index = Dist_min<0.3;

% link these features back to original features and affine transformed
% features
num_minindex = size(min_index,2);
min_index_2nd = 1:num_minindex;

SelectedPair_index_1st = min_index(min_smallerthan1_index);
SelectedPair_index_2nd = min_index_2nd(min_smallerthan1_index);

% display on the original images
num_min_smallerthan1_index = sum(min_smallerthan1_index);
figure(3);
imshow(A);
hold on;
num_f = size(newfeatures,2);
for jjj=1:num_min_smallerthan1_index
    ii = SelectedPair_index_2nd(jjj);
    plot([Tag_left(1,ii),Tag_right(1,ii)],[Tag_left(2,ii),Tag_right(2,ii)],'r','linewidth',1);
    plot([Tag_top(1,ii),Tag_bottom(1,ii)],[Tag_top(2,ii),Tag_bottom(2,ii)],'r','linewidth',1);
end

% display on the original image that is without transformation
figure(4);
imshow(A);
hold on;
% get the point coordinates for cross marks drawing
Tag_ori_left(1,:) =  frames_origin(1,:)-5;
Tag_ori_left(2,:) =  frames_origin(2,:);
Tag_ori_right(1,:) =  frames_origin(1,:)+5;
Tag_ori_right(2,:) =  frames_origin(2,:);

Tag_ori_top(1,:) = frames_origin(1,:);
Tag_ori_top(2,:) = frames_origin(2,:) + 5;
Tag_ori_bottom(1,:) = frames_origin(1,:);
Tag_ori_bottom(2,:) = frames_origin(2,:) - 5;
for jjj=1:num_min_smallerthan1_index
    ii = SelectedPair_index_1st(jjj);
    plot([Tag_ori_left(1,ii),Tag_ori_right(1,ii)],[Tag_ori_left(2,ii),Tag_ori_right(2,ii)],'r','linewidth',1);
    plot([Tag_ori_top(1,ii),Tag_ori_bottom(1,ii)],[Tag_ori_top(2,ii),Tag_ori_bottom(2,ii)],'r','linewidth',1);
end


% display the points positions on the affine transformed image
figure(5);
imshow(uint8(outputImage));
hold on;

% get the point coordinates for cross marks drawing
Tag_aff_left(1,:) =  current_frames(1,:)-5;
Tag_aff_left(2,:) =  current_frames(2,:);
Tag_aff_right(1,:) =  current_frames(1,:)+5;
Tag_aff_right(2,:) =  current_frames(2,:);

Tag_aff_top(1,:) = current_frames(1,:);
Tag_aff_top(2,:) = current_frames(2,:) + 5;
Tag_aff_bottom(1,:) = current_frames(1,:);
Tag_aff_bottom(2,:) = current_frames(2,:) - 5;
for jjj=1:num_min_smallerthan1_index
    ii = SelectedPair_index_2nd(jjj);
    plot([Tag_aff_left(1,ii),Tag_aff_right(1,ii)],[Tag_aff_left(2,ii),Tag_aff_right(2,ii)],'r','linewidth',1);
    plot([Tag_aff_top(1,ii),Tag_aff_bottom(1,ii)],[Tag_aff_top(2,ii),Tag_aff_bottom(2,ii)],'r','linewidth',1);
end