% Read input images:
image1 = double(imread('./data/fountain/0005.png'));
image2 = double(imread('./data/fountain/0007.png'));

% Number of corresponding point pairs:
nPoints =  12;  % or 12 e.g.

% Get corresponding point pairs:
% Select points by mouse clicking
% [x1,y1,x2,y2] = getpoints(image1,image2,nPoints);
% or
% Use predefined points (see below)
[x1,y1,x2,y2] = getpoints2();      

% Intrinsic camera paramter matrices
K1 = [2759.48 0 1520.69; 0 2764.16 1006.81; 0 0 1];
K2 = K1;

% Transform image coordinates with inverse camera matrices:
Left = K1 \ [x1'; y1'; ones(nPoints, 1)'];
Right = K2 \ [x2'; y2'; ones(nPoints, 1)'];
x1 = Left(1, :)';
y1 = Left(2, :)';
x2 = Right(1, :)';
y2 = Right(2, :)';

[R1, T1, R2, T2] = eight_point_algorithm(x1, y1, x2, y2);

% Compute scene reconstruction and correct combination of R and T:
reconstruction(R1,T1,x1,y1,x2,y2,nPoints);
reconstruction(R1,T2,x1,y1,x2,y2,nPoints);
reconstruction(R2,T1,x1,y1,x2,y2,nPoints);
reconstruction(R2,T2,x1,y1,x2,y2,nPoints);

% alternative reconstruction method
reconstruction_2(R1,T1,x1,y1,x2,y2,nPoints);
reconstruction_2(R1,T2,x1,y1,x2,y2,nPoints);
reconstruction_2(R2,T1,x1,y1,x2,y2,nPoints);
reconstruction_2(R2,T2,x1,y1,x2,y2,nPoints);

















