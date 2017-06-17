% setup;
randn(2,3,4,5);
x = single(randn(32,32,1,1));
a = sqrt(6/1024);
we1  = -a +2*a*(rand(5, 5, 1,5));
we1 = single(we1);
wd1  = -a +2*a*(rand(5, 5, 5,1));
wd1 = single(wd1);
be1 = single(zeros(1,5));
bd1 = single(zeros(1,0));


[res,recons] = Chen_StackedConvolutionAutoEncoder(x, we1, wd1,be1,bd1);