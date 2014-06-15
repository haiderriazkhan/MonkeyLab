% Function for storing SingleUnits spikes of a trial as int8 boolean arrays
%
% Haider Riaz - haider.riaz@mail.mcgill.ca
% McIntyre Medical Building Room 1225
% Department of Physiology, McGill University
%
% Created by Haider Riaz 2014.


function SU = SingleUnits(RawWaveforms, e , Session , TrialNum, SUnum)

    TimeDiffMs = e(Session,1).ev(TrialNum,1).SampleZero - double(e(Session,1).ev(TrialNum,1).startTime);
    
    TimingMs = e(Session).H(2);

    %Obtaining id
    id = e(Session,1).ev(TrialNum,1).id;
    
    TrodeNum = e(Session,1).neur(SUnum,1).trode;
    
    X = RawWaveforms(1,id).RawWaveforms{TrodeNum,1};
    
    LengthWaveform = length(X);
    
    JacksonSpikes = e(Session,1).neur(SUnum,1).times(TrialNum,1).ms;
    
    if(isempty(JacksonSpikes))
       
        SU = [];
        return;
        
    end
    
    
    SU = zeros(LengthWaveform , 1);
    
    
    for j = 1:length(JacksonSpikes)
        
        TimeStamp = JacksonSpikes(j , 1);
        
        TimeStamp = double(TimeStamp);
        
        index = ((TimeStamp - TimeDiffMs)/TimingMs) + 1;
        
        index = int64(index);
        
        if((TimeStamp - TimeDiffMs) < 0)
           
            if((TimeStamp - TimeDiffMs) >= -1)
                
               SU(1 , 1) = 1; 
                
            end
            
            continue;
            
        end
        
        if(index > LengthWaveform)
           
            if(index <= (LengthWaveform + 26))
                
               SU(LengthWaveform , 1) = 1; 
                
            end
            
            continue;
            
        end
        
        
        
        SU(index , 1) = 1;
        
    end
    
    

end