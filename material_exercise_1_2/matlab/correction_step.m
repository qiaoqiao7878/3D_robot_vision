function [mu, sigma] = correction_step(mu, sigma, z, landmarks)
% Updates the belief, i. e., mu and sigma after observing landmarks, according to the sensor model
% The employed sensor model measures the range and bearing of a landmark
% mu: 3 x 1 vector representing the state mean.
% The 3 components of mu correspond to the current estimate of the robot pose [x; y; theta]
% sigma: 3x3 is the covariance matrix
% z: struct array containing the landmark observations.
% landmarks: struct array containing the actual landmark positions. 
% Each observation z(i) has an id z(i).id, a range z(i).range, and a bearing z(i).bearing

% Number of measurements in this time step
m = size(z, 2);

% Z: vectorized form of all measurements made in this time step: [range_1; bearing_1; range_2; bearing_2; ...; range_m; bearing_m]
% ExpectedZ: vectorized form of all expected measurements in the same form.
% They are initialized here and should be filled out in the for loop below
Z = zeros(m*2, 1);
expectedZ = zeros(m*2, 1);

% Iterate over the measurements and compute the H matrix
% (stacked Jacobian blocks of the measurement function)
% H will be 2m x 3
H = [];

for i = 1:m
	% Get the id of the landmark corresponding to the i-th observation
	landmarkId = z(i).id;

	% TODO: Add the landmark measurement to the Z vector
    Z(i*2-1) = z(i).range;
	Z(i*2) = z(i).bearing;
	
	% TODO: Use the actual landmark position and the current estimate of
	% the robot pose
	% to compute the corresponding expected measurement in expectedZ:
    zX = landmarks(landmarkId).x - mu(1);
    zY = landmarks(landmarkId).y - mu(2);
    expectedZ(i*2-1) = sqrt(zX^2 + zY^2);
    expectedZ(i*2) = atan2( zY, zX ) - mu(3);
    

	% TODO: Compute the Jacobian Hi of the measurement function h for this observation
    Hi = [-zX/expectedZ(i*2-1),-zY/expectedZ(i*2-1),0;zY/(zX^2 + zY^2),-zX/(zX^2 + zY^2),-1];
    
	% Augment H with the new Hi
	H = [H;Hi];	
end

% TODO: Construct the sensor noise matrix Q
Q = 0.1*eye(2*m);

% TODO: Compute the Kalman gain
K = sigma * H' * inv( H * sigma * H' + Q );

% TODO: Compute the difference between the recorded and expected measurements.
% Remember to normalize the bearings after subtracting!
% (hint: use the normalize_all_bearings function available in tools)
z_innovation = normalize_all_bearings( Z - expectedZ );

% TODO: Finish the correction step by computing the new mu and sigma.
% Normalize theta in the robot pose.
mu = mu + K *(z_innovation);
sigma = (eye(3) - K * H) * sigma;

end
