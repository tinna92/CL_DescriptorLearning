% I = vl_impattern('roofs1') ;
I = imread('E:\Image Matching\ISPRS Kongress 2016\presentation\PragueCastleCloseup.jpg');
image(I) ;
I = single(rgb2gray(I)) ;
[f,d] = vl_sift(I) ;
perm = randperm(size(f,2)) ;
sel = perm(1:50) ;
h1 = vl_plotframe(f(:,sel)) ;
h2 = vl_plotframe(f(:,sel)) ;
set(h1,'color','k','linewidth',3) ;
set(h2,'color','y','linewidth',2) ;
h3 = vl_plotsiftdescriptor(d(:,sel),f(:,sel)) ;
set(h3,'color','g') ;


a = imread ('E:\software\IPI\CL_DescriptorLearning\data\datasets\vggAffineDataset\graf\img1.ppm');
imwrite(a,'1.jpg')
a1 = imread ('E:\software\IPI\CL_DescriptorLearning\data\datasets\vggAffineDataset\graf\img2.ppm');
imwrite(a1,'2.jpg')
a2 = imread ('E:\software\IPI\CL_DescriptorLearning\data\datasets\vggAffineDataset\graf\img3.ppm');
image(a);
imwrite(a2,'3.jpg')
a3 = imread ('E:\software\IPI\CL_DescriptorLearning\data\datasets\vggAffineDataset\graf\img4.ppm');
image(a);
imwrite(a3,'4.jpg')
a4 = imread ('E:\software\IPI\CL_DescriptorLearning\data\datasets\vggAffineDataset\graf\img5.ppm');
image(a);
imwrite(a4,'5.jpg')
a5 = imread ('E:\software\IPI\CL_DescriptorLearning\data\datasets\vggAffineDataset\graf\img6.ppm');
image(a);
imwrite(a5,'6.jpg')

subplot(3,2,1)
imshow(a1)