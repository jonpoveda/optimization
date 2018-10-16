function [result] = colour_equalize(rgb_image)
  %COLOUR_EQUALIZE Equalizes the histogram of a colour RGB image by using
  % its intensity channel in a HSV space.
  %assert(class(rgb_image) == 'uint8')
  if ~isa(rgb_image, 'uint8')
    error('Input image is not a uint8 matrix')
  else
    hsv_image = rgb2hsv(rgb_image);

    % Equalizes intensity component
    H_eq = histeq(hsv_image(:,:,3));
    hsv_eq = hsv_image;
    hsv_eq(:,:,3) = H_eq;

    % Returns back to RGB
    result = hsv2rgb(hsv_eq);

    % Restores 8-bit per colour image
    result = uint8(result * 255);
  end
