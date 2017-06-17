% get training data from  "m50_n1_n2.txt" files

% To allow researchers to replicate our learning results (if desired), we have include the match files that we used to generate the results in the paper. 
% These are name "m50_n1_n2.txt" where n1 and n2 are the number of matches and non-matches present in the file. The format of the file is as follows:
% 
%     patchID1   3DpointID1   unused1   patchID2   3DpointID2   unused2
%     ... 
% 
% "matches" have the same 3DpointID, and correspond to interest points that were detected with 5 pixels in position, and agreeing to 0.25 octaves of scale
% and pi/8 radians in angle. "non-matches" have different 3DpointID's, and correspond to interest points lying outside a range of 10 pixels in position, 
% 0.5 octaves of scale and pi/4 radians in angle. 

% More information please visit % http://www.cs.ubc.ca/~mbrown/patchdata/patchdata.html 
% and check the following papers: 
% [1] S. Winder and M. Brown. Learning Local Image Descriptors. To appear International Conference on Computer Vision and Pattern Recognition (CVPR2007) (pdf 300Kb)
% [2] Discriminant Learning of Local Image Descriptors. M. Brown, G. Hua and S. Winder.IEEE Transactions on Pattern Analysis and Machine Intelligence. 2010.
%%

function [x_pos,x_neg]=Chen_descriptortrainingdatageneratefromBrownDateset_4layer(PatchDir,patchinfoFileName)

% first load the patch data and
PatchesPath = [PatchDir '/patches64.mat'];
load(PatchesPath);
% patchinfoFileName = '/m50_500000_500000_0.txt';
train_patch_info = load([PatchDir patchinfoFileName]);
Patch_pair_Number = size(train_patch_info,1);

% load the patch pairs according to the "m50_n1_n2.txt" files
pos_count = 0;
neg_count = 0;
for ii = 1:Patch_pair_Number
    if train_patch_info(ii,2) == train_patch_info(ii,5)
        pos_count = pos_count + 1;
    else 
        neg_count = neg_count + 1;
    end
end
Patch_pairs_pos = cell(pos_count,2);
Patch_pairs_neg = cell(neg_count,2);% pre define the size for speeding computation

pos_count = 0;
neg_count = 0;
for i = 1:Patch_pair_Number
    left_pair_index = train_patch_info(i,1)+1;
    right_pair_index = train_patch_info(i,4)+1;
    if train_patch_info(i,2) == train_patch_info(i,5)
        pos_count = pos_count + 1;
        Patch_pairs_pos{pos_count,1}=Patches{int32(left_pair_index)};
        Patch_pairs_pos{pos_count,2}=Patches{int32(right_pair_index)};         
    else
        neg_count = neg_count + 1;
        Patch_pairs_neg{neg_count,1}=Patches{int32(left_pair_index)};
        Patch_pairs_neg{neg_count,2}=Patches{int32(right_pair_index)};        
    end
end
x_pos = Patch_pairs_pos;
x_neg = Patch_pairs_neg;

end