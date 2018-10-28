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

% 'nu' is Area parameter
nu = 0;

% Sets parameters
epHeaviside = 1;
%eta = 0.01;
eta = 1;
tol = 0.1;
%dt = (10^-2) / p.mu;
dt = (10^-1) / p.mu;
iterMax = 100000;
%reIni = 0; %Try both of them
%reIni = 500;
reIni = 100;

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
