% -------------------------------------------------------------------------
% Part 3: Learning a simple CNN
% -------------------------------------------------------------------------

% first set the required document directories
setup ;

% -------------------------------------------------------------------------
% then load data and set paremeters for learning
% -------------------------------------------------------------------------
% load('notryose_pos.mat');
% load('notryose_neg.mat');
Num_Pos_valid_set = 100;% number of positive or negative samples in validation sets
Num_pos = 5000;% number of postive(negative) examples for tarining datasets 
Start_pos = 0; % start position for validation set extraction begin point in x_pos and x_neg
Num_valid_set = Num_Pos_valid_set*3;% the real number of samples in validation sets

% -------------------------------------------------------------------------
% Set parameters for training, including the batch size and epoches
% -------------------------------------------------------------------------
Num_Epoches  = 20; % num of iterations( for each training sample)
Size_batches = 128; % size of the batch
Num_batches = 10; % how many batches are used for training
BatchSample_status = 1; %set the default status as positive pairs
Size_trainingSamples = Size_batches*Num_batches;
Num_wholesamples = size(x_pos,1); % number of the training samples in the training dataset 
% SampleIndex = randperm(Num_wholesamples,Size_trainingSamples); % used to generate the sample indexes
% SampleIndex = randperm(Size_trainingSamples,Size_trainingSamples)+3*Size_trainingSamples; % used to generate the sample indexes
SampleIndex = randperm(Size_trainingSamples,Size_trainingSamples); % used to generate the sample indexes
% -------------------------------------------------------------------------
% Initialize the training parameters
% -------------------------------------------------------------------------
% w1 = 0.05*randn(5, 5, 1,5) ;
% w2 = 0.05*randn(5, 5, 5,25) ;
% w3 = 0.05*randn(5, 5, 25,125) ;
% w1 = 0.15*randn(5, 5, 1,5) ;
% w2 = 0.15*randn(5, 5, 5,25) ;
% w3 = 0.15*randn(5, 5, 25,125) ;
% for t=1:5
%     w1(:,:,1,t) = single(w1(:,:,1,t) - mean(mean(mean(w1(:,:,1,t))))) ;
% end
% for t=1:25
%     for tt = 1:5
%         w2(:,:,tt,t) = single(w2(:,:,tt,t) - mean(mean(mean(w2(:,:,tt,t))))) ;
%     end
% end
% for t=1:125
%     for tt = 1:25
%         w3(:,:,tt,t) = single(w3(:,:,tt,t) - mean(mean(mean(w3(:,:,tt,t))))) ;
%     end
% end
% w1 = single(w1);
% w2 = single(w2);
% w3 = single(w3);
% b1 = single(zeros(1,5));
% b2 = single(zeros(1,25));
% b3 = single(zeros(1,125));

numIterations = 80 ;
% rate = 5 ;
rate = 0.05;
momentum = 0.9 ;
% shrinkRate = 0.0001 ;
 shrinkRate = 0.00003 ;
plotPeriod = 10 ;

% Initial momentum
% w_momentum1 = zeros('like', w1) ;
% b_momentum1 = zeros('like', b1) ;
% w_momentum2 = zeros('like', w2) ;
% b_momentum2 = zeros('like', b2) ;
% w_momentum3 = zeros('like', w3) ;
% b_momentum3 = zeros('like', b3) ;

% Initiallearningrate = 0.005;
% Initiallearningrate = 0.0005;
% Initiallearningrate = 0.000003;% Initiallearningrate = 0.000003 for multi mini batches, batch size = 256 works OK
% Initiallearningrate = 0.00001
Initiallearningrate = 0.0001
gain_upperbound = 100;
gain_lowerbound = 0.1;
rate_gain= 0.1;
rate_decrease = 0.91;
inc = 1.2;
dec = 0.5;% if the last two gradients have the same sign, then increase the 
%gaining rate by adding 0.05, otherwise, decrease it by multiplying 0.95 
res.ratew1 = Initiallearningrate*ones(size(w1));
res.ratew2 = Initiallearningrate*ones(size(w2));
res.ratew3 = Initiallearningrate*ones(size(w3));
res.rateb1 = Initiallearningrate*ones(size(b1));
res.rateb2 = Initiallearningrate*ones(size(b2));
res.rateb3 = Initiallearningrate*ones(size(b3));
res.rpropw1 = ones(size(w1));
res.rpropw2 = ones(size(w2));
res.rpropw3 = ones(size(w3));
res.rpropb1 = ones(size(b1));
res.rpropb2 = ones(size(b2));
res.rpropb3 = ones(size(b3));

