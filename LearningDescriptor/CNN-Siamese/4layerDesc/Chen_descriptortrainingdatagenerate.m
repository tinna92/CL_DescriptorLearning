% read the original patch data and generate training data
%param@ x_pos,x_neg, postive and negative samples for training
%param@ current_amount, number of sample for each feature point(one point, 2 or more patches)
function [x_pos,x_neg,x,labels,current_amount]=Chen_descriptortrainingdatagenerate(PatchDir,infoFileName,Num_patcheachcolumn)
    PatchesPath = [PatchDir '/patches.mat'];
    
    % check if patches.mat is existed or not. if exist, just quit from the
    % for loop
%     if exist(PatchesPath, 'file')
%         disp('patches.mat is already exist!');
%         return;
%     end    

    D = dir([PatchDir '*.bmp']);
    nFiles = numel(D);
    info = load([PatchDir infoFileName]);
    nPatches = size(info, 1);
    k = 0;
    Patches = cell(Num_patcheachcolumn * Num_patcheachcolumn * nFiles, 1);

    % extract patches from the first image to the last image
    disp('start reading patches data');
    for iFile = 1:nFiles

%         fprintf('%d/%d\n', iFile, nFiles);
        %read the current processing Patch image
        PatchImg = imread([PatchDir D(iFile).name]);
        for i = 1:Num_patcheachcolumn
            for j = 1:Num_patcheachcolumn
                k = k + 1;
                % put patch into the right position of the whole patch sets
                current_Patch = PatchImg((i - 1) * 64 + 1 : i * 64, (j - 1) * 64 + 1 : j * 64);
                %                 Patches{k} = PatchImg((i - 1) * 64 + 1 : i * 64, (j - 1) * 64 + 1 : j * 64);
%                 imresize(current_Patch, 0.5,'bilinear','Antialiasing',true);
                Patches{k} =imresize(current_Patch, 0.5);% the default interpolation method is bicuc, it is antialiasing
            end
        end    
    end

    % to delete the final patches,because the final image may be not fully
    % covered by patches
    Patches = Patches(1:nPatches);    
    % put every patch into the patches
    save(PatchesPath, 'Patches');        
        
    Dsize = info(size(info,1));
    Patch_pairs = cell(nPatches-Dsize-1, 2);
    
    disp('extract postive patch pairs');
    nn=1; 
    ll=0;
    current_amount = zeros(1,Dsize);
    for ii=0:Dsize 
        currentfirst_patch = Patches{nn}; 
        current_amount(ii+1) =0;
        while(info(nn,1)==ii)
            current_amount(ii+1) =  current_amount(ii+1)+1;
            if(current_amount(ii+1)>1) 
                ll=ll+1;%get the number of
                Patch_pairs{ll,1}=currentfirst_patch;
                Patch_pairs{ll,2}=Patches{nn};                                               
            end
            if(nn<nPatches )
                nn=nn+1;                  
            else
                break;
            end
        end
    end
    
    x_pos = Patch_pairs;
    
    disp('randomly generate negative patch pairs');
    Patch_pairs_negative = cell(nPatches-Dsize-1, 2);
    
    % for getting the negative samples
    for iii=1:ll
%         [pickpointindex] = randNnum(Dsize-1,2);% please pay attention to the randNnum() function here, it is not right.
        [pickpointindex] = randNnum(Dsize-2,2);
        [patchorderindex1] = randNnum(current_amount(pickpointindex(1)),1);
        [patchorderindex2] = randNnum(current_amount(pickpointindex(2)),1);
        Patch_pairs_negative{iii,1}=Patches{sum(current_amount(1:pickpointindex(1)))+patchorderindex1};
        Patch_pairs_negative{iii,2}=Patches{sum(current_amount(1:pickpointindex(2)))+patchorderindex2};
    end
    
    x_neg = Patch_pairs_negative;
    MM=nPatches-Dsize-1;
    x = cell((nPatches-Dsize-1)*2, 2);
    labels = zeros((nPatches-Dsize-1)*2,1);
    disp('generate labels for training data');
    for ii=1:MM
        x{ii,1} = Patch_pairs{ii,1};
        x{ii,2} = Patch_pairs{ii,2};
        labels(ii) =1;
        x{MM+ii,1}=Patch_pairs_negative{ii,1};
        x{MM+ii,2}=Patch_pairs_negative{ii,2};
        labels(MM+ii)=-1;
    end
end