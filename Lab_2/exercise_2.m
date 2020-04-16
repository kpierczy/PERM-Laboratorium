clc
clear

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% Configuration %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% An absolute path to the video file

% [file, path] = uigetfile('.mp4');
% file
% path
% videoPath = strcat(path, file);

% Number of frames to load
framesNumber = 300; 

% Number of frames per second
frameRate = 30;

% Method of pulse measuring
% 1 - zero's counting
% 2 - autocorrelation
% 3 - discrete fourier transform
method = 3;

% Plotting options
plots = true;
plotPulse = true;
plotAutocorrelation = true;
plotSpectrum = true;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Initialization %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get path of the 'brightness' serialization

[filepath,~,~] = fileparts(mfilename('fullpath'));
savePath = strcat(filepath, '/data/brightness.mat');
%savePath = '';
% Load brightness vector if saved
if isfile(savePath)
    load = matfile(savePath);
    brightness = load.brightness;
    
% Otherwise compute and save
else
    addpath('utilities\')
    brightness = movie2brightness(videoPath, framesNumber);
    save(savePath, 'brightness');
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Calculations %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Zeros' counting
if method == 1
    
    % Count zeros
    zeroCrosses = 0;
    for i=2:size(brightness, 1)
       if brightness(i-1)*brightness(i) <= 0
          
          zeroCrosses = zeroCrosses + 1;
          
          % Increment iterator if one of the points
          % is 0 (as we don't want to count it again,
          % in the next iteration).
          if brightness(i-1)*brightness(i) == 0
             i = i + 1;
          end
       end
    end
    
    % Establish measurement time [s]
    time = framesNumber / frameRate;
    
    % Pulse [Hz]
    pulseHz= (zeroCrosses / 2) / time;
    
% Autocorrelation
elseif method == 2
    
    % Compute autocorrelation within full shift range
    autocorrelation = autocorr(brightness, 'NumLags', framesNumber - 1);
    
    % Get DFT of the autocorrelation.
    %
    % @note DFT of the autocorrelation function is used to extract
    %       frequency of the local maxima. Distance between them
    %       could be also computed as an average distance between
    %       subsequent ones. DFT is more reliable method, though.
    %
    spectrum = fft(autocorrelation);
    
    % Get the amplitude spectrum
    A = abs(spectrum) / framesNumber;
    A = A(1:framesNumber/2+1);
    A(2:end-1) = 2*A(2:end-1);
    
    % Frequencies axis computing
    f_step = frameRate / framesNumber;
    f = 0 : f_step : frameRate/2;
    
    % Get maximum amplitude from spectrum and get it's frequency
    maxAmplitude = max(A);
    pulseHz= f(A == maxAmplitude);
    
% Discrete Fourier Transform
elseif method == 3
    
    % Compute FFT
    spectrum = fft(brightness);

    % Get the amplitude spectrum
    A = abs(spectrum) / framesNumber;
    A = A(1:framesNumber/2+1);
    A(2:end-1) = 2*A(2:end-1);

    % Frequencies axis computing
    f_step = frameRate / framesNumber;
    f = 0 : f_step : frameRate/2;
    
    % Get maximum amplitude from spectrum and get it's frequency
    maxAmplitude = max(A);
    pulseHz= f(A == maxAmplitude);
    
end

% Pulse [beat / min]
pulsePerMin = pulseHz * 60;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Plotting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if plots
    
    % Pulse plotting
    if plotPulse
        figure
        time = linspace(0, framesNumber / frameRate, framesNumber);
        plot(time, brightness) ;
        xlabel('Time [s]');
        ylabel('Average brightness');
    end

    % Autocorrelation
    if plotAutocorrelation && method == 2
        figure
        time = linspace(0, framesNumber / frameRate, framesNumber);
        plot(time, autocorrelation) ;
        xlabel('Time shift [s]');
        ylabel('Autocorrelation');
    end

    % Spectrum plotting
    if plotSpectrum && (method == 2 || method == 3)
        figure;
        plot(f, A);
        xlabel('Frequency [Hz]')
        if method == 2
            ylabel('Amplitude (autocorrelation)')
        else
            ylabel('Amplitude')
        end
    end
    
end

clearvars -except pulseHz pulsePerMin