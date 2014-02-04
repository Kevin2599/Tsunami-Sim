% Alexander Mitkus
% May 2, 2012
% This returns a single scalar value for right hand phantom
% APPM 3050, Project 02

function phantom = rightBoundary(i,j, alpha, beta, gamma, deltaX, u)
    phantom =  (2*deltaX/beta)*(gamma-alpha*u(i,j)) + u(i,j-1);    
end