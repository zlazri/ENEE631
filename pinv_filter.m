function [G, H, G_ft, H_ft] = pinv_filter(I, B, ep)

% Creates a pseudo inverse filter given original image (I), and blurred
% image (B).

I = double(I);
B = double(B);

I_ft = dft_2(I);
B_ft = dft_2(B);

% Create filters
H_ft = B_ft./I_ft; % Filter (freq domain)
G_ft = ones(size(H_ft))./H_ft; % Inverse Filter (freq domain)
G_ft(abs(H_ft) < ep) = 0;

% Spatial Domain Filters
H = idft_2(H_ft);
G = idft_2(G_ft);
