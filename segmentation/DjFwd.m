
function [ result ] = DjFwd( I, hj )
% Compute the Forward finite differences with respect to the
% j coordinate only for the 1:end-1 columns. The last column is not replaced

    if (~exist('hj', 'var'))
        hj=1;
    end;
 
    result = I;
    
    result(:, 1:end-1) = (I(:, 2:end)-I(:, 1:end-1))./hj; 
    

end