res.gainw1 = ones(size(w1));
res.gainw2 = ones(size(w2));
res.gainw3 = ones(size(w3));
res.gainb1 = ones(size(b1));
res.gainb2 = ones(size(b2));
res.gainb3 = ones(size(b3));
% -------------------------------------------------------------------------
% now begin to do the real job in every epoch
% -------------------------------------------------------------------------

for iii=1:Num_Epoches
    
    SampleIndex = randperm(Size_trainingSamples,Size_trainingSamples); % used to generate the sample indexes
% SampleIndex = randperm(Num_wholesamples,Size_trainingSamples); % used to generate the sample indexes, change the sample size every time
    
    for batch_ground =1:Num_batches 
        if mod(batch_ground,2)==1
            BatchSample_status = 1 ;
        else
            BatchSample_status = 0 ;
        end
        
        if batch_ground < 10
%             rate = 0.005;
            momentum = 0.9 ;
        else
            if batch_ground < 18
%             rate = 0.01;
            momentum = 0.9 ;
            end
        end
        if batch_ground >= 18
%             rate = 0.02;
            momentum = 0.9 ;
        end
            
         % first get the training data and its sample index    
%          if BatchSample_status==1
%              for ii=1:Size_batches
%                  x_l(:,:,1,ii) = single(x_pos{SampleIndex((batch_ground-1)*Size_batches+ii),1});
%                  x_r(:,:,1,ii) = single(x_pos{SampleIndex((batch_ground-1)*Size_batches+ii),2});
% %                  x_l(:,:,1,ii+Size_batches) = single(x_neg{SampleIndex((batch_ground-1)*Size_batches+ii),1});
% %                  x_l(:,:,1,ii+Size_batches) = single(x_neg{SampleIndex((batch_ground-1)*Size_batches+ii),1});
%              end
%              y(1:Size_batches)=1;
% %              y(Size_batches+1:2*Size_batches)=0;
%              rate = 0.05;
%          else
%              for ii=1:Size_batches
%                  x_l(:,:,1,ii) = single(x_neg{SampleIndex((batch_ground-1)*Size_batches+ii),1});
%                  x_r(:,:,1,ii) = single(x_neg{SampleIndex((batch_ground-1)*Size_batches+ii),2});
%              end
%              y(1:Size_batches)=0;
%              rate = 0.1;
%          end
         
         for ii=1:Size_batches
                 x_l(:,:,1,ii) = single(x_pos{SampleIndex((batch_ground-1)*Size_batches+ii),1});
                 x_r(:,:,1,ii) = single(x_pos{SampleIndex((batch_ground-1)*Size_batches+ii),2});
                 x_l(:,:,1,ii+Size_batches) = single(x_neg{SampleIndex((batch_ground-1)*Size_batches+ii),1});
                 x_r(:,:,1,ii+Size_batches) = single(x_neg{SampleIndex((batch_ground-1)*Size_batches+ii),2});
         end
         y(1:Size_batches)=1;
         y(Size_batches+1:2*Size_batches)=0;
         
         % central normalization training data 
         for i=1:Size_batches*2
             tmp_xl =  x_l(:,:,:,i);
             tmp_xr =  x_r(:,:,:,i);
             x_l(:,:,:,i) = (x_l(:,:,:,i) - mean(mean(mean(x_l(:,:,:,i)))))/std(tmp_xl(:));
             x_r(:,:,:,i) = (x_r(:,:,:,i) - mean(mean(mean(x_r(:,:,:,i)))))/std(tmp_xr(:));
         end
         
         % do forward propagation first
         [resl,resr] = PatchDesc_DeepCnn(x_l,x_r, w1, b1,w2,b2,w3,b3);
         
         % then calculate the cost and derivatives
         t = 1:Size_batches*2;
         % calculate the distance for each pair.
         MM = size(resl.x6,3);
         NN = size(resl.x6,4);
         xNNl = reshape(resl.x6,[MM NN]);
         xNNr = reshape(resr.x6,[MM NN]);
         dist = (xNNl-xNNr).*(xNNl-xNNr);
         Eucl_dist(t) = sqrt(sum(dist(:,t)));
         % compute current Loss  
