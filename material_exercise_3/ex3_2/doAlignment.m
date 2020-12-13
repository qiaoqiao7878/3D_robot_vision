clear all; close all;
% first pair of input frames
K = [517.3 0 318.6;	0 516.5 255.3; 0 0 1];
c2 = double(imreadbw('rgb/1305031102.175304.png'));
c1 = double(imreadbw('rgb/1305031102.275326.png'));
d2 = double(imread('depth/1305031102.160407.png'))/5000;
d1 = double(imread('depth/1305031102.262886.png'))/5000;
% result:
% approximately  -0.0018    0.0065    0.0369   -0.0287   -0.0184   -0.0004

% second pair of input frames
%K = [ 535.4  0 320.1;	0 539.2 247.6; 0 0 1];
%c1 = double(imreadbw('rgb/1341847980.722988.png'));
%c2 = double(imreadbw('rgb/1341847982.998783.png'));
%d1 = double(imread('depth/1341847980.723020.png'))/5000;
%d2 = double(imread('depth/1341847982.998830.png'))/5000;
% result:
% approximately  0.2979   -0.0106    0.0452   -0.0041   -0.0993   -0.0421


% initialization
xi = [0 0 0 0 0 0]';

% pyramid levels
for lvl = 5:-1:1
    lvl
    
    % get downscaled image, depth image, and K-matrix of down-scaled image.
    [IRef, DRef, Klvl] = downscale(c1,d1,K,lvl);
    [I, D] = downscale(c2,d2,K,lvl);
    
    % just do at most 20 steps.
    errLast = 1e10;
    for i=1:20
        
        % calculate Jacobian of residual function (Matrix of dim (width*height) x 6)
        [Jac, residual] = deriveResidualsNumeric(IRef,DRef,I,xi,Klvl);   % ENABLE ME FOR NUMERIC DERIVATIVES
        %[Jac, residual] = deriveResidualsAnalytic(IRef,DRef,I,xi,Klvl);   % ENABLE ME FOR ANALYTIC DERIVATIVES
        axis equal
        
        % set rows with NaN to 0 (e.g. because out-of-bounds or invalid depth).
        notValid = isnan(sum(Jac,2));
        residual(notValid,:) = 0;
        Jac(notValid,:) = 0;

        % do Gauss-Newton step
        % TODO
        xi_theta = -(Jac' * Jac)^(-1) * (Jac' * residual)
        xi = se3Log(se3Exp(xi_theta) * se3Exp(xi))
        
        % get mean and display
        err = mean(residual .* residual)
        
        % stop condition
        % TODO
        if ((err / errLast) >0.995)
            break;
        end
        errLast = err;
    end
end

