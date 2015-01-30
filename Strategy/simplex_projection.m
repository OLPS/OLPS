function w = simplex_projection(v, b)
% Simplex_Projection Projects point onto simplex of specified radius.
%
% w = simplex_projection(v, b) returns the vector w which is the solution
%   to the following constrained minimization problem:
%
%    min   ||w - v||_2
%    s.t.  sum(w) <= b, w >= 0.
%
%   That is, performs Euclidean projection of v to the positive simplex of
%   radius b.
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of OLPS: http://OLPS.stevenhoi.org/
% Original authors: John Duchi (jduchi@cs.berkeley.edu)
% Contributors: Bin LI, Steven C.H. Hoi
% Change log: 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (b < 0)
  error('Radius of simplex is negative: %2.3f\n', b);
end
v = (v > 0) .* v;
u = sort(v,'descend');
sv = cumsum(u);
rho = find(u > (sv - b) ./ (1:length(u))', 1, 'last');
theta = max(0, (sv(rho) - b) / rho);
w = max(v - theta, 0);
