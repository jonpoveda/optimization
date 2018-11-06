function [c1, c2] = regionAverages(I, phi)
% Computes c1 and c2 as the region averages
% The regions are defined by thresholding phi at 0 (i.e.: zero-level set)

region_c1 = logical(phi >= 0);
region_c2 = logical(phi < 0);
c1 = sum(sum(I(region_c1))) / sum(region_c1(:)); % TODO 1: Line to complete
c2 = sum(sum(I(region_c2))) / sum(region_c2(:)); % TODO 2: Line to complete

end
