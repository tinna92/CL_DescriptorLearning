% this is going to show how different 1st order gradient descent
clear all;


% initial value and hyperparameters
x10 = 2;
x20 = 2;
Thet_x10 = x10;
Thet_x20 = x20;
momentum = 0.95;
learning_rate = 0.001;
iteration_steps = 300;
% first only with steepest gradient descent
learning_rate = 0.001;

x1=linspace(-0.5,2,100);
x2=linspace(-0.5,2.5,100);
figure(1);
[x1,x2]=meshgrid(x1,x2);
% y1=@(x1,x2)10*(x2-x1.^2).^2+(1-x1).^2;
y1=10*(x2-x1.^2).^2+(1-x1).^2;
% plot3(x1,x2,y1,'b:');            %????????????
surf(x1,x2,y1);
xlabel('x1','FontSize',15);
ylabel('x2','FontSize',15);
zlabel('y','FontSize',15);
title('Functional image for y=10(x2-x1^2)^2+(1-x1)^2','FontSize',15);
% hold on;contour(y1,v); 
% 
% subplot(1,2,2) 
figure(2);
v=[0.1,0.5,1,3,5,10,20,40,100];
[C,h] = contour(x1,x2,y1,v); 
clabel(C,h) ;hold on;
plot(1,1,'o','MarkerEdgeColor','k',...
                       'MarkerFaceColor','g',...
                       'MarkerSize',5);
title('Countour map for y=10(x2-x1^2)^2+(1-x1)^2','FontSize',15);

figure(3);
v=[0.1,0.5,1,3,5,10,20,40,100];
[C,h] = contourf(x1,x2,y1,v); 
clabel(C,h) ;hold on;
plot(1,1,'o','MarkerEdgeColor','k',...
                       'MarkerFaceColor','g',...
                       'MarkerSize',5);
title('Filled contour map for y=10(x2-x1^2)^2+(1-x1)^2','FontSize',15);


for i=1:iteration_steps
    dy_dx1 = 40*(Thet_x10.^2-Thet_x20)*Thet_x10+2*(Thet_x10-1);
    dy_dx2 = 20*(Thet_x20-Thet_x10.^2);
    Thet_x10 = Thet_x10 - learning_rate*dy_dx1;
    Thet_x20 = Thet_x20 - learning_rate*dy_dx2;
    current_E = 10*(Thet_x20-Thet_x10.^2).^2+(1-Thet_x10).^2;
    fprintf('%f  ',current_E);
    Loss_steepestGradientDescent(i)=current_E;
    x1_steepestGradientDescent(i)=Thet_x10;
    x2_steepestGradientDescent(i)=Thet_x20;
end

% then with momentum
Thet_x10 = x10;
Thet_x20 = x20;
v_t_x1 = 0;
v_t_x2 = 0;
for i=1:iteration_steps
    dy_dx1 = 40*(Thet_x10.^2-Thet_x20)*Thet_x10+2*(Thet_x10-1);
    dy_dx2 = 20*(Thet_x20-Thet_x10.^2);
    v_tplus1_x1 = momentum*v_t_x1 - learning_rate*dy_dx1;
    v_tplus1_x2 = momentum*v_t_x2 - learning_rate*dy_dx2;
    Thet_x10 = Thet_x10 + v_tplus1_x1;
    Thet_x20 = Thet_x20 + v_tplus1_x2;
    v_t_x1 = v_tplus1_x1;
    v_t_x2 = v_tplus1_x2;
    current_E = 10*(Thet_x20-Thet_x10.^2).^2+(1-Thet_x10).^2;
    fprintf('%f  ',current_E);
    Loss_GradientDescentwithMomentum(i)=current_E;
    x1_GradientDescentwithMomentum(i)=Thet_x10;
    x2_GradientDescentwithMomentum(i)=Thet_x20;
end

