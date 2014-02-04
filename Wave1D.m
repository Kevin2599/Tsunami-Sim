
% Solve the 1-D wave equation subject to
% fixed boundary condition on right
% moving boundary condition on left
% -------------------------------------------

clear all
close all
clc

nFrames = 400;                % number of frames in the movie

c = 1;                        % set physical parameters
deltaT = 0.02;
deltaX = 0.02;
lamb = (c*deltaT/deltaX)^2;

xRight = 4;
x = linspace(0, xRight, (xRight/deltaX +1) );     % calculate x node locations
n = length(x);


uInit = zeros(1,n);       % set temporal initial values
plot(x,uInit), xlabel('X axis'), ylabel('Y axis'),
               title('My title'), axis([0 xRight -1 1])
drawnow



uCur(1) = 0;                  % set spatial boundary values
uCur(length(x)) = 0;
uCur(1) = leftBoundary(1, deltaT);
for j = 2 : (length(x)-1)                  % calculate the first time-step
    uCur(j) = ( lamb*uInit(j-1) + (2-2*lamb)*uInit(j) + lamb*uInit(j+1) ) / 2;
end
plot(x,uCur), xlabel('X axis'), ylabel('Y axis'),
              title('My title'), axis([0 xRight -1 1])
drawnow




uFut(1) = 0;
uFut(length(x)) = 0;
                               % and the rest of the time steps...
for k = 2 : nFrames
      uFut(1) = leftBoundary(k, deltaT);
      for j = 2 : (length(x)-1)
          uFut(j) = ( lamb*uCur(j-1) + (2-2*lamb)*uCur(j) + lamb*uCur(j+1) - uInit(j));
      end
      plot(x,uFut), xlabel('X axis'), ylabel('Y axis'),
                    title('My title'), axis([0 xRight -1 1])
      drawnow

      uInit = uCur;            % update u values
      uCur = uFut;
end

