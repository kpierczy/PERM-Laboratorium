function [Y] = fourierSpectrum(A)
    subplot(1,2,1);
    imshow(A, [])
    axis on;
    Y = fftshift(fft2(A));
    subplot(1,2,2);
    imshow(log(abs(Y)), []);
end

