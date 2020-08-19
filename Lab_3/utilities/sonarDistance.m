%======================================================%
% Function computes distance from the object basing on
% the registered echo signal.
%
% @param sig : registered echo
% @param Fs : sampling frequency [Hz]
% @param Fb : sonar band's frequency [Hz]
%
% @return distance from the object [m]
%
% Function contains a few attributes that can be tuned.
%======================================================%

function [distance, pingFiltered] = sonarDistance(ping, Fs, Fb)

%==================== Configuration ===================%

% Filter's bandwidth [% of the Fs]
BW = 0.01;

% Filter's roll-off [% of the Fs]
rollOff = 0.01;

% Spectrogram Parameters
WinLen = 0.0025 * Fs;
NTFFT = 0.0025 * Fs;
WinOverlap = WinLen / 2;

% Threshold for the ping's echo detection
THRESHOLD = 100;

% Assumpted sound velocity [m/s]
SOUND_VELOCITY =  343;

%===================== Computation ====================%

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

% Get the spectrogramm
[~, ~, T, P] = spectrogram(pingFiltered, WinLen, WinOverlap, NTFFT, Fs, 'MinThreshold', -100, 'yaxis'); 

% Find the first non-zero chunk of the PSD (Power Spectral Density)
%
% @note : If we initialize previousChunk with a zero vector, the
%         first non-zero chunk will meet the THRESHOLD and object
%         will be mistakenly detected
for time_index = 2:size(P, 2)
   if norm(P(:, time_index)) ~= 0
      previousChunk =  P(:, time_index);
      break
   end
   previousChunk =  P(:, end);
end

% Search the band
for time_index = 2:size(P, 2)
    
    % Get the chunk (set of samples at the given moment)
    actualChunk = P(:, time_index);
    
    % Compare magnitudes of the actual chunk and the previous one
    if norm(actualChunk) > norm(previousChunk) * THRESHOLD
       break 
    end
    
    % Update previous chunk
    previousChunk = actualChunk;
end

% Get the moment of the detected ping [s]
time = T(time_index);

% Compute distance from the object [m]
distance = SOUND_VELOCITY * time / 2;

end

