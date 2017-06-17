% analyse the features repeatability using the oct tree
function [index_ifrepeat_1stimg,repeated_feature_index_2ndimg] = Chen_analy_repeatedfeatures_in_2Images2_quadtree(frames_origin, frames_aff,aff_T,similarity_threshold)
% load('Test_Coord.mat');

inv_T_temp = inv(aff_T);
current_frames = frames_aff(1:2,:);
current_frames(3,:) =1;
newfeatures = frames_aff;

Dist_Threshold = similarity_threshold;
Current_repeat_index=0;
frames_origin = frames_origin';
newfeatures = newfeatures';
Num_1 = size(frames_origin,1);  
Num_2 = size(newfeatures,1); % num of image features in the transformed version image
% in the following stages we use quadtree to boost the computing speed.
X_frames(1:Num_1) = frames_origin(:,1);
Y_frames(1:Num_1) = frames_origin(:,2);
X_frames(Num_1+1:Num_1+Num_2) = newfeatures(:,1);
Y_frames(Num_1+1:Num_1+Num_2) = newfeatures(:,2);
ss = ones(1,Num_1+Num_2);
[ind,bx,by,Nb,lx,ly] = quadtree(X_frames,Y_frames,ss,32);
plot(lx(:,[1 2 2 1 1])',ly(:,[1 1 2 2 1])');
Ind_Newfeature = ind(Num_1+1:Num_1+Num_2);
for kk=1:Num_1
    ind1 = ind(kk); % get the index of the quadtree blocks for the point on original image
    xx = find(Ind_Newfeature==ind1);
    Num_overlapp = size(xx,2);
    if Num_overlapp~=0
        if Num_overlapp>1
            for ii = 1:Num_overlapp
                c_index = xx(ii);
                Dist(ii) = (X_frames(kk)-X_frames(Num_1 + c_index)).^2 + ...
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

end