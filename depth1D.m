function [h, hx] = depth1D(x)

%---------------------------------
% h is h(x) = depth function measured down from
% the equlibrium surface
%
% hx is dh/dx
%---------------------------------

%  h = 1;
%  hx = 0;
% 
% h=-.3*exp(-(x-10)^2);
% hx=.6*(x-10)*exp(-(x-10)^2);

% h = 1 - (x/4)*0.8;
% hx = -0.8/4;

h = .05*sin(x)+.5  ;
hx = .05*cos(x);

