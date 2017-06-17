% frames_Image, descrs_Image,frames1, descrs1
for jjj=1:num_min_smallerthan1_index
    ii = SelectedPair_index_2nd(jjj);
    kk = SelectedPair_index_1st(jjj);
    xx = floor(reshape(descrs1(:,ii),[63,63]));
    yy = floor(reshape(descrs_Image(:,kk),[63,63]));
    col_num = mod(jjj,16);
    row_num = mod(jjj,16);
    col_index = floor(jjj/16);
    row_index = floor(jjj/16);
    orig_left = col_index*63*2 + 1;
    orig_right = orig_left + 62;
    orig_top = row_num*63 + 1;
    orig_bottom = row_num*63 + 63;
    patchpair_image(orig_left:orig_right,orig_top:orig_bottom) =  uint8(xx);
    patchpair_image(orig_right+1:orig_right+63,orig_top:orig_bottom) =   uint8(yy);
end

 imshow(patchpair_image);% still need to write them into files
 imwrite(patchpair_image,'pair.jpg'); 
% subplot(2,2,1);
% imshow(uint8(xx));
% subplot(2,2,2);
% imshow(uint8(yy));