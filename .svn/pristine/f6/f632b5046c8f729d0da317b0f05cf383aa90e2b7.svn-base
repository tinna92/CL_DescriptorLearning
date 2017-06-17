% % evaluate the feature detector repeatability in different view of images from the view sphere
% % and we can see how much of them are repeated features
PatchDir='E:\KarstenData\apartimg1\';
D = dir([PatchDir '*.png']);
nFiles = numel(D);
k = 0;
% image_name = '000003-111406161250-04.tifresize.png';
feature_detector_type = {'DoG','Hessian','HessianLaplace','HarrisLaplace','MultiscaleHessian','MultiscaleHarris'};
n=4;
a=sqrt(2);
b=72;
similarity_threshold = 1.0;
% 
% % extract patches from the first image to the last image
% disp('start doing job');
% Whole_Num = 0;
% for i_detector = 1:6
%     for iFile = 1:nFiles
%         [repeat_score]= Chen_imagerepeatability_inoneImage_analysis2([PatchDir D(iFile).name],feature_detector_type{i_detector},n,a,b,similarity_threshold);
%         Repeatfactor_alldetector{i_detector,iFile} = repeat_score;
%         fprintf('%f image, %f detector, %c\n',iFile,i_detector,feature_detector_type{i_detector});
%     end
% end
% save('repeat_score_differentdetector0411result.mat','Repeatfactor_alldetector');

% show the repeatablity from the evaluation
% n=4;
% a=sqrt(2);
% b=72;
% similarity_threshold = 1.0;

for ii=1:n+1
    t(ii)=a^(ii-1);
    k(ii) = floor(t(ii)*180/b)+1;
end


for i_detector=1:6
    for iFile=1:nFiles
        for ii=1:n
            for jj=1:k(ii)
                Repeat_Score(i_detector,iFile,ii,jj) = Repeatfactor_alldetector{i_detector,iFile}(ii,jj);
            end
        end
    end
end

for ii=1:n
    for jj=1:k(ii)
%         Repeat_Analysis(ii,jj) = mean(Repeat_Score(:,:,ii,jj));
        Repeat_Score(i_detector,iFile,ii,jj) = Repeatfactor_alldetector{i_detector,iFile}(ii,jj);
    end
end

for ii=1:n
    for jj=1:k(ii)
        CurrentRepeat = Repeat_Score(1,:,ii,jj);
        Mean_repeat(ii,jj) = mean(CurrentRepeat(:));
        std_Mean_repeat(ii,jj) =std(CurrentRepeat(:));
%         Repeat_Score(i_detector,iFile,ii,jj) = Repeatfactor_alldetector{i_detector,iFile}(ii,jj);
    end
end

mean(Repeat_Score(:,:,ii,jj));
subplot(2,1,1);bar3(Mean_repeat);set(gca,'ztick',[0:0.1:1]);xlabel('tilt');ylabel('rotation');title('repeatability in Viewsphere for DoG');

subplot(2,1,2);bar3(Repeatfactor_alldetector{2,1});set(gca,'ztick',[0:0.1:1]);xlabel('tilt');ylabel('rotation');title('repeatability in Viewsphere for Hessian');
subplot(2,1,1);bar3(Repeatfactor_alldetector{3,1});set(gca,'ztick',[0:0.1:1]);xlabel('tilt');ylabel('rotation');title('repeatability in Viewsphere for HessianLaplace');
subplot(2,1,2);bar3(Repeatfactor_alldetector{4,1});set(gca,'ztick',[0:0.1:1]);xlabel('tilt');ylabel('rotation');title('repeatability in Viewsphere for HarrisLaplace');
subplot(2,1,1);bar3(Repeatfactor_alldetector{5,1});set(gca,'ztick',[0:0.1:1]);xlabel('tilt');ylabel('rotation');title('repeatability in Viewsphere for MultiscaleHessian');
subplot(2,1,2);bar3(Repeatfactor_alldetector{6,1});set(gca,'ztick',[0:0.1:1]);xlabel('tilt');ylabel('rotation');title('repeatability in Viewsphere for MultiscaleHarris');