function [smoothed] = smooth(image, coef)
  smoothed = double(imgaussfilt(image, coef));
  smoothed = smoothed - mean(smoothed(:));
end
