clearvars -except Filters Records FilteredRecords
clc

%=============================================================%
%====================== Configuration ========================%
%=============================================================%

% If set to true computations are not performed;
% only the spectrogram from the previous run is printed
PrintOnly = true;

% Index of the record (index in the 'RecordNames' array) to
% be plotted at the spectrogram
RecordToPrint = 3;

% Index of the filter (row of the index in the 'FiltersParams' array)
% to be plotted at the spectrogram. If the 0 is given, the
% original record will be printed.
FilterToPrint = 5;

% Spectrogram parameters
WinLen = 512;
WinOverlap = 256;
NTFFT = 512;

%-------------------------------------------------------------%

if not(PrintOnly)

    % Record's names (all should be placed in the 'data' folder)
    RecordsNames = [
        'record_1.m4a';
        'record_2.m4a';
        'record_3.m4a'
    ];

    % Filters' parameters (frequencies in [Hz]). Subsequent
    % rows conatain parameters for a single filter each.
    %
    % I column   : filter's type
    % II column  : cut-off frequency / frequencies [Hz]
    %              For 'LowPass' and 'HighPass' filters, the
    %              second frequency is not taken int account.
    %              First value describes the lower cut-off, when
    %              the second the higher one.
    % III column : roll-off width [Hz] 
    %
    % @note : cut-off frequencies and roll-offs cannot be higher
    %         than 0.5*Fs. For more details @see FilterFIR.
    FiltersParams = [
        {'LowPass',     [500;  0],  10};
        {'BandPass', [500;  1500],  10};
        {'BandPass', [1500; 3500],  10};
        {'BandPass', [3500; 7500],  10};
        {'HighPass',    [7500; 0],  10}
    ];


    %=============================================================%
    %====================== Initialization =======================%
    %=============================================================%

    % Create all filters
    Filters = cell(size(FiltersParams, 1), 1);
    for i = 1:size(Filters, 1)
       Filters{i} = FilterFIR( ...
                       FiltersParams{i, 1}, ...
                       2 * FiltersParams{size(FiltersParams, 1), 2}(1) + 1, ...
                       FiltersParams{i, 2}, ...
                       FiltersParams{i, 3} ...
                   );
    end

    % Load all records
    Records = cell(size(RecordsNames, 1), 2);
    for i = 1:size(RecordsNames, 1)
        [Records{i, 1}, Records{i, 2}] = audioread(strcat('data/', RecordsNames(i, :)));
    end

    %=============================================================%
    %======================= Computation =========================%
    %=============================================================%

    % Filter all records with all filters. 'FilteredRecords' 
    % cell array conatins:
    %
    % Rows )    subsequent records
    % Columns ) subsequent frequency ranges
    % Cells )   [X, 2] arrays containing filtered records for both
    %           left and right channels
    %
    FilteredRecords = cell(size(Records, 1), size(Filters, 1));
    for i = 1:size(Records, 1)

        % Get the sampling frequency to adjust filter
        Fs = Records{i, 2};

        for j = 1:size(Filters, 1)

            % Update sampling frequency
            Filters{j}.Fs = Fs;
            % Get the filter's impulse response
             h = Filters{j}.getImpulseResponse()';

            % Filter left channel
            left = conv(Records{i, 1}(:, 1), h);

            % Filter right channel
            right = conv(Records{i, 1}(:, 2), h);


            % Save both channels
            FilteredRecords{i, j} = [left right];
            % Trim filtered record to get rid of disturbed edges
            % (periods when convolution has been taking samples
            % from the outside of the record's range)
            FilteredRecords{i, j} = ...
                FilteredRecords{i, j}(size(h, 1) : (end - size(h, 1)), :);

        end
    end

% PrintOnly end
end 
    
%=============================================================%
%========================= Plotting ==========================%
%=============================================================%

if FilterToPrint == 0
   spectrogram( ...
       Records{RecordToPrint, 1}(:, 1), ...
       WinLen, WinOverlap, NTFFT, ...
       Records{RecordToPrint, 2}, ...
       'MinThreshold', -100, 'yaxis' ...
   ) 
else
    spectrogram( ...
        FilteredRecords{RecordToPrint, FilterToPrint}(:, 1), ...
        WinLen, WinOverlap, NTFFT, ...
        Records{RecordToPrint, 2}, ...
        'MinThreshold', -100, 'yaxis' ...
    )
end


%=============================================================%
%======================== Cleaning ===========================%
%=============================================================%

clearvars -except Filters Records FilteredRecords