function [ result ] = DjBwd( I, hj )
% Compute the backward finite differences with respect to the
% j coordinate only for the 2:end columns. The first column is not replaced

    if (~exist('hj', 'var'))
        hj=1;
    end;

    result=I;
    
    result(:, 2:end) = (I(:, 2:end)-I(:, 1:end-1))./hj; %result(:, 2:end)
    
end

