% this function write the matches into 1 file for colmap to use
function Chen_Write_Matches_for_Colmap(filename,img_path1, img_path2, Matches)
fileID = fopen(filename,'w');
% first output the file name pair, then the corresponding feature matches..
fprintf(fileID,'%s %s\n',img_path1,img_path2);

% write the match into the file
out_matches_file = Matches - 1;
for ii=1:size(Matches,2)
    fprintf(fileID,'%d %d\n',out_matches_file(1,ii), out_matches_file(2,ii));
end
fclose(fileID);
end