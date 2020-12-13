clear all; close all;

%% (a) Associate the RGB images with depth images by the closest timestamps
data_path = './data/rgbd/';

P1 = {'1305031102.175304.png'; '1305031102.275326.png'};
P2 = {'1341847980.722988.png'; '1341847982.998783.png'};
D1 = {'1305031102.160407.png'; '1305031102.262886.png'};
D2 = {'1341847980.723020.png'; '1341847982.998830.png'};

C1 = [517.3, 0, 318.6
      0, 516.5, 255.3
      0, 0, 1];
  
C2 = [535.4, 0, 320.1
      0, 539.2, 247.6
      0, 0, 1];

  
%% (b) Select 6 corresponding points from images and retrieve their depth
nPoints = 6;

image1 = imread([data_path 'rgb/' P2{1}]);
image2 = imread([data_path 'rgb/' P2{2}]);
depth = imread([data_path 'depth/' D2{1}]);
C = C2;
% image1 = imread([data_path 'rgb/' P2{1}]);
% image2 = imread([data_path 'rgb/' P2{2}]);
% depth = imread([data_path 'depth/' D2{1}]);
% C = C1;

%[x1,y1,x2,y2, d] = getpoints_with_depth(image1, image2, depth, nPoints);
%d = d / 5000;

%save('selected_points.mat', 'x1', 'y1', 'x2', 'y2', 'd');
load selected_points.mat

%% (c) Implement the DLT algorithm

% Image coordinates to normalized image coordinates
First = C \ [x1'; y1'; ones(nPoints, 1)'];
Second = C \ [x2'; y2'; ones(nPoints, 1)'];

x1 = First(1, :)';
y1 = First(2, :)';
x2 = Second(1, :)';
y2 = Second(2, :)';

% 3D coordinates in first camera frame
X1 = [x1, y1, ones(nPoints, 1)] .* repmat(d, 1, 3);

% Construct matrix A
A = zeros(12);

for i = 1:6
   A(2 * i - 1, :) = kron([0, -1, y2(i)], [X1(i, :) 1]);
   A(2 * i, :) = kron([1, 0, -x2(i)], [X1(i, :) 1]);
end

[U, S, V] = svd(A);

% Varify if R is in SO(3)
P = reshape(-V(:, 12), 4, 3)'
R = P(1:3, 1:3)

% also works to some degree but needs ortho-normalization as well
R3norm = norm( R(3, 1:3) );
P = 1 / R3norm * P

% Ortho-Normalization of R
Q = P(:, 1:3);
[UQ, SQ, VQ] = svd(Q);
R = UQ * VQ'
P(:,1:3) = R;
P

T = P(:, 4)

disp('DLT reprojections (will be off quite a bit):')
PX = P * [ X1, ones(6,1) ]';
Px = PX(1:2,:) ./ repmat(PX(3,:), 2, 1)
[ x2'; y2' ]


% (d) Run the 8-point algorithm and compare the estimations
% Get two more points
nPoints_add = 2;
%[x11, y11, x22, y22] = getpoints(image1, image2, nPoints_add); 
%save('selected_points.mat', 'x11', 'y11', 'x22', 'y22', '-append');

First = C \ [x11'; y11'; ones(nPoints_add, 1)'];
Second = C \ [x22'; y22'; ones(nPoints_add, 1)'];
x11 = First(1, :)';
y11 = First(2, :)';
x22 = Second(1, :)';
y22 = Second(2, :)';
nPoints = nPoints+nPoints_add;

x1 = [x1; x11];
y1 = [y1; y11];
x2 = [x2; x22];
y2 = [y2; y22];

[R1, T1, R2, T2] = eight_point_algorithm(x1, y1, x2, y2);

% Find correct transformation
reconstruction(R1,T1,x1,y1,x2,y2,nPoints);
reconstruction(R1,T2,x1,y1,x2,y2,nPoints);
reconstruction(R2,T1,x1,y1,x2,y2,nPoints);
reconstruction(R2,T2,x1,y1,x2,y2,nPoints);

disp('Eight point reprojections:')
load P8.mat;
px8 = (p28(:,1:2) ./ repmat(p28(:,3), 1, 2))'
[ x2'; y2' ]

% Scale the estimation to match the scale
ratio = sum(X1(:, 3)) / sum(p8(1:6, 3));
T8 = T8 * ratio;

figure, plot3(X1( :, 1 ) , X1( :, 2 ) , X1( :, 3 ) ,'+');
hold on
plot3(p8(1:6, 1 ) * ratio, p8(1:6, 2 ) * ratio, p8(1:6, 3 ) * ratio ,'x');
axis equal

disp('DLT transform:')
P

disp('Eight point transform:')
[R8 T8]