%          L = y.*max(0,Eucl_dist-0.6)+(1-y).*max(0,2-Eucl_dist);
%           L = 0.5*y.*(max(0,Eucl_dist-1).^2)+0.5*(1-y).*(max(0,5-Eucl_dist).^2);% change the loss function into square of Euclidean distance
%           L = y.*(max(0,Eucl_dist-1.5))+3*(1-y).*(max(0,4.5-Eucl_dist))+ 0.5 * shrinkRate * sum(w1(:).^2)+0.5 * shrinkRate * sum(w2(:).^2) +0.5 * shrinkRate * sum(w3(:).^2);% Try to change the loss function into L1 Norm
          L = 0.5*y.*(max(0,Eucl_dist-3).^2)+0.5*(1-y).*(max(0,8-Eucl_dist).^2)+ 0.5 * shrinkRate * sum(w1(:).^2)+0.5 * shrinkRate * sum(w2(:).^2) +0.5 * shrinkRate * sum(w3(:).^2);% change the loss function into square of Euclidean distance

            Loss_Rec_batch(batch_ground) = mean(L); % record the loss for visulizing
          %             L = 0.5*y.*(Eucl_dist.^2)+0.5*(1-y).*(max(0,10-Eucl_dist).^2)+ 0.5 * shrinkRate * sum(w1(:).^2)+0.5 * shrinkRate * sum(w2(:).^2) +0.5 * shrinkRate * sum(w3(:).^2);% change the loss function into square of Euclidean distance
%          fprintf('currentpatchstatus: %f, current loss: %f\n',BatchSample_status,mean(L));
         fprintf('BatchNum %d, Epoch :%d current loss: %f\n',batch_ground,iii,mean(L));
%          disp(mean(L));
%          % if the Loss is greater than the last round, then the learning rate is
%          % halved; if the decreasing rate is too low, then increase the learning
%          % rate by times 2
%          if trainround>2
%              if Temp_L(trainround-1)>Temp_L(trainround);
%                  rate = 0.5*rate;
%              else
%                  if trainround > 3
%                      if (Temp_L(trainround-1)-Temp_L(trainround))/Temp_L(trainround-2)<0.02
%                          rate = 2*rate;
%                      end
%                  end
%              end
%     end
%  dLdD = single((y)&(Eucl_dist>0.6)) +  single((y-1) & (Eucl_dist<2)); 
%          dLdD = single((y.*(Eucl_dist-1))&(Eucl_dist>1)) +  single((y-1).*(Eucl_dist-5) & (Eucl_dist<5));
%          dLdD = single((y.*(Eucl_dist))) +  single((y-1).*(Eucl_dist-0.2) & (Eucl_dist<0.2));
          dLdD = single((y.*(Eucl_dist-3)).*(Eucl_dist>3)) +  single((1-y).*(Eucl_dist-8) .* (Eucl_dist<8));
