%======================================================%
% Function computes distance from the object basing on
% the registered echo signal.
%
% @param sig : registered echo
% @param Fs : sampling frequency [Hz]
% @param Fb : sonar band's frequency [Hz]
%
% @return distance from the object [m]
%======================================================%
function distance = sonarDistance(sig, Fs, Fb)

%==================== Configuration ===================%

% Spectrogram Parameters
WinLen = 0.0025 * Fs;
NTFFT = 0.0025 * Fs;
WinOverlap = WinLen / 2;

% Width of the range of frequencies around the
% Fb band that will be searched to obtain ping
% signal's echo [Hz]
searchRange = Fb * 0.04;

% Threshold for the ping's echo detection
THRESHOLD = 100;

% Assumpted sound velocity [m/s]
SOUND_VELOCITY =  343;

%===================== Computation ====================%

% Get the spectrogramm
[~, F, T, P] = spectrogram(sig, WinLen, WinOverlap, NTFFT, Fs, 'MinThreshold', -100, 'yaxis'); 

% Get indeces of the P matrix rows that represent 
% a range of frequencies around the sonar band's 
% frequency
L = find(F > Fb - searchRange / 2);
H = find(F < Fb + searchRange / 2);
searchBand = intersect(L, H);

% Search the band
previousChunk = P(searchBand, 1);
for time_index = 2:size(P, 2)
    
    % Get the chunk (set of samples at the given moment)
    actualChunk = P(searchBand, time_index);
    
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

