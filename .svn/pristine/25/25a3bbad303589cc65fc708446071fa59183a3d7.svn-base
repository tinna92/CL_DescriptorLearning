% This part is used to generate cross mark to show the feature points
function [Tag_left,Tag_right,Tag_top,Tag_bottom] = Chen_Getcrossmark(feature_points,marker_length)
    Tag_left(1,:) =  feature_points(1,:)-marker_length;
    Tag_left(2,:) =  feature_points(2,:);
    Tag_right(1,:) =  feature_points(1,:)+marker_length;
    Tag_right(2,:) =  feature_points(2,:);
    
    Tag_top(1,:) = feature_points(1,:);
    Tag_top(2,:) = feature_points(2,:) + marker_length;
    Tag_bottom(1,:) = feature_points(1,:);
    Tag_bottom(2,:) = feature_points(2,:) - marker_length;
end