% then with Nesterov Momentum 
Thet_x10 = x10;
Thet_x20 = x20;
v_t_x1 = 0;
v_t_x2 = 0;
for i=1:iteration_steps
    x1_tplushalf = Thet_x10 + momentum*v_t_x1;
    x2_tplushalf = Thet_x20 + momentum*v_t_x2;
    dy_dx1_tplushalf = 40*(x1_tplushalf.^2-x2_tplushalf)*x1_tplushalf+2*(x1_tplushalf-1);
    dy_dx2_tplushalf = 20*(x2_tplushalf-x1_tplushalf.^2);
    v_tplus1_x1 = momentum*v_t_x1 - learning_rate*dy_dx1_tplushalf;
    v_tplus1_x2 = momentum*v_t_x2 - learning_rate*dy_dx2_tplushalf;
    Thet_x10 = Thet_x10 + v_tplus1_x1;
    Thet_x20 = Thet_x20 + v_tplus1_x2;
    v_t_x1 = v_tplus1_x1;
    v_t_x2 = v_tplus1_x2;
    current_E = 10*(Thet_x20-Thet_x10.^2).^2+(1-Thet_x10).^2;
%     fprintf('%f  ',current_E);
    Loss_Nesterov_Momentum(i)=current_E;
    x1_Nesterov_Momentum(i)=Thet_x10;
    x2_Nesterov_Momentum(i)=Thet_x20;
end

% plot the moving trajectory of each method 
%  surf(x1,x2,y1);
figure(4)
v=[0.1,0.5,1,3,5,10,20,40,100];
[C,h] = contourf(x1,x2,y1,v); 
clabel(C,h) ;hold on;
% x_steepDes = [x1_steepestGradientDescent(1:30);x2_steepestGradientDescent(1:30)];
plot(x1_steepestGradientDescent,x2_steepestGradientDescent,'gx-','LineWidth',2);hold on;
plot(x1_GradientDescentwithMomentum,x2_GradientDescentwithMomentum,'ro-','LineWidth',2);hold on;
plot(x1_Nesterov_Momentum,x2_Nesterov_Momentum,'b+-','LineWidth',2);
legend('countour line','Standard Gradient Descent',...
    'Standard Gradient Descent with Momentum','Nesterov Momentum','Location','NorthOutside');
plot(1,1,'o','MarkerEdgeColor','k',...
                       'MarkerFaceColor','g',...
                       'MarkerSize',5);
title('trajectories of different methods for y=10(x2-x1^2)^2+(1-x1)^2','FontSize',15);

figure(5)
v=[0.1,0.5,1,3,5,10,20,40,100];
[C,h] = contour(x1,x2,y1,v); 
clabel(C,h) ;hold on;
% x_steepDes = [x1_steepestGradientDescent(1:30);x2_steepestGradientDescent(1:30)];
plot(x1_steepestGradientDescent,x2_steepestGradientDescent,'gx-','LineWidth',2);hold on;
plot(x1_GradientDescentwithMomentum,x2_GradientDescentwithMomentum,'ro-','LineWidth',2);hold on;
plot(x1_Nesterov_Momentum,x2_Nesterov_Momentum,'b+-','LineWidth',2);
legend('countour line','Standard Gradient Descent',...
    'Standard Gradient Descent with Momentum','Nesterov Momentum','Location','NorthOutside');
plot(1,1,'o','MarkerEdgeColor','k',...
                       'MarkerFaceColor','g',...
                       'MarkerSize',5);
title('trajectories of different methods for y=10(x2-x1^2)^2+(1-x1)^2','FontSize',15);

% plot how the loss decrease..
figure(6)
plot(Loss_steepestGradientDescent,'g-','LineWidth',2);hold on;
plot(Loss_GradientDescentwithMomentum,'r-','LineWidth',2);hold on;
plot(Loss_Nesterov_Momentum,'b-','LineWidth',2);
legend('Standard Gradient Descent',...
    'Standard Gradient Descent with Momentum','Nesterov Momentum','Location','NorthOutside');
title('Loss decrease for y=10(x2-x1^2)^2+(1-x1)^2','FontSize',15);
