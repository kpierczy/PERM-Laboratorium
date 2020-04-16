classdef FilterFIR
    
    % ============================================================ %
    % A small class representing sinc-windowed FIR filter.
    % FilterFIR shares a simple interface that makes it able to
    %  - set filter's cut-off frequencies
    %  - set desired roll-off width
    %  - set desired window type
    % ============================================================ %

    properties (Access = private)
        
        % Filter's type. Available types are:
        %  'LowPass'
        %  'HighPass'
        %  'BandPass'
        %  'BandReject'
        Type (1,:) char
    
    end
        
    properties (Access = public)
                 
        % Filter's sampling frequency [Hz]
        Fs (1, 1) uint32 {mustBeInteger, mustBeGreaterThan(Fs, 0)} = 1
    
        % Cut-off frequencies. For 'BandPass' and
        % 'BandReject' Fc holds pair of lower (Fc(1))
        % and higher cut-off frequencies (Fc(2)).
        % 
        % @note It is expressed as a fraction of the
        %       sampling frequency in range [0; 0.5].
        Fc (2, 1) double {mustBeReal, mustBeGreaterThan(Fc, 0), ...
                          mustBeLessThan(Fc, 0.5)} = [0.25; 0.25]
        
        % Roll-off width. For 'BandPass' 
        % and 'BandReject' this value refers to both slopes
        %
        % @note It is expressed as a fraction of the
        %       sampling frequency in range [0; 0.5].
        rollOff (1,1) double {mustBeReal, mustBeNonnegative, ...
                              mustBeLessThanOrEqual(rollOff, 0.5)} = 0.25
        
        % Type of the window being used to smooth the
        % sinc filter. Available windows are:
        %
        % 'blackman'
        % 'hamming'
        % 'hanning'
        %
        % For all windows Matlab function's calls are used
        windowType (1, :) char {mustBeMember(windowType, ...
                                {'blackman', 'hamming', 'hanning'})} ...
                   = 'blackman'
    end
    
    methods (Access = public)
        
        % Constructor; a default window is a 'blackman' window
        % (using Matlab's blackman(M)). To change the window type
        % call obj.windowSet(window_type).
        %
        % @param type : @seeFilterFIR.Type
        % @param fs : @seeFilterFIR.Fs
        % @param fc : Cut-off frequency / frequencies [Hz] 
        %             @seeFilterFIR.Fc
        % @param rolloff : Roll-off width [Hz]
        %                  @seeFilterFIR.rollOff
        %
        % @note Fs and Fc attributes are expressed as a fraction
        % of the sampling frequency, but corresponding arguments
        % to the constructor should be passed in [Hz]
        function obj = FilterFIR(type, fs, fc, rolloff)
            mustBeMember(type, {'LowPass', 'HighPass', ...
                                'BandPass', 'BandReject'})
            obj.Type = type;
            
            mustBeInteger(fs);
            mustBeGreaterThan(fs, 0);
            obj.Fs = fs;
            
            fc = double(fc) / double(obj.Fs);
            mustBeReal(fc);
            mustBeGreaterThan(fc, 0);
            mustBeLessThan(fc, 0.5);
            obj.Fc = fc;
            
            rolloff = double(rolloff) / double(obj.Fs);
            mustBeReal(rolloff);
            mustBeGreaterThan(rolloff, 0);
            mustBeLessThan(rolloff, 0.5);
            obj.rollOff= rolloff;
        end
        
        % Returns impulse response for a configured filter
        function h = getImpulseResponse(obj)
            
            % Call an appropriate function basing on the Type
            switch obj.Type
                case 'LowPass'
                    h = obj.lowPass(obj.Fc(1), obj.rollOff);
                case 'HighPass'
                    h = obj.highPass(obj.Fc(1), obj.rollOff);
                case 'BandPass'
                    h = obj.bandPass(obj.Fc, obj.rollOff);
                case 'BandReject'
                    h = obj.bandReject(obj.Fc, obj.rollOff);
            end
        end
        
        % Returns impulse response for a configured filter
        function H = getFrequencyResponse(obj)
            H = fft(obj.getImpulseResponse());
        end
        
    end
    
    methods (Access = private)
        
        % Returns impulse response of the low-pass filter with 
        % a given parameters (parameters that are not given are 
        % taken from the class' atributes)
        %
        % @param fc : cou-off frequency
        % @param BW : roll-off width
        %
        % @note Both parameters are given as a fraction of the 
        % sampling frequency
        function h = lowPass(obj, fc, BW)

            % Compute kernel's length
            M = floor(4 / BW);
            if rem(M, 2) ~= 0
               M = M + 1; 
            end

            % Initialize kernel with a K parameter equal to 1
            n = 0 : M;
            switch obj.windowType
                case 'blackman'
                    h = sin(2*pi*fc*(n-M/2)) ./ ...
                        (n-M/2) .*...
                        blackman(M + 1)';
                case 'hamming'
                    h = sin(2*pi*fc*(n-M/2)) ./ ...
                        (n-M/2) .*...
                        hamming(M + 1)';
                case 'hanning'
                    h = sin(2*pi*fc*(n-M/2)) ./ ...
                        (n-M/2) .*...
                        hanning(M + 1)';
            end
            h(M/2 + 1) = 2 * pi * fc;

            % Tune K parameter
            h = h / sum(h);
        end
        
        % Returns impulse response of the high-pass filter with 
        % a given parameters (parameters that are not given are 
        % taken from the class' atributes)
        %
        % @param fc : cou-off frequency
        % @param BW : roll-off width
        %
        % @note Both parameters are given as a fraction of the 
        % sampling frequency
        function h = highPass(obj, fc, BW)
           
            % Get low pass filter
            h = obj.lowPass(fc, BW); 
            
            % Compute kernel's length
            M = floor(4 / BW);
            if rem(M, 2) ~= 0
               M = M + 1; 
            end
            
            % Perform spectral inverse
            h = -h;
            h(M/2 + 1) = h(M/2 + 1) + 1;
        end
        
        % Returns impulse response of the band-reject filter with 
        % a given parameters (parameters that are not given are 
        % taken from the class' atributes)
        %
        % @param fc : cou-off frequency ([2; 1] array)
        % @param BW : roll-off width
        %
        % @note Both parameters are given as a fraction of the 
        % sampling frequency
        function h = bandReject(obj, fc, BW)
           
            % Get component filters
            h_low = obj.lowPass(fc(1), BW); 
            h_high = obj.highPass(fc(2), BW); 
            
            % Sum both filters to get the band reject filter 
            h = (h_low + h_high) / 2;
        end
        
        % Returns impulse response of the band-pass filter with 
        % a given parameters (parameters that are not given are 
        % taken from the class' atributes)
        %
        % @param fc : cou-off frequency ([2; 1] array)
        % @param BW : roll-off width
        %
        % @note Both parameters are given as a fraction of the 
        % sampling frequency
        function h = bandPass(obj, fc, BW)
           
            % Get component filters
            h_low = obj.lowPass(fc(2), BW); 
            h_high = obj.highPass(fc(1), BW); 
            
            % Convolve both impulse responses to multiply
            % subsystem's frequency responses
            h = conv(h_low, h_high);
            
        end
        
    end
end

