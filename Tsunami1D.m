
% Solve the 1-D wave equation subject to
% a*u + b*(du/dx) = c on the right
% moving boundary condition on left
% -------------------------------------------

clear all
close all
clc

nFrames = 500;                % number of frames in the movie

c = 1;                        % set physical parameters
deltaT = 0.02;
deltaX = 0.02;
lamb = (c*deltaT/deltaX)^2;
alpha = 0;
beta = 1;
gamma = 0;

xRight = 4;                   % calculate x node locations
x = 0:deltaX:xRight;
n = length(x);


uInit = ones(1,n);            % set values for uInit, uCur and uFut
uCur  = uInit;
uFut  = uCur;

plot(x,uInit), xlabel('X axis'), ylabel('Y axis'),
               title('My title'), axis([0 xRight -1 1])
drawnow

[h,hx]=depth1D(x);

                             % set left spatial boundary value
                             
uCur(1) = leftBoundary(1, deltaT);
for i = 2 : n                 % calculate the first time-step
    
    if i == n
        if beta == 0
            uCur(n) = gamma/alpha;
        else
            phantom = rightBoundary(i, alpha, beta, gamma, deltaX, uInit);
            uCur(i) = ( lamb*hx(i)*(deltaX/2)*(-uInit(i-1)+phantom) + lamb*h(i)*(uInit(i-1)-2*uInit(i)+phantom) +2*uInit(i))/2;
        end
    else
        uCur(i) = ( lamb*hx(i)*(deltaX/2)*(-uInit(i-1)+uInit(i+1)) + lamb*h(i)*(uInit(i-1)-2*uInit(i)+uInit(i+1)) +2*uInit(i))/2;
    end
end

plot(x,uCur), xlabel('X axis'), ylabel('Y axis'),
              title('Variable Depth'), axis([0 xRight -1 2])
drawnow




                               % and the rest of the time steps...
for k = 2 : nFrames
      uFut(1) = leftBoundary(k, deltaT);
      for i = 2 : n
         
          if i == n
              if beta == 0
                  uFut(n) = gamma/alpha;
              else
                  phantom = rightBoundary(i, alpha, beta, gamma, deltaX, uCur);
                  uFut(i) = ( lamb*hx(i)*(deltaX/2)*(-uCur(i-1)+phantom) + lamb*h(i)*(uCur(i-1)-2*uCur(i)+phantom) +2*uCur(i) - uInit(i));
              end
          else
              uFut(i) = ( lamb*hx(i)*(deltaX/2)*(-uCur(i-1)+uCur(i+1)) + lamb*h(i)*(uCur(i-1)-2*uCur(i)+uCur(i+1)) +2*uCur(i) - uInit(i));
          end
      end
      plot(x,uFut), xlabel('X axis'), ylabel('Y axis'),
                    title('Variable Depth'), axis([0 xRight -1 2])
      drawnow

      uInit = uCur;            % update u values
      uCur  = uFut;
end

