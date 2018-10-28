function y = G4_diracReg( x, epsilon )
  %  Dirac function of x
  %    G4_diracReg( x, epsilon ) Computes the derivative of the heaviside
  %    function of x with respect to x. Regularized based on epsilon.

  y = epsilon ./ (pi * ( epsilon^2 + x.^ 2)); %TODO 19: Line to complete

end
