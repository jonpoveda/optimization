function plot_phi(phi, I)
  % (Debug) plot the evolution of 'diff' across iterations
  %Plot the level sets surface
  subplot(1,2,1)
  %The level set function
  h=surfc(phi); %TODO 16: Line to complete
  % Note: to avoid black surface lines painting the whole surface (lots
  % of points), remove mesh
  set(h,'LineStyle','none')
  colormap(gca, 'jet');
  hold on
  %The zero level set over the surface
  contour(phi<=0, 'r--'); %TODO 17: Line to complete
  hold off
  title('Phi Function');

  %Plot the curve evolution over the image
  subplot(1,2,2)
  imagesc(I);
  colormap(gca, 'gray');
  hold on;
  contour(phi<=0, 'b-'); %TODO 18: Line to complete
  title('Image and zero level set of Phi')

  axis off;
  hold off
  drawnow;
  pause(.0001);
end