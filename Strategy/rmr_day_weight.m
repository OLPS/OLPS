function [day_weight]=rmr_day_weight(data_close,data,t1,day_weight, w, epsilon)
%to calculate the day_weight at the t+1 day with robust mean reversion method
%Input:
%    data
%    t1         ---the new day 
%    day_weight ---the weight before the new day
%    w          ---the length of window
%    epsilon      ---the parameter to control the reversion threshold
%Output:
%    day_weight ---the weight at the new day
%w=min(w,t1-1);
%x_t1 = l1median_VaZh_z(data((t1-w):(t1-1),:));
if t1<w+2
    x_t1=data(t1-1,:);
else
   x_t1 = l1median_VaZh_z(data_close((t1-w):(t1-1),:))./data_close(t1-1,:);
end
%   if sum(x_t1)==size(data,2)
%       x_t1 = median(data_close((t1-w):(t1-1),:))./data_close(t1-1,:);
%   end

if (norm(x_t1-mean(x_t1)))^2==0
    tao = 0;
else
    tao = min(0,(x_t1*day_weight-epsilon)/(norm(x_t1-mean(x_t1)))^2);
end
day_weight = day_weight - tao*(x_t1-mean(x_t1)*ones(size(x_t1)))';
day_weight = simplex_projection(day_weight,1);

end
