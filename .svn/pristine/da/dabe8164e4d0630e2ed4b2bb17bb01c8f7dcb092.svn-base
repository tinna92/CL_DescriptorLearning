function [alpha]= Chen_DeepDescTraining_adjust_theta_indifferentlayer(alpha1,alpha2,alpha3)
sizew1 = [5 5 1 5];
sizeb1 = [1 5];
sizew2 = [5 5 5 25];
sizeb2 = [1 25];
sizew3 = [5 5 25 125];
sizeb3 = [1 125];
totalsizew1 = cumprod(sizew1);
totalsizeb1 = cumprod(sizeb1);
totalsizew2 = cumprod(sizew2);
totalsizeb2 = cumprod(sizeb2);
totalsizew3 = cumprod(sizew3);
totalsizeb3 = cumprod(sizeb3);

mark1 = totalsizeb1(2)+totalsizew1(4);
mark2 = mark1+totalsizew2(4)+totalsizeb2(2);

alpha(1:mark1)=alpha1;
alpha(mark1+1:mark2)=alpha2;
alpha(mark2+1:mark2+totalsizew3(4)+totalsizeb3(2)) = alpha3;

end