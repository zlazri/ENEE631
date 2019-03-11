function R = cov_mat(M)

[m,n] = size(M);
R = ones(m,n);

mu = sum(m(:))/(m*n);

for i = 1:m
    for j = 1:n
        M1 = M(i:end,j:end);
        M2 = M(1:m-i+1,1:n-j+1);
        M1 = M1-mu;
        M2 = M2-mu;
        r = M1.*M2;
        R(i,j) = sum(r(:));
    end
end
R = R/(m*n);