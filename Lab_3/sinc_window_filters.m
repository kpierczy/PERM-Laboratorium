%=============================================================%
%====================== Configuration ========================%
%=============================================================%

fs = 200; % 100 Hz

fc = 14; % 14 Hz
BW = 2; % 2 Hz

f_test = 40; % Frequency of the test input
test_duration = 10; % Duration of the test signal [s]
                    % Cannot be shorter than kernel's duration

% false - lowpass; true - highpass
spectral_inverse = false;
spectral_reverse = true;

% impulse response printing
h_print = true;

% FFT printing
FFT_mag_print = true;
FFT_ang_print = true;

%=============================================================%
%====================== Initialization =======================%
%=============================================================%

% Scale filter parameters
fc = fc / fs;
BW = BW / fs;

% Compute kernel's length
M = floor(4 / BW);
if rem(M, 2) ~= 0
   M = M + 1; 
end

% Initialize kernel with a K parameter equal to 1
n = 0 : M;
h = sin(2*pi*fc*(n-M/2)) ./ ...
    (n-M/2) .*...
    hamming(M + 1)';
h(M/2 + 1) = 2 * pi * fc;

% Tune K parameter
h = h / sum(h);

if spectral_inverse
    h = -h;
    h(M/2 + 1) = h(M/2 + 1) + 1;
end

if spectral_reverse
    for k = 1:2:M+1
        h(k) = -h(k);
    end
end


%=============================================================%
%============================= Test ==========================%
%=============================================================%

t = 0 : 1/fs : test_duration;
test_signal = cos(2*pi*f_test*t);
output = conv(h, test_signal);
output = output(M + 1 : end - (M + 1));


%=============================================================%
%=========================== Plotting ========================%
%=============================================================%

if h_print
    figure
    plot(h) 
end


if FFT_mag_print
    figure
    X = abs(fft(h));
    plot(0 : fs/2/(M/2) : fs/2, X(1:M/2+1))
end

if FFT_ang_print
    figure
    X = unwrap(angle(fft(h)));
    plot(0 : fs/2/(M/2) : fs/2, X(1:M/2+1))    
end


%=============================================================%
%========================== Cleaning =========================%
%=============================================================%

clearvars -except h output