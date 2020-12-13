%% (a) Read in the sample images and convert them to grayscale.

distorted_rgb = imread('data/sample_distorted.jpg');
undistorted_rgb = imread('data/sample_undistorted.jpg');

% Convert to grayscale
distorted_gray = rgb2gray(distorted_rgb);
undistorted_gray = rgb2gray(undistorted_rgb);



%% (b) Project the 3D points from checkboard onto the undistorted image.

% Variables to store the given values:
% Transformation from camera frame to checkerboard frame.
% Rotational part:
w1 = -0.372483192214;
w2 = 0.0397022486165;
w3 = 0.0650393402332;
w = [w1; w2; w3];

% Translational part:
t1 = -0.107035863625;
t2 = -0.147065242923;
t3 = 0.398512498053;
t = [t1; t2; t3];

% Camera intrinsics:
fx = 420.506712;
fy = 420.610940;
cx = 355.2082980;
cy = 250.3367870;
C = [fx, 0,  cx;
     0,  fy, cy;
     0,  0,  1];

% 3D coordinates of all the corner points:
x = (-1:9) * 0.04;
y = (-1:6) * 0.04;
z = 0;
[X, Y, Z] = meshgrid(x, y, z);
corners_3D = [X(:), Y(:), Z(:)]';

% Calculate the rotation matrix from the axis-angle representation:
theta = norm(w);
n = w / theta;
n_hat = [ 0,    -n(3),  n(2);
          n(3),  0,    -n(1);
         -n(2),  n(1),  0];
R = eye(3) + sin(theta) * n_hat + (1 - cos(theta)) * n_hat^2;

% Build up the transformation matrix 
T = [R, t; 0, 0, 0, 1];

% Transform the 3D points to camera frame:
corners_3D_camera = T(1:3, 1:3) * corners_3D + repmat(T(1:3, 4), 1, size(corners_3D, 2));

% Normalize the coordinates:
corners_3D_camera = corners_3D_camera./repmat(corners_3D_camera(3, :), 3, 1);

% Calculate image coordinates of corners:
corners_2D = C * corners_3D_camera;

% Draw the corners:
figure(1);
imshow(undistorted_gray);
hold on;
scatter(corners_2D(1, :), corners_2D(2, :), 'ro');



%% (c) Project the 3D points from checkboard onto the distorted image.

% Distort the normalized 3D coordinates in camera frame.
k1 = -0.296609;
k2 = 0.080818;
% r = vecnorm(corners_3D_camera(1:2, :));
% vecnorm was introduced since R2017b
% For older versions, use:
r = sqrt(sum(corners_3D_camera(1:2, :).^2,1));

factor = 1 + k1 * r.^2 + k2 * r.^4;
corners_3D_distorted = corners_3D_camera;
corners_3D_distorted(1:2, :) = repmat(factor, 2, 1) .* corners_3D_camera(1:2, :);

% Calculate image coordinates of corners:
corners_2D_distorted = C * corners_3D_distorted;

% Draw the corners:
figure(2);
imshow(distorted_gray);
hold on;
scatter(corners_2D_distorted(1, :), corners_2D_distorted(2, :), 'ro');



%% (d) Determine the field of view of the camera.

% Note that the principal point may not be the image center! 
% Undistorted image:
undistorted_horizontal_fov = atan(cx/fx) * 180 / pi;
undistorted_horizontal_fov = undistorted_horizontal_fov + atan((size(undistorted_gray, 2) - cx)/fx) * 180 / pi

undistorted_vertical_fov = atan(cy/fy) * 180 / pi;
undistorted_vertical_fov = undistorted_vertical_fov + atan((size(undistorted_gray, 1) - cy)/fy) * 180 / pi

% Distorted image;
xt1 = undistort([cx / fx; 0], k1, k2);
xt2 = undistort([(size(undistorted_gray, 2) - cx) / fx; 0], k1, k2);
yt1 = undistort([0; cy / fy], k1, k2);
yt2 = undistort([0; (size(undistorted_gray, 1) - cy) / fy], k1, k2);
distorted_horizontal_fov = (atan(xt1(1)) + atan(xt2(1))) * 180 / pi
distorted_vertical_fov = (atan(yt1(2)) + atan(yt2(2))) * 180 / pi


