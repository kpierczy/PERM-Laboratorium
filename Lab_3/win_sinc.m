function [L] = win_sinc()
    audio_read;
    
    sampling = fs;
    cutoff = 500;
    bandwidth = 50;

    fc = cutoff/sampling

    BW = bandwidth/sampling

    M = 4/BW
    L = zeros(M+1,2);

    for i = 1 : 1 : M+1
        L(i,1) = i;
        if i == M/2
            L(i,2) = 2*pi*fc;
            continue
        end
        L(i,2) = (sin(2*pi*fc*(i - M/2))/(i-M/2))*(0.42-0.5*cos(2*pi*i/M) + 0.08*cos(4*pi*i/M));
    end
    L(:,2)
    s = sum(L(:,2));
    K = 1/s;
    L = L(:,2)*K;
    
end

