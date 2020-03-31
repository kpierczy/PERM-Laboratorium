classdef SignalGenerator
    
    properties
        % Sampling frequency [Hz]
        Fs {mustBePositive, mustBeInteger} = 1000
    end
    
    properties (Access = private)
        % Number of components
        N {mustBePositive, mustBeInteger} = 1
        % Components' amplitudes
        amplitudes = 0
        % Components' frequencies
        frequencies = 0
        % Components' phase shifts
        phaseShifts = 0
    end
    
    methods
        
        % Default constructor
        %
        % @param samplingFreq [Hz]
        %
        function obj = SignalGenerator(samplingFreq)
            obj.Fs = samplingFreq;
        end
        
        % Generates signal of a specified length according
        % to set object's properties
        %
        % @param length Signal's length [s]
        %
        function [t_base ,x] = generate(obj, length)
            
            T = length/obj.Fs; % Sampling perios
            t_base = (0:length*obj.Fs - 1) * T; % Time base
            x = zeros(size(t_base));
            for i = 1:obj.N
              x = x + obj.amplitudes(i) * cos(2 * pi * obj.frequencies(i) * t_base + obj.phaseShifts(i));
            end
            
        end
        
        % Sets number of components. Sets all amplitudes,
        % frequencies and phase shifts to 0.
        %
        % @param num
        %
        function obj = setComponentsNum(obj, num)
            
            if num < 1
                error('Number of components have to be positive!')
            else
                obj.N = num;
                obj.amplitudes = zeros(obj.N, 1);
                obj.frequencies = zeros(obj.N, 1);
                obj.phaseShifts = zeros(obj.N, 1);
            end
            
        end
        
        % Sets vector of amplitudes of the components
        %
        % @param amplitudes Vector of size (N, 1) containing
        %                   amplitudes of the subsequent components
        %
        function obj = setAmplitudes(obj, amplitudes)
            
            if size(amplitudes, 1) ~= obj.N
                error('Number of amplitudes does not match number of components!')
            else
                obj.amplitudes = amplitudes;
            end
            
        end
        
        % Sets vector of frequencies [Hz] of the components
        %
        % @param frequencies Vector of size (N, 1) containing
        %                    frequencies of the subsequent components
        %
        function obj = setFrequencies(obj, frequencies)
            
            if size(frequencies, 1) ~= obj.N
                error('Number of frequencies does not match number of components!')
            else
                obj.frequencies = frequencies;
            end
            
        end
        
        % Sets vector of phase shifts of the components
        %
        % @param shifts Vector of size (N, 1) containing
        %               phase shifts of the subsequent components
        %
        function obj = setPhaseShifts(obj, shifts)
            
            if size(shifts, 1) ~= obj.N
                error('Number of phase shifts does not match number of components!')
            else
                obj.phaseShifts = shifts;
            end
            
        end
        
    end
end

