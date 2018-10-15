function [ result ] = DiFwd( I, hi )
  % Compute the Forward finite differences with respect to the
  % i coordinate only for the 1:end-1 rows. The last row is not replaced

  if (~exist('hi', 'var'))
    hi=1;
  end;

  result = I;
  %Begin To Complete 8
  result(1:end-1, :) = (I(2:end, :)-I(1:end-1, :))./hi; %result(1:end-1, :)=??
  %End To Complete 8
end
