function I = idft_2(image)

[M,N] = size(image);
Wm = zeros(M,M);
Wn = zeros(N,N);


for m = 0:M-1
    for u = 0:M-1
        Wm(m+1,u+1) = exp(1i*2*pi*m*u/M);
    end
end

for n = 0:N-1
    for v = 0:N-1
        Wn(n+1,v+1) = exp(1i*2*pi*n*v/N);
    end
end

I = Wm*image*Wn/(M*N);
I = real(I);

