clc
clear

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% Configuration %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

samplingFreq = 1000; % Sampling frequency [Hz]
length = 0.5; % Signal's length [s]

componentsNum = 3; % Number of components in the signal
amplitudes = [1.0; 0.4; 0.8]; % Components amplitudes
frequencies = [12; 8; 15]; % Components frequencies [Hz]
phaseShifts = [0; -pi/3; pi/7]; % Components phase shifts

noise = true; % Noise component (gauusian noise)

plotSignal = false;
plotAmp = false;
plotPhase = true;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Initialization %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Number of samples
N = length * samplingFreq;

% Construct a default generator
gen  = SignalGenerator(samplingFreq, noise);

% Configure generator's components
gen = gen.setComponentsNum(componentsNum);
gen = gen.setAmplitudes(amplitudes);
gen = gen.setFrequencies(frequencies);
gen = gen.setPhaseShifts(phaseShifts);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Calculations %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Generate signal
[t, x] = gen.generate(length);

% Compute FFT
spectrum = fft(x);

% Get the amplitude spectrum
A = abs(spectrum) / N;
A = A(1:N/2+1);
A(2:end-1) = 2*A(2:end-1);

% Get the phase spectrum
F = angle(spectrum);
F = F(1:N/2+1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Plotting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Frequencies axes computing
f_step = gen.Fs / N;
f = 0 : f_step : gen.Fs/2;

% Signal plotting
if plotSignal
    figure;
    plot(t, x);
    xlabel('Time [s]')
    ylabel('Amplitude')
end

% Spectrum plotting
if plotAmp
    figure;
    plot(f, A);
    xlabel('Frequency [Hz]')
    ylabel('Amplitude')
end

if plotPhase
    figure;
    plot(f, F);
    xlabel('Frequency [Hz]')
    ylabel('Phase shift')
end

clearvars -except A F f t x