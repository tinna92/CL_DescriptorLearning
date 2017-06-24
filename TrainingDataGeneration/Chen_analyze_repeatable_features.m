% remove the duplicate features in the 2 images by using the repeat table 
% anylyze the features in frames_Aff1;Max_n_eachblock:maximum permissible
%	number of "counted" points in the elementary block.
% if two features lies inside a circle of radius 1, then it can only
% preserve one
function Re_index = Chen_analyze_repeatable_features(frames_Aff1,Max_n_eachblock)
Num_1 = size(frames_Aff1,2);  
Num_2 = size(frames_Aff1,2); 
X_frames(1:Num_1) = frames_Aff1(1,:);
Y_frames(1:Num_1) = frames_Aff1(2,:);
% X_frames(Num_1+1:Num_1+Num_2) = feature_1{ii,jj}(1,:);
% Y_frames(Num_1+1:Num_1+Num_2) = feature_1{ii,jj}(2,:);
ss = ones(1,Num_1);
[ind,bx,by,Nb,lx,ly] = quadtree(X_frames,Y_frames,ss,Max_n_eachblock); % how kdtree works?
plot(lx(:,[1 2 2 1 1])',ly(:,[1 1 2 2 1])');
% seek the repeat in every block of quadtree cells
Re_index = 1:numel(X_frames);
for kk = 1:max(ind)
    qq = find(ind==kk);
    xx = find(ind==kk);
    Num_overlapp = size(xx,2);
    if Num_overlapp>1 % if there are more than 1 points in the current grid , then it need to be check
        XX = pdist([X_frames(xx);Y_frames(xx)]');
        Dist = squareform(XX);
        Dist_smallthan1 = Dist<1.0;
        for ii = 1:Num_overlapp
            for jj = 1:Num_overlapp
                if Dist_smallthan1(ii,jj)==1
                    C_index(ii)=min(xx(ii),xx(jj));
                    xx(jj) = C_index(ii);
                end
            end
        end
        Re_index(qq) = C_index;
        clear xx qq XX Dist Dist_smallthan1 C_index;
    end
end

end