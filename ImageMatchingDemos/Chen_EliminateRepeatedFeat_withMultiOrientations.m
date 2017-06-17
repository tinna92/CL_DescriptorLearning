% find the repeated features and delete multiple orientated features 
% (remain only one direction and one feature) 
% 15.11.2015 Lin Chen @ IPI
function[index_if_deletefeat,feat_repeaty] =  Chen_EliminateRepeatedFeat_withMultiOrientations(frames_left)
kdtree_left = vl_kdtreebuild(frames_left(1:2,:));
[index, distance] = vl_kdtreequery(kdtree_left, frames_left(1:2,:),frames_left(1:2,:),'NumNeighbors', 5) ;
%     [index1, distance1] = vl_kdtreequery(kdtree_left,  Frame_Coord_left(1:2,:),Frames_Coord_right2left(1:2,:)) ;
feat_repeaty = ones(1,size(frames_left,2));

% find ii times repeat points in the feature space
index_2times = find( distance(2,:) ==0);
feat_repeaty(1,index_2times) = 2;
index_3times = find( distance(3,:) ==0);
feat_repeaty(1,index_3times) = 3;
feat_repeaty(1,index(1,index_3times))=3;
feat_repeaty(1,index(2,index_3times))=3;
feat_repeaty(1,index(3,index_3times))=3;
index_4times = find( distance(4,:) ==0);
feat_repeaty(1,index_4times) = 4;
feat_repeaty(1,index(1,index_4times))=4;
feat_repeaty(1,index(2,index_4times))=4;
feat_repeaty(1,index(3,index_4times))=4;
feat_repeaty(1,index(4,index_4times))=4;

index_if_deletefeat = zeros(1,size(frames_left,2));  % a index to delete the current feature index
for ii=1:size(frames_left,2)
    if feat_repeaty(ii)==2
        if(index_if_deletefeat(1,index(1,ii)) == 0) % if the current feature is not deleted, then delete its homo features
%             if(index(2,ii)>ii)
                index_if_deletefeat(1,index(2,ii)) =1;
%             end
        end
     else
        if feat_repeaty(ii)==3
            if(index_if_deletefeat(1,index(1,ii)) == 0)
                index_if_deletefeat(1,index(2,ii)) =1; % if the current feature is not deleted, then delete its homo feature
                index_if_deletefeat(1,index(3,ii)) =1;                   
            end
        end
        if feat_repeaty(ii)==4
            if(index_if_deletefeat(1,index(1,ii)) == 0)
                index_if_deletefeat(1,index(2,ii)) =1; % if the current feature is not deleted, then delete its homo feature
                index_if_deletefeat(1,index(3,ii)) =1; 
                index_if_deletefeat(1,index(4,ii)) =1;
            end
        end
    end
end
end