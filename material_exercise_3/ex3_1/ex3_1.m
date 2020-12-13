image1 = imread('0005.png');
image2 = imread('0007.png');
image1 = rgb2gray(image1);
image2 = rgb2gray(image2);


C = [2759.48 0 1520.69 ;
    0 2764.16 1006.81 ;
    0 0 1 ]

%matchedPoint.Location [x,y]
[matchedPoints1, matchedPoints2] = feature_match(image1,image2,'FAST','BRISK');

figure(1); 
imshow(image1);
hold on;
plot(matchedPoints1);

figure(2); 
imshow(image2);
hold on;
plot(matchedPoints2);
%showMatchedFeatures(image1,image2,matchedPoints1,matchedPoints2);

%%


P_success = 0.99;
outlier_radio = 0.2;
number_points = 8;
reprojection_error_threshold = 10;
%Compute required number of iterations
N = int8(log(1-P_success)/log(1-(1-outlier_radio)^number_points));
best_inlier_number = 0;
best_R = eye(3);
best_T = ones(3,1);
for i = 1:N
    %Randomly select a subset of data points
    r = randperm(size(matchedPoints1,1),number_points);
    P1 = matchedPoints1(r);
    P2 = matchedPoints2(r);
    u1 = P1.Location(:,1);
    v1 = P1.Location(:,2);
    u2 = P2.Location(:,1);
    v2 = P2.Location(:,2);
    
    %Fit model on the subset
    [R, T] = eight_point_algorithm(u1, v1, u2, v2, C)
    pp = [u2';v2';ones(8, 1)']
    pixel22 = C*(R*(C\pp)+T)
    pixel22(1,:) - u1'
    pixel22(2,:) - v1'
    
    
    
    
    %%
    %Count inliers and keep model/subset with largest number of inliers
    N_Point = size(matchedPoints1.Location,1);
    pixel1 = [matchedPoints1.Location(:,1)';matchedPoints1.Location(:,2)';ones(N_Point, 1)'];
    pixel2 = [matchedPoints2.Location(:,1)';matchedPoints2.Location(:,2)';ones(N_Point, 1)'];
   
    First = C\pixel1;
    Second = R * First
    second = C\pixel2
    pixel2 = C * Second;
    diff = matchedPoints2.Location()' - pixel2(1:2,:);
    diff_L2 = (diff(1,:).^2  + diff(2,:).^2).^(0.5);
    
    inlier_number = sum(diff_L2 <= 10);
    if inlier_number > best_inlier_number
        best_inlier_number = inlier_number;
        best_R = R;
        best_T = T;
    end
end
best_inlier_number
best_R
best_T


