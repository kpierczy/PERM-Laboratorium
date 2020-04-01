clc
clear

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% Configuration %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

samplingFreq = 10000; % Sampling frequency [Hz]
length = 3; % Signal's length [s]

componentsNum = 4; % Number of components in the signal
amplitudes = [1.0; 0.4; 0.8; 0.65]; % Components amplitudes
frequencies = [12; 8; 15; 20]; % Components frequencies [Hz]
phaseShifts = [0; -pi/3; pi/7; pi]; % Components phase shifts

noise = true; % Noise component (gauusian noise)

plotSignal = true;
plotRevivedSignal = true;
plotAmp = true;
plotPhase = false;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Initialization %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Sort components info vectors
components = [amplitudes, frequencies, phaseShifts];
[~, idx] = sort(components(:, 1), 'descend');
components = components(idx,:);
amplitudes = components(:,1);
frequencies = components(:,2);
phaseShifts = components(:,3);

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

% Frequencies axis computing
f_step = gen.Fs / N;
f = 0 : f_step : gen.Fs/2;

%Try to recover original signal from noised one
if noise
    
    % Form (N x 2) matrix to hold main frequencies and their amplitudes
    mainFrequencies = zeros(componentsNum, 2);
    % Get amplitudes of N max frequencies
    [mainFrequencies(:, 2), mainFrequencies(:, 1)] = maxk(A, componentsNum);
    
    % Turn off noise
    gen.noise = false;

    % Configure generator's components
    gen = gen.setAmplitudes(mainFrequencies(:, 2));
    gen = gen.setFrequencies(f(mainFrequencies(:, 1))');
    gen = gen.setPhaseShifts(phaseShifts);
    
    % Compute filtered signal
    [~, x_revived] = gen.generate(length);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Plotting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Signal plotting
if plotSignal
    figure;
    plot(t, x);
    if noise && plotRevivedSignal
        hold on
        plot(t, x_revived);
    end
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

clearvars -except A F f t x x_revived