%                     dLdD = single(y.*Eucl_dist) +  single((1-y).*(Eucl_dist-10) .* (Eucl_dist<10));
%          dLdD = single(y.*(Eucl_dist>1.5)) +  3*single((y-1).*(Eucl_dist<4.5));
         % change the form of resl.x3 and resr.x3 into vector
         dLdxl = zeros(size(resl.x6)) ;
         dDdx6l  = zeros(size(resl.x6)) ;
         dLdxr = zeros(size(resl.x6)) ; 
         dDdx6r = zeros(size(resl.x6)) ;
         
         for t = 1:2*Size_batches
             dDdx6l(:,:,:,t) = 2*(resl.x6(:,:,:,t)-resr.x6(:,:,:,t));
             dLdxl(:,:,:,t) = dLdD(t)*dDdx6l(:,:,:,t);
             dDdx6r(:,:,:,t) = 2*(resr.x6(:,:,:,t)-resl.x6(:,:,:,t));
             dLdxr(:,:,:,t) = dLdD(t)*dDdx6r(:,:,:,t);
         end
         dLdxl = single(dLdxl);
         dLdxr = single(dLdxr);
         
         [resl,resr] = PatchDesc_DeepCnn(x_l,x_r, w1, b1,w2,b2,w3,b3,dLdxl,dLdxr);
         % check if the gradient computation is right?
         ex = randn(size(x_l), 'single') ;
         eta = 0.0001 ;
         xp_l = x_l + eta * ex  ;
         [resxl,resxr] = PatchDesc_DeepCnn(xp_l,x_r, w1, b1,w2,b2,w3,b3,dLdxl,dLdxr);
         dzdx_empirical = sum(dLdxl(:) .* (resxl.x6(:) - resl.x6(:)) / eta) ;
         dzdx_computed = sum(resl.dzdx1(:) .* ex(:)) ;
%          fprintf(...
%              'der: empirical: %f, computed: %f, error: %.2f %%\n', ...
%              dzdx_empirical, dzdx_computed, ...
%              abs(1 - dzdx_empirical/dzdx_computed)*100) ;
         
         res.dzdw1 = (resl.dzdw1 + resr.dzdw1)/size(resl.x1,4);
         res.dzdb1 = (resl.dzdb1 + resr.dzdb1)/ size(resl.x1,4);
         res.dzdw2 = (resl.dzdw2 + resr.dzdw2)/size(resl.x1,4);
         res.dzdb2 = (resl.dzdb2 + resr.dzdb2)/ size(resl.x1,4);
         res.dzdw3 = (resl.dzdw3 + resr.dzdw3)/size(resl.x1,4);
         res.dzdb3 = (resl.dzdb3 + resr.dzdb3)/ size(resl.x1,4);
         
         
         
% store the last time of learned gradients
%          w_momentum1 = momentum * w_momentum1 + rate * (res.dzdw1 + shrinkRate * w1) ;
%          b_momentum1 = momentum * b_momentum1 + rate * 0.1* res.dzdb1 ;
%          w_momentum2 = momentum * w_momentum2 + rate * (res.dzdw2 + shrinkRate * w2) ;
%          b_momentum2 = momentum * b_momentum2 + rate * 0.1*res.dzdb2 ;
%          w_momentum3 = momentum * w_momentum3 + rate * (res.dzdw3 + shrinkRate * w3) ;
%          b_momentum3 = momentum * b_momentum3 + rate * 0.1* res.dzdb3 ;
         
         
         % do the rprop, give every parameters seperate learning rate.
