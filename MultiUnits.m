% Function for computing MultiUnit spikes for a trial and storing them as 
% int8 boolean array. The output is two arrays for each electrode.
%
% Haider Riaz - haider.riaz@mail.mcgill.ca
% McIntyre Medical Building Room 1225
% Department of Physiology, McGill University
%
% Created by Haider Riaz 2014.

function [MU] = MultiUnits(e , Session, Trode, TrialNum, FiltTrode, Threshold)


LengthWaveform = length(FiltTrode);

% Create trigger Arrays
trigger = zeros(LengthWaveform , 1);

MU = zeros(LengthWaveform , 1);


TimingMs = e(Session).H(1);

%Time Difference
TimeDiff = e(Session,1).ev(TrialNum,1).SampleZero - double(e(Session,1).ev(TrialNum,1).startTime);



for i=1:LengthWaveform
    
    if FiltTrode(i , 1)>Threshold
        
        
        
        trigger(i) = 1;
        
        
    else
        
        
        trigger(i) = 0;
        
        
    end
    
    
    
end



for i=1:(LengthWaveform - 1)
    
    
    
    if (trigger(i+1) - trigger(i)) == 1
        
        MU(i+1) = 1;
        
    end
    
    
    
end




if(e(Session,1).nneur ~= 0)
    
    for j = 1:length(Trode)
        
        Jst = e(Session,1).neur(Trode(j),1).times(TrialNum,1).ms;
        
        if(isempty(Jst))
            
            continue;
            
        end
        
        
        
        for i = 1:length(Jst(: , 1))
            
            indices = find(MU);
            
            TimeStamp = Jst(i , 1);
            
            TimeStamp = double(TimeStamp);
            
            index = ((TimeStamp - TimeDiff)/TimingMs) + 1;
            
            index = double(index);
            
            if(index > (LengthWaveform + 26))
                
                continue;
                
            end
            
            if(index < -24)
                
                continue;
                
            end
            
            
            [Junk , Catch] = min(abs(indices-index));
            
            
            MU(indices(Catch)) = 0;
            
            
            
        end
        
        
    end
    
end



MU = int8(MU);


end