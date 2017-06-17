% duplicate filtering of ASIFT matches according to 
% MODS: Fast and Robust Method for Two-View Matching
% D Mishkin, J Matas, M Perdoch - arXiv preprint arXiv:1503.02619, 2015
function [filtered_outmatches] = Chen_DuplicateFileteringforViewSphereMatching(frames1,frames2,matches,threshold_manytone,threshold_onetomany)
% Initial_MatchNum = size(match,2);
img_coord1 = frames1(1:2,matches(1,:));
img_coord2 = frames2(1:2,matches(2,:));
Num_1 = size(img_coord1,2);  
% Num_2 = size(img_coord2,2); % num of image features in the transformed version image

for ii = 1:Num_1
    for jj= 1:Num_1
        Dist1(ii,jj)=(img_coord1(1,ii)-img_coord1(1,jj))^2+...
            (img_coord1(2,ii)-img_coord1(2,jj))^2;
        Dist2(ii,jj)=(img_coord2(1,ii)-img_coord2(1,jj))^2+...
            (img_coord2(2,ii)-img_coord2(2,jj))^2;
    end
end

filtered_outmatches = matches;

for ii = 1:Num_1
    [Minv,indexMin] = min(Dist1(ii,:));
    if(Minv<threshold_manytone)
         % find and remove the many to one
        if (Dist2(ii,indexMin)<threshold_manytone)
            NN = randperm(2,1);
            if NN == 2
                Dist1(indexMin,:)=[];
                Dist2(indexMin,:)=[];
                filtered_outmatches(1:2,indexMin) = [];
            end
            if NN == 1
                Dist1(ii,:)=[];
                Dist2(ii,:)=[];
                filtered_outmatches(1:2,ii) = [];
            end
            Num_1 = Num_1-1;
        end
    end
    
    if(Minv<threshold_onetomany)
         % find and remove the many to one
        if (Dist2(ii,indexMin)>3*threshold_manytone) % if the corresponding points spread in other image
            NN = randperm(2,1);
            if NN == 2
                Dist1(indexMin,:)=[];
                Dist2(indexMin,:)=[];
                filtered_outmatches(1:2,indexMin) = [];
            end
            if NN == 1
                Dist1(ii,:)=[];
                Dist2(ii,:)=[];
                filtered_outmatches(1:2,ii) = [];
            end
            Num_1 = Num_1-1;
        end
    end
end


% 
% % find the pair of features that is lied in less than 0.3 pixel (threshold)
% [Dist_min,min_index] = min(Dist');
% min_smallerthan1_index = Dist_min<similarity_threshold; % this is the index for the orignal image
% num_minindex = size(min_index,2);
% min_index_2nd = 1:num_minindex;
% second_image_index = min_index.*min_smallerthan1_index;
% SelectedPair_index_2nd = min_index(min_smallerthan1_index);
% SelectedPair_index_1st = min_index_2nd(min_smallerthan1_index);

end