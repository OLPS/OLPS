function [ calmars ] = calmar( cumReturns, mdds, frequency )

    [r c] = size(cumReturns);
    calmars = zeros(1,c);
    den = 252/frequency;
    Y = r/den;
    annualisedReturns = ((cumReturns(r,:)./cumReturns(1,:)) .^ (1/Y)) - 1;
    calmars = annualisedReturns ./ mdds;
end

