function [y] = filter_iir(cutoff, type, pass)
    [data,fs]=audioread('data/20200416_150545.m4a');
    
    switch (type)
        case 'low-pass'
            k = exp(-2*pi*cutoff/fs)
            
            y = zeros(size(data, 1),1);
            x = data(:,2);
            
            a_0 = 1 - k;
            b_1 = k;
            
            for i = 2 : 1 : size(data,1)
                y(i) = a_0*x(i) + b_1*y(i-1);
            end
        case 'high-pass'
            k = exp(-2*pi*cutoff/fs)
            
            y = zeros(size(data, 1),1);
            x = data(:,2);
            x(1) = 0;
            
            a_0 = (1 - k)/2;
            a_1 = -1*(1 + k)/2;
            b_1 = k;
            
            for i = 2 : 1 : size(data,1)
                y(i) = a_0*x(i) + a_1*x(i-1) + b_1*y(i-1);
            end
            
            
        case 'band-pass'
            
            y = zeros(size(data, 1),1);
            x = data(:,2);
            R = 1 - 3 * (pass - cutoff)/fs;
            
            f = (pass - cutoff)/(2*fs);
            K = (1-2*R*cos(2*pi*f) + R^2)/(2-2*cos(2*pi*f));
            
            a_0 = 1-K;
            a_1 = 2*(K-R)*cos(2*pi*f);
            a_2 = R^2 - K;
            b_1 = 2*R*cos(2*pi*f);
            b_2 = -1*R^2;
            
            for i = 3 : 1 : size(data,1)
                y(i) = a_0*x(i) + a_1*x(i-1) + a_2*x(i-2) + b_1*y(i-1) + b_2*y(i-2);
            end

        otherwise
            warning('wrong filter type')            
    end

    win_len = 512;
    win_overlap = 256;
    nfft = 512;
    figure
    spectrogram(y, win_len, win_overlap, nfft, fs, 'MinThreshold', -100, 'yaxis')
            
end
%         case 'high-pass'
%             k = exp(-2*pi*cutoff/fs)
%             
%             y = zeros(size(data, 1),1);
%             x = data(:,2);
%             x(1) = 0;
%             
%             a_0 = (1 - k)^4;
%             b_1 = 4*k;
%             b_2 = -6*k^2;
%             b_3 = 4*k^3;
%             b_4 = -1*k^4;
%             
%             for i = 5 : 1 : size(data,1)
%                 y(i) = a_0*x(i) + b_1*y(i-1) + b_2*y(i-2) + b_3*y(i-3) + b_4*y(i-4);
%             end
%                 y = -1*y;
%                 y(size(y,1)/2) = y(size(y,1)/2) + 1;

