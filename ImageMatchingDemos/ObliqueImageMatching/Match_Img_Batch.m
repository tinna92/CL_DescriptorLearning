img_path1 = 'data/IGI-UM_Soest-City_GSD5cm-Nadir.jpgresize.pngcropped.png';
img_path2 = 'data/IGI-UM_Soest-City_GSD7cm-ObliqueEast.jpgresize.pngcropped.png';
opts.similarity_threshold = 1;
opts.detector_type = 'DoG';
opts.descriptor_type = 'SIFT';
opts.n = 3; opts.a = sqrt(2); opts.b = 72;
%detect those feature with affine adaption
[out_match, out_features1, out_features2, out_desc1, out_desc2] =...
    Chen_Match2ImgsByViewsphereSimulation(img_path1, img_path2, opts);
% 
% Chen_show_matchresult(rgb2gray(imread(img_path1)),...
%     rgb2gray(imread(img_path2)), out_match ,out_features1,out_features2,0);
% 
% 
% % this is to show the detected features on the original image, so one can
% % check what happens actually for those images
% perm = randperm(size(out_features1,2)) ;
% sel = perm(1:1000) ;
% imshow(rgb2gray(imread(img_path1)));
% h1 = vl_plotframe(out_features1(:,1:10)) ;
% h2 = vl_plotframe(out_features1(:,1:10)) ;
% set(h1,'color','k','linewidth',3) ;
% set(h2,'color','y','linewidth',1) ;
% 
% % as the feature is formed into an affine matrix, so we can derive the
% % scale and orientation of the features. Turn it into the form of [x, y,
% scale, orientation]
% frame = Chen_Derive_ScaOri_from_vlframes(input_frame);

frame_out1 = Chen_Derive_ScaOri_from_vlframes(out_features1);
frame_out2 = Chen_Derive_ScaOri_from_vlframes(out_features2);
% check whether the calculated derivation is right or not. In order to
% check, just select one feature index randomly.
check_index = randperm(size(out_features1,2),1);
figure(1);
imshow(rgb2gray(imread(img_path1)));
h2 = vl_plotframe(out_features1(:,check_index)) ;
set(h2,'color','y','linewidth',1) ;
frame_out(:,check_index)
theta = frame_out(4,check_index);
scale =  frame_out(3,check_index);
figure(2);
imshow(rgb2gray(imread(img_path1)));
A = scale*[cos(theta),-sin(theta);sin(theta),cos(theta)];
frame_current = [frame_out(1,check_index),frame_out(2,check_index),A(:)'];
h2 = vl_plotframe(frame_current);
set(h2,'color','r','linewidth',1);

% when save those features to the format for colmap to use, remeber that
% the index of matches in colmap is 0-based, so each index in the current
% matches should be -1
% fileID = fopen('exp.txt','w');
% % first output the file name pair, then the corresponding feature matches..
% fprintf(fileID,'%s %s\n',img_path1,img_path2);
% 
% % write the match into the file
% out_matches_file = out_match-1;
% for ii=1:size(out_match,2)
%     fprintf(fileID,'%d %d\n',out_matches_file(1,ii), out_matches_file(2,ii));
% end
% fclose(fileID);
% 
% % write the feature into files.
% file_name = strcat(img_path1,'.txt');
% fileID = fopen(file_name,'w');
% fprintf(fileID,'NUM_FEATURES %d\n', size(out_features1, 2));
% output_feature_desc(1:4,:) = frame_out;
% output_feature_desc(5:132,:) = floor(out_desc1*255);
% for ii=1:size(output_feature_desc,2)-1
%     fprintf(fileID,'%f ',output_feature_desc(1:4,ii));
%     fprintf(fileID,'%d ',output_feature_desc(5:132,ii));
%     fprintf(fileID,'\n');
% end
% fprintf(fileID,'%f ',output_feature_desc(1:4,end));
% fprintf(fileID,'%d ',output_feature_desc(5:132,end));
% fclose(fileID);

Chen_Write_Features_for_Colmap(img_path1, frame_out1, out_desc1);
Chen_Write_Features_for_Colmap(img_path2, frame_out2, out_desc2);
Chen_Write_Matches_for_Colmap('matches.txt',img_path1, img_path2, out_match);

