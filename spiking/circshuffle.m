function p = circshuffle(ts,timewin,binsize,rep)
% performs circular shuffling of spike times locked to event (time 0)
% inputs
%   ts: 1 x no. of trials cell array of spike times 
%   timewin: time window to shuffle e.g. [-2 2]s
%   binsize: binsize in s
%   rep: no. of repetitions

% initialize outputs
t = timewin(1):binsize:timewin(2);
shuffles = nan(rep,length(t));

tottime = timewin(2)-timewin(1);

% get time stamps in time window of interest
ts = cellfun(@(x) x(x>=timewin(1) & x<=timewin(2)),ts,'UniformOutput',0);
ts_peth = hist(cell2mat(ts),t);

for i = 1:rep
    rnd = randi((timewin(2)-timewin(1))*1000,1,length(ts))./1000;
    ts_rnd = cellfun(@(x,y) x+y,ts,num2cell(rnd),'UniformOutput',0);
    ts_rnd = cellfun(@(x) [x(x>timewin(2))-tottime,x(x<=timewin(2))],ts_rnd,'UniformOutput',0);
    shuffles(i,:) = hist(cell2mat(ts_rnd),t);
end

pethm = mean(shuffles);

msedist = bsxfun(@minus,shuffles,pethm);
msedist = mean(msedist.^2,2);

ts_mse = mean((ts_peth-pethm).^2);

p = sum(msedist>ts_mse)/rep;