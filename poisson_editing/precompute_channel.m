function [param] = precompute_channel(src, dst, mask_src, mask_dst, param)
  %TO DO: COMPLETE the ??
  % Fwd or backward gradient?
  % Uses forward diff for first order derivatives (gradient) [Recommended]
  srcGrad_i = G4_DiFwd(src, param.hi);
  srcGrad_j = G4_DjFwd(src, param.hj);
  dstGrad_i = G4_DiFwd(dst, param.hi);
  dstGrad_j = G4_DjFwd(dst, param.hj);
  dstGrad = sqrt(dstGrad_i .^ 2 + dstGrad_j .^ 2);

  if isequal(param.method, 'importing')
    % Pre-compute Laplacian (see eq(4) in the paper)
    laplacian_mask = [0 1 0; 1 -4 1; 0 1 0];
    lap = conv2(src, laplacian_mask, 'same');

  elseif isequal(param.method, 'mixing')
    % Get gradients mixing source and destination images
    % Having both the source and destination's image gradient
    % Use the one with bigger absolute value and approximate it with the
    % laplacian.

    % create mask for the first derivative
    grad_mask_x = [-1 1];
    grad_mask_y = [-1;1];

    % get the first derivative of the destination image
    g_x_target = conv2(dst, grad_mask_x, 'same');
    g_y_target = conv2(dst, grad_mask_y, 'same');
    g_mag_target = sqrt(g_x_target.^2 + g_y_target.^2);

    % get the first derivative of the source image
    g_x_source = conv2(src, grad_mask_x, 'same');
    g_y_source = conv2(src, grad_mask_y, 'same');
    g_mag_source = sqrt(g_x_source.^2 + g_y_source.^2);

    % convert to 1-D column vector (to do boolean operations below)
    g_mag_target = g_mag_target(:);
    g_mag_source = g_mag_source(:);

    % initialize the final (bigger) gradient with the source gradient
    g_x_final = g_x_source(:);
    g_y_final = g_y_source(:);

    % Retain the bigger gradient, source or destination
    g_x_final(abs(g_mag_target) > abs(g_mag_source)) =...
    g_x_target(g_mag_target > g_mag_source);
    g_y_final(abs(g_mag_target) > abs(g_mag_source)) =...
    g_y_target(g_mag_target > g_mag_source);

    % back to 2-D
    g_x_final = reshape(g_x_final, size(im_source,1), size(im_source,2));
    g_y_final = reshape(g_y_final, size(im_source,1), size(im_source,2));

    % Compute the laplacian of the combination of source and destination
    % (i.e. final)

    lap = conv2(g_x_final, grad_mask_x, 'same'); % in x-dir
    lap = lap + conv2(g_y_final, grad_mask_y, 'same'); % add in y-dir

  else
    error('A method needs to be defined. Expected `param.method`={importing, mixing}')
  end

  driving_on_src_lap = lap;
  driving_on_dst_lap = zeros(size(src(:,:,1)));
  driving_on_dst_lap(mask_dst(:)) = driving_on_src_lap(mask_src(:));

  param.driving_lap = driving_on_dst_lap;

  % Final gradient image: add vertical and horizontal gradients to
  % compute the magnitude. We have negative and positive values so we
  % need to use sqrt(a^2+b^2).
  % driving = sqrt(grad_i .^ 2 + grad_j .^ 2);
  %
  % % Additionally, as we are using a very small filter, the computer
  % % gradient will be very noisy and worse approximations of the gradient
  % % compared to Sobel or even Prewitt (which employ larger filters).
  % driving_on_dst = zeros(size(mask_dst));
  % driving_on_dst(mask_dst(:)) = driving(mask_src(:));
  %
  % grad = dstGrad;
  % driving = driving_on_dst;
end
