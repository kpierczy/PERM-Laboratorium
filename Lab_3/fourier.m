    signal = c;

    spectrum = fft(signal);
    framesNumber = size(signal,1);
    frameRate = fs;
    
    % Get the amplitude spectrum
    A = abs(spectrum) / framesNumber;
    A = A(1:framesNumber/2+1);
    A(2:end-1) = 2*A(2:end-1);

    % Frequencies axis computing
    f_step = frameRate / framesNumber;
    f = 0 : f_step : frameRate/2;
    
    figure;
    plot(f, A);
    xlabel('Frequency [Hz]')