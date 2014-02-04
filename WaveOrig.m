
% Solve the 1-D wave equation with fixed values on the right
% and left, with given initial displacement of 0 down the length
% of the wire.


clear all
close all
clc

nFrames = 100;                % number of frames in the movie

c = 1;                        % set physical parameters
deltaT = 0.02;
deltaX = 0.02;
lamb = (c*deltaT/deltaX)^2;

xRight = 1;
x = linspace(0, xRight, (xRight/deltaX +1) );     % calculate x node locations
uInit = sin(x*2*pi);          % set temporal initial values


plot(x,uInit), xlabel('X axis'), ylabel('Y axis'),
               title('My title'), axis([0 xRight -2 2])
drawnow


uCur(1) = 0;                  % calculate the first time-step
uCur(length(x)) = 0;
for j = 2 : (length(x)-1)
    uCur(j) = ( lamb*uInit(j-1) + (2-2*lamb)*uInit(j) + lamb*uInit(j+1) ) / 2;
end
plot(x,uCur), xlabel('X axis'), ylabel('Y axis'),
              title('My title'), axis([0 xRight -2 2])
drawnow



uFut(1) = 0;                  % and the rest of the time steps...
uFut(length(x)) = 0;
for i = 2 : nFrames
    
      for j = 2 : (length(x)-1)
          uFut(j) = ( lamb*uCur(j-1) + (2-2*lamb)*uCur(j) + lamb*uCur(j+1) - uInit(j));
      end
      plot(x,uFut), xlabel('X axis'), ylabel('Y axis'),
                    title('My title'), axis([0 xRight -2 2])
      drawnow

      uInit = uCur;            % update u values
      uCur = uFut;
end

