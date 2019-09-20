function spks = alignSpikes2(timestamps, timeMarkers, timeZero, bin)
% Align spikes in trial structure based on 2 time markers (start and end
% for each trial)
% Output 
%   spks: 1 x no. of trials/timeMarkers cell array of time stamps/ binned 
%       spikes aligned to timeMarkers
% Inputs
%   timestamps: vector of time stamps
%   timeMarkers: no. of trials x 2 (start,end) of time markers in s to align spikes
%   timeZero: time where time 0 for each trial should be
%   bin: binsize for binned spikes. If bin = 0, output will be time stamps
% LG 7/2/2019

if nargin == 3
    bin = 0;
end
spks = cell(1,size(timeMarkers,1));
for i = 1:size(timeMarkers,1)
    spks{i} = timestamps(timestamps>=timeMarkers(i,1) & ...
        timestamps<=timeMarkers(i,2)) - ...
        timeZero(i);
    if bin > 0
        spks{i} = histcounts(spks{i}, (timeMarkers(i,1)-timeZero(i)):bin:(timeMarkers(i,2)-timeZero(i)));
    end
end