function plot_dif(dif, nIter, iterMax)
  plot(nIter, dif, 'r.');
  hold on;
  xlim([1,iterMax]);
  ylim([0, 250]);
  xlabel('iter');
  ylabel('Diff');
  title('Difference across iterations (phi vs phi_0)');  
end