% Function for generating Root Mean Sqaure plots for SingleUnits and MultiUnits
% The plots are concatenated into two postscript files (one each for SU and MU)
%
% Haider Riaz - haider.riaz@mail.mcgill.ca
% McIntyre Medical Building Room 1225
% Department of Physiology, McGill University
%
% Created by Haider Riaz 2014.


function RootMeanSqaure(RawWaveforms , MultiUnits, e , Session)

%% Determining the indices of Single Units corresponding to Trode 1 and 2
Trode1 = [];
Trode2 = [];

if(e(Session,1).nneur ~= 0)
    
    for i=1:length(e(Session , 1).neur)
        
        if(e(Session , 1).neur(i , 1).trode == 1)
            
            Trode1(end+1) = i;
            
        else
            
            Trode2(end+1) = i;
        end
        
    end
    
end


%% Session Name

Name = e(Session , 1).exp;


%% Initializing Variables

TimingMs = e(Session).H(1);
RMS1 = zeros(201 , length(Trode1)+1);
RMS2 = zeros(201 , length(Trode2)+1);
n = 0;

%% For Loop to iterate through the trials and compute spike triggered averages for each.


for i=1:length(MultiUnits)
    
    disp(i);
    
    [FiltTrode1 , FiltTrode2] = FilterWaveforms(RawWaveforms, e , Session, MultiUnits(i).TrialNum, 2 );
    
    TimeDiffMs = e(Session,1).ev(MultiUnits(i).TrialNum,1).SampleZero - double(e(Session,1).ev(MultiUnits(i).TrialNum,1).startTime);
    
    %% Multi Units
    
    MU1 = MultiUnits(i).Trode1;
    
    MU2 = MultiUnits(i).Trode2;
    
    MU1_Times = find(MU1);
    MU2_Times = find(MU2);
    
    MU1_Times = (MU1_Times-1).*TimingMs;
    MU2_Times = (MU2_Times-1).*TimingMs;
    
    MU1_Times = MU1_Times + TimeDiffMs;
    MU2_Times = MU2_Times + TimeDiffMs;
    
    
    if(~isempty(MU1_Times))
        MUTriggeredAverageTrode1 = sta(MU1_Times, FiltTrode1, TimingMs , TimeDiffMs);
    else
        
        MUTriggeredAverageTrode1 = zeros(201 , 1);
    end
    
    if(~isempty(MU2_Times))
        MUTriggeredAverageTrode2 = sta(MU2_Times, FiltTrode2, TimingMs , TimeDiffMs);
    else
        MUTriggeredAverageTrode2 = zeros(201 , 1);
    end
    
    SpikeTriggeredAverages1(: , 1) = nanmean(MUTriggeredAverageTrode1 , 2);
    SpikeTriggeredAverages2(: , 1) = nanmean(MUTriggeredAverageTrode2 , 2);
    
    %% Single Units
    
    for j=1:length(Trode1)
        JacksonSpikesTrode1 = e(Session,1).neur(Trode1(j),1).times(MultiUnits(i).TrialNum,1).ms;
        Intermediate = sta(JacksonSpikesTrode1, FiltTrode1, TimingMs , TimeDiffMs);
        SpikeTriggeredAverages1(: , j+1) = nanmean(Intermediate , 2);
    end
    
    for j=1:length(Trode2)
        JacksonSpikesTrode2 = e(Session,1).neur(Trode2(j),1).times(MultiUnits(i).TrialNum,1).ms;
        Intermediate = sta(JacksonSpikesTrode2, FiltTrode2, TimingMs , TimeDiffMs);
        SpikeTriggeredAverages2(: , j+1) = nanmean(Intermediate , 2);
    end
    
    
    
    
    %% Adding the spike triggered averages to the RMS matrix
    n = n + 1;
    
    SpikeTriggeredAverages1(isnan(SpikeTriggeredAverages1)) = 0;
    
    SpikeTriggeredAverages2(isnan(SpikeTriggeredAverages2)) = 0;
    
    SpikeTriggeredAverages1 = SpikeTriggeredAverages1.^2;
    
    SpikeTriggeredAverages2 = SpikeTriggeredAverages2.^2;
    
    RMS1 = RMS1 + SpikeTriggeredAverages1;
    
    RMS2 = RMS2 + SpikeTriggeredAverages2;
    
end


RMS1 = RMS1/n;

RMS2 = RMS2/n;

RMS1 = sqrt(RMS1);

RMS2 = sqrt(RMS2);

xAxis = -100:100;

%% Plots

figure(1);
Title = strcat(Name , ' Spike Triggered Averages Trode 1');
title(Title, 'FontSize', 22)
Legend = cell(length(Trode1) + 1,1);
hold on
for j=1:length(Trode1)
    plot(xAxis , RMS1(: , j+1) , 'b')
    Legend{j} = 'Single Units';
end
plot(xAxis , RMS1(: , 1) , 'r')
Legend{length(Trode1)+1} = 'Multi Units';
legend(Legend);
xlabel('Time (0.05 ms)', 'FontSize', 20)
ylabel('Normalized Triggered Average', 'FontSize', 20)
print(figure(1),'-append','-dpsc2', 'SpikeTrigAverages')


figure(2);
Title = strcat(Name , ' Spike Triggered Averages Trode 2');
title(Title, 'FontSize', 22)
Legend = cell(length(Trode2) + 1,1);
hold on
for j=1:length(Trode2)
    plot(xAxis , RMS2(: , j+1) , 'b')
    Legend{j} = 'Single Units';
end
plot(xAxis , RMS2(: , 1) , 'r')
Legend{length(Trode2)+1} = 'Multi Units';
legend(Legend);
xlabel('Time (0.05 ms)', 'FontSize', 20)
ylabel('Normalized Triggered Average', 'FontSize', 20)
print(figure(2),'-append','-dpsc2', 'SpikeTrigAverages')




end