%          samw1 = sign(res_lt.dzdw1) == sign(res_lt.dzdw1);
%          difw1 = sign(res_lt.dzdw1) ~= sign(res_lt.dzdw1);
%          res.ratew1 = inc*res_lt.ratew1.*samw1 + dec*res_lt.ratew1.*difw1;
%          nn = res.ratew1 < 0.3;mm = res.ratew1 >= 0.3;        
%          res.ratew1 = res.ratew1.*nn + 0.3*ones(size(res.ratew1)).*mm;
%          
%          samw2 = sign(res_lt.dzdw2) == sign(res_lt.dzdw2);
%          difw2 = sign(res_lt.dzdw2) ~= sign(res_lt.dzdw2);
%          res.ratew2 = inc*res_lt.ratew2.*samw2 + dec*res_lt.ratew2.*difw2;
%          nn = res.ratew2 < 0.3;mm = res.ratew2 >= 0.3;      
%          res.ratew2 = res.ratew2.*nn+ 0.3*ones(size(res.ratew2)).*mm;
%          
%          samw3 = sign(res_lt.dzdw3) == sign(res_lt.dzdw3);
%          difw3 = sign(res_lt.dzdw3) ~= sign(res_lt.dzdw3);
%          res.ratew3 = inc*res_lt.ratew3.*samw3 + dec*res_lt.ratew3.*difw3;
%          nn = res.ratew3 < 0.3;mm = res.ratew3 >= 0.3;      
%          res.ratew3 = res.ratew3.*nn+ 0.3*ones(size(res.ratew3)).*mm;
%          
%          samb1 = sign(res_lt.dzdb1) == sign(res_lt.dzdb1);
%          difb1 = sign(res_lt.dzdb1) ~= sign(res_lt.dzdb1);
%          res.rateb1 = inc*res_lt.rateb1.*samb1 + dec*res_lt.rateb1.*difb1;
%          nn = res.rateb1 < 0.3; mm = res.rateb1 >= 0.3;        
%          res.rateb1 = res.rateb1.*nn + 0.3*ones(size(res.rateb1)).*mm;
%          
%          samb2 = sign(res_lt.dzdb2) == sign(res_lt.dzdb2);
%          difb2 = sign(res_lt.dzdb2) ~= sign(res_lt.dzdb2);
%          res.rateb2 = inc*res_lt.rateb2.*samb2 + dec*res_lt.rateb2.*difb2;
%          nn = res.rateb2 < 0.3;mm = res.rateb2 >= 0.3;       
%          res.rateb2 = res.rateb2.*nn+ 0.3*ones(size(res.rateb2)).*mm;
%          
%          samb3 = sign(res_lt.dzdb3) == sign(res_lt.dzdb3);
%          difb3 = sign(res_lt.dzdb3) ~= sign(res_lt.dzdb3);
%          res.rateb3 = inc*res_lt.rateb3.*samb3 + dec*res_lt.rateb3.*difb3;
%          nn = res.rateb3 < 0.3;mm = res.rateb3 >= 0.3;       
%          res.rateb3 = res.rateb3.*nn+ 0.3*ones(size(res.rateb3)).*mm;



