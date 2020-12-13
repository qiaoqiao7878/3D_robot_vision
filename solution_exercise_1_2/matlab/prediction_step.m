function [mu, sigma] = prediction_step(mu, sigma, u)
% Updates the belief concerning the robot pose according to the motion model,
% mu: 3 x 1 vector representing the state mean
% sigma: 3x3 covariance matrix
% u: odometry reading (r1, t, r2)
% Use u.r1, u.t, and u.r2 to access the rotation and translation values

% Compute the new mu based on the noise-free (odometry-based) motion model
% Remember to normalize theta after the update (hint: use the function normalize_angle available in tools)

mu_pred = mu + [ u.t * cos( mu(3) + u.r1 ); u.t * sin( mu(3) + u.r1 ); u.r1+u.r2 ];
mu_pred(3) = normalize_angle( mu_pred(3) );

% Compute the 3x3 Jacobian G of the motion model
G = eye(3) + [ 0, 0, u.t * -sin( mu(3) + u.r1 ); 0, 0, u.t * cos( mu(3) + u.r1 ); 0, 0, 0 ];


% Motion noise
motionNoise = 0.1;
R3 = [motionNoise, 0, 0; 
     0, motionNoise, 0; 
     0, 0, motionNoise/10];
R = zeros(size(sigma,1));
R(1:3,1:3) = R3;

% Compute the predicted sigma after incorporating the motion
sigma_pred = G * sigma * G' + R;

mu = mu_pred;
sigma = sigma_pred;

end
