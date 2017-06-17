% function for showing the image match result
% randm_selected show random selected keypoints or not

function Chen_show_matchresult(img,img2,matches,frames,frames2,randm_selected)

[w1 h1] = size(img);
[w2 h2] = size(img2);
num_match = size(matches,2); % get the number of matches
matchimage(1:w1,1:h1)=img;
matchimage(w1+11:w1+w2+10,1:h2)=img2;

num_showmatch = 200;
if num_match<num_showmatch
    num_showmatch = num_match;
end
showindex=randperm(num_match,num_showmatch);
imshow(matchimage);
axis on;hold on;

if randm_selected==0 % show all the matches when we set this symbol as 0 
    num_showmatch = num_match;
    for i=1:num_showmatch
        l_index = matches(1,i);
        r_index = matches(2,i);
        % pay attention to the fact matlab and vlfeat has an oppisite coordinate definition
        plot([frames(1,l_index),frames2(1,r_index)],[frames(2,l_index),frames2(2,r_index)+w1+11],'r','linewidth',1);
    end

else % show random selected features
    for i=1:num_showmatch
        l_index = matches(1,showindex(i));
        r_index = matches(2,showindex(i));
        % pay attention to the fact matlab and vlfeat has an oppisite coordinate definition
        plot([frames(1,l_index),frames2(1,r_index)],[frames(2,l_index),frames2(2,r_index)+w1+11],'r','linewidth',1);
    end
end

end