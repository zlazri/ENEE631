function I_new = IBD(g, f0, h0, k, a)

% Performs Iterative Blind Deconvolution algorithm.
%
% How the algorithm works: Start with initial guesses of the real image
% (f0) and point spread function (h0) and use these and our knowledge of
% the blurred image to find the orignal image iteratively.
%
% Parameters
% g: degraded image
% f0: initial estimate of real image
% h0: original estimate of PSF
% k: number of iterations over which the algorithm runs
% a: constant parameter in the iteration equations

g = double(g);
f0 = double(f0)/255;

fk = f0;
hk = h0;
G = dft_2(g);

for i = 1:k
    Fk = fft2(fk);
    Hk = fft2(hk);
    
    % Update H
    
    H_new = (G.*conj(Fk))./(conj(Fk).*Fk + a*ones(size(Hk))./(conj(Hk).*Hk));
    h_new = real(ifft2(H_new));
    h_new(h0==0) = 0;
    E = -sum(h_new(h_new<0))/length(h_new(h_new<0)); % Energy conservation as values of support get zeroed out.
    h_new(h_new<0) = E;
    h_new(h_new<0) = 0;
    h_new = h_new/(sum(h_new(:)));
    
    % Update F
    
    F_new = (G.*conj(Hk))./(conj(Hk).*Hk + a*ones(size(Hk))./(conj(Fk).*Fk));
    f_new = real(ifft2(F_new));
    f_new(g==0) = 0;
    E = -sum(f_new(f_new<0))/length(f_new(f_new<0)); % Energy conservation as values of support get zeroed out.
    f_new(f_new<0) = E;
    f_new(f_new<0) = 0;
    
    
    % Update H and F values for next iteration
    
    fk = f_new;
    hk = h_new;
end

%I_new = fk/max(fk(:));
I_new = fk;    

