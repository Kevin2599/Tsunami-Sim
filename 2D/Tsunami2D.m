% Alexander Mitkus
% May 2, 2012
% This code creates an animation of a tsunami wave rushing toward a
% shore with a given ocean depth function.
% APPM 3050, Project 02


% Necessary housekeeping
clear all
close all
clc

% Number of frame in the movie
nFrames = 900; 

% Physical parameters
c = 1;                      
deltaT = 0.04;
deltaX = 0.04;
lamb = (c*deltaT/deltaX)^2;

% Driving function
alpha = 0;
beta = 1;
gamma = 0;

% Calculate x and y node locations
xRight = 4;                   
[x,y] = meshgrid(0:deltaX:2,1:-deltaX:-(2/3));
[m,n] = size(x);

% Set values for uInit, uCur, uFut
uInit = ones(m,n);           
uCur  = uInit;
uFut  = uCur;

% Call depth function to return depth and depth derivative array
[h, hx, hy] = depth2D(x,y);
                            
% Set left spatial boundary value
uCur(:,1) = leftBoundary(1, deltaT);


% Loop through to calculate first time step
for i = 1 : m
    for j = 2 : n
        
        if i == m && j~=n           %Bottom Edge
            phantom = bottomBoundary(i,j,alpha,beta,gamma,deltaX,uCur);
            uCur(i,j) = (((lamb*deltaX/2)*hx(i,j)+lamb*h(i,j))*uInit(i,j+1)+(-(lamb*deltaX/2)*hx(i,j)+lamb*h(i,j))*uInit(i,j-1)+(-(lamb*deltaX/2)*hy(i,j)+lamb*h(i,j))*phantom+((lamb*deltaX/2)*hy(i,j)+lamb*h(i,j))*uInit(i-1,j) +(-lamb*h(i,j)*4+2)*uInit(i,j))/2;
        
        elseif i == 1 && j~=n       %Top Edge
            phantom = topBoundary(i,j,alpha,beta,gamma,deltaX,uCur);
            uCur(i,j) = (((lamb*deltaX/2)*hx(i,j)+lamb*h(i,j))*uInit(i,j+1)+(-(lamb*deltaX/2)*hx(i,j)+lamb*h(i,j))*uInit(i,j-1)+(-(lamb*deltaX/2)*hy(i,j)+lamb*h(i,j))*uInit(i+1,j)+((lamb*deltaX/2)*hy(i,j)+lamb*h(i,j))*phantom +(-lamb*h(i,j)*4+2)*uInit(i,j))/2;
        
        elseif j == n && i == m     %Bottom-Right Corner
            bottomPhantom = bottomBoundary(i,j,alpha,beta,gamma,deltaX,uCur);
            rightPhantom = rightBoundary(i,j,alpha,beta,gamma,deltaX,uCur);
            uCur(i,j) = (((lamb*deltaX/2)*hx(i,j)+lamb*h(i,j))*rightPhantom+(-(lamb*deltaX/2)*hx(i,j)+lamb*h(i,j))*uInit(i,j-1)+(-(lamb*deltaX/2)*hy(i,j)+lamb*h(i,j))*bottomPhantom+((lamb*deltaX/2)*hy(i,j)+lamb*h(i,j))*uInit(i-1,j) +(-lamb*h(i,j)*4+2)*uInit(i,j))/2;
        
        elseif i == 1 && j == n     %Top-Right Corner
            topPhantom = topBoundary(i,j,alpha,beta,gamma,deltaX,uCur);
            rightPhantom = rightBoundary(i,j,alpha,beta,gamma,deltaX,uCur);
            uCur(i,j) = (((lamb*deltaX/2)*hx(i,j)+lamb*h(i,j))*rightPhantom+(-(lamb*deltaX/2)*hx(i,j)+lamb*h(i,j))*uInit(i,j-1)+(-(lamb*deltaX/2)*hy(i,j)+lamb*h(i,j))*uInit(i+1,j)+((lamb*deltaX/2)*hy(i,j)+lamb*h(i,j))*topPhantom +(-lamb*h(i,j)*4+2)*uInit(i,j))/2;
        
        elseif j == n && i ~=m      %Right Edge
            phantom = rightBoundary(i,j,alpha,beta,gamma,deltaX,uCur);
            uCur(i,j) = (((lamb*deltaX/2)*hx(i,j)+lamb*h(i,j))*phantom+(-(lamb*deltaX/2)*hx(i,j)+lamb*h(i,j))*uInit(i,j-1)+(-(lamb*deltaX/2)*hy(i,j)+lamb*h(i,j))*uInit(i+1,j)+((lamb*deltaX/2)*hy(i,j)+lamb*h(i,j))*uInit(i-1,j) +(-lamb*h(i,j)*4+2)*uInit(i,j))/2;
        
        else                        %General Case
            uCur(i,j) = (((lamb*deltaX/2)*hx(i,j)+lamb*h(i,j))*uInit(i,j+1)+(-(lamb*deltaX/2)*hx(i,j)+lamb*h(i,j))*uInit(i,j-1)+(-(lamb*deltaX/2)*hy(i,j)+lamb*h(i,j))*uInit(i+1,j)+((lamb*deltaX/2)*hy(i,j)+lamb*h(i,j))*uInit(i-1,j) +(-lamb*h(i,j)*4+2)*uInit(i,j))/2;
        
        end
    end
