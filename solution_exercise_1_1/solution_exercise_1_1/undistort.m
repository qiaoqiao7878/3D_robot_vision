function yt = undistort(yd, k1, k2)
    if (size(yd, 1) == 1)
        yd = yd';
    end
    
    yt = yd;
    yt_prev = [Inf; Inf];
    threshold = 1.0e-06;
    
    while(norm(yt - yt_prev) >= threshold)
        r = norm(yt);
        rd = 1 + k1 * r^2 + k2 * r^4;
        yt_prev = yt;
        yt = yd / rd;
    end
    
end