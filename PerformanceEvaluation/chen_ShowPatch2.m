function patch_image = chen_ShowPatch2(Patch,num_show,num_column)
num_patch = size(Patch,2);
perm = randperm(num_patch) ;
sel = perm(1:num_show) ;
select_Patch = Patch(:,sel);
num_row = num_show/num_column;
for i=1:num_row
    for j=1:num_column
        patch_image(((i-1)*32+1):i*32,((j-1)*32+1):j*32) = reshape(select_Patch(:,(i-1)*num_column+j),32,32);
    end
end
imshow(uint8(patch_image));
end