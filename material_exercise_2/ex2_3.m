clear;
clc;
close;
%%

image1 = imread('data\rgbd\rgb\1305031102.175304.png');
image2 = imread('data\rgbd\rgb\1305031102.275326.png');

image1_depth = imread('data\rgbd\depth\1305031102.160407.png');
image2_depth = imread('data\rgbd\depth\1305031102.262886.png');


C1 = [517.3 0 318.6;0 516.5 255.3; 0 0 1];
C2 = [525.4 0 320.1;0 539.2 247.6; 0 0 1];

number_points = 6;

x1 = zeros(number_points,1);
y1 = zeros(number_points,1);
x2 = zeros(number_points,1);
y2 = zeros(number_points,1);
d= zeros(number_points,1);

figure(1);
imshow(uint8(image1));
hold on;
i = 1;
while (i <= number_points)

    [x,y] = ginput(1);
    depth = image1_depth(int16(y),int16(x));
    if (depth == 0)
        continue;
    end
    x1(i) = x;
    y1(i) = y;
    d(i) = depth;
    plot(x1(i),y1(i),'r+')
    i = i + 1;
end
hold off;
    
figure(2);
imshow(uint8(image2));
hold on;
i = 1;
while (i <= number_points)
    [x,y] = ginput(1);
    x2(i) = x;
    y2(i) = y;
    plot(x2(i),y2(i),'r+')
    i = i + 1;
end
hold off;
%%
pixel1 = [x1'; y1'];
pixel1(3,:) = 1;
normalized_image1 = C1 \ pixel1;
nx1 = normalized_image1(1,:)';
ny1 = normalized_image1(2,:)';

pixel2 = [x2'; y2'];
pixel2(3,:) = 1;
normalized_image2 = C2 \ pixel2;
nx2 = normalized_image2(1,:)';
ny2 = normalized_image2(2,:)';

depth = depth /5000;



