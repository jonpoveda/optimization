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
p.iterMax = 500;
p.reIni = 0;
f1 = pi/5;
f2 = pi/5;

% Sets default parameters from original implementation
% p.mu = 1;
% p.nu = 0;
% p.lambda1 = 1;
% p.lambda2 = 1;
% p.dt = 10^-1 / p.mu;
% p.tol = 10^-1;
% p.epHeaviside = 1;
% p.eta = 1;
% p.iterMax = 1000;
% p.reIni = 100;

switch number
  case 1
    I = double(imread('circles.png'));
    p.mu = 1;
    p.iterMax = 500;

  case 2
    I = double(imread('noisedCircles.tif'));
    p.mu = 0.2;
    p.reIni = 0; %100;
    p.iterMax = 6000;

  case 3
    I = double(imread('zigzag_mask.png'));
    I = mean(I,3); %To 2D matrix

  case 4
    I = double(imread('phantom17.bmp'));
    I = rgb2gray(I);
    p.mu = 0.25;

  case 5
    I = double(imread('phantom18.bmp'));
    p.mu = 0.1;
    p.iterMax = 1000;
    %p.nu = -0.1;
    %p.reIni = 100;

    % TODO:
    % Try checkerboard and compare speed & quality of segmentation
    % Try centered circle but centered at (ni/2, nj/2) & r > sqrt(50)
    % This initialization allows a faster convergence for phantom 18
    %p.phi_0 = (-sqrt( ( X-round(ni/2)).^2 + (Y-round(nj/4)).^2)+50);
    % Normalization of the initial phi to [-1 1]
    %p.phi_0 = p.phi_0-min(p.phi_0(:));
    %p.phi_0 = 2*p.phi_0/max(p.phi_0(:));
    %p.phi_0 = p.phi_0-1;

  case 6
    I = double(imread('phantom19.bmp'));
    p.mu = 1;
    p.iterMax = 1000;
    %p.reIni = 100;  
    
  case 7
    I = double(imread('Image_to_Restore.png'));
    I = mean(I,3);
    p.mu = 0.75;
    p.lambda1 = 1; %10^-3;
    p.lambda2 = 1; %10^-3;
    p.phi_0 = I; % Also test of using only the red channel(?)

  case 8
    I = double(imread('wrench.png'));
    p.mu = 0.1;
    p.iterMax = 2000;

  % TODO: tweak parameters for new cases 8-18
  case 9
    I = double(imread('europe_lights.png'));

  case 10
    I = double(imread('moon.png')); % Try centered-circle init on this!

  case 11
    I = double(imread('bears.jpg'));

  case 12
    I = double(imread('beavers.jpg'));

  case 13
    I = double(imread('church.jpg'));

  case 14
    I = double(imread('penguin.jpg'));

  % NOTE: from here downwards, colour images (good to check if
  % generalization to RGB works). For now, just average channels.
  case 15
    I = double(imread('koala_colour.jpg'));

  case 16
    I = double(imread('snake_colour.jpg'));

  case 17
    I = double(imread('windsurf_colour.jpg'));

  case 18
    I = double(imread('zebras_colour.jpg'));
    [ni, nj, ~] = size(I); % ommit third dimension to work with rgb
    [X, Y] = meshgrid(0:nj-1, 0:ni-1);
    p.phi_0 = centered_circle(X, Y, nj, ni);     % From Getreuer's paper
    p.mu = 0.04;           % Length weight
    p.iterMax = 4000;   % Max iterations (stopper)
    p.reIni = 100;

  case 19
    I = double(imread('crystal_pyramid_colour.jpg'));
    
  case 20
    I = double(imread('moon_bw.jpg'));
    p.mu = 1;
    p.iterMax=2000;
    [ni, nj] = size(I);
    %[X, Y] = meshgrid(1:nj, 1:ni);
    [X, Y] = meshgrid(0:nj-1, 0:ni-1);
    
    %%% This initialization allows a faster convergence for phantom 18
    p.phi_0 = (-sqrt( ( X-round(nj/2)).^2 + (Y-round(ni/2)).^2) + ni);
    % Normalization of the initial phi to [-1 1]
    p.phi_0 = p.phi_0 - min(p.phi_0(:));
    p.phi_0 = 2 * p.phi_0 / max(p.phi_0(:));
    p.phi_0 = p.phi_0-1;
    
  case 21
    I = double(imread('satellite_spaceJunk.jpg'));
    %p.mu = 0.18;
end

% Default initial phi (if not defined before)
if ~isfield(p, 'phi_0')
  [ni, nj, ~] = size(I); % ommit third dimension to work with rgb
  [X, Y] = meshgrid(0:nj-1, 0:ni-1);

  p.phi_0 = checkerboard(X, Y, f1, f2);     % From Getreuer's paper

  % Normalises phi_0 to [-1,1]
  p.phi_0 = p.phi_0 - min(p.phi_0(:));
  p.phi_0 = 2 * p.phi_0 / max(p.phi_0(:));
  p.phi_0 = p.phi_0 - 1;
end
end
