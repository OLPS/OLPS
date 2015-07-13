function [y] = l1median_VaZh_z(X, maxiter, tol, zerotol, medIn )
%To calculate the L1_median of X  with the l1median_VaZh method
%INput:
%     X       ---the number of the records is the number of rows
%     maxiter ---the max number of iteration
%     tol     ---the tolerance of iteration 
%     zerotol ---the tolerance of vector to zero
%     medIn   ---a row vector representing initial median of X
%output:
%     y       ---the median of X

    %To discuss the parameters
    if (nargin > 5)
        error ('Too many input arguments.') ;
    elseif (nargin < 5)
        medIn = median(X);
        if(nargin < 4)
            zerotol = 1e-15 ;
            if (nargin < 3)
                tol = 1e-9 ;
                if (nargin < 2)
                    maxiter = 200 ;
                    if (nargin < 1)
                        error ('Data matrix X is missing.') ;
                    end
                end
            end
        end
    end
    
    [rn,vn] = size(X);
    iterdis = 1;
    iter = 0;
    y = medIn;
    
    %Begin the iteration
    while (iterdis > 0) && (iter < maxiter)
        Tnum=zeros(1,vn);
        R = zeros(1,vn);
        Tden=0;
        yita = 0;
        for i=1:rn
            dist = norm(X(i,:)-y);
            if dist >= zerotol
                Tnum = Tnum + X(i,:)/dist;
                Tden=Tden + 1/dist;
                R = R + (X(i,:)-y)/dist;
            else
                yita = 1;
            end
        end

        if Tden == 0
            T=0;
        else
           T=Tnum/Tden;
        end

        if norm(R) == 0
            r = 0;
        else
            r = min(1,yita/norm(R));
        end

        Ty = (1-r)*T + r*y;

        iterdis = norm((Ty-y),1) - tol*norm(y,1);
        iter = iter + 1;
        y=Ty;
        
    end

    
    %End the iteration
    
      
    
        
