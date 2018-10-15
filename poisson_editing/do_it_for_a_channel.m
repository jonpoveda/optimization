function [grad, driving] = do_it_for_a_channel(src, dst, mask_src, mask_dst, param)
  %TO DO: COMPLETE the ??
  % Fwd or backward gradient?
  % Uses forward diff for first order derivatives (gradient) [Recommended]
  srcGrad_i = G4_DiFwd(src, param.hi);
  srcGrad_j = G4_DjFwd(src, param.hj);
  dstGrad_i = G4_DiFwd(dst, param.hi);
  dstGrad_j = G4_DjFwd(dst, param.hj);
  dstGrad = sqrt(dstGrad_i .^ 2 + dstGrad_j .^ 2);

  if isequal(param.method, 'importing')
    % Get gradients directly from source image
    grad_i = srcGrad_i;
    grad_j = srcGrad_j;
    
  elseif isequal(param.method, 'mixing')
    % Get gradients mixing source and destination images
    grad_i = (srcGrad_i + dstGrad_i) / 2;
    grad_j = (srcGrad_j + dstGrad_j) / 2;
    
  else
    error('A method needs to be defined. Expected `param.method`={importing, mixing}')
  end

  % Final gradient image: add vertical and horizontal gradients to
  % compute the magnitude. We have negative and positive values so we
  % need to use sqrt(a^2+b^2).
  driving = sqrt(grad_i .^ 2 + grad_j .^ 2);

  % Additionally, as we are using a very small filter, the computer
  % gradient will be very noisy and worse approximations of the gradient
  % compared to Sobel or even Prewitt (which employ larger filters).
  driving_on_dst = zeros(size(mask_dst));
  driving_on_dst(mask_dst(:)) = driving(mask_src(:));

  grad = dstGrad;
  driving = driving_on_dst;
end
