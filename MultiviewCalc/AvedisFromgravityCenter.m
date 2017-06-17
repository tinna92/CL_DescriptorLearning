%----- calculte the mean distance of all points to the centre of gravity
function avgdist = AvedisFromgravityCenter(A)
    XC = mean(A')';    
    dims = size(A);
    % dims(1) =3 (2D) or 4 (3D), dims(2) = number of points
    coords = dims(1) - 1;
    % number of Euclidean coordinates per point
    STD = A(1: coords,:)-kron(ones(1,dims(2)),XC(1:coords,1));
    % the columns of the matrix STD always contain X- XC!
    avgdist = sqrt(trace(STD'*STD)/ dims(2));
    % STD‘ * STD contains the squared distances between the
    % points and the centre of gravity in the main diagonal;
    % the source code determines the geometric mean
end