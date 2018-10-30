function [phi_0] = centered_circle(X, Y, ni, nj)
  % Default (circle centered around (ni/2, nj/2) with a radius sqrt(50))
  phi_0 = (-sqrt( (X - round(ni/2)) .^2 + (Y - round(nj/2) ) .^2) + 50);
end
