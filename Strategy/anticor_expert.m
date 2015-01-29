% Bin Li (libin@pmail.ntu.edu.sg)
% This program generates portfolio for a specified parameter setting.
% Anticor expert
% while the original version is based on loop, which is slow in matlab,
% I replace the code using matrix operations
% Most previous experiments run based on the commented version, at the end
% of the file.
%
% function [weight] = anticor_expert(data, weight_o, w)
%
% weight: experts portfolio, used for next rebalance/combination
%
% data: market sequence vectors
% weight_o: last portfolio, also can be last price relative adjusted.
% w: window size for the experts
%
% Example: [weight] = anticor_expert(data, weight_o, 30)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [weight] = anticor_expert(data, weight_o, w)

[T, N]=size(data);
weight = weight_o;

% 1. Return the current portfolio if t < 2w
if (T >= 2*w),
    % 2. Compute LX1, LX2
    LX1 = log(data((T-2*w+1):(T-w),:));
    LX2 = log(data((T-w+1):T,:));
    
    % 2. Compute averages of LX1 and LX2
    mu1 = mean(LX1); 
    mu2 = mean(LX2);
    
    % M_cor = corr(LX1, LX2);
    M_cov = zeros(N, N); 
    M_cor = zeros(N, N);
    
    % I replace the following loop using matrix operations
    n_LX1 = LX1(:, :) - repmat(mu1, [w, 1]);
    n_LX2 = LX2(:, :) - repmat(mu2, [w, 1]);
    
    Std1 = diag(n_LX1'*n_LX1)/(w-1);
    Std2 = diag(n_LX2'*n_LX2)/(w-1);
    Std12 = Std1*Std2';
    M_cov = n_LX1'*n_LX2/(w-1);
         
    M_cor(Std12==0) = 0;
    M_cor(Std12~=0) = M_cov(Std12~=0)./sqrt(Std12(Std12~=0));

    % claim varialbe, matrixization 
    claim = zeros(N);
    w_mu2 = repmat(mu2', [1, N]);
    w_mu1 = repmat(mu2, [N, 1]);
    s_12 = (w_mu2 >= w_mu1) & (M_cor > 0);
    claim(s_12) = claim(s_12) + M_cor(s_12);
    
    diag_M_cor = diag(M_cor);
    cor1 = max(0, repmat(-diag_M_cor, [1, N]));
    cor2 = max(0, repmat(-diag_M_cor', [N, 1]));
    claim(s_12) = claim(s_12) + cor1(s_12) + cor2(s_12);
    
    transfer = zeros(N);
    sum_claim = repmat(sum(claim, 2), [1, N]);
    s_1 = abs(sum_claim) > 0;
    w_weight_o = repmat(weight_o, [1, N]);
    transfer(s_1) = w_weight_o(s_1).*claim(s_1)./sum_claim(s_1);

    % Use matrix operations, replacing the following loop
    transfer_ij = transfer'-transfer;
    weight = weight - sum(transfer_ij)';
end
end

%     for i=1:N,
%         for j = 1:N,
%             M_cov(i, j) = (LX1(:, i)-mu1(:, i))'*(LX2(:, j) - mu2(:, j))/(w-1);
%             
%             % Std1 = Std(LX1(:, i)
%             Std1 = (LX1(:, i) - mu1(:, i))'*(LX1(:, i) - mu1(:, i))/(w-1);
%             Std2 = (LX2(:, j) - mu2(:, j))'*(LX2(:, j) - mu2(:, j))/(w-1);
%             
%             if (Std12(i, j) == 0),
%                 M_cor(i, j) = 0;
%             else
%                 M_cor(i, j) = M_cov(i, j) / sqrt(Std1(i, 1)*Std2(j, 1));
%             end
%         end
%     end

%     
%     for i = 1:N,
%         for j = 1:N,
%             if ((mu2(i) >= mu2(j)) && (M_cor(i, j) > 0)),
%                 claim(i, j) = claim(i, j) + M_cor(i, j);
% %                 claim(i, j) = claim(i, j) + max(0, -M_cor(i, i));
% %                 claim(i, j) = claim(i, j) + max(0, -M_cor(j, j));
%             end
%         end
%     end    
%     for i = 1:N,
%         sum_claim_i = sum(claim(i, :));
%         if (abs(sum_claim_i) > 0)
%             for j = 1:N,
%                 transfer(i, j) = weight_o(i)*claim(i, j)/sum_claim_i;
%             end
%         end
%     end
%     for i = 1:N,
%         for j = 1:N,
%             weight(i) = weight(i) - transfer(i, j) + transfer(j, i);
%         end
%     end
