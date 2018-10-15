clearvars;
addpath('../inpainting')
dst = double(imread('lena.png'));
src = double(imread('girl.png')); % flipped girl, because of the eyes

[ni,nj, nChannels] = size(dst);

param.hi = 1;
param.hj = 1;

% Seamless cloning with importing gradients or mixing gradients
param.method = 'importing';
% param.method = 'mixing';

% Combine all masks in one
mask_src = logical(imread('mask_src_eyes.png')) | ...
  logical(imread('mask_src_mouth.png'));
mask_dst = logical(imread('mask_dst_eyes.png')) | ...
  logical(imread('mask_dst_mouth.png'));

result = zeros(size(dst));
for nC = 1: nChannels
  param = precompute_channel(src(:,:,nC), dst(:,:,nC), mask_src,...
  mask_dst, param);

  result(:,:,nC) = G4_Poisson_Equation_Axb(dst(:,:,nC), mask_dst, param);
end

figure(2), imshow(result/256, [])
