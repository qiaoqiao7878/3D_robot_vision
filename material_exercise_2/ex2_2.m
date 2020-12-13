clear;
clc;
close;
%%

image1 = imread('data\fountain\0005.png');
image2 = imread('data\fountain\0007.png');

intrinsics_matrix = importdata('data\fountain\camera_intrinsics_matrix.txt');


figure(1);
imshow(image1);
[pixel_x1,pixel_y1] = ginput;
%%
pixel1 = [pixel_x1';pixel_y1'];
pixel1(3,:) = 1;

normalized_image1 = intrinsics_matrix \ pixel1;
%%
x1 = normalized_image1(1,:)';
y1 = normalized_image1(2,:)';




%%
figure(2);
imshow(image2);
[pixel_x2,pixel_y2] = ginput;


pixel2 = [pixel_x2';pixel_y2'];
pixel2(3,:) = 1;

normalized_image2 = intrinsics_matrix \ pixel2;
%%
x2 = normalized_image2(1,:)';
y2 = normalized_image2(2,:)';



%%

A = [x2 .* x1, x2 .* y1, x2, y2 .* x1, y2 .* y1, y2, x1, y1, ones(8, 1)];

[U,S,V] = svd(A);
E_estimated = reshape(A(8,:),[3,3]);

[U1,S1,V1] = svd(E_estimated);

diag110 = [1,0,0;0,1,0;0,0,0];
E = U1 * diag110 * V1';

R_z_90 = [0,-1,0;1,0,0;0,0,1];
R_z_minus90 = [0,1,0;-1,0,0;0,0,1];

R1 = U1 * R_z_90 * V1';
R2 = U1 * R_z_minus90*V1';

t1 = U1 * R_z_90 * diag110 * U1';
t2 = U1 * R_z_minus90 * diag110 * U1';

t1_vec = [t1(3,2);t1(1,3);t1(2,1)];
t2_vec = [t2(3,2);t2(1,3);t2(2,1)];

P11 = R1 * normalized_image1(:,1) + t1_vec;
P12 = R1 * normalized_image1(:,1) + t2_vec;
P21 = R2 * normalized_image1(:,1) + t1_vec;
P22 = R2 * normalized_image1(:,1) + t2_vec;


normalized_image2(:,1)
P11_2 = R1 \ (normalized_image2(:,1) - t1_vec);
P12_2 = R1 \ (normalized_image2(:,1) - t2_vec);
P21_2 = R2 \ (normalized_image2(:,1) - t1_vec);
P22_2 = R2 \ (normalized_image2(:,1) - t2_vec);


