function I = RL(g, h, iter, type)

g= double(g)/255;
h = double(h);
ui =  ones(size(g));
[m,n] = size(h);

if type == "rgb"
    dummy1 = ones(m,n,3);   
    for i = 1:3
        dummy1(:,:,i) = h;
    end
    h = dummy1;
end

for i = 1:iter
    
    uh = fourier_conv(ui,h, false);
%    Ui = fft2(ui);
%    UH = Ui.*H;
%    uh = ifft2(UH);
    c = g./uh;
    c = fourier_conv(c,h, true);
%    C = fft2(c);
%    C = C.*H_star;
%    c = ifft2(C);
    ui_1 = ui.*c;
    ui = ui_1;
end
I = uint8(ui_1*255);