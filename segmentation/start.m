%close all;
clearvars;
clc

% Examples (each image has diff 'good' parameter values)
% 'mu' is Lenght parameters
% Example 1
I = double(imread('circles.png'));
mu = 1;
%mu = 2;
%mu = 10;

% Example 2
%I = double(imread('noisedCircles.tif'));
%mu = 0.1;

% Example 3
%I = double(imread('zigzag_mask.png'));
%I = mean(I,3); %To 2D matrix

% Example 4
%I = double(imread('phantom17.bmp'));
%mu = 1;
%mu = 2;
%mu = 10;

% Example 5
%I = double(imread('phantom18.bmp'));
%mu = 0.2;
%mu = 0.5;

% Example 6
%I = double(imread('Image_to_Restore.png'));
%hola carola mu = 1
%lambda1 = 10^-3; %Hola carola problem
%lambda2 = 10^-3; %Hola carola problem
%phi_0 = I; %For the Hola carola problem

% Image normalization
I = mean(I,3);
I = I - min(I(:));
I = I / max(I(:));

[ni, nj] = size(I);

% 'nu' is Area parameter
nu = 0;

%%Parameters
lambda1 = 1;
lambda2 = 1;

epHeaviside = 1;
%eta = 0.01;
eta = 1
tol = 0.1;
%dt = (10^-2)/mu;
dt = (10^-1) / mu;
iterMax = 100000
%reIni = 0; %Try both of them
%reIni = 500;
reIni = 100;
[X, Y] = meshgrid(1:nj, 1:ni);

%%Initial phi
p.phi_0 = (-sqrt( (X - round(ni/2)) .^2 + (Y - round(nj/2) ) .^2) + 50);

%%% This initialization allows a faster convergence for phantom 18
%phi_0 = (-sqrt( ( X-round(ni/2)).^2 + (Y-round(nj/4)).^2)+50);
%Normalization of the initial phi to [-1 1]
%phi_0 = phi_0-min(phi_0(:));
%phi_0 = 2*phi_0/max(phi_0(:));
%phi_0 = phi_0-1;

phi_0 = phi_0 - min(phi_0(:));
phi_0 = 2 * phi_0 / max(phi_0(:));
phi_0 = phi_0 - 1;

%%Explicit Gradient Descent
seg = G4_ChanVeseIpol_GDExp(I, phi_0, mu, nu, eta, lambda1, lambda2, tol, epHeaviside, dt, iterMax, reIni);
