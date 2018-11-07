function plot_phi(phi, I, iter, c1, c2)
% Plots the level sets surface & its contour (zero-level set), the curve
% evolution superimposed on the image & the actual segmentation.

  % Level sets surface
  subplot(2,2,1)
  h = surfc(phi);             % TODO 16: Line to complete
  zlim([-1,1]);               % Phi is normalized so it has values in [-1,1]
  set(h,'LineStyle','none')   % To avoid a black surface (too many lines)
  colormap(gca, 'jet');       % Set colourmap
  hold on;
  
  % The zero level set over the surface
  contour(phi<=0, 'r--');     % TODO 17: Line to complete
  hold off;
  title('Phi Function');

  % Plot the curve evolution over the image
  subplot(2,2,2)
  imshow(I);
  hold on;
  contour(phi<=0, 'b-');      % TODO 18: Line to complete
  str = sprintf('iter = %d', iter);
  title(str);
  hold off;

  % Plot original image for reference
  subplot(2,2,3)
  imshow(I);
  title('Original image');

  % Draw segmentation w. region averages as values (c1,c2)
  subplot(2,2,4)
  zero_levelSet = logical((phi >= 0));
  I_seg = double(zero_levelSet);
  I_seg(zero_levelSet) = c1;
  I_seg(~zero_levelSet) = c2;

  imshow(I_seg);
  title('Current segmentation');
  
  % Force update of figure and add tiny pause
  drawnow;
  pause(.0001);
end