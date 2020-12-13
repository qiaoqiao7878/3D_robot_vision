function plot_state(mu, sigma, landmarks, timestep, z, window)
    % Visualizes the state of the EKF localization algorithm.
    %
    % The resulting plot displays the following information:
    % - landmark map g(black +'s)
    % - current robot pose estimate (red)
    % - visualization of the observations made at this time step (line between robot and landmark)

    figure(1);
    clf;
    hold on
    grid("on")
    L = struct2cell(landmarks); 
    drawprobellipse(mu(1:3), sigma(1:3,1:3), 0.6, 'r');
    plot(cell2mat(L(2,:)), cell2mat(L(3,:)), 'k+', 'markersize', 10, 'linewidth', 5);

    for(i=1:size(z,2))
        size(L,3)
        z(i).id
        mX = cell2mat(L(2,1,z(i).id));
        mY = cell2mat(L(3,1,z(i).id));
        line([mu(1), mX],[mu(2), mY], 'color', 'k', 'linewidth', 1);
        
        zX = z(i).range * cos(z(i).bearing);
        zY = z(i).range * sin(z(i).bearing);
        mX = cos(mu(3)) * zX - sin(mu(3)) * zY;
        mY = sin(mu(3)) * zX + cos(mu(3)) * zY;
        
        line([mu(1), mu(1) + mX],[mu(2), mu(2) + mY], 'color', 'r', 'linewidth', 1);
        
    end

    drawrobot(mu(1:3), 'r', 3, 0.3, 0.3);
    xlim([-2, 12])
    ylim([-2, 12])
    hold off

    if window
      f = figure(1);
      f.Visible = "on";
      drawnow;
      pause(0.1);
    else
      f = figure(1);
      f.Visible = "off";
      filename = sprintf('../plots/ekf_%03d.png', timestep);
      print(filename, '-dpng');
    end
end
