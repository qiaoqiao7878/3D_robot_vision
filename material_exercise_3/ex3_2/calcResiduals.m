function [ residuals ] = calcResiduals( IRef, DRef, I, xi, K )

% TODO
[ydim,xdim] =size(IRef);
T = se3Exp(xi);
R = T(1:3,1:3);
t = T(1:3,4);
xImg = zeros(size(IRef))-10;
yImg = zeros(size(IRef))-10;

for x = 1:xdim
    for y = 1:ydim
        pixel2d = [x - 1; y - 1; 1];
        point2d = K \ pixel2d;
        point3d = (point2d) * DRef(y,x);
        point3d_new = R * point3d + t;
        pixel2d_new = K * point3d_new;
        x_new = pixel2d_new(1);
        y_new = pixel2d_new(2);
        z_new = pixel2d_new(3);
        if(z_new > 0 && DRef(y,x) > 0 )
            xImg(y,x) = x_new/z_new + 1;
            yImg(y,x) = y_new/z_new + 1;
        end
    end
end

    
residuals = IRef - interp2(I, xImg,yImg);
figure(1);
imshow(residuals);
residuals = residuals(:);
end

