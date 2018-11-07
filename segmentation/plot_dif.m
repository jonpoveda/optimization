function plot_dif(dif, nIter, iterMax, maxdif)
  plot(nIter, dif, 'r.');
  hold on;
  xlim([1,iterMax]);
  ylim([0, maxdif]);
  xlabel('iter');
  ylabel('Diff');
  title('Difference across iterations (phi vs phi_0)');
  % Force update
  drawnow;
end