%  Copyright (c) 2014, Chen Lin
%  All rights reserved.
%  This code is made available under the terms of the BSD license (see COPYING file).

% read the training data direct from patch images and label .txt file
% param@ PatchDir: path for the patch image
% param@ label_filename: filename of the label txt file
% param@ Num_patcheachcolumn: number of patches in each image column(row)
% param@ x, labels: the output params, x is patch, labels represent positive
%                   or negetive
function [x,labels] = loadtrainingdata4layer(PatchDir,label_filename,Num_patcheachcolumn)
   
    PatchesPath = [PatchDir '/patches64.mat'];
    
    % check if patches.mat is existed or not. if exist, just quit from the
    % for loop
%     if exist(PatchesPath, 'file')
%         disp('patches.mat is already exist!');
%         return;
%     end    

    D = dir([PatchDir '*.bmp']);
    nFiles = numel(D);
    labels = load([PatchDir label_filename]);
    nPatches = size(labels, 1);
    k = 0;
    Patches = cell(Num_patcheachcolumn * Num_patcheachcolumn * nFiles, 1);

    % extract patches from the first image to the last image
    for iFile = 1:nFiles

        fprintf('%d/%d\n', iFile, nFiles);

        %read the current processing Patch image
        PatchImg = imread([PatchDir D(iFile).name]);

        for i = 1:Num_patcheachcolumn
            for j = 1:Num_patcheachcolumn
                k = k + 1;
                % put patch into the right position of the whole patch sets
                Patches{k} = PatchImg((i - 1) * 64 + 1 : i * 64, (j - 1) * 64 + 1 : j * 64);
            end
        end    

    end

    % to delete the final patches,because the final image may be not fully
    % covered by patches
    Patches = Patches(1:nPatches);    
    % put every patch into the patches
    save(PatchesPath, 'Patches');
        
    x = Patches;

end