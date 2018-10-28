function [I, p] = load_example(number)
  % Load an example image and its chosen parameters.
  %
  % [I, p] = load_example(1..6) returns the image I and a parameter object
  %
  % Parameters:
  %   mu      : as Lenght parameter
  %   lambda1 : as fidelity parameter
  %   lambda2 : as fidelity parameter
  %   phi_0   : as initial Phi parameter

  % Default parameter
  p.mu = 1;
  p.lambda1 = 1;
  p.lambda2 = 1;

  switch  number
  case 1
    I = double(imread('circles.png'));
    p.mu = 1;
    %mu = 2;
    %mu = 10;
  case 2
    I = double(imread('noisedCircles.tif'));
    p.mu = 0.1;
  case 3
    I = double(imread('zigzag_mask.png'));
    I = mean(I,3); %To 2D matrix
  case 4
    I = double(imread('phantom17.bmp'));
    p.mu = 1;
    %p.mu = 2;
    %p.mu = 10;
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

end
