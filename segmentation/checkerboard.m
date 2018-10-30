function [phi_0] = checkerboard(X, Y)
  % Checkerboard initialization (paper, equation 28)
  phi_0 = sin((pi/5) .* X) .* sin((pi/5) .* Y);
end