if iii>1
%     if batch_ground >1
             samw1 = sign(res.dzdw1) == sign(res_lt.dzdw1);
             difw1 = sign(res.dzdw1) ~= sign(res_lt.dzdw1);
             res.gainw1 = (res_lt.gainw1+rate_gain).*samw1 + (res_lt.gainw1*rate_decrease).*difw1;
             nn = res.gainw1 < gain_upperbound;mm = res.gainw1 >= gain_upperbound;             
             res.gainw1 = res.gainw1.*nn + gain_upperbound*ones(size(res.gainw1)).*mm;
             nn = res.gainw1 > 0.1;mm = res.ratew1 <= 0.1;   
             res.gainw1 = res.gainw1.*nn + 0.1*ones(size(res.gainw1)).*mm;    
             res.rpropw1 = 0.9*lst_w1 + 0.1*(res.dzdw1.^2);
             
             samw2 = sign(res.dzdw2) == sign(res_lt.dzdw2);
             difw2 = sign(res.dzdw2) ~= sign(res_lt.dzdw2);
             res.gainw2 = (res_lt.gainw2+rate_gain).*samw2 + (res_lt.gainw2*rate_decrease).*difw2;
             nn = res.gainw2 < gain_upperbound;mm = res.gainw2 >= gain_upperbound;     
             res.gainw2 = res.gainw2.*nn + gain_upperbound*ones(size(res.gainw2)).*mm;
             nn = res.gainw2 > 0.1;mm = res.ratew2 <= 0.1;   
             res.gainw2 = res.gainw2.*nn + 0.1*ones(size(res.gainw2)).*mm;
             res.rpropw2 = 0.9*lst_w2 + 0.1*(res.dzdw2.^2);
             
             samw3 = sign(res.dzdw3) == sign(res_lt.dzdw3);
             difw3 = sign(res.dzdw3) ~= sign(res_lt.dzdw3);
             res.gainw3 = (res_lt.gainw3+rate_gain).*samw3 + (res_lt.gainw3*rate_decrease).*difw3;
             nn = res.gainw3 < gain_upperbound;mm = res.gainw3 >= gain_upperbound;        
             res.gainw3 = res.gainw3.*nn + gain_upperbound*ones(size(res.gainw3)).*mm;
             nn = res.gainw3 > 0.1;mm = res.ratew3 <= 0.1;   
             res.gainw3 = res.gainw3.*nn + 0.1*ones(size(res.gainw3)).*mm;
             res.rpropw3 = 0.9*lst_w3 + 0.1*(res.dzdw3.^2);
             
             samb1 = sign(res.dzdb1) == sign(res_lt.dzdb1);
             difb1 = sign(res.dzdb1) ~= sign(res_lt.dzdb1);
             res.gainb1 = (res_lt.gainb1+rate_gain).*samb1 + (res_lt.gainb1*rate_decrease).*difb1;
             nn = res.gainb1 < gain_upperbound;mm = res.gainb1 >= gain_upperbound;        
             res.gainb1 = res.gainb1.*nn + gain_upperbound*ones(size(res.gainb1)).*mm;
             nn = res.gainb1 > 0.1;mm = res.gainb1 <= 0.1;   
             res.gainb1 = res.gainb1.*nn + 0.1*ones(size(res.gainb1)).*mm;
             res.rpropb1 = 0.9*lst_b1 + 0.1*(res.dzdb1.^2);
             
             samb2 = sign(res.dzdb2) == sign(res_lt.dzdb2);
             difb2 = sign(res.dzdb2) ~= sign(res_lt.dzdb2);
             res.gainb2 = (res_lt.gainb2+rate_gain).*samb2 + (res_lt.gainb2*rate_decrease).*difb2;
             nn = res.gainb2 < gain_upperbound;mm = res.gainb2 >= gain_upperbound;        
             res.gainb2 = res.gainb2.*nn + gain_upperbound*ones(size(res.gainb2)).*mm;
             nn = res.gainb2 > 0.1;mm = res.gainb2 <= 0.1;   
             res.gainb2 = res.gainb2.*nn + 0.1*ones(size(res.gainb2)).*mm;
             res.rpropb2 = 0.9*lst_b2 + 0.1*(res.dzdb2.^2);
             
             samb3 = sign(res.dzdb3) == sign(res_lt.dzdb3);
             difb3 = sign(res.dzdb3) ~= sign(res_lt.dzdb3);
             res.gainb3 = (res_lt.gainb3+rate_gain).*samb3 + (res_lt.gainb3*rate_decrease).*difb3;
             nn = res.gainb3 < gain_upperbound;mm = res.gainb3 >= gain_upperbound;        
             res.gainb3 = res.gainb3.*nn + gain_upperbound*ones(size(res.gainb3)).*mm;
             nn = res.gainb3 > 0.1;mm = res.gainb3 <= 0.1;   
             res.gainb3 = res.gainb3.*nn + 0.1*ones(size(res.gainb3)).*mm;
             res.rpropb3 = 0.9*lst_b3 + 0.1*(res.dzdb3.^2);
       
         end
                  
         
         
         w_momentum1 = momentum * w_momentum1 + res.ratew1.*res.gainw1.* (res.dzdw1 + shrinkRate * w1) ;
         w_momentum2 = momentum * w_momentum2 + res.ratew2.*res.gainw2.* (res.dzdw2 + shrinkRate * w2) ;
         w_momentum3 = momentum * w_momentum3 + res.ratew3.*res.gainw3.* (res.dzdw3 + shrinkRate * w3) ;
         b_momentum1 = momentum * b_momentum1 + res.rateb1.*res.gainb1.* res.dzdb1 ;  
         b_momentum2 = momentum * b_momentum2 + res.rateb2.*res.gainb2.* res.dzdb2 ;
         b_momentum3 = momentum * b_momentum3 + res.rateb3.*res.gainb3.* res.dzdb3 ;
         
            % combine the information of rprop, that means try to make adjacent mini
            % batches have similar adjusting step
