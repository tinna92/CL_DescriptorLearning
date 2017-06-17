% read the orignal file and compute the overlapping rate among different
% images
OreFileDir = 'E:\KarstenData\MultiVision\Testing\Orientation files\';
image_geom_info = ReadFootPrintFromOrientationFile(OreFileDir);
overlap_rate = zeros(Num,Num);
% draw all the footprints in a 2D plane,use pilybool for intersection and
% ?? for the area of polygon
Num = numel(image_geom_info.footprint);
for i=1:Num
    x_i = image_geom_info.footprint{1,i}(1:4,1);
    y_i = image_geom_info.footprint{1,i}(1:4,2);
    fill(image_geom_info.footprint{1,i}(1:4,1),image_geom_info.footprint{1,i}(1:4,2),'w');  hold on;
    poly_area(i) = polyarea(x_i,y_i);% compute the poly area
    
    for jj=i+1:Num
        x_jj = image_geom_info.footprint{1,jj}(1:4,1);
        y_jj = image_geom_info.footprint{1,jj}(1:4,2);
        poly_area_jj = polyarea(x_jj,y_jj);
        [xb, yb] = polybool('intersection', x_i, y_i, x_jj, y_jj);
        poly_area_intersect = polyarea(xb, yb);
        overlap_rate(i,jj) = poly_area_intersect/min(poly_area(i),poly_area_jj);
    end
end

% find all high overlapping images from different cameras
[index1,index2,rate] = find(overlap_rate>0.5);
num_pairs = numel(index1);
count =1;
for i=1:num_pairs
    if rem(index1(i)-index2(i),5)~=0 % this means they are not from the same camera in the camera systems
        pairs(count,1:2)=[index1(i) index2(i)];
        pairs(count,3)= overlap_rate(index1(i),index2(i));
        pairs(count,4) = abs(index1(i)-index2(i));% level of distance from each other
        count = count +1;
    end
end

cross_view_level = abs(index1-index2);

% write them into result file
fid = fopen( 'overlapping_analyse_results.txt', 'wt' );
fprintf( fid, 'first image index,second image index,overlapping rate,level of distance\n');
num_pairs_acrossimage = size(pairs,1);
for count = 1:num_pairs_acrossimage
  fprintf( fid, '%d,%d,%f,%d\n',pairs(count,1),pairs(count,2),pairs(count,3),pairs(count,4));
end
fclose(fid);