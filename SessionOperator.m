% Function for computing MultiUnits from raw waveforms
% The function is custom made for use in Erik Cook's lab and is compatible
% with experiments performed with two microelectrodes placed in separate  
% recpeptive fields in area MT.
%
% Haider Riaz - haider.riaz@mail.mcgill.ca
% McIntyre Medical Building Room 1225
% Department of Physiology, McGill University
%
% Created by Haider Riaz 2014.




function [MultiUnit, Info] = SessionOperator(RawWaveforms , e , Session, RandTrial)

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





%% Get Initial Thresholds - Use any reasonable Trial
[FiltTrode1 , FiltTrode2] = FilterWaveforms(RawWaveforms, e , Session, RandTrial , 2 );

MaxTrode1 = max(FiltTrode1(: , 1))/2;
MaxTrode2 = max(FiltTrode2(: , 1))/2;




%% Initializing Variables

Threshold1 = MaxTrode1;
Threshold2 = MaxTrode2;
IterationStepTrode1 = MaxTrode1/1000;
IterationStepTrode2 = MaxTrode2/1000;
MU_Counter1 = 0;
MU_Counter2 = 0;

ConditionalTrode1 = 1;
ConditionalTrode2 = 1;



while(ConditionalTrode1 || ConditionalTrode2)
    
    TotalMUTrode1 = 0;
    TotalMUTrode2 = 0;
    TotalTimeTrode1 = 0;
    TotalTimeTrode2 = 0;
    
    for i=1:numel(e(Session,1).ev)
        
        
        
        [FiltTrode1 , FiltTrode2, TrialTime1, TrialTime2 ] = FilterWaveforms(RawWaveforms, e , Session, i, 2 );
        
        if(isempty(TrialTime1) && isempty(TrialTime2))
            
            continue;
            
        end
        
        
        MU1 = MultiUnits(e , Session, Trode1, i, FiltTrode1, Threshold1);
        
        MU2 = MultiUnits(e , Session, Trode2, i, FiltTrode2, Threshold2);
        
        TotalTimeTrode1 = TotalTimeTrode1 + TrialTime1;
        
        TotalTimeTrode2 = TotalTimeTrode2 + TrialTime2;
        
        indices1 = find(MU1);
        NoMU1 = length(indices1);
        indices2 = find(MU2);
        NoMU2 = length(indices2);
        
        TotalMUTrode1 = TotalMUTrode1 + NoMU1;
        TotalMUTrode2 = TotalMUTrode2 + NoMU2;
        
        
        
    end
    
    
    MU_Counter1 = TotalMUTrode1/TotalTimeTrode1;
    MU_Counter2 = TotalMUTrode2/TotalTimeTrode2;
    
    if((MU_Counter1 < 10) && (Threshold1 > 0))
        
        Threshold1 = Threshold1 - (150*IterationStepTrode1);
        
    elseif((MU_Counter1 < 100) && (Threshold1 > 0))
        
        Threshold1 = Threshold1 - (40*IterationStepTrode1);
        
    elseif((MU_Counter1 < 155) && (Threshold1 > 0))
        
        Threshold1 = Threshold1 - (10*IterationStepTrode1);
        
    elseif((MU_Counter1 < 175) && (Threshold1 > 0))
        
        Threshold1 = Threshold1 - (5*IterationStepTrode1);
        
    elseif((MU_Counter1 < 195) && (Threshold1 > 0))
        
        Threshold1 = Threshold1 - IterationStepTrode1;
        
    elseif((MU_Counter1 < 200) && (Threshold1 > 0))
        
        Threshold1 = Threshold1 - (IterationStepTrode1/2);
        
    else
        
        ConditionalTrode1 = 0;
        
    end
    
    if((MU_Counter2 < 10) && (Threshold2 > 0))
        
        Threshold2 = Threshold2 - (150*IterationStepTrode2);
        
    elseif((MU_Counter2 < 100) && (Threshold2 > 0))
        
        Threshold2 = Threshold2 - (40*IterationStepTrode2);
        
    elseif((MU_Counter2 < 155) && (Threshold2 > 0))
        
        Threshold2 = Threshold2 - (10*IterationStepTrode2);
        
    elseif((MU_Counter2 < 175) && (Threshold2 > 0))
        
        Threshold2 = Threshold2 - (5*IterationStepTrode2);
        
    elseif((MU_Counter2 < 195) && (Threshold2 > 0))
        
        Threshold2 = Threshold2 - IterationStepTrode2;
        
    elseif((MU_Counter2 < 200) && (Threshold2 > 0))
        
        Threshold2 = Threshold2 - (IterationStepTrode2/2);
        
    else
        
        ConditionalTrode2 = 0;
        
    end
    
    disp(MU_Counter1);
    disp(MU_Counter2);
    
end


NumberOfJacksonTrials = length(e(Session,1).ev);
n = 0;
FlaggedTrials = [];
MultiUnit(NumberOfJacksonTrials).TrialNum = [];
MultiUnit(NumberOfJacksonTrials).Trode1 = [];
MultiUnit(NumberOfJacksonTrials).Trode2 = [];


for i=1:numel(e(Session,1).ev)

        
    disp(i);
    
    
    [FiltTrode1 , FiltTrode2] = FilterWaveforms(RawWaveforms, e , Session, i, 2 );
    
    if(isempty(FiltTrode1) || isempty(FiltTrode2))
       
        FlaggedTrials(end+1) = i;
        continue;
        
        
    end
    
    MU1 = MultiUnits(e , Session, Trode1, i, FiltTrode1, Threshold1);
    
    MU2 = MultiUnits(e , Session, Trode2, i, FiltTrode2, Threshold2);
    
    
    n = n + 1;
    
    MultiUnit(n).TrialNum = i;
    MultiUnit(n).Trode1 = MU1;
    MultiUnit(n).Trode2 = MU2;
    
    
    
    
end


MultiUnit = MultiUnit(1:n);


FlaggedTrials = FlaggedTrials';

Info.FlaggedTrials = FlaggedTrials;
Info.Thresholds(1 , 1) = Threshold1;
Info.Thresholds(1 , 2) = MU_Counter1;
Info.Thresholds(2 , 1) = Threshold2;
Info.Thresholds(2 , 2) = MU_Counter2;





end