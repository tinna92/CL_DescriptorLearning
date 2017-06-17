% % PatchDir = 'E:\chen\caffe-master\matchnet-master\data\phototour\notredame\';
PatchDir = 'E:\software\IPI\Data\yosemite\patches\';
infoFileName = 'info.txt';
info = load([PatchDir infoFileName]);
Size_allpatch = size(info,1);
size_3Dpoints = info(size(info,1))+1;
Num_each3Dpont = zeros(info(size(info,1))+1,1); % record the # of patches for each 3D point
Endindex_each3Dpont = zeros(info(size(info,1))+1,1);% record the end index for each 3D point
for ii=1:Size_allpatch
    Num_each3Dpont(info(ii)+1)=Num_each3Dpont(info(ii)+1)+1;
    Endindex_each3Dpont(info(ii)+1)=ii; % to get the patch, use Endindex_each3Dpont-number_index+1 to get the index 
end


% pick the pairs for each 3D points, choose 20 pairs of negative for each image
kk=1;
qq=1;
while(kk<=size_3Dpoints)
    [anchor_pos] = randperm(Num_each3Dpont(kk),2);
    [pos_neg] = randperm(size_3Dpoints,20);% choose negative 
    for i=1:20
        current_pos_neg = pos_neg(i);
        if current_pos_neg~=kk % avoid choose real positive as negative
            neg_in3Dpoint_index(i) = randperm(Num_each3Dpont(current_pos_neg),1);
            triplet_patch_index(i+2,kk) = Endindex_each3Dpont(current_pos_neg) -  Num_each3Dpont(current_pos_neg) + neg_in3Dpoint_index(i);
        else
            [current_pos_neg] = randperm(size_3Dpoints,1); % when choosed negative are equal to positive, then do it again
            neg_in3Dpoint_index(i) = randperm(Num_each3Dpont(current_pos_neg),1);
            triplet_patch_index(i+2,kk) = Endindex_each3Dpont(current_pos_neg) -  Num_each3Dpont(current_pos_neg) + neg_in3Dpoint_index(i);
        end
    end
    triplet_patch_index(1,kk) = Endindex_each3Dpont(kk) -  Num_each3Dpont(kk) + anchor_pos(1);
    triplet_patch_index(2,kk) = Endindex_each3Dpont(kk) -  Num_each3Dpont(kk) + anchor_pos(2);
%     triplet_patch_index(3,kk) = Endindex_each3Dpont(pos_neg) -  Num_each3Dpont(pos_neg) + neg_in3Dpoint_index;
    kk = kk + 1;
end

% write images into folder and pairs of images into .txt file for further processing.
Triplet_patch_number = size(triplet_patch_index,2);
load([PatchDir 'patches.mat']);
fid=fopen('Data_train_largeneg_yosemite.txt','a+');
Size_patch_eachpoint = 21;
% for i = 1:size_3Dpoints*0.75
nn1 = floor(size_3Dpoints*0.25);
for i = 1:size_3Dpoints*0.25
    write_image =  Patches{triplet_patch_index(1,i)};
    write_image(:,1+size(write_image,1):2*size(write_image,1)) =  Patches{triplet_patch_index(2,i)};
    imwrite(write_image,[PatchDir 'largeneg_train1\' 'largeneg_patch_' num2str((i-1)*Size_patch_eachpoint + 1) '.jpg']);
    fprintf(fid,'%s 1\n',['largeneg_train1/' 'largeneg_patch_' num2str((i-1)*Size_patch_eachpoint + 1) '.jpg']);
    for ii=3:22
        write_image(:,1+size(write_image,1):2*size(write_image,1)) =  Patches{triplet_patch_index(ii,i)};
        imwrite(write_image,[PatchDir 'largeneg_train1\' 'largeneg_patch_' num2str((i-1)*Size_patch_eachpoint  + ii-1) '.jpg']);
        fprintf(fid,'%s 0\n',['largeneg_train1/' 'largeneg_patch_' num2str((i-1)*Size_patch_eachpoint + ii-1) '.jpg']);
    end
end
clear write_image;

nn2 = floor(size_3Dpoints*0.50);
for i = nn1 + 1:nn2
    write_image =  Patches{triplet_patch_index(1,i)};
    write_image(:,1+size(write_image,1):2*size(write_image,1)) =  Patches{triplet_patch_index(2,i)};
    imwrite(write_image,[PatchDir 'largeneg_train2\' 'largeneg_patch_' num2str((i-1)*Size_patch_eachpoint + 1) '.jpg']);
    fprintf(fid,'%s 1\n',['largeneg_train2/' 'largeneg_patch_' num2str((i-1)*Size_patch_eachpoint + 1) '.jpg']);
    for ii=3:22
        write_image(:,1+size(write_image,1):2*size(write_image,1)) =  Patches{triplet_patch_index(ii,i)};
        imwrite(write_image,[PatchDir 'largeneg_train2\' 'largeneg_patch_' num2str((i-1)*Size_patch_eachpoint  + ii-1) '.jpg']);
        fprintf(fid,'%s 0\n',['largeneg_train2/' 'largeneg_patch_' num2str((i-1)*Size_patch_eachpoint + ii-1) '.jpg']);
    end
end
clear write_image;

nn3 = floor(size_3Dpoints*0.75);
for i = nn2 + 1:nn3
    write_image =  Patches{triplet_patch_index(1,i)};
    write_image(:,1+size(write_image,1):2*size(write_image,1)) =  Patches{triplet_patch_index(2,i)};
    imwrite(write_image,[PatchDir 'largeneg_train3\' 'largeneg_patch_' num2str((i-1)*Size_patch_eachpoint + 1) '.jpg']);
    fprintf(fid,'%s 1\n',['largeneg_train3/' 'largeneg_patch_' num2str((i-1)*Size_patch_eachpoint + 1) '.jpg']);
    for ii=3:22
        write_image(:,1+size(write_image,1):2*size(write_image,1)) =  Patches{triplet_patch_index(ii,i)};
        imwrite(write_image,[PatchDir 'largeneg_train3\' 'largeneg_patch_' num2str((i-1)*Size_patch_eachpoint  + ii-1) '.jpg']);
        fprintf(fid,'%s 0\n',['largeneg_train3/' 'largeneg_patch_' num2str((i-1)*Size_patch_eachpoint + ii-1) '.jpg']);
    end
end



fclose(fid);

clear write_image;
% write to the test dataset
fid=fopen('Data_test_largeneg_yosemite.txt','a+');
Size_patch_eachpoint = 21;
% for i = 1:size_3Dpoints*0.75
for i = nn3+1 : size_3Dpoints
    write_image =  Patches{triplet_patch_index(1,i)};
    write_image(:,1+size(write_image,1):2*size(write_image,1)) =  Patches{triplet_patch_index(2,i)};
    imwrite(write_image,[PatchDir 'largeneg_train4\' 'largeneg_patch_' num2str((i-1)*Size_patch_eachpoint + 1) '.jpg']);
    fprintf(fid,'%s 1\n',['largeneg_train4/' 'largeneg_patch_' num2str((i-1)*Size_patch_eachpoint + 1) '.jpg']);
    for ii=3:22
        write_image(:,1+size(write_image,1):2*size(write_image,1)) =  Patches{triplet_patch_index(ii,i)};
        imwrite(write_image,[PatchDir 'largeneg_train4\' 'largeneg_patch_' num2str((i-1)*Size_patch_eachpoint  + ii-1) '.jpg']);
        fprintf(fid,'%s 0\n',['largeneg_train4/' 'largeneg_patch_' num2str((i-1)*Size_patch_eachpoint + ii-1) '.jpg']);
    end
end

fclose(fid);


% the order of negative samples must be reorganized in order to avoid the
% situation of seeing less the same first patch in postive and negative
% pairs.... (actually this is equal to 1:N triplet...)

% shuffle the positive samples and negative samples...
% fileID = fopen('C:\Users\chen.admin\Documents\MATLAB\Data_train_largeneg_notradame.txt','r');
fileID = fopen('E:\chen\LeanringDescriptor\Data_train_largeneg_yosemite.txt','r');
[C] = textscan(fileID,'%s');
fclose(fileID);
for i = 1:size_3Dpoints*0.75
    index_pos(i) = (i-1)*Size_patch_eachpoint + 1;     
    for ii=3:22
        index_neg((i-1)*20+ii-2) = (i-1)*Size_patch_eachpoint + ii-1;
    end
end

rand_neg_index = randperm( size(index_neg,2), size(index_neg,2));
rand_pos_index = randperm( size(index_pos,2), size(index_pos,2));

fid=fopen('Data_train_largeneg_yosemite_shuffle_all.txt','a+');
for i = 1:size_3Dpoints*0.75
%     index_pos(i) = (i-1)*Size_patch_eachpoint + 1; 
    search_index = 2*index_pos(rand_pos_index(i))-1; 
    fprintf(fid,'%s %s\n', C{1}{search_index},  C{1}{search_index+1});
    for ii=3:22
        search_index = 2*index_neg(rand_neg_index((i-1)*20+ii-2))-1; 
%         search_index = 2*index_neg((rand_neg_index(i)-1)*20+ii-2)-1; 
        fprintf(fid,'%s %s\n', C{1}{search_index},  C{1}{search_index+1});
%         fprintf(fid, '%s \n',[C{1}(search_index) ' ' C{1}(search_index+1)]);
%         index_neg((i-1)*20+ii-2) = (i-1)*Size_patch_eachpoint + ii-1;
    end
end
fclose(fid);

% fileID = fopen('C:\Users\chen.admin\Documents\MATLAB\Data_train_largeneg_liberty.txt','r');
% formatSpec = ['%s' '/' '%s' '%d' '\n'];

% [A,count] = fscanf(fileID,formatSpec);
% train_data=load('C:\Users\chen.admin\Documents\MATLAB\Data_train_largeneg_liberty.txt','r+');
