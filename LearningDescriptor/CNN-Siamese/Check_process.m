 
size(resl.x3);

% check the computed distance
dist = (resl.x3-resr.x3).*(resl.x3-resr.x3);
Dist1 = resl.x3(:,:,:,1000)-resr.x3(:,:,:,1000);
Dis1 = Dist1.*Dist1;
Dist1000 = sqrt(sum(Dis1(:)))
Dist1000 - Eucl_dist(1000);
subplot(2,2,1); imshow(x_l(:,:,1,1));subplot(2,2,2);imshow(x_r(:,:,1,1));subplot(2,2,3); imshow(x_l(:,:,1,501));subplot(2,2,4);imshow(x_r(:,:,1,502));



dzdx3 = dLdxl(:,:,:,1);
x1 = resl.x1(:,:,:,1);
x2 = vl_nnconv(x1, w, b);
x3 = vl_nnpool(x2, 2) ;
x2(1:3,1:3,4);
 resl.x2(1:3,1:3,4,1);
 
 resl.x3(1:3,1:3,4,1);
 
 
 % for resize and get nn
 AA = randn(2,3,4,5);
BB=reshape(AA,[2,3*4*5]);
CC = resizem(BB,2);
DD = reshape(CC,[4 6 4 5]);
AA(1:2,1:2,1,2)
DD(1:4,1:4,1,2)


% show the similar image pairs which have higher Euclidean Distance 
subplot(2,2,1); 
imshow(x_pos{SampleIndex((batch_ground-1)*Size_batches+11),1});subplot(2,2,2);imshow(x_pos{SampleIndex((batch_ground-1)*Size_batches+11),2});
subplot(2,2,3);
imshow(x_pos{SampleIndex((batch_ground-1)*Size_batches+8),1});subplot(2,2,4);imshow(x_pos{SampleIndex((batch_ground-1)*Size_batches+8),2});

[n,x] = hist(Eucl_dist(1:256), 50);
plot(x, n/length(Eucl_dist(1:256)),'g'); hold on;
[n1,x1] = hist(Eucl_dist(257:512), 50);
plot(x1, n1/length(Eucl_dist(257:512)),'r');


[n,x] = hist(Eucl_dist(1:512), 50);
plot(x, n/length(Eucl_dist(1:512)),'g'); hold on;
[n1,x1] = hist(Eucl_dist(513:1024), 50);
plot(x1, n1/length(Eucl_dist(513:1024)),'r');

[n,x] = hist(Eucl_dist(1:128), 50);
plot(x, n/length(Eucl_dist(1:128)),'g'); hold on;
[n1,x1] = hist(Eucl_dist(129:256), 50);
plot(x1, n1/length(Eucl_dist(129:256)),'r');

save('learnedParamaters0805_20.mat','w1','w2','w3','b1','b2','b3');


% check the gradient calculation
num_gradient = (cost_testtheta - cost)/(0.0001*theta);
test_theta = theta + 0.0001*theta;
test_theta = theta + 0.0001*ones(81530,1);
[cost_testtheta,grad_testtheta]= Chen_DeepDescTrainingCost_WithNonlinear_sigmoid(test_theta,shrinkRate,x_l,x_r,y,1,10);
num_gradient = (cost_testtheta - cost)/(0.0001*ones(81530,1));
sum(cost_testtheta - cost)

subplot(2,2,1)
imshow(affine_patch_pos{333,1});
subplot(2,2,2)
imshow(affine_patch_pos{333,2});

% for affine transformation computation
[xlim,ylim] = outputLimits(affine2d(aff_mat{1,3}),[0.5 324.5],[0.5 223.5]);
xNudge = (ceil( diff(xlim))-diff(xlim))/2;
yNudge = (ceil( diff(ylim))-diff(ylim))/2;
xlim_final = xlim + [-xNudge xNudge];
ylim_final = ylim + [-yNudge yNudge];
