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


%=============================================================%
%======================= Computation =========================%
%=============================================================%

% Compute distance from the object
[distance, pingFiltered] = sonarDistance(ping, Fs, Fb);


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