% Alexander Mitkus
% May 2, 2012
% This returns the depth and depth derivatives at a given point x,y
% Note that we have a couple depth functions to choose from by commenting
% APPM 3050, Project 02

function [h, hx, hy] = depth2D(x,y)

%---------------------------------
% h is h(x) = depth function measured down from
% the equlibrium surface
%
% hx is dh/dx
% hy is dh/dy
%---------------------------------

[w,z] = size(x);

% h = 1*ones(w,z);
% hx = 0*ones(w,z);
% hy = 0*ones(w,z);

% h = 1 - x.*(0.8/4);
% hx = -0.8/4*ones(w,z);
% hy = 0*ones(w,z);

% h =  1-.05*(x-4).^2;
% hx = -.1*(x-4);
% hy = 0*ones(w,z);

x0 = 1.5;
y0 = -1.5;
x1 = 3.5;
y1 = -1.5;
h = .1+.1*exp(-((x-x0).^2+(y-y0).^2))-.1*exp(-((x-x1).^2+(y-y1).^2));
hx = -.1*(2*(x-x0)).*exp(-((x-x0).^2+(y-y0).^2))-.1*(2*(x-x1)).*exp(-((x-x1).^2+(y-y1).^2));
hy = -.1*(2*(y-y0)).*exp(-((x-x0).^2+(y-y0).^2))-.1*(2*(y-y1)).*exp(-((x-x1).^2+(y-y1).^2));

end