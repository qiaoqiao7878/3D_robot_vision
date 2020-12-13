function [ T ] = se3Exp( twist )

% TODO
w = twist(1:3);
w_norm = norm(w);

v = twist(4:6);
w_theta = [0, -w(3), w(2);w(3), 0 , -w(1); -w(2),w(1),0];
I = [1 0 0; 0 1 0; 0 0 1];
if abs(w_norm) > 1e-6
    exp_w_theta = I + sin(w_norm)/w_norm * w_theta + (1 - cos(w_norm))/(w_norm^2) * w_theta * w_theta;
    J = I + (1 - cos(w_norm))/(w_norm^2)  * w_theta + (w_norm - sin(w_norm))/(w_norm^3) * w_theta * w_theta;
else
    exp_w_theta = I;
    J = I;
end

T = [exp_w_theta ,J * v;0,0,0,1];

end

