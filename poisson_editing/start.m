clearvars;
addpath('../inpainting')

dst = double(imread('lena.png'));
src = double(imread('girl.png')); % flipped girl, because of the eyes
[ni,nj, nChannels]=size(dst);

param.hi=1;
param.hj=1;

% Seamless cloning with importing gradients or mixing gradients (optional)
param.method = 'importing';
% param.method = 'mixing';

% ---- Mask(s) ----
% Masks to exchange: Eyes
mask_src_eyes=logical(imread('mask_src_eyes.png'));
mask_dst_eyes=logical(imread('mask_dst_eyes.png'));

% masks to exchange: Mouth
mask_src_mouth=logical(imread('mask_src_mouth.png'));
mask_dst_mouth=logical(imread('mask_dst_mouth.png'));

% Placeholder for the result
result = zeros(size(src));

% Loop 1: mask 1 => eyes
for nC = 1: nChannels
  % Pre-compute auxiliar variables (gradients, laplacian, etc.)
  param = precompute_auxiliar(src(:,:,nC), dst(:,:,nC), mask_src_eyes,...
  mask_dst_eyes, param);

  % Solve Poisson equation for the eyes
  result(:,:,nC) = G4_Poisson_Equation_Axb(dst(:,:,nC), mask_dst_eyes, param);
end

% Loop 2: mask 2 => mouth
for nC = 1: nChannels
  % Pre-compute auxiliar variables (gradients, laplacian, etc.)
  param = precompute_auxiliar(src(:,:,nC), dst(:,:,nC), mask_src_mouth,...
  mask_dst_mouth, param);

  % Solve Poisson equation for the eyes
  result(:,:,nC) = G4_Poisson_Equation_Axb(result(:,:,nC), mask_dst_mouth, param);
end

% Plot final figure
figure, imshow(result/256, [])
