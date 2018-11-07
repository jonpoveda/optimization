function [phi_0] = centered_circle(X, Y, ni, nj)
  % Default (circle centered around (ni/2, nj/2) with a radius sqrt(a))
  a = (ni+nj)/4;
  phi_0 = (-sqrt( (X - round(ni/2)) .^2 + (Y - round(nj/2)) .^2) + a);
end
