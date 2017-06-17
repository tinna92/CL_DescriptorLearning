% I = imread('liftingbody.png');
% S = qtdecomp(I,.27);
% blocks = repmat(uint8(0),size(S));
% for dim = [512 256 128 64 32 16 8 4 2 1];  
%     numblocks = length(find(S==dim));    
%     if (numblocks > 0)        
%         values = repmat(uint8(1),[dim dim numblocks]);
%         values(2:dim,2:dim,:) = 0;
%         blocks = qtsetblk(blocks,S,dim,values);
%     end
% end
% blocks(end,1:end) =1;
% blocks(1:end,end) = 1;
% imshow(I),figure,imshow(blocks,[]);
% 
% I1 = uint8(zeros(666,999));
% S1 = qtdecomp(I1,.27);
% 
% xx =randperm(10000,5000);
% yy =randperm(10000,5000);
% ss=ones(1,5000);
% [ind,bx,by,Nb,lx,ly] = quadtree(xx,yy,ss,9);
% plot(lx(:,[1 2 2 1 1])',ly(:,[1 1 2 2 1])');

load('Test_Coord.mat');

% the naive comparison of image coordinates is not intelligent enough
similarity_threshold = 1.0
frames_origin = coord1;
newfeatures = coord2;
Num_1 = size(frames_origin,2);  
Num_2 = size(newfeatures,2); % num of image features in the transformed version image
for ii = 1:Num_1
    for jj= 1:Num_2
        Dist(ii,jj)=(frames_origin(1,ii)-newfeatures(1,jj))^2+...
            (frames_origin(2,ii)-newfeatures(2,jj))^2;
    end
end

% find the pair of features that is lied in less than 0.3 pixel (threshold)
[Dist_min,min_index] = min(Dist');
min_smallerthan1_index = Dist_min<similarity_threshold; % this is the index for the orignal image
num_minindex = size(min_index,2);
min_index_2nd = 1:num_minindex;
second_image_index = min_index.*min_smallerthan1_index;
SelectedPair_index_2nd = min_index(min_smallerthan1_index);
SelectedPair_index_1st = min_index_2nd(min_smallerthan1_index);
index_ifrepeat_1stimg = min_smallerthan1_index;
repeated_feature_index_2ndimg = SelectedPair_index_2nd;

% load('Test_Coord.mat');
% Dist_Threshold = 1.0;
% Current_repeat_index=0;
% frames_origin = coord1';
% newfeatures = coord2';
% Num_1 = size(frames_origin,1);  
% Num_2 = size(newfeatures,1); % num of image features in the transformed version image
% % in the following stages we use quadtree to boost the computing speed.
% X_frames(1:Num_1) = frames_origin(:,1);
% Y_frames(1:Num_1) = frames_origin(:,2);
% X_frames(Num_1+1:Num_1+Num_2) = newfeatures(:,1);
% Y_frames(Num_1+1:Num_1+Num_2) = newfeatures(:,2);
% ss = ones(1,Num_1+Num_2);
% [ind,bx,by,Nb,lx,ly] = quadtree(X_frames,Y_frames,ss,32);
% % plot(lx(:,[1 2 2 1 1])',ly(:,[1 1 2 2 1])');
% Ind_Newfeature = ind(Num_1+1:Num_1+Num_2);
% for kk=1:Num_1
%     ind1 = ind(kk); % get the index of the quadtree blocks for the point on original image
%     xx = find(Ind_Newfeature==ind1);
%     Num_overlapp = size(xx,2);
%     if Num_overlapp~=0
%         if Num_overlapp>1
%             for ii = 1:Num_overlapp
%                 c_index = xx(ii);
%                 Dist(ii) = (X_frames(kk)-X_frames(Num_1 + c_index)).^2 + ...
%                     (Y_frames(kk)-Y_frames(Num_1 + c_index)).^2;
%             end
%             [min_Dist,min_index] = min(Dist);
%             if min_Dist<Dist_Threshold
%                 index_ifrepeat_1stimg(kk)=1;
%                 Current_repeat_index = Current_repeat_index+1;
%                 repeated_feature_index_2ndimg(Current_repeat_index) = xx(min_index);
%             else
%                 index_ifrepeat_1stimg(kk)=0;
%             end
%             clear Dist c_index;
%         else % only one in overlapping area
%             c_index = xx;
%             Dist = (X_frames(kk)-X_frames(Num_1 + c_index)).^2 + (Y_frames(kk)-Y_frames(Num_1 + c_index)).^2;
%             if Dist<Dist_Threshold
%                Current_repeat_index = Current_repeat_index+1;
%                repeated_feature_index_2ndimg(Current_repeat_index) = xx;
%                index_ifrepeat_1stimg(kk)=1; 
%             else
%                index_ifrepeat_1stimg(kk)=0; 
%             end
%             clear Dist c_index;
%         end
%     else
%         index_ifrepeat_1stimg(kk)=0; 
%     end
%     clear xx;
% end