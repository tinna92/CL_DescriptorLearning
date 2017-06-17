
%% 1) this part is for testing the loading from raw patches data. Uncomment the following code lines to conduct this operation
% PatchDir='..\Data\notredame\patches/';
% infoFileName='info.txt';
% Num_patcheachcolumn=16;
% [xnotredame_pos,xnotredame_neg,x_notredame,notredame_labels,notredame_current_amount]=...
%     Chen_descriptortrainingdatagenerate(PatchDir,infoFileName,Num_patcheachcolumn); % load from raw patch data

%% 2) load the training data used in Brown's descriptor learning PAMI 2010 paper (Discriminant Learning of Local Image Descriptors. M. Brown, G. Hua and S. Winder.)
PatchDir = {'../Data/notredame/patches/','../Data/liberty/patches/','../Data/yosemite/patches/'};
PatchName = {'notredame','liberty','yosemite'};
patchinfoFileName = '/m50_500000_500000_0.txt';
processmark = [1 0 0]; % process mark for every dataset. if it is 1, then it will generate the dataset
if processmark(1) == 1
    [notredame_x_pos,notredame_x_neg]=Chen_descriptortrainingdatageneratefromBrownDateset(PatchDir{1},patchinfoFileName);
    mkdir([PatchDir{1} 'patchmatdata/']);
    pos_save_path = [PatchDir 'patchmatdata/' 'notredame_x_pos.mat'];
    neg_save_path = [PatchDir 'patchmatdata/' 'notredame_x_neg.mat'];
    save(pos_save_path,'notredame_x_pos');
    save(neg_save_path,'notredame_x_neg');
end

if processmark(2) == 1
    [liberty_x_pos,liberty_x_neg]=Chen_descriptortrainingdatageneratefromBrownDateset(PatchDir{2},patchinfoFileName);
    mkdir([PatchDir{2} 'patchmatdata/']);
    pos_save_path = [PatchDir{2} 'patchmatdata/' 'liberty_x_pos.mat'];
    neg_save_path = [PatchDir{2} 'patchmatdata/' 'liberty_x_neg.mat'];
    save(pos_save_path,'liberty_x_pos');
    save(neg_save_path,'liberty_x_neg');
end

if processmark(3) == 1
    [yosemite_x_pos,yosemite_x_neg]=Chen_descriptortrainingdatageneratefromBrownDateset(PatchDir{3},patchinfoFileName);
    mkdir([PatchDir{3} 'patchmatdata/']);
    pos_save_path = [PatchDir{3} 'patchmatdata/' 'yosemite_x_pos.mat'];
    neg_save_path = [PatchDir{3} 'patchmatdata/' 'yosemite_x_neg.mat'];
    save(pos_save_path,'yosemite_x_pos');
    save(neg_save_path,'yosemite_x_neg');
end

% visualize random selected pair.
% first select
neg_count = size(notredame_x_pos,1);
pos_count = size(notredame_x_neg,1);
Show_pair_Num = 5;
neg_index = unidrnd(neg_count,Show_pair_Num,1);
pos_index = unidrnd(pos_count,Show_pair_Num,1);
% then visualize
for i = 1:Show_pair_Num
    subplot(4,Show_pair_Num,i);
    imshow(notredame_x_pos{pos_index(i),1});
    subplot(4,Show_pair_Num,Show_pair_Num + i);
    imshow(notredame_x_pos{pos_index(i),2});
    subplot(4,Show_pair_Num,i+2*Show_pair_Num);
    imshow(notredame_x_neg{neg_index(i),1});
    subplot(4,Show_pair_Num,3*Show_pair_Num + i);
    imshow(notredame_x_neg{neg_index(i),2});
end
% gtext('random selected visualized training paris');
%%