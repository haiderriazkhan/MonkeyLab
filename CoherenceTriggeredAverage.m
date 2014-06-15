% Generates plots depicting the average repsonse of Single Units and 
% Multi Units to a motionstimulus condition. The plots are compiled to two
% postscript files one each for Single Units and Multi Units.
%
% Haider Riaz - haider.riaz@mail.mcgill.ca
% McIntyre Medical Building Room 1225
% Department of Physiology, McGill University
%
% Created by Haider Riaz 2014.

function  CoherenceTriggeredAverage(DataStruct , e , Session)

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





%% Initializing Variables

NofTrials = length(DataStruct.Trials);

CoherenceTrigAverage.Trode1 = struct;

CoherenceTrigAverage.Trode2 = struct;

%% Trode 1 %%%

CoherenceTrigAverage.Trode1(1).CohLevel = -1;

for j=1:length(Trode1)
    
    CoherenceTrigAverage.Trode1(1).SU(j , 1).SingleUnits = zeros(10001 , NofTrials);
    
end

CoherenceTrigAverage.Trode1(1).MU = zeros(10001 , NofTrials);

CoherenceTrigAverage.Trode1(1).Counter = 0;


CoherenceTrigAverage.Trode1(2).CohLevel = 0;

for j=1:length(Trode1)
    
    CoherenceTrigAverage.Trode1(2).SU(j,1).SingleUnits = zeros(10001 , NofTrials);
    
end

CoherenceTrigAverage.Trode1(2).MU = zeros(10001 , NofTrials);

CoherenceTrigAverage.Trode1(2).Counter = 0;

for i=1:length(DataStruct.coh1)
    
    CoherenceTrigAverage.Trode1(i+2).CohLevel = DataStruct.coh1(i);
    
    for j=1:length(Trode1)
        
        CoherenceTrigAverage.Trode1(i+2).SU(j , 1).SingleUnits = zeros(10001 , NofTrials);
        
    end
    
    CoherenceTrigAverage.Trode1(i+2).MU = zeros(10001 , NofTrials);
    
    CoherenceTrigAverage.Trode1(i+2).Counter = 0;
    
    
end




%% Trode 2 %%%

CoherenceTrigAverage.Trode2(1).CohLevel = -1;

for j=1:length(Trode2)
    
    CoherenceTrigAverage.Trode2(1).SU(j , 1).SingleUnits = zeros(10001 , NofTrials);
    
end

CoherenceTrigAverage.Trode2(1).MU = zeros(10001 , NofTrials);

CoherenceTrigAverage.Trode2(1).Counter = 0;


CoherenceTrigAverage.Trode2(2).CohLevel = 0;

for j=1:length(Trode2)
    
    CoherenceTrigAverage.Trode2(2).SU(j , 1).SingleUnits = zeros(10001 , NofTrials);
    
end

CoherenceTrigAverage.Trode2(2).MU = zeros(10001 , NofTrials);

CoherenceTrigAverage.Trode2(2).Counter = 0;


for i=1:length(DataStruct.coh2)
    
    CoherenceTrigAverage.Trode2(i+2).CohLevel = DataStruct.coh2(i);
    
    for j=1:length(Trode2)
        
        CoherenceTrigAverage.Trode2(i+2).SU(j , 1).SingleUnits = zeros(10001 , NofTrials);
        
    end
    
    CoherenceTrigAverage.Trode2(i+2).MU = zeros(10001 , NofTrials);
    
    CoherenceTrigAverage.Trode2(i+2).Counter = 0;
    
end

Length = length(DataStruct.Trials);


for i=1:Length
    
    try
        
        if(length(DataStruct.Trials(i , 1).SU(Trode1(1),1).SingleUnits) ~= length(DataStruct.Trials(i , 1).SU(Trode2(1), 1).SingleUnits))
            
            disp('Lengths are different!');
            disp(i);
            continue;
            
        end
        
    catch err
        
        if(length(DataStruct.Trials(i , 1).MU{1,1}) ~= length(DataStruct.Trials(i , 1).MU{2,1}))
            
            disp('Lengths are different!');
            disp(i);
            continue;
            
        end
        
        
    end
    
    if(e(Session,1).nneur ~= 0)
        SUTrode1 = zeros(10001 , length(Trode1));
        SUTrode2 = zeros(10001 , length(Trode2));
    end
    
    MUTrode1 = zeros(10001 , 1);
    MUTrode2 = zeros(10001 , 1);
    
    CoherencePulseTime = DataStruct.Trials(i , 1).signalOn;
    
    
    if(CoherencePulseTime == -1)
        % No coherent motion pulse occurred in this trial.
        continue;
        
    end
    
    TimeDiffMs = DataStruct.Trials(i , 1).SampleZero - double(DataStruct.Trials(i , 1).startTime);
    
    CoherencePulseTime = double(CoherencePulseTime);
    
    
    index = ((CoherencePulseTime - TimeDiffMs)/DataStruct.TimingMs(1,1)) + 1;
    
    index = int64(index);
    
    try
        
        if(index > length(DataStruct.Trials(i , 1).SU(Trode1(1) , 1).SingleUnits) )
            
            disp(i);
            continue;
            
        end
        
    catch err
        
        if(index > length(DataStruct.Trials(i , 1).MU{1,1}) )
            
            disp(i);
            continue;
            
        end
        
    end
    
    try
        
        if(index > length(DataStruct.Trials(i , 1).SU(Trode2(1) , 1).SingleUnits) )
            disp(i);
            continue;
            
        end
        
    catch err
        
        if(index > length(DataStruct.Trials(i , 1).MU{2,1}) )
            disp(i);
            continue;
            
        end
        
    end
    
    
    
    if((index-5000) > 0)
        
        for j=1:length(Trode1)
            
            if(~isempty(DataStruct.Trials(i , 1).SU(Trode1(j) , 1).SingleUnits))
                
                SUTrode1(1:5001 , j) = DataStruct.Trials(i , 1).SU(Trode1(j) , 1).SingleUnits((index-5000):index,1);
           
            else
                
                SUTrode1(1:5001 , j) = NaN;
                
            end
            
        end
        
        for j=1:length(Trode2)
            
            if(~isempty(DataStruct.Trials(i , 1).SU(Trode2(j) , 1).SingleUnits))
                
                SUTrode2(1:5001 , j) = DataStruct.Trials(i , 1).SU(Trode2(j) , 1).SingleUnits((index-5000):index,1);
               
            else
                
                SUTrode2(1:5001 , j) = NaN;
                
            end
            
        end
        
        MUTrode1(1:5001 , 1) = DataStruct.Trials(i , 1).MU{1,1}((index-5000):index,1);
        MUTrode2(1:5001 , 1) = DataStruct.Trials(i , 1).MU{2,1}((index-5000):index,1);
        
    else
        
        residual = (5000 - index) + 2;
        
        for j=1:length(Trode1)
            
            if(~isempty(DataStruct.Trials(i , 1).SU(Trode1(j) , 1).SingleUnits))
                
                SUTrode1(residual:5001 , j) = DataStruct.Trials(i , 1).SU(Trode1(j) , 1).SingleUnits(1:index,1);
            
            else
                
                SUTrode1(residual:5001 , j) = NaN;
                
            end
            
        end
        
        for j=1:length(Trode2)
            
            if(~isempty(DataStruct.Trials(i , 1).SU(Trode2(j) , 1).SingleUnits))
                
                SUTrode2(residual:5001 , j) = DataStruct.Trials(i , 1).SU(Trode2(j) , 1).SingleUnits(1:index,1);
           
            else
                
                SUTrode2(residual:5001 , j) = NaN;
                
            end
            
        end
        
        MUTrode1(residual:5001 , 1) = DataStruct.Trials(i , 1).MU{1,1}(1:index,1);
        MUTrode2(residual:5001 , 1) = DataStruct.Trials(i , 1).MU{2,1}(1:index,1);
        
        for j=1:length(Trode1)
            
            
            SUTrode1(1:(residual-1) , j) = NaN;
            
        end
        
        for j=1:length(Trode2)
            
            
            SUTrode2(1:(residual-1) , j) = NaN;
            
            
        end
        
        MUTrode1(1:(residual-1) , 1) = NaN;
        MUTrode2(1:(residual-1) , 1) = NaN;
        
        
        
    end
    
    
    if((index+5000) <= length(DataStruct.Trials(i , 1).MU{1,1}))
        
        for j=1:length(Trode1)
            
            if(~isempty(DataStruct.Trials(i , 1).SU(Trode1(j) , 1).SingleUnits))
                
                SUTrode1(5001:10001 , j) = DataStruct.Trials(i , 1).SU(Trode1(j) , 1).SingleUnits(index:(index+5000),1);
                
            else
                
                SUTrode1(5001:10001 , j) = NaN;
                
            end
            
        end
        
        MUTrode1(5001:10001 , 1) = DataStruct.Trials(i , 1).MU{1,1}(index:(index+5000),1);
        
        for j=1:length(Trode2)
            
            if(~isempty(DataStruct.Trials(i , 1).SU(Trode2(j) , 1).SingleUnits))
                
                SUTrode2(5001:10001 , j) = DataStruct.Trials(i , 1).SU(Trode2(j) , 1).SingleUnits(index:(index+5000),1);
            
            else
                
                SUTrode2(5001:10001 , j) = NaN;
                
            end
            
        end
        
        MUTrode2(5001:10001 , 1) = DataStruct.Trials(i , 1).MU{2,1}(index:(index+5000),1);
        
        
    else
        
        try
            residual = length(DataStruct.Trials(i , 1).SU(1,1).SingleUnits) - index;
        catch err
            residual = length(DataStruct.Trials(i , 1).MU{1,1}) - index;
        end
        
        for j=1:length(Trode1)
            
            if(~isempty(DataStruct.Trials(i , 1).SU(Trode1(j) , 1).SingleUnits))
                
                SUTrode1(5001:(5001+residual) , j) = DataStruct.Trials(i , 1).SU(Trode1(j) , 1).SingleUnits(index:length(DataStruct.Trials(i , 1).SU(Trode1(j),1).SingleUnits),1);
                
            else
                
                SUTrode1(5001:(5001+residual) , j) = NaN;
                
            end
            
        end
        
        MUTrode1(5001:(5001+residual) , 1) = DataStruct.Trials(i , 1).MU{1,1}(index:length(DataStruct.Trials(i , 1).MU{1,1}),1);
        
        for j=1:length(Trode2)
            
            if(~isempty(DataStruct.Trials(i , 1).SU(Trode2(j) , 1).SingleUnits))
                
                SUTrode2(5001:(5001+residual) , j) = DataStruct.Trials(i , 1).SU(Trode2(j) , 1).SingleUnits(index:length(DataStruct.Trials(i , 1).SU(Trode2(j),1).SingleUnits),1);
                
            else
                
                SUTrode2(5001:(5001+residual) , j) = NaN;
                
            end
            
        end
        
        MUTrode2(5001:(5001+residual) , 1) = DataStruct.Trials(i , 1).MU{2,1}(index:length(DataStruct.Trials(i , 1).MU{2,1}),1);
        
        for j=1:length(Trode1)
            
            
            SUTrode1((5002+residual):10001 , j) = NaN;
            
            
        end
        MUTrode1((5002+residual):10001 , 1) = NaN;
        
        for j=1:length(Trode2)
            
            
            SUTrode2((5002+residual):10001 , j) = NaN;
            
            
        end
        
        MUTrode2((5002+residual):10001 , 1) = NaN;
        
    end
    
    
    
    
    CohLevelTrode1 = DataStruct.Trials(i , 1).coh1;
    
    if(CohLevelTrode1 == -1)
        
        CoherenceTrigAverage.Trode1(1).Counter = CoherenceTrigAverage.Trode1(1).Counter + 1;
        
        for j=1:length(Trode1)
            
            CoherenceTrigAverage.Trode1(1).SU(j , 1).SingleUnits(: , CoherenceTrigAverage.Trode1(1).Counter) = SUTrode1(: , j);
        end
        CoherenceTrigAverage.Trode1(1).MU(: , CoherenceTrigAverage.Trode1(1).Counter) = MUTrode1;
        
    elseif(CohLevelTrode1 == 0)
        
        CoherenceTrigAverage.Trode1(2).Counter = CoherenceTrigAverage.Trode1(2).Counter + 1;
        
        for j=1:length(Trode1)
            CoherenceTrigAverage.Trode1(2).SU(j , 1).SingleUnits(: , CoherenceTrigAverage.Trode1(2).Counter) = SUTrode1(: , j);
        end
        
        CoherenceTrigAverage.Trode1(2).MU(: , CoherenceTrigAverage.Trode1(2).Counter) = MUTrode1;
        
    else
        
        CaseTrode1 = CohLevelTrode1 + 2;
        
        CoherenceTrigAverage.Trode1(CaseTrode1).Counter = CoherenceTrigAverage.Trode1(CaseTrode1).Counter + 1;
        
        for j=1:length(Trode1)
            
            CoherenceTrigAverage.Trode1(CaseTrode1).SU(j,1).SingleUnits(: , CoherenceTrigAverage.Trode1(CaseTrode1).Counter) = SUTrode1(: , j);
        end
        CoherenceTrigAverage.Trode1(CaseTrode1).MU(: , CoherenceTrigAverage.Trode1(CaseTrode1).Counter) = MUTrode1;
        
        
    end
    
    
    CohLevelTrode2 = DataStruct.Trials(i , 1).coh2;
    
    
    
    if(CohLevelTrode2 == -1)
        
        CoherenceTrigAverage.Trode2(1).Counter = CoherenceTrigAverage.Trode2(1).Counter + 1;
        
        for j=1:length(Trode2)
            
            CoherenceTrigAverage.Trode2(1).SU(j,1).SingleUnits(: , CoherenceTrigAverage.Trode2(1).Counter) = SUTrode2(:,j);
        end
        CoherenceTrigAverage.Trode2(1).MU(: , CoherenceTrigAverage.Trode2(1).Counter) = MUTrode2;
        
    elseif(CohLevelTrode2 == 0)
        
        CoherenceTrigAverage.Trode2(2).Counter = CoherenceTrigAverage.Trode2(2).Counter + 1;
        
        for j=1:length(Trode2)
            
            CoherenceTrigAverage.Trode2(2).SU(j,1).SingleUnits(: , CoherenceTrigAverage.Trode2(2).Counter) = SUTrode2(:,j);
        end
        
        CoherenceTrigAverage.Trode2(2).MU(: , CoherenceTrigAverage.Trode2(2).Counter) = MUTrode2;
        
    else
        
        CaseTrode2 = CohLevelTrode2 + 2;
        
        CoherenceTrigAverage.Trode2(CaseTrode2).Counter = CoherenceTrigAverage.Trode2(CaseTrode2).Counter + 1;
        
        for j=1:length(Trode2)
            
            CoherenceTrigAverage.Trode2(CaseTrode2).SU(j,1).SingleUnits(: , CoherenceTrigAverage.Trode2(CaseTrode2).Counter) = SUTrode2(: , j);
        end
        
        CoherenceTrigAverage.Trode2(CaseTrode2).MU(: , CoherenceTrigAverage.Trode2(CaseTrode2).Counter) = MUTrode2;
        
        
    end
    
    
    
    
    
    
end


for j=1:length(CoherenceTrigAverage.Trode1)
    
    for i=1:length(Trode1)
        
        CoherenceTrigAverage.Trode1(j).SU(i,1).SingleUnits = CoherenceTrigAverage.Trode1(j).SU(i,1).SingleUnits(: , 1:CoherenceTrigAverage.Trode1(j).Counter);
        CoherenceTrigAverage.Trode1(j).SU(i,1).SingleUnits = nanmean(CoherenceTrigAverage.Trode1(j).SU(i,1).SingleUnits , 2);
        
    end
    
    CoherenceTrigAverage.Trode1(j).MU = nanmean(CoherenceTrigAverage.Trode1(j).MU , 2);
    
       
end


for j=1:length(CoherenceTrigAverage.Trode2)
    
    for i=1:length(Trode2)
        
        CoherenceTrigAverage.Trode2(j).SU(i,1).SingleUnits = CoherenceTrigAverage.Trode2(j).SU(i,1).SingleUnits(: , 1:CoherenceTrigAverage.Trode2(j).Counter);
        CoherenceTrigAverage.Trode2(j).SU(i,1).SingleUnits = nanmean(CoherenceTrigAverage.Trode2(j).SU(i,1).SingleUnits , 2);
        
    end
    
    CoherenceTrigAverage.Trode2(j).MU = nanmean(CoherenceTrigAverage.Trode2(j).MU , 2);
    
      
end


xAxis = -5000:5000;

PlotCounter = 0;

sigma = (1/DataStruct.TimingMs(1,1)) * 2;
size = 6*sigma;
x = linspace(-size / 2, size / 2, size);
gaussFilter = exp(-x .^ 2 / (2 * sigma ^ 2));
gaussFilter = gaussFilter / sum (gaussFilter); % normalize



for j=1:length(CoherenceTrigAverage.Trode1)
    
    if(CoherenceTrigAverage.Trode1(j).Counter ~= 0)
        
        
        PlotCounter = PlotCounter + 1;
        figure(PlotCounter);
        Title = strcat(num2str(CoherenceTrigAverage.Trode1(j).CohLevel) , ' Percent Coherence Pulse Triggered Averages for Trode 1');
        Name = strcat(DataStruct.exp, ' -' , Title);
        title(Name, 'FontSize', 16)
        
        Legend = cell(length(Trode1) + 1,1);
        hold on
        
        for i=1:length(Trode1)
            yfilt1 = conv(CoherenceTrigAverage.Trode1(j).SU(i,1).SingleUnits ,gaussFilter,'same');
            plot(xAxis , yfilt1 , 'b' , 'linewidth' , 2)
            Legend{i} = 'Single Units';
        end
        
        yfilt2 = conv(CoherenceTrigAverage.Trode1(j).MU ,gaussFilter,'same');
        plot(xAxis , yfilt2 , 'r' , 'linewidth' , 2)
        Legend{length(Trode1)+1} = 'Multi Units';
        legend(Legend , 'Location' , 'NorthWest');
        
        xlabel('Time (0.05 ms)', 'FontSize', 20)
        ylabel('Coherence Triggered Average', 'FontSize', 20)
        print(figure(PlotCounter),'-append','-dpsc2', 'Average Response')
        
        
    end
    
    
    
end


sigma = (1/DataStruct.TimingMs(1,1))*2;
size = 6*sigma;
x = linspace(-size / 2, size / 2, size);
gaussFilter = exp(-x .^ 2 / (2 * sigma ^ 2));
gaussFilter = gaussFilter / sum (gaussFilter); % normalize




for j=1:length(CoherenceTrigAverage.Trode2)
    
    if(CoherenceTrigAverage.Trode2(j).Counter ~= 0)
        
        
        PlotCounter = PlotCounter + 1;
        figure(PlotCounter);
        Title = strcat(num2str(CoherenceTrigAverage.Trode2(j).CohLevel) , ' Percent Coherence Pulse Triggered Averages for Trode 2');
        Name = strcat(DataStruct.exp, ' -' , Title);
        title(Name, 'FontSize', 16)
       
        
        Legend = cell(length(Trode2) + 1,1);
        hold on
        
        for i=1:length(Trode2)
            yfilt1 = conv(CoherenceTrigAverage.Trode2(j).SU(i,1).SingleUnits , gaussFilter,'same');
            plot(xAxis , yfilt1 , 'b' , 'linewidth' , 2)
            Legend{i} = 'Single Units';
        end
        
        yfilt2 = conv(CoherenceTrigAverage.Trode2(j).MU,gaussFilter,'same');
        plot(xAxis , yfilt2 , 'r' , 'linewidth' , 2)
        Legend{length(Trode2)+1} = 'Multi Units';
        legend(Legend, 'Location', 'NorthWest');
        
        
        xlabel('Time (0.05 ms)', 'FontSize', 20)
        ylabel('Coherence Triggered Average', 'FontSize', 20)
        print(figure(PlotCounter),'-append','-dpsc2', 'Average Response')
        
        
    end
    
    
    
end


end

