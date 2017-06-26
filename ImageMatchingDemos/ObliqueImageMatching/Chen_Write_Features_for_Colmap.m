function Chen_Write_Features_for_Colmap(img_path, feature_frames, feature_desc)
file_name = strcat(img_path,'.txt');
fileID = fopen(file_name,'w');
fprintf(fileID,'%d 128\n', size(feature_desc, 2));
output_feature_desc(1:4,:) = feature_frames;
output_feature_desc(5:132,:) = round(feature_desc*512);
% output_feature_desc(5:132,:) = feature_desc; % without multiplication
for ii=1:size(output_feature_desc,2)-1
    fprintf(fileID,'%f ',output_feature_desc(1:4,ii));
    fprintf(fileID,'%f ',output_feature_desc(5:131,ii));
    % avoid a extra balank in the end of one line
    fprintf(fileID,'%f',output_feature_desc(132,ii));
    fprintf(fileID,'\n');
end
fprintf(fileID,'%f ',output_feature_desc(1:4,end));
fprintf(fileID,'%f ',output_feature_desc(5:131,end));
fprintf(fileID,'%f',output_feature_desc(132,end));
fclose(fileID);
end