end

% Plot the surface using surf. Note that this will use a colormap
% representative of the depth at each point.
surf(x,y,uCur,h)
    xlabel('X axis'), ylabel('Y axis'), title('Tsunami 2D'), zlim([0 1.5])
    set(gcf,'renderer','painters');
drawnow


% Now, loop through to calculate the rest of the time steps                              
for k = 2 : nFrames
      
    % Calculate left boundary for future step
    uFut(:,1) = leftBoundary(k, deltaT);
    
    for i = 1 : m
        for j = 2 : n
            
            if i == m && j~=n           %Bottom Edge
                phantom = bottomBoundary(i,j,alpha,beta,gamma,deltaX,uCur);
                uFut(i,j) = ((lamb*deltaX/2)*hx(i,j)+lamb*h(i,j))*uCur(i,j+1)+(-(lamb*deltaX/2)*hx(i,j)+lamb*h(i,j))*uCur(i,j-1)+(-(lamb*deltaX/2)*hy(i,j)+lamb*h(i,j))*phantom+((lamb*deltaX/2)*hy(i,j)+lamb*h(i,j))*uCur(i-1,j) +(-lamb*h(i,j)*4+2)*uCur(i,j) - uInit(i,j);
            
            elseif i == 1 && j~=n       %Top Edge
                phantom = topBoundary(i,j,alpha,beta,gamma,deltaX,uCur);
                uFut(i,j) = ((lamb*deltaX/2)*hx(i,j)+lamb*h(i,j))*uCur(i,j+1)+(-(lamb*deltaX/2)*hx(i,j)+lamb*h(i,j))*uCur(i,j-1)+(-(lamb*deltaX/2)*hy(i,j)+lamb*h(i,j))*uCur(i+1,j)+((lamb*deltaX/2)*hy(i,j)+lamb*h(i,j))*phantom +(-lamb*h(i,j)*4+2)*uCur(i,j) - uInit(i,j);
            
            elseif j == n && i == m     %Bottom-Right Corner
                bottomPhantom = bottomBoundary(i,j,alpha,beta,gamma,deltaX,uCur);
                rightPhantom = rightBoundary(i,j,alpha,beta,gamma,deltaX,uCur);
                uFut(i,j) = ((lamb*deltaX/2)*hx(i,j)+lamb*h(i,j))*rightPhantom+(-(lamb*deltaX/2)*hx(i,j)+lamb*h(i,j))*uCur(i,j-1)+(-(lamb*deltaX/2)*hy(i,j)+lamb*h(i,j))*bottomPhantom+((lamb*deltaX/2)*hy(i,j)+lamb*h(i,j))*uCur(i-1,j) +(-lamb*h(i,j)*4+2)*uCur(i,j) - uInit(i,j);
            
            elseif i == 1 && j == n     %Top-Right Corner
                topPhantom = topBoundary(i,j,alpha,beta,gamma,deltaX,uCur);
                rightPhantom = rightBoundary(i,j,alpha,beta,gamma,deltaX,uCur);
                uFut(i,j) = ((lamb*deltaX/2)*hx(i,j)+lamb*h(i,j))*rightPhantom+(-(lamb*deltaX/2)*hx(i,j)+lamb*h(i,j))*uCur(i,j-1)+(-(lamb*deltaX/2)*hy(i,j)+lamb*h(i,j))*uCur(i+1,j)+((lamb*deltaX/2)*hy(i,j)+lamb*h(i,j))*topPhantom +(-lamb*h(i,j)*4+2)*uCur(i,j) - uInit(i,j);
            
            elseif j == n && i ~=m      %Right Edge
                phantom = rightBoundary(i,j,alpha,beta,gamma,deltaX,uCur);
                uFut(i,j) = ((lamb*deltaX/2)*hx(i,j)+lamb*h(i,j))*phantom+(-(lamb*deltaX/2)*hx(i,j)+lamb*h(i,j))*uCur(i,j-1)+(-(lamb*deltaX/2)*hy(i,j)+lamb*h(i,j))*uCur(i+1,j)+((lamb*deltaX/2)*hy(i,j)+lamb*h(i,j))*uCur(i-1,j) +(-lamb*h(i,j)*4+2)*uCur(i,j) - uInit(i,j);
            
            else                        %General Case
                uFut(i,j) = ((lamb*deltaX/2)*hx(i,j)+lamb*h(i,j))*uCur(i,j+1)+(-(lamb*deltaX/2)*hx(i,j)+lamb*h(i,j))*uCur(i,j-1)+(-(lamb*deltaX/2)*hy(i,j)+lamb*h(i,j))*uCur(i+1,j)+((lamb*deltaX/2)*hy(i,j)+lamb*h(i,j))*uCur(i-1,j) +(-lamb*h(i,j)*4+2)*uCur(i,j) - uInit(i,j);
            
            end
        end
    end
    
    % Plot using surf. Again, the colormap serves as a visual
    % representation of the depth
    surf(x,y,uCur,h)
        xlabel('X axis'), ylabel('Y axis'), title('Tsunami 2D'), zlim([0 1.5])
        set(gcf,'renderer','painters');
    drawnow

    % Update u values
    uInit = uCur;            
    uCur  = uFut;

end