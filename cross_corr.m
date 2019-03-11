function R = cross_corr(M1, M2)

% Cross correlation for WSS images

[m,n] = size(M1);
R = ones(m,n);

for i = 1:m
    for j = 1:n
        r = M1(i:end,j:end).*M2(1:m-i+1,1:n-j+1);
        R(i,j) = sum(r(:));
    end
end
R = R/(m*n);