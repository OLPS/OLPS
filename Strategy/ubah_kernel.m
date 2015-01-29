% Li Bin (libin@pmail.ntu.edu.sg)
% This file is the kernel core for the market strategy.
% If multiple experts are required, implement in this file.
% Here, only one expert is designed.
%
% function [weight] = ubah_kernel(data, weight_o)
% weight: generate portfolio for day t+1
% data: market sequence until day t
% weight_o: last (t^th) portfolio 
%
% Example: [weight] ...
%          = ubah_kernel(data(1:t), weight_o);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [weight] = ubah_kernel(data, weight_o)

weight = ubah_expert(data, weight_o);

end
%%%%%%%%%%%%%%End%%%%%%%%%%%%%%%%%%%%%%