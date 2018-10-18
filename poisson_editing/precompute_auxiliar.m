function [param] = precompute_auxiliar(src, dst, mask_src, mask_dst, param)
  if isequal(param.method, 'mixing2')  % mixing gradients
    % Create the gradient mask for the first derivative
    grad_mask_x = [-1 0 1]';
    grad_mask_y = [-1 0 1];

    % Get the first derivative of the destination image
    g_x_dst = conv2(dst, grad_mask_x, 'same');
    g_y_dst = conv2(dst, grad_mask_y, 'same');
    g_mag_dst = sqrt(g_x_dst.^2 + g_y_dst.^2);

    % Get the first derivative of the source image
    g_x_source = conv2(src, grad_mask_x, 'same');
    g_y_source = conv2(src, grad_mask_y, 'same');
    g_mag_source = sqrt(g_x_source.^2 + g_y_source.^2);

    f_greater_g = abs(g_mag_dst) > abs(g_mag_source);
    f_lower_g = abs(g_mag_dst) <= abs(g_mag_source);

    max_grad_x(f_greater_g) = g_x_dst(f_greater_g);
    max_grad_y(f_greater_g) = g_y_dst(f_greater_g);
    max_grad_x(f_lower_g) = g_x_source(f_lower_g);
    max_grad_y(f_lower_g) = g_y_source(f_lower_g);

    lap_x = conv2(max_grad_x, grad_mask_x, 'same');
    lap_y = conv2(max_grad_y, grad_mask_y, 'same');
    %   lap = sqrt(max_mag_x .^ 2 + max_mag_y .^ 2);
    %   lap = abs(max_mag_x) + abs(max_mag_y);
    lap = lap_x + lap_y;

  elseif isequal(param.method, 'mixing')  % mixing gradients
    % Create the gradient mask for the first derivative
    grad_mask_x = [-1 1]';
    grad_mask_y = [-1 1];

    % Get the first derivative of the destination image
    g_x_dst = conv2(dst, grad_mask_x, 'same');
    g_y_dst = conv2(dst, grad_mask_y, 'same');
    g_mag_dst = sqrt(g_x_dst.^2 + g_y_dst.^2);

    % Get the first derivative of the source image
    g_x_source = conv2(src, grad_mask_x, 'same');
    g_y_source = conv2(src, grad_mask_y, 'same');
    %g_x_source = del2(dst, 1);
    %g_y_source = del2(dst, 1);
    g_mag_source = sqrt(g_x_source.^2 + g_y_source.^2);

    % Convert to 1-D (for boolean operation below)
    g_mag_dst = g_mag_dst(:);
    g_mag_source = g_mag_source(:);

    % Initialize the final gradient with the source gradient
    g_x_final = g_x_source(:);
    g_y_final = g_y_source(:);

    % Keep the bigger gradient for each location i,j in the image
    g_x_final(abs(g_mag_dst) > abs(g_mag_source)) =...
    g_x_dst(g_mag_dst > g_mag_source);
    g_y_final(abs(g_mag_dst) > abs(g_mag_source)) =...
    g_y_dst(g_mag_dst > g_mag_source);

    % Convert back to 2D (image dimensions)
    g_x_final = reshape(g_x_final, size(src,1),size(src,2));
    g_y_final = reshape(g_y_final, size(src,1),size(src,2));

    % Compute the laplacian of the combination of greater gradients
    lap = conv2(g_x_final, grad_mask_x, 'same');
    lap = lap + conv2(g_y_final, grad_mask_y, 'same');

  elseif isequal(param.method, 'importing')
    % OLD CODE
    %     drivingGrad_i = G4_DiFwd(src(:,:,nC), param.hi);
    %     drivingGrad_j = G4_DjFwd(src(:,:,nC), param.hj);
    %     driving_on_src = sqrt(drivingGrad_i.^2 + drivingGrad_j.^2);

    % Create the laplacian of the source image
    laplacian_mask = [
    0  1  0;
    1 -4  1;
    0  1  0
    ];
    lap = conv2(src, laplacian_mask, 'same');

  elseif isequal(param.method, 'importing_diag')
    % Create the laplacian of the source image including diagonals
    laplacian_mask = [
    0.25, 0.50, 0.25;
    0.40, -3.0, 0.50;
    0.25, 0.50, 0.25
    ];
    lap = conv2(src, laplacian_mask, 'same');

  else
    error('A method needs to be defined. Expected `param.method`={importing, mixing}')
  end

  driving_on_src_lap = lap;
  driving_on_dst_lap = zeros(size(src(:,:,1)));
  driving_on_dst_lap(mask_dst(:)) = driving_on_src_lap(mask_src(:));
  param.lap = driving_on_dst_lap;
