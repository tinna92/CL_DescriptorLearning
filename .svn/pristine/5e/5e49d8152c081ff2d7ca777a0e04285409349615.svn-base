% compute RMS error from image point x, 3D point X and projection matrix P
function RMS = Backprojectionerror(x,X,P)
    PX = P*X;% calculate projection point coor
    sumEerr =0;
    dims = size(x);
    for i=1:dims(2)
        PX_E(1,i) = PX(1,i)/PX(3,i);
        PX_E(2,i) = PX(2,i)/PX(3,i);
        PX_E(3,i) = PX(3,i)/PX(3,i);
        temp_err = (x(1,i)-PX_E(1,i))^2+(x(2,i)-PX_E(2,i))^2+(x(3,i)-PX_E(3,i))^2;
        sumEerr = sumEerr+temp_err;
    end
    RMS =sqrt(sumEerr/dims(2));
end