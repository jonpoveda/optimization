function [ result ] = G4_DjFwd( I, hj )
  % Compute the Forward finite differences with respect to the
  % j coordinate only for the 1:end-1 columns. The last column is not replaced
  if (~exist('hj', 'var'))
    hj = 1;
  end

  result = I;
  %Begin To Complete 9
  result(:, 1:end-1) = (I(:, 2:end)-I(:, 1:end-1)) ./ hj;
  %End To Complete 9
end
