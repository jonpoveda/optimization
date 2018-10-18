clearvars;

% Sets parameters
% Seamless cloning with importing gradients or mixing gradients (optional)
%param.method = 'importing';
param.method = 'mixing';

% Sets gradient normalization
param.hi=1;
param.hj=1;

% Does equalization
equalize = false;

% Pick images and masks (choose one example)
% Example 1
% src_path = 'girl.png';  % flipped girl, because of the eyes
% dst_path = 'lena.png';
% src_mask_path = 'mask_src_eyes.png';
% dst_mask_path = 'mask_dst_eyes.png';
% src2_mask_path = 'mask_src_mouth.png';
% dst2_mask_path = 'mask_dst_mouth.png';

% Example 2
% src_path = 'stamps.png';
% dst_path = 'passport.png';
% src_mask_path = 'mask_src_stamp.png';
% dst_mask_path = 'mask_dst_stamp.png';

% Example 3
% src_path = 'forest_moon.jpg';
% dst_path = 'mountain_reflection.jpg';
% src_mask_path = 'mask_src_forest_moon.png';
% dst_mask_path = 'mask_dst_mountains_reflection.png';

% Example 4
src_path = 'children.jpg';
dst_path = 'book_def.jpg';
src_mask_path = 'mask_src_children.png';
dst_mask_path = 'mask_dst_book.png';

% Loads images
dst = double(imread(dst_path));
src = double(imread(src_path));
[ni,nj, nChannels]=size(dst);

if equalize
  dst = colour_equalize(uint8(dst));
  src = colour_equalize(uint8(src));
end

% Placeholder for the result
result = zeros(size(dst));

% Loads masks to exchange
mask_src=logical(imread(src_mask_path));
mask_dst=logical(imread(dst_mask_path));

for nC = 1: nChannels
  % Pre-compute auxiliar variables (gradients, laplacian, etc.)
  param = precompute_auxiliar(src(:,:,nC), dst(:,:,nC), mask_src,...
  mask_dst, param);

  % Solve Poisson equation for the eyes
  result(:,:,nC) = G4_Poisson_Equation_Axb(dst(:,:,nC), mask_dst, param);
end

if exist('src2_mask_path', 'var') && exist('dst2_mask_path', 'var')
  % Loads masks to exchange
  mask2_src=logical(imread(src2_mask_path));
  mask2_dst=logical(imread(dst2_mask_path));

  for nC = 1: nChannels
    % Pre-compute auxiliar variables (gradients, laplacian, etc.)
    param = precompute_auxiliar(src(:,:,nC), dst(:,:,nC), mask2_src,...
    mask2_dst, param);

    % Solve Poisson equation for the eyes
    result(:,:,nC) = G4_Poisson_Equation_Axb(result(:,:,nC), mask2_dst, param);
  end
end

% Scale linearly the range to ensure valid values
result = uint8(result / max(result(:)) * 255);

% Plot final figure
figure, imshow(result), title(param.method)
