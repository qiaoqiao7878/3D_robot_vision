% Compute correct combination of R and T and reconstruction of 3D points
function [positive_depths, p] = reconstruction(R,T,x1,y1,x2,y2,nPoints)

R2 = R;
T2 = T;
R1 = eye(3);
T1 = zeros( 3, 1 );

p = zeros( nPoints, 3 );

for i = 1:nPoints
   A = zeros(4, 4);

   A( 1, : ) = [ R1( 1, : ), T1(1) ]; 
   A( 2, : ) = [ R1( 2, : ), T1(2) ]; 
   A( 3, : ) = [ R2( 1, : ), T2(1) ]; 
   A( 4, : ) = [ R2( 2, : ), T2(2) ]; 
   
   A( 1, : ) = A( 1, : ) - [ R1( 3, : ), T1(3) ] * x1(i);
   A( 2, : ) = A( 2, : ) - [ R1( 3, : ), T1(3) ] * y1(i);
   A( 3, : ) = A( 3, : ) - [ R2( 3, : ), T2(3) ] * x2(i);
   A( 4, : ) = A( 4, : ) - [ R2( 3, : ), T2(3) ] * y2(i);
      
   B = -A( :, 4 );
   A = A( :, 1:3 );
   
   
   % solve Ap = B
   p( i, : ) = (pinv(A) * B)';
   
end

positive_depths = false;
p2 = (R' * p' + repmat(-R'*T, 1, nPoints))';

if min(p(:, 3)) > 0.0 && min(p2(:, 3)) > 0.0 
    R8 = R;
    T8 = T;
    p8 = p;
    p28 = p2;
    save P8.mat R8 T8 p8 p28
    'triangulate individually'
    display(R);
    display(T);
    positive_depths = true;
    % Visualize the 3D points:
    figure, plot3(p( :, 1 ) , p( :, 2 ) , p( :, 3 ) ,'+');
    axis equal
end

end