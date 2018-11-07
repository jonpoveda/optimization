function [smoothed] = smooth(image)
  smoothed = double(imgaussfilt(image, 2)) - 127;
end