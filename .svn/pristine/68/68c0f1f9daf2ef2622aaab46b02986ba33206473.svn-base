%% generate num random numbers from 1-N, without duplicate
function [result] = randNnum(N,num)
result = zeros(num,1);
result(1)=1+fix((N)*rand());
for i=2:num 
    x =  1+fix((N)*rand());
    if(x<result(i-1))
        result(i)=x;
    else
        result(i)=x+1;
    end
end
end