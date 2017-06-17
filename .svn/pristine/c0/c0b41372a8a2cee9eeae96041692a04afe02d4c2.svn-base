function [w1,b1,w2,b2,w3,b3] = Chen_GetSiameseCNNparamesFromSavedParameterFiles(parameterfilename,mode)

load(parameterfilename);
if mode == 1
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
% theta = theta';
w1 = reshape(theta(1:totalsizew1(4)),sizew1(1),sizew1(2),sizew1(3),sizew1(4));
b1 = reshape(theta(totalsizew1(4)+1:totalsizeb1(2)+totalsizew1(4)),sizeb1(1),sizeb1(2));
mark1 = totalsizeb1(2)+totalsizew1(4);
w2 = reshape(theta(mark1+1:mark1+totalsizew2(4)),sizew2(1),sizew2(2),sizew2(3),sizew2(4));
b2 = reshape(theta(mark1+totalsizew2(4)+1:mark1+totalsizew2(4)+totalsizeb2(2)),sizeb2(1),sizeb2(2));
mark2 = mark1+totalsizew2(4)+totalsizeb2(2);
w3 = reshape(theta(mark2+1:mark2+totalsizew3(4)),sizew3(1),sizew3(2),sizew3(3),sizew3(4));
b3 = reshape(theta(mark2+totalsizew3(4)+1:mark2+totalsizew3(4)+totalsizeb3(2)),sizeb3(1),sizeb3(2));
end

end