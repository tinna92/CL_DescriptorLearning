% load('Loss_standardgradient_momentum_isprs.mat');Loss_stdGra_mom=Loss_Rec;
% load('Loss_standardgradient_isprs.mat');Loss_stdGra=Loss_Rec;
% load('Loss_rmsprop_isprs.mat');Loss_rmsprop=Loss_Rec;
load('Loss_Nesterov_Momentum.mat');Loss_rmsprop=Loss_Rec;
load('Loss_Momentum_30.mat');Loss_stdGra_mom=Loss_Rec;
load('Loss_standardGradient_30');Loss_stdGra=Loss_Rec;
load('Loss_Neterov_Gradient.mat');Loss_Nesterov=Loss_Rec;

% plot(Loss_stdGra,'-dr');hold on;
% plot(Loss_stdGra_mom,'-ob');hold on;
% plot(Loss_rmsprop,'-sg');
% plot(Loss_Nesterov,'-xk');
plot(Loss_stdGra,'-r');hold on;
plot(Loss_stdGra_mom,'-b');hold on;
plot(Loss_Nesterov,'-k');
plot(Loss_rmsprop,'-g');

xlabel('Epoch Number');
ylabel('Average Loss');
axis([1, 30, 3, 9]);
set(gca,'xtick', 0:5:30);
legend('Standard Gradient Descent',...
    'Standard Gradient Descent with Momentum','Nesterov Momentum Method','RMSPROP with Nesterov Momentum in Our Paper');

load('Loss_Rmsprop_nesterov_mommentum.mat');Loss_rmsprop=Loss_Rec;
load('Loss_stdgradient1_mommentum.mat');Loss_stdGra_mom=Loss_Rec;
load('Loss_stdgradientdescent1.mat');Loss_stdGra=Loss_Rec;
load('Loss_Neterov_Gradient1.mat');Loss_Nesterov=Loss_Rec(1:10);

% plot(Loss_stdGra,'-dr');hold on;
% plot(Loss_stdGra_mom,'-ob');hold on;
% plot(Loss_rmsprop,'-sg');
% plot(Loss_Nesterov,'-xk');
plot(Loss_stdGra,'-ro','LineWidth',1.5);hold on;
plot(Loss_stdGra_mom,'-bs','LineWidth',1.5);hold on;
plot(Loss_Nesterov,'-ks','LineWidth',1.5);
plot(Loss_rmsprop,'-go','LineWidth',1.5);

xlabel('Epoch Number');
ylabel('Average Loss');
axis([1, 10, 3, 9]);
set(gca,'xtick', 0:1:10);
legend('Standard Gradient Descent',...
    'Standard Gradient Descent with Momentum','Nesterov Momentum Method','Method in Our Paper');