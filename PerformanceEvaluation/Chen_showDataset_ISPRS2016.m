% load('notredame_x_64_pos.mat');
% load('notredame_x_64_neg.mat');

Show_Pair_index = [3 190 290 500];
for i=1:4
    subplot(2,4,i);
    imshow(notredame_x_64_pos{Show_Pair_index(i),1});
    subplot(2,4,i+4);
    imshow(notredame_x_64_pos{Show_Pair_index(i),2});
end

figure(2);
Show_Pair_index = [3 190 290 500];
for i=1:4
    subplot(2,4,i);
    imshow(notredame_x_64_neg{Show_Pair_index(i),1});
    subplot(2,4,i+4);
    imshow(notredame_x_64_neg{Show_Pair_index(i),2});
end