% Alexander Mitkus
% May 2, 2012
% This returns the necessary top phantom value
% APPM 3050, Project 02

function phantom = topBoundary(i,j, alpha, beta, gamma, deltaX, u)
    phantom =  u(i+1,j);    
end