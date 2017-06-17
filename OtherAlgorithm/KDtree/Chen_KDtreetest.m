% the kdtree from matlab needs extra license, that is quite annoying!!
%        % Create a KDTreeSearcher object for data X with the 'euclidean' 
%        % distance.
%        X = randn(100,5);
%        ns = createns(X,'nsmethod','kdtree');
%  
%        % Find 5 nearest neighbors in X and the corresponding distance
%        % values for each point in Y.
%        Y = randn(25, 5);
%        [idx, dist] = knnsearch(ns,Y,'k',5);
%  
%        % Find the points in X whose distance are not greater than 0.3 to
%        % the points in Y.
%        idx = rangesearch(ns,Y,0.3);
       
%  X = rand(2, 100) ;  kdtree = vl_kdtreebuild(X) ;
% Q = rand(2, 1) ;
% [index, distance] = vl_kdtreequery(kdtree, X, Q) ;

load('Test_Coord.mat');
Dist_Threshold = 1.0;
Current_repeat_index=0;
frames_origin = coord1(1:2,:);
newfeatures = coord2;
Num_1 = size(frames_origin,2);  
Num_2 = size(newfeatures,2); 
% kdtree = vl_kdtreebuild(frames_origin) ;
% % [index, distance] = vl_kdtreequery(kdtree, frames_origin, newfeatures) ;
% % first_dropout_index = find(distance>1); % first find the obvious wrong points, whose nearst neighbor is more than 1 pixel
% % newfeatures(:,first_dropout_index)=[];
% [index, distance] = vl_kdtreequery(kdtree, frames_origin, newfeatures,'NumNeighbors', 5) ;
% test_index = find(distance(1,:)<1.0);


kdtree1 = vl_kdtreebuild(newfeatures) ;
% [index, distance] = vl_kdtreequery(kdtree, frames_origin, newfeatures) ;
% first_dropout_index = find(distance>1); % first find the obvious wrong points, whose nearst neighbor is more than 1 pixel
% newfeatures(:,first_dropout_index)=[];
[index, distance] = vl_kdtreequery(kdtree1, newfeatures, frames_origin) ;
test_index = find(distance(1,:)<1.0); % why get different result
% test_index = distance(1,:)<1.0;
repeated_feature_index_2ndimg1 = index(1,test_index);
index_ifrepeat_1stimg1 = distance(1,:)<1.0;
% only with the above 4 lines code the repeated features could be found
% out. 

% kdtree2 = vl_kdtreebuild(frames_origin) ;
% [index, distance] = vl_kdtreequery(kdtree2, frames_origin, frames_origin,'NumNeighbors', 10) ;
% min(distance(2,:)); % ?????1???????????????????????????????????