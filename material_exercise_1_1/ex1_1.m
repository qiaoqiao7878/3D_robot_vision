clear;
clc;
close;
%%
% a)

sample_distorted = imread('data\sample_distorted.jpg');
sample_distorted = rgb2gray(sample_distorted);

sample_undistorted = imread('data\sample_undistorted.jpg');
sample_undistorted = rgb2gray(sample_undistorted);

%%
% b)

x = (-1:9) * 0.04;
y = (-1:6) * 0.04;
z = 0;
[X, Y, Z] = meshgrid(x, y, z);
corners_3D = [X(:), Y(:), Z(:)]';
% imshow(sample_distorted)

w1= -0.372483192214; 
w2 = 0.039702248616;
w3 = 0.0650393402332;
 
w = [w1, w2, w3];
theta = norm(w);
w = w/theta;
axang = [w, theta];

rotm = axang2rotm(axang);

t1 = -0.107035863625;
t2 = -0.147065242923;
t3 = 0.398512498053;
t = [t1; t2; t3];

corners_3D_camera_frame = rotm * corners_3D +t;

normalized_corners_3D = corners_3D_camera_frame ./ corners_3D_camera_frame(3,:);



f_x = 420.506712;
f_y = 420.610940;

c_x = 355.2082980;
c_y = 250.3367870;

camera_matrix = [f_x, 0,c_x;0,f_y,c_y;0,0,1];
corners_2D = camera_matrix * normalized_corners_3D;


%%
figure(1);
imshow(sample_undistorted);
hold on;
% first line (y), then column (x) when indexing image(-matrices)
scatter(corners_2D(1, :), corners_2D(2, :), 'ro');

%%
% c)
k1 = -0.296609;
k2 = 0.080818;
r = sqrt(normalized_corners_3D(1,:).^2 + normalized_corners_3D(2,:).^2);

normalized_corners_3D_dist = normalized_corners_3D(1:2,:).*(1 + k1 * r.^2 + k2 * r.^4);
normalized_corners_3D_dist(3,:) = 1
corners_2D_dist = camera_matrix * normalized_corners_3D_dist;

%%
figure(2);
imshow(sample_distorted);
hold on;
% first line (y), then column (x) when indexing image(-matrices)
scatter(corners_2D_dist(1, :), corners_2D_dist(2, :), 'ro');













