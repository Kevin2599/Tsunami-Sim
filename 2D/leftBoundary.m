% Alexander Mitkus
% May 2, 2012
% This returns a single scalar value for left hand displacement
% APPM 3050, Project 02

function u = leftBoundary(t, deltaT)

if ( t < 0.5/deltaT)
    u = 1+0.3*sin(2*pi*t*deltaT);
else
    u = 1;
end