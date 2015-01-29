function [weight]=ons_expert(data, weight_o, eta, beta, delta)
% Copyright by Li Bin, 2009
% Online newton Step for ps, expert file
% Input
%     data    -- market historical prices
%     weight_o -- portfolio weight for last trading day
%     eta, beta, delta - parameters
% Output
%     weight  -- weight column vector
%

[T N]=size(data);
weight = weight_o(:, T); %#ok<NASGU>


%compute b(t-1) and A(t-1)
At = zeros(N);
bt = zeros(N, 1);
grad = zeros(T, 1);
hessian = zeros(T);

for i=1:T,
    grad = data(i, :)'/(data(i, :) * weight_o(:, i));
    heissian = (grad*grad')*(-1);
    At = At + (-1)*heissian;
    bt = bt + grad;
end

%Compute p(t)
At=At + eye(N, N);
bt=bt*(1+1/beta);

qt=At\bt*delta;

%argmin(q-p)'*A(t-1)*(q-p)

H=At*2; f=[]; A=[]; b=[];
Aeq=ones(N, 1)'; beq = ones(N, 1)'*qt - 1;
lb=qt-ones(N, 1); up = qt;

if (exist('OCTAVE_VERSION', 'builtin'))
    weight = qp([], H, f, Aeq, beq, lb, up);

else
    options = optimset('largescale','off', 'display', 'off', 'algorithm', 'active-set');

    weight = quadprog(H, f, A, b, Aeq, beq, lb, up, [], options);
end

weight = qt-weight;
weight=(1-eta)*weight + eta*ones(N, 1)/N;

end