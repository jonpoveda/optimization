%close all;
clearvars;
clc

% Load example (each image has diff 'good' parameter values)
[I, p] = load_example(1);

% Normalise image
I = mean(I,3);
I = I - min(I(:));
I = I / max(I(:));

[ni, nj] = size(I);

% Sets parameters from Getreuer's paper
nu = 0;           % Area weight
dt = 0.5;         % Time step
tol = 10^-3;      % convergence tolerance
epHeaviside = 1;  % Heaviside regularization
eta = 10^-8;      % Curvature regularization
reIni = 0;        % No reinitialization

% Sets parameters from given implementation
epHeaviside = 1;
eta = 1;            % 1 OR 0.01
tol = 0.1;
dt = (10^-1) / p.mu;  % (10^-1)/mu OR (10^-2)/mu;
iterMax = 100000;
reIni = 100;        % 0 OR 100 OR 500

% Modifies parameters customly
iterMax = 1000;   % Max iterations (stopper)

[X, Y] = meshgrid(1:nj, 1:ni);

% Initialise phi (if not defined yet)
if ~isfield(p, 'phi_0')
  p.phi_0 = (-sqrt( (X - round(ni/2)) .^2 + (Y - round(nj/2) ) .^2) + 50);

  p.phi_0 = p.phi_0 - min(p.phi_0(:));
  p.phi_0 = 2 * p.phi_0 / max(p.phi_0(:));
  p.phi_0 = p.phi_0 - 1;
end

%% Runs Explicit Gradient Descent
seg = G4_ChanVeseIpol_GDExp(I, p.phi_0, p.mu, nu, eta, p.lambda1, p.lambda2, tol, epHeaviside, dt, iterMax, reIni);
