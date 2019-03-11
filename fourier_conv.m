function I = fourier_conv(image, filter, isConj)

% Performs convolution on an image and a filter by performing pointwise
% multiplication in the frequency domain.

image = double(image);
filter = double(filter);

[m,n] = size(image);
[k,l] = size(filter);
h = zeros(m,n);
h(1:k, 1:l) = filter;
I = padarray(image, [m-1 n-1], 0, 'post');
h = padarray(h, [m-1 n-1], 0, 'post');

ft_img = dft_2(I);
H = dft_2(h);

if isConj == true
    H = conj(H);
end

% Convolution
conv_img = ft_img.*H;

% New image
I = idft_2(conv_img);
I = I(1:m, 1:n);


