
clear all
close all
clc

nFrames = 400;                % number of frames in the movie

c = 1;                        % set physical parameters
deltaT = 0.02;
deltaX = 0.02;
lamb = (c*deltaT/deltaX)^2;
alpha = 0;
beta = 1;
gamma = 0;

xRight = 4;                   % calculate x node locations
x = linspace(0, xRight, (xRight/deltaX +1) );
y = linspace(0, xRight, (xRight/deltaX +1) );
n = length(x);


uInit = zeros(n,n);            % set values for uInit, uCur and uFut
uCur  = uInit;
uFut  = uCur;

                             % set left spatial boundary value
uCur(:,1) = leftBoundary(1, deltaT);
for i = 1 : n                 % calculate the first time-step
    for j = 2 : n
        if i == n && j~=n
            phantom = bottomBoundary(i,j,alpha,beta,gamma,deltaX,uInit);
            uCur(i,j) = ( lamb*uInit(i-1,j) + (2-4*lamb)*uInit(i,j) + lamb*uInit(i,j-1)+ lamb*uInit(i,j+1) + lamb*phantom ) / 2;
        elseif i == 1 && j~=n
            phantom = topBoundary(i,j,alpha,beta,gamma,deltaX,uInit);
            uCur(i,j) = ( lamb*phantom + (2-4*lamb)*uInit(i,j) + lamb*uInit(i,j-1)+ lamb*uInit(i,j+1) + lamb*uInit(i+1,j) ) / 2;
        elseif j == n && i == n
            uCur(i,j) = lamb*((2*uInit(i-1,j)-4*uInit(i,j)+2*uInit(i,j-1))+2*uInit(i,j))/2;
        elseif i == 1 && j == n
            uCur(i,j) = lamb*((2*uInit(i+1,j)-4*uInit(i,j)+2*uInit(i,j-1))+2*uInit(i,j))/2;
        elseif j == n && i ~=n 
            phantom = rightBoundary(i,j,alpha,beta,gamma,deltaX,uInit);
            uCur(i,j) = ( lamb*uInit(i-1,j) + (2-4*lamb)*uInit(i,j) + lamb*uInit(i,j-1)+ lamb*phantom + lamb*uInit(i+1,j) ) / 2;
        else
            uCur(i,j) = ( lamb*uInit(i-1,j) + (2-4*lamb)*uInit(i,j) + lamb*uInit(i,j-1)+ lamb*uInit(i,j+1) + lamb*uInit(i+1,j) ) / 2;
        end
    end
end

surf(x,y,uCur)
camlight left; lighting phong, xlabel('X axis'), ylabel('Y axis'),
                    title('Uniform Depth 2D')
                    colormap cool
      drawnow



                               % and the rest of the time steps...
for k = 2 : nFrames
      uFut(:,1) = leftBoundary(k, deltaT);
      for i = 1 : n
           for j = 2 : n
               if i == n && j~=n
                    phantom = bottomBoundary(i,j,alpha,beta,gamma,deltaX,uCur);
                    uFut(i,j) = ( lamb*uCur(i-1,j) + (2-4*lamb)*uCur(i,j) + lamb*uCur(i,j-1)+ lamb*uCur(i,j+1) + lamb*phantom ) - uInit(i,j);
                elseif i == 1 && j~=n
                    phantom = topBoundary(i,j,alpha,beta,gamma,deltaX,uCur);
                    uFut(i,j) = ( lamb*phantom + (2-4*lamb)*uCur(i,j) + lamb*uCur(i,j-1)+ lamb*uCur(i,j+1) + lamb*uCur(i+1,j) ) - uInit(i,j);
                elseif j == n && i == n
                    uFut(i,j) = lamb*((2*uCur(i-1,j)-4*uCur(i,j)+2*uCur(i,j-1))+2*uCur(i,j)) - uInit(i,j);
                elseif i == 1 && j == n
                    uFut(i,j) = lamb*((2*uCur(i+1,j)-4*uCur(i,j)+2*uCur(i,j-1))+2*uCur(i,j)) - uInit(i,j);
                elseif j == n && i ~=n 
                    phantom = rightBoundary(i,j,alpha,beta,gamma,deltaX,uCur);
                    uFut(i,j) = ( lamb*uCur(i-1,j) + (2-4*lamb)*uCur(i,j) + lamb*uCur(i,j-1)+ lamb*phantom + lamb*uCur(i+1,j) ) - uInit(i,j);
               else
                    uFut(i,j) = ( lamb*uCur(i-1,j) + (2-4*lamb)*uCur(i,j) + lamb*uCur(i,j-1)+ lamb*uCur(i,j+1) + lamb*uCur(i+1,j) ) - uInit(i,j);
               end
%             if j == n && i == n
%                   uFut(i,j) = lamb*((2*uCur(i-1,j)-4*uCur(i,j)+2*uCur(i,j-1))+2*uCur(i,j)) - uInit(i,j);
%             elseif i == n && j ~= n
%                   if beta == 0
%                       uFut(n,j) = gamma/alpha;
%                   else
%                       phantom = rightBoundary(i,j, alpha, beta, gamma, deltaX, uCur);
%                       uFut(n,j) = ( lamb*uCur(i-1,j) + (2-4*lamb)*uCur(i,j) + lamb*phantom + lamb*uCur(i,j-1)+ lamb*uCur(i,j+1) - uInit(i,j));
%                   end
%               elseif j == n && i ~=n
%                      phantom = topBoundary(i,j,alpha,beta,gamma,deltaX,uCur);
%                      uFut(i,j) = ( lamb*uCur(i-1,j) + (2-4*lamb)*uCur(i,j) + lamb*uCur(i,j-1)+ lamb*phantom + lamb*uCur(i+1,j) ) - uInit(i,j);
%               elseif j == 1
%                     phantom = bottomBoundary(i,j,alpha,beta,gamma,deltaX,uCur);
%                     uFut(i,j) = ( lamb*uCur(i-1,j) + (2-4*lamb)*uCur(i,j) + lamb*phantom+ lamb*uCur(i,j+1) + lamb*uCur(i+1,j) ) - uInit(i,j);
%             else
%                   uFut(i,j) = ( lamb*uCur(i-1,j) + (2-4*lamb)*uCur(i,j) + lamb*uCur(i+1,j) + lamb*uCur(i,j-1)+ lamb*uCur(i,j+1) - uInit(i,j));
%             end
           end
       end
      surf(x,y,uCur,'FaceColor','red','EdgeColor','none')
camlight left; lighting phong, xlabel('X axis'), ylabel('Y axis'),
                    title('Uniform Depth 2D')
                    colormap cool
      drawnow

      uInit = uCur;            % update u values
      uCur  = uFut;
end

