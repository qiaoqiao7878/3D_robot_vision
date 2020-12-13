function [ Jac, residual ] = deriveResidualsNumeric( IRef, DRef, I, xi, K )

% TODO
[y,x] =size(IRef);
Jac = zeros(x * y ,6);
residual = calcResiduals( IRef, DRef, I, xi, K );
eps = 1e-6;
for i = 1:6
    twist_incre = [0 0 0 0 0 0]';
    twist_incre(i) = eps;
    xi1 = se3Log(se3Exp(twist_incre) * se3Exp(xi));
    residual1 = calcResiduals( IRef, DRef, I, xi1, K );
    Jac(:,i) = (residual1 - residual) ./ eps;
end
end

