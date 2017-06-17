% this function is used to resize downsampled pooling function
% this is used for backpropagation gradients in CNN
% Note the input AA should have the size form of H*W*S*N (S= #feature maps, N = #training samples used currently)
function [DD] = Chen_ResizeDownsamPool_withouttailer(AA,ratio)

    [s1,s2,s3,s4] = size(AA);
    BB=reshape(AA,[s1,s2*s3*s4]);
%     CC = resizem(BB,ratio);
    CC = (1.0/ratio^2).*kron(BB,ones(ratio));
    DD = reshape(CC,[ratio*s1,ratio*s2,s3,s4]);
%     DD(:,s2,:,:)=[];
%     DD(s1,:,:,:)=[];

end