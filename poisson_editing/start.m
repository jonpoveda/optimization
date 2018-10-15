clearvars;
dst = double(imread('lena.png'));
src = double(imread('girl.png')); % flipped girl, because of the eyes
[ni,nj, nChannels]=size(dst);

param.hi=1;
param.hj=1;


%masks to exchange: Eyes
mask_src=logical(imread('mask_src_eyes.png'));
mask_dst=logical(imread('mask_dst_eyes.png'));

for nC = 1: nChannels

  %TO DO: COMPLETE the ??
  % Fwd or backward gradient?
  % The professor recommended for first order (gradient) to use forward
  % differences so==>
  drivingGrad_i = G4_DiFwd(src(:,:,nC), param.hi);
  drivingGrad_j = G4_DjFwd(src(:,:,nC), param.hj);

  % Final gradient image: add vertical and horizontal gradients to
  % compute the magnitude. We have negative and positive values so we
  % need to use sqrt(a^2+b^2).
  % Additionally, as we are using a very small filter, the computer
  % gradient will be very noisy and worse approximations of the gradient
  % compared to Sobel or even Prewitt (which employ larger filters).
  driving_on_src = sqrt(drivingGrad_i.^2 + drivingGrad_j.^2);

  driving_on_dst = zeros(size(src(:,:,1)));
  driving_on_dst(mask_dst(:)) = driving_on_src(mask_src(:));

  param.driving = driving_on_dst;

  dst1(:,:,nC) = G4_Poisson_Equation_Axb(dst(:,:,nC), mask_dst, param);
end

%Mouth
%masks to exchange: Mouth
mask_src=logical(imread('mask_src_mouth.png'));
mask_dst=logical(imread('mask_dst_mouth.png'));
for nC = 1: nChannels
  % Same as above
  % No need to recompute the image's gradient (not true because the values
  % for each channel are stored in temporal variables (drivingGrad_i,...)
  % which get overwritten on the following iteration...
  % We could refactor the code to avoid computing the gradient twice (but
  % may not be significant in execution time anyway).

  %  (only if we change the code): Simply, different indices
  % (different masks) are used so different locations of driving_on_dst
  % will be filled with driving_on_src values computed above
  % Right (??) Double-check just in case!

  drivingGrad_i = G4_DiFwd(src(:,:,nC), param.hi);
  drivingGrad_j = G4_DjFwd(src(:,:,nC), param.hj);

  driving_on_src = sqrt(drivingGrad_i.^2 + drivingGrad_j.^2);

  driving_on_dst = zeros(size(src(:,:,1)));
  driving_on_dst(mask_dst(:)) = driving_on_src(mask_src(:));

  param.driving = driving_on_dst;

  dst1(:,:,nC) = G4_Poisson_Equation_Axb(dst1(:,:,nC), mask_dst, param);
end

imshow(dst1/256)
