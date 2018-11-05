close all;
clearvars;
clc

% Load example (each image has diff 'good' parameter values)
[I, p] = load_example(1);

% Normalise image
I = mean(I,3);
I = I - min(I(:));
I = I / max(I(:));

% Modifies parameters customly
% p.nu = 0;           % Area weight
% p.dt = 0.5;         % Time step
% p.tol = 10^-3;      % convergence tolerance
% p.epHeaviside = 1;  % Heaviside regularization
% p.eta = 10^-8;      % Curvature regularization
% p.iterMax = 6000;   % Max iterations (stopper)
% p.reIni = 500;

%% Runs Explicit Gradient Descent
seg = G4_ChanVeseIpol_GDExp(I, ...
  p.phi_0, p.mu, p.nu, p.eta, p.lambda1, p.lambda2, p.tol, ...
  p.epHeaviside, p.dt, p.iterMax, p.reIni);
