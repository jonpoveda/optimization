function [phi_0] = checkerboard(X, Y, f1, f2)
  % Checkerboard initialization (paper, equation 28)
  % [f1, f2] = [pi/5 pi/5];
  phi_0 = sin(f1 .* X) .* sin(f2 .* Y);
end
