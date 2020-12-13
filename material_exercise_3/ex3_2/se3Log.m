function [ twist ] = se3Log( T )
% TODO
t = T(1:3,4);
R = T(1:3,1:3);
I = [1 0 0; 0 1 0; 0 0 1];
w_norm = acos((trace(R) - 1) / 2);
if abs(w_norm) > 1e-6
    w = w_norm / (2 * sin(w_norm)) * [R(3,2)-R(2,3);R(1,3)-R(3,1);R(2,1)-R(1,2)];
    w_theta = [0, -w(3), w(2);w(3), 0 , -w(1); -w(2),w(1),0];
    J_inv = I - 1 / 2 * w_theta + (1/(w_norm)^2 - (1 + cos(w_norm))/(2 * w_norm * sin(w_norm))) * w_theta * w_theta;
    v = J_inv * t;
else
    w = [0;0;0];
    v = t;
end
twist = [w;v];
end