%          w_momentum1 = momentum * w_momentum1 + res.ratew1.*res.gainw1.* (res.dzdw1./sqrt(res.rpropw1) + shrinkRate * w1) ;
%          w_momentum2 = momentum * w_momentum2 + res.ratew2.*res.gainw2.* (res.dzdw2./sqrt(res.rpropw2) + shrinkRate * w2) ;
%          w_momentum3 = momentum * w_momentum3 + res.ratew3.*res.gainw3.* (res.dzdw3./sqrt(res.rpropw3) + shrinkRate * w3) ;
%          b_momentum1 = momentum * b_momentum1 + res.rateb1.*res.gainb1.* res.dzdb1./sqrt(res.rpropb1) ;  
%          b_momentum2 = momentum * b_momentum2 + res.rateb2.*res.gainb2.* res.dzdb2./sqrt(res.rpropb2) ;
%            b_momentum3 = momentum * b_momentum3 + res.rateb3.*res.gainb3.* res.dzdb3 ;
%          b_momentum3 = momentum * b_momentum3 + res.rateb3.*res.gainb3.* res.dzdb3./sqrt(res.rpropb3) ;
         
         
         res_lt = res; 
         lst_w1 = w1;
         lst_w2 = w2;
         lst_w3 = w3;
         lst_b1 = b1;
         lst_b2 = b2;
         lst_b3 = b3;
%          w_momentum1 = momentum * w_momentum1 + res.ratew1.* res.dzdw1 ;
%          b_momentum1 = momentum * b_momentum1 + res.rateb1.* res.dzdb1 ;    
%          w_momentum2 = momentum * w_momentum2 + res.ratew2.* res.dzdw2  ;
%          b_momentum2 = momentum * b_momentum2 + res.rateb2.* res.dzdb2 ;
%          w_momentum3 = momentum * w_momentum3 + res.ratew3.* res.dzdw3  ;
%          b_momentum3 = momentum * b_momentum3 + res.rateb3.* res.dzdb3 ;

%          w_momentum1 = momentum * w_momentum1 + rate * res.dzdw1 ;
%          b_momentum1 = momentum * b_momentum1 + rate *  res.dzdb1 ;    
%          w_momentum2 = momentum * w_momentum2 + rate * res.dzdw2  ;
%          b_momentum2 = momentum * b_momentum2 + rate *res.dzdb2 ;
%          w_momentum3 = momentum * w_momentum3 + rate * res.dzdw3  ;
%          b_momentum3 = momentum * b_momentum3 + rate * res.dzdb3 ;
         
         % let's test not using momentum
%          w_momentum1 =  rate * res.dzdw1 ;
%          b_momentum1 =  rate *  res.dzdb1 ;    
%          w_momentum2 =  rate * res.dzdw2  ;
%          b_momentum2 =  rate *res.dzdb2 ;
%          w_momentum3 =  rate * res.dzdw3  ;
%          b_momentum3 =  rate * res.dzdb3 ;
         
         % apply momentum Gradient 
         w1 = w1 - w_momentum1 ;
         b1 = b1 - b_momentum1 ;
         w2 = w2 - w_momentum2 ;
         b2 = b2 - b_momentum2 ;
         w3 = w3 - w_momentum3 ;
         b3 = b3 - b_momentum3 ;
    end
    Loss_Rec(iii) = mean(Loss_Rec_batch);% get the average Loss in the current epoch
    plot(Loss_Rec);
    xlabel('epoch number');
    ylabel('average loss for training samples');
    hold on
    
end


