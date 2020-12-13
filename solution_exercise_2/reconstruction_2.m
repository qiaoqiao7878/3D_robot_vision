% Compute correct combination of R and T and reconstruction of 3D points
% This is an alternative solution to the one we discussed in the lecture.
% See Section 5.4.4 in the "An Invitation to 3-D Vision" book. 
function reconstruction_2(R,T,x1,y1,x2,y2,nPoints)

% Structure reconstruction matrix M:
M = zeros(3*nPoints, nPoints + 1);
for i = 1:nPoints
   x2_hat = hat([x2(i) y2(i) 1]);
   
   M(3*i - 2  :  3*i, i)           = x2_hat * R * [x1(i); y1(i); 1];
   M(3*i - 2  :  3*i, nPoints + 1) = x2_hat * T;
end

% Get depth values (eigenvector to the smallest eigenvalue of M'M):
[V,D] = eig(M' * M);
lambda = V(1:nPoints, 1);
gamma  = V(nPoints + 1, 1);

% Determine correct combination of R and T:
if lambda >= zeros(nPoints,1)
    'structure matrix'
    
    display(R);
    display(T);
    display(lambda);
    display(gamma);
    
    % Visualize the 3D points:
    figure, plot3(x1.*lambda ,y1.*lambda ,lambda ,'+');
    axis equal
end

end