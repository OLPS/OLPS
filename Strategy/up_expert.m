function [weight] = up_expert(data, weight_o)
% This program generates portfolio for a specified parameter setting.
% Refer to KV02
%
% function [weight] = up_expert(data, k, l, c)
%
% weight: experts portfolio, used for next rebalance/combination
%
% data: market sequence vectors
% weight_o: last portfolio, also can be last price relative adjusted.
%
% Example: [weight] = up_expert(data, weight_o);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of OLPS: http://OLPS.stevenhoi.org/
% Original authors: Bin LI, Steven C.H. Hoi
% Contributors:
% Change log: 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [weight] = up_expert(data, weight_o)

del0 = 4e-3;      % minimum coordinate
delta = 5e-3;     % spacing of grid
M = 1e1;          % Number of samples
S = 0.5e1;        % Number of steps in the random walk

[~, N] = size(data);  % Number of stocks,Time period.

% Computing Universal Portfolio.
r = ones(N, 1)/N;  % Start each one at the uniform point
b = ones(size(r)); %#ok<NASGU>

allM = zeros(N, M);  % Take the average of m samples
for m = 1:M
    b = r;
    for i = 1:S
        bnew = b;
        j = randi(N-1, 1);  % Choose 1<= j <= N-1 at random
        
        % Choose X = -1 or 1 randomly.
        a = randi(2, 1);
        if a == 2
            a = -1;
        end
        
        % If 
        bnew(j) = b(j) + (a*delta);
        bnew(N) = b(N) - (a*delta);
        if bnew(j) >= del0 && bnew(N) >= del0,
            x = up_expert_findQ(b, data, del0, delta);
            y = up_expert_findQ(bnew, data, del0, delta);
                        
            pr = min(y/x, 1);
            temp = rand(1);
            if temp < pr,
                b = bnew;
            end
        end
    end
    allM(:,m) = b';
end

weight = sum(allM, 2)/M;  %Taking the average of m samples.

end