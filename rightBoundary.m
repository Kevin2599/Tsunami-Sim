function phantom = rightBoundary(i,alpha, beta, gamma, deltaX, u)
    phantom = (2*deltaX/beta)*(gamma-alpha*u(i))+ u(i-1);    
end