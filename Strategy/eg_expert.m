% Bin Li (libin@pmail.ntu.edu.sg)
% This program generates portfolio for a specified parameter setting.
% EG expert
%
% function [weight] = eg_expert(data, weight_o, eta)
%
% weight: experts portfolio, used for next rebalance/combination
%
% data: market sequence vectors
% weight_o: last portfolio, also can be last price relative adjusted.
% eta: learning rate
%
% Example: [weight] = eg_expert(data, weight_o, 0.05);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [weight] = eg_expert(data, weight_o, eta)

[T, N]=size(data);

% for i = 1:N,
%     weight(i, 1) = weight_o(i, 1)*exp(eta*data(T, i)/(data(T, :)*weight_o));
% end

weight(:, 1) = weight_o(:, 1).*exp(eta*data(T, :)'/(data(T, :)*weight_o));

weight=weight./sum(weight);

end