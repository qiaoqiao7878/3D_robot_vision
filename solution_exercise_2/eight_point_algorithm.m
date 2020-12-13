function [R1, T1, R2, T2] = eight_point_algorithm(x1, y1, x2, y2)

nPoints = size(x1, 1);

% Compute constraint matrix A:
A = zeros(nPoints,9);

for i = 1:nPoints
    A(i,:) = kron([x1(i) y1(i) 1],[x2(i) y2(i) 1])';
end

rank_A = rank(A)

% Find minimizer for |A*E|:
[UA,DA,VA] = svd(A);

% Unstacked ninth column of V:
E = reshape(VA(:,9), 3, 3)

% SVD of E
[U,D,V] = svd(E);

if det(U) < 0 || det(V) < 0
    [U,D,V] = svd(-E);
end

% Project E onto essential space (replace eigenvalues):
D(1,1) = 1;
D(2,2) = 1;
D(3,3) = 0;

% Final essential matrix:
E = U * D * V';

% Recover R and T from the essential matrix E:
% (Compare Slides)
Rz1 = [0 1 0; -1 0 0; 0 0 1]';
Rz2 = [0 -1 0; 1 0 0; 0 0 1]';
R1 = U * Rz1' * V';
R2 = U * Rz2' * V';
T_hat1 = U * Rz1 * D * U';
T_hat2 = U * Rz2 * D * U';

% Translation belonging to T_hat
T1 = [ -T_hat1(2,3); T_hat1(1,3); -T_hat1(1,2) ];
T2 = [ -T_hat2(2,3); T_hat2(1,3); -T_hat2(1,2) ];

end