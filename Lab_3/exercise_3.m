clear
load('data/ping.mat')
clc

%=============================================================%
%====================== Configuration ========================%
%=============================================================%

% If true, spectrogram of the echo will be plotted
PrintSpectrogram = true;

% If true, spectrogram of the filtered echo will be plotted
PrintFilteredSpectrogram = true;

% Spectrogram parameters
WinLen = 512;
WinOverlap = 256;
NTFFT = 512;

%-------------------------------------------------------------%

% Sampling frequency [Hz]
Fs = 200000;

% Sonar's band [Hz]
Fb = 40000;

% Filter's bandwidth [% of the Fs]
BW = 0.01;

% Filter's roll-off [% of the Fs]
rollOff = 0.01;

%=============================================================%
%======================= Computation =========================%
%=============================================================%

% Compute distance from the object
distance = sonarDistance(ping, Fs, Fb);

% Configure band-pass filter to filter the sonar echo
%
% @note : filtration is not required to distinguish
%         ping signal's echo from the noise basing
%         on the echo's STFT. Spectrogram of the filtered
%         signal look cool though.
%
% @see FilterFIR.m for parameters description
filter = FilterFIR( ...
    'BandPass', Fs, ...
    [Fb - BW * Fs / 2 ;  Fb + BW * Fs / 2], ...
    rollOff * Fs ...
);
h = filter.getImpulseResponse();

% Filter sonar's echo
pingFiltered = conv(ping, h);
% Trim additional samples produced by convolution
pingFiltered = pingFiltered(1:(end - size(h, 2) + 1));

%=============================================================%
%========================= Plotting ==========================%
%=============================================================%

if PrintSpectrogram
    figure
    spectrogram( ...
        ping, ...
        WinLen, WinOverlap, NTFFT, ...
        Fs, ...
        'MinThreshold', -100, 'yaxis' ...
    ) 
end

if PrintFilteredSpectrogram
    figure
    spectrogram( ...
        pingFiltered, ...
        WinLen, WinOverlap, NTFFT, ...
        Fs, ...
        'MinThreshold', -100, 'yaxis' ...
    ) 
end

%=============================================================%
%======================== Cleaning ===========================%
%=============================================================%

clearvars -except distance