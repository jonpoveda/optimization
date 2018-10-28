
function [ result ] = DiBwd( I, hi )
% Compute the backward finite differences with respect to the
% i coordinate only for the 2:end rows. The first row is not replaced
    if (~exist('hi', 'var'))
        hi=1;
    end;

    result=I;
    
    result(2:end, :) = (I(2:end, :)-I(1:end-1, :))./hi; %result(2:end, :) =??
    
end
