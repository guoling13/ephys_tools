function [badchans,badtrials] = visualizeTrialData(trial_data)
% Visualize raw LFP data and mark bad trials and channels
% input: trial_data channel x time x trial
% Updated 5/17/18 by LG: now marks both bad trials and channels, instead of
%   just trials

%% Initialize variables
% trial_data(badchans,:,:)=[]; % remove bad chans
sz=size(trial_data);
exit=0;
n=1;
badtrials=[];
badchans=[];

%% GUI figure
fig = figure('units','normalized','outerposition',[0.1 0.1 .8 .8],'KeyPressFcn',@keyPress_callback);
ax = axes('Position',[0.05 0.15 0.8 0.75]);
global p
setPlot;
hold on
uicontrol('style','text','string','Bad trials','position',[50 50 80 20],'backgroundcolor',[.8 .8 .8]);
markerframes(1)=uicontrol('style','text','string','','HorizontalAlignment','left','position',[50 25 200 20]);

% channel check boxes
uicontrol('style','text','string','Bad channels','position',[1350 725 100 20],'backgroundcolor',[.8 .8 .8]);
for i = 1:sz(1)
    if i <=32
        buttons(i) = uicontrol('style','checkbox','position',[1350 700-(i-1)*20 40 20], ...
            'FontSize',10,'String',num2str(i));
    else
        buttons(i) = uicontrol('style','checkbox','position',[1410 700-(i-32-1)*20 40 20], ...
            'FontSize',10,'String',num2str(i));
    end
end
set(buttons,'Callback', @hideChannels);
hold off
%% GUI functions

    function keyPress_callback(hObject, eventdata)
        button = double(fig.CurrentCharacter);
        switch button
            case 32 % space
                if sum(badtrials == n)
                    badtrials(badtrials==n)=[];
                else
                    badtrials=[badtrials, n];
                end
                set(markerframes(1),'string',num2str(badtrials));
            case 28 % left
                n=n-1;
            case 29 % right
                n=n+1;
            case 101 % e to exit
                exit=1;
        end
        if n>sz(3)
            exit=1;
        end
        if n<1
            n=1;
        end
        if exit
            badchans = sort(badchans);
            assignin('base','badtrials',badtrials);
            assignin('base','badchans',badchans);
            close(fig);
        else
            setPlot;
        end
    end

    function setPlot
        p(1) = plot(trial_data(1,:,n));
        hold on
        for c = 2:sz(1)
            p(c) = plot(trial_data(c,:,n));
        end
        hold off
        xlim([1 sz(2)])
        title(['Trial ' num2str(n)])
        set(p,'ButtonDownFcn', @LineSelected);
        set(p(badchans), 'Visible', 'off');
    end

    function LineSelected(ObjectH, EventData)
        set(ObjectH, 'Visible', 'off');
        bc = find(p==ObjectH);
        badchans = [badchans;bc];
        set(buttons(bc),'value',1);
    end

    function hideChannels(ObjectH, EventData)
        selectedChan = find(buttons == ObjectH);
        if get(ObjectH,'value')
            badchans = [badchans;selectedChan];
            set(p(selectedChan),'Visible','off');
        elseif get(ObjectH,'value') == 0
            badchans(badchans==selectedChan) = [];
            set(p(selectedChan),'Visible','on');
        end
    end

end