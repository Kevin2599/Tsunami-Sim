% Alexander Mitkus
% May 2, 2012
% This returns the necessary phantom value at the bottom boundary
% APPM 3050, Project 02

function phantom = bottomBoundary(i,j, alpha, beta, gamma, deltaX, u)
    phantom =  u(i-1,j);    
end