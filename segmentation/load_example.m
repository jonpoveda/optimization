function [I, p] = load_example(number)
  % Load an example image and its chosen parameters.
  %
  % [I, p] = load_example(1..6) returns the image I and a parameter object
  %
  % Parameters:
  %   mu          : as Length weight
  %   nu          : as Area weight
  %   lambda1     : as Fidelity on region 1
  %   lambda2     : as Fidelity on region 2
  %   dt          : as Time step
  %   tol         : as convergence tolerance
  %   epHeaviside : as Heaviside regularization
  %   eta         : as Curvature regularization
  %   reIni       : as No reinitialization
  %   iterMax     : as Stop after a number of iterations

  % Sets parameters from Getreuer's paper
  p.mu = 0.2;
  p.nu = 0;
  p.lambda1 = 1;
  p.lambda2 = 1;
  p.dt = 0.5;
  p.tol = 10^-3;
  p.epHeaviside = 1;
  p.eta = 10^-8;
  p.iterMax = 6000;
  p.reIni = 0;

  % Sets default parameters from original implementation
  p.mu = 1;
  p.nu = 0;
  p.lambda1 = 1;
  p.lambda2 = 1;
  p.dt = 10^-1 / p.mu;
  p.tol = 10^-1;
  p.epHeaviside = 1;
  p.eta = 1;
  p.iterMax = 1000;
  p.reIni = 100;

  switch  number
  case 1
    I = double(imread('circles.png'));
    p.mu = 1;
    %mu = 2;
    %mu = 10;
  case 2
    I = double(imread('noisedCircles.tif'));
    [ni, nj] = size(I);
    [X, Y] = meshgrid(1:nj, 1:ni);

    p.mu = 0.3;
    p.phi_0 = centered_circle(X, Y, ni, nj);

  case 3
    I = double(imread('zigzag_mask.png'));
    I = mean(I,3); %To 2D matrix

  case 4
    I = double(imread('phantom17.bmp'));
    p.mu = 1;

  case 5
    I = double(imread('phantom18.bmp'));
    p.mu = 0.2;
    %p.mu = 0.5;

    %%% This initialization allows a faster convergence for phantom 18
    %p.phi_0 = (-sqrt( ( X-round(ni/2)).^2 + (Y-round(nj/4)).^2)+50);
    %Normalization of the initial phi to [-1 1]
    %p.phi_0 = phi_0-min(phi_0(:));
    %p.phi_0 = 2*phi_0/max(phi_0(:));
    %p.phi_0 = phi_0-1;

  case 6
    I = double(imread('Image_to_Restore.png'));
    p.mu = 1;
    p.lambda1 = 10^-3;
    p.lambda2 = 10^-3;
    p.phi_0 = I;
  end

  % Default initial phi (if not defined before)
  if ~isfield(p, 'phi_0')
    [ni, nj] = size(I);
    [X, Y] = meshgrid(1:nj, 1:ni);

    p.phi_0 = checkerboard(X, Y, pi/5, pi/5);     % From Getreuer's paper

    % Normalises phi_0 to [-1,1]
    p.phi_0 = p.phi_0 - min(p.phi_0(:));
    p.phi_0 = 2 * p.phi_0 / max(p.phi_0(:));
    p.phi_0 = p.phi_0 - 1;
  end
end
