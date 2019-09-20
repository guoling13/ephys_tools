function spks = alignSpikes(timestamps, timeMarkers, timeframe)
% Align spikes in trial structure based on time markers
% Output 
%   spks: 1 x no. of trials/timeMarkers cell array of time stamps aligned
%       to timeMarkers
% Inputs
%   timestamps: vector of time stamps
%   timeMarkers: vector of time markers in s to align spikes
%   timeframe: time to include before and after time 0, in s, e.g. [-2 4]
% LG 7/23/2018

spks = cell(1,length(timeMarkers));
for i = 1:length(timeMarkers)
    spks{i} = timestamps(timestamps>=(timeframe(1)+timeMarkers(i)) & ...
        timestamps<=(timeframe(2)+timeMarkers(i))) - ...
        timeMarkers(i);
end