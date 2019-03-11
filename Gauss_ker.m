function kernel = Gauss_ker(N)

% Creates 2D Normalized Gaussian kernel with mean = 0 and variance = 1. N
% must be odd.

assert(mod((N),2) == 1);
k = ceil((N)/2);

kernel = zeros(N);

for x = 1:N
    for y = 1:N
        kernel(x,y) = (1/2*pi)*exp(-((x-k)^(2) + (y-k)^(2))/2);
    end
end

kernel = kernel/sum(kernel(:));