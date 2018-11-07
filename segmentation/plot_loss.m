function plot_loss(loss, nIter, iterMax, maxdif)
  plot(nIter, loss, 'r.');
  hold on;
  xlim([1,iterMax]);
  ylim([0, maxdif]);
  xlabel('iter');
  ylabel('loss');
  title('Loss across iterations');
  % Force update
  drawnow;
end
