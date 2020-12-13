% ================
% function getpoints
function [x1,y1,x2,y2] = getpoints(image1,image2,nPoints)

x1 = zeros(nPoints,1);
y1 = zeros(nPoints,1);
x2 = zeros(nPoints,1);
y2 = zeros(nPoints,1);

% Click points in image1:
% Can be done without for-loop: ginput(nPoints)
figure; imshow(uint8(image1));
hold on;
for i = 1:nPoints
    [x,y] = ginput(1);
    x1(i) = double(x);
    y1(i) = double(y);
    plot(x, y, 'r+');
end
hold off;


% Click points in image2:
figure; imshow(uint8(image2));
hold on;
for i = 1:nPoints
    [x,y] = ginput(1);
    x2(i) = double(x);
    y2(i) = double(y);
    plot(x, y, 'r+');
end
hold off;

end