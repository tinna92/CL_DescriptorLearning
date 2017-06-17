I = imread('000002-111406161256-02.tifresize.png');
imshow(I);
I = single(I) ;
[f,d] = vl_sift(I) ;

perm = randperm(size(f,2)) ;
sel = perm(1:100) ;
h1 = vl_plotframe(f(:,sel)) ;
h2 = vl_plotframe(f(:,sel)) ;
set(h1,'color','k','linewidth',1) ;
set(h2,'color','y','linewidth',1) ;
h3 = vl_plotsiftdescriptor(d(:,sel),f(:,sel)) ;
set(h3,'color','g') ;


I2 = imread('000006-111406161233-04.tifresize.png');
imshow(I2);
I2 = single(I2) ;
[f2,d2] = vl_sift(I2) ;

perm2 = randperm(size(f2,2)) ;
sel2 = perm2(1:100) ;
h12 = vl_plotframe(f2(:,sel2)) ;
h22 = vl_plotframe(f2(:,sel2)) ;
set(h12,'color','k','linewidth',3) ;
set(h22,'color','y','linewidth',2) ;
h32 = vl_plotsiftdescriptor(d2(:,sel2),f2(:,sel2)) ;
set(h32,'color','g') ;


I = imread('000002-111406161256-02.tifresize.png');
imshow(I);
I1 = single(I) ;
[f,d] = vl_sift(I1) ;

perm = randperm(size(f,2)) ;
sel = perm(1:100) ;
h1 = vl_plotframe(f) ;
h2 = vl_plotframe(f) ;
set(h1,'color','k','linewidth',1) ;
set(h2,'color','y','linewidth',1) ;
% h3 = vl_plotsiftdescriptor(d(:,sel),f(:,sel)) ;
% set(h3,'color','g') ;

I2 = imread('000006-111406161233-04.tifresize.png');
figure(2);
imshow(I2);
I2 = single(I2) ;
[f2,d2] = vl_sift(I2) ;

perm2 = randperm(size(f2,2)) ;
sel2 = perm2(1:100) ;
h12 = vl_plotframe(f2) ;
h22 = vl_plotframe(f2) ;
set(h12,'color','k','linewidth',1) ;
set(h22,'color','y','linewidth',1) ;

frames = vl_covdet(im2single(I), 'method', 'HarrisLaplace') ;
figure(3);
imshow(I);
hold on ;
h32 = vl_plotframe(frames); 
set(h32,'color','y','linewidth',1) ;

 [H,DETAILS] = vl_harris(I,0.02);

