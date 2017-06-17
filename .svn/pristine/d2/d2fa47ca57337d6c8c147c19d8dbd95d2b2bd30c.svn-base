% load('Loss_standardgradient_momentum_isprs.mat');Loss_stdGra_mom=Loss_Rec;
% load('Loss_standardgradient_isprs.mat');Loss_stdGra=Loss_Rec;
% load('Loss_rmsprop_isprs.mat');Loss_rmsprop=Loss_Rec;
load('Loss_Nesterov_Momentum.mat');Loss_rmsprop=Loss_Rec;
load('Loss_Momentum_30.mat');Loss_stdGra_mom=Loss_Rec;
load('Loss_standardGradient_30');Loss_stdGra=Loss_Rec;

plot(Loss_stdGra,'-dr');hold on;
plot(Loss_stdGra_mom,'-ob');hold on;
plot(Loss_rmsprop,'-sg');
xlabel('Epoch Number');
ylabel('Average Loss');
axis([1, 30, 3, 9]);
set(gca,'xtick', 0:5:30);
legend('Standard Gradient Descent',...
    'Standard Gradient Descent with Momentum','RMSPROP with Nesterov Momentum in Our Paper');