function G = Wiener(I, B, varargin)

% I: Original clean image
%
% N: Corrupted image from blurring and possibly noisy.
%
% varagin: used to specifiy eta (the amount of noisy we expect to be in the
% image. If we don't pass a parameter for this agrument, the function uses
% a default guess.

[m,n] = size(I);

if isempty(varargin)
    eta = wgn(m,n,0);
elseif length(varargin)>=2
    assert(length(varargin)>=2, "Too many input arguments")
else
    eta=varargin{1};
end

I = double(I);
B = double(B);
eta = double(eta);

% Cross Correlations
R_I = cross_corr(I,I);
R_eta = cross_corr(eta,eta);

% Spectral Densities
S_I = spectral(R_I);
S_eta = spectral(R_eta);

% Find H
W = B-eta;
W_four = dft_2(W);
I_four = dft_2(I);
H = W_four./I_four;

% Wiener filter
G = ones(size(I))./(H + S_eta./(conj(H).*S_I));
