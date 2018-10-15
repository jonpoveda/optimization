function [ result ] = G4_DjBwd( I, hj )
  % Compute the backward finite differences with respect to the
  % j coordinate only for the 2:end columns. The first column is not replaced
  if (~exist('hj', 'var'))
    hj = 1;
  end

  result = I;
  %Begin To Complete 11
  result(:, 2:end) = (I(:, 2:end) - I(:, 1:end-1)) ./ hj;
  %End To Complete 11
end
