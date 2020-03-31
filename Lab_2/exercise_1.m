
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% Configuration %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

samplingFreq = 500; % Sampling frequency [Hz]
length = 1; % Signal's length [s]

componentsNum = 3; % Number of components in the signal
amplitudes = [1.0; 0.4; 0.8]; % Components amplitudes
frequencies = [50; 27; 300]; % Components frequencies [Hz]
phaseShifts = [0; -pi/3; pi/7]; % Components phase shifts

plotAmp = true;
plotPhase = false;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Initialization %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Number of samples
N = length * samplingFreq;

% Construct a default generator
gen  = SignalGenerator(samplingFreq);

% Configure generator's components
gen = gen.setComponentsNum(componentsNum);
gen = gen.setAmplitudes(amplitudes);
gen = gen.setFrequencies(frequencies);
gen = gen.setPhaseShifts(phaseShifts);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Calculations %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Generate signal
[t, x] = gen.generate(1);

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