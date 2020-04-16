%=============================================================%
%====================== Configuration ========================%
%=============================================================%

fs = 5000; % [Hz]

fc1 = 2100; % [Hz]
fc2 = 1000; % [Hz]
BW = 4; % [Hz]

f_test = 2050; % Frequency of the test input
test_duration = 3; % Duration of the test signal [s]
                    % Cannot be shorter than kernel's duration

% false - lowpass; true - highpass
spectral_inverse = false;
spectral_reverse = false;

% impulse response printing
h_print = false;

% FFT printing
FFT_mag_print = true;
FFT_ang_print = false;

%=============================================================%
%====================== Initialization =======================%
%=============================================================%

% Scale filter parameters
fc1 = fc1 / fs;
fc2 = fc2 / fs;
BW = BW / fs;

% Compute kernel's length
M = floor(4 / BW);
if rem(M, 2) ~= 0
   M = M + 1; 
end

% Make the first (low-pass) filter
n = 0 : M;
h1 = sin(2*pi*fc1*(n-M/2)) ./ ...
    (n-M/2) .*...
    hamming(M + 1)';
h1(M/2 + 1) = 2 * pi * fc1;
h1 = h1 / sum(h1);

% Make the second (high-pass) filter
n = 0 : M;
h2 = sin(2*pi*fc2*(n-M/2)) ./ ...
    (n-M/2) .*...
    hamming(M + 1)';
h2(M/2 + 1) = 2 * pi * fc2;
h2 = h2 / sum(h2);
h2 = -h2;
h2(M/2 + 1) = h2(M/2 + 1) + 1;

% Convolve both filter to get a band-pass filter
h = conv(h1, h2);

% Make band-reject filters
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
output = output(size(h, 2) : end - size(h, 2));


%=============================================================%
%=========================== Plotting ========================%
%=============================================================%

if h_print
    figure
    plot(h) 
end


if FFT_mag_print
    figure
    H = abs(fft(h));
    plot(linspace(0, fs/2, size(H,2) / 2 + 1), H(1 : size(H,2) / 2 + 1))
end

if FFT_ang_print
    figure
    H = unwrap(angle(fft(h)));
    plot(linspace(0, fs/2, size(H,2) / 2 + 1), H(1 : size(H,2) / 2 + 1))   
end


%=============================================================%
%========================== Cleaning =========================%
%=============================================================%

clearvars -except h output