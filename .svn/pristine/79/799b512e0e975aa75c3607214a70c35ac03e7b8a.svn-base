function image_geom_info = ReadFootPrintFromOrientationFile(OreFileDir)

D = dir([OreFileDir '*.ore']);
nFiles = numel(D);

for iFile = 1:nFiles
%     fid = fopen([OreFileDir D(iFile).name]);
%     image_geom_info.foorprint(iFile) = fread(fid);
%     [a1,a2,a3,a4]=textread('test1.txt','%s%s%s%s','headerlines',4) 
    [a1,a2]=textread([OreFileDir D(iFile).name],'%s%s','headerlines',5);
    image_geom_info.footprint{iFile} = str2double([a1(1:4) a2(1:4)]);
    image_geom_info.imagename{iFile} = D(iFile).name;
end

end

 