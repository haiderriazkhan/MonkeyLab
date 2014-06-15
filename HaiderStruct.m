% Function for creating a matlab data structure designed to hold all the 
% relevant information of every trial in a session.
% 
% Haider Riaz - haider.riaz@mail.mcgill.ca
% McIntyre Medical Building Room 1225
% Department of Physiology, McGill University
%
% Created by Haider Riaz 2014.


function Name = HaiderStruct(e , Session ,   MultiUnits , Info , RawWaveforms )


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



Name.exp = e(Session,1).exp;

Name.patch = e(Session,1).patch;

Name.coh1 = e(Session,1).coh1;

Name.coh2 = e(Session,1).coh2;

Name.nneur = e(Session,1).nneur;

Name.npair = e(Session,1).npair;

Name.TimingMs = e(Session,1).H;

Name.FlaggedTrials = Info.FlaggedTrials;

Name.MUThresh1 = Info.Thresholds(1 , 1:2);

Name.MUThresh2 = Info.Thresholds(2 , 1:2);






for i=1:length(MultiUnits)
    
    TrialNum = MultiUnits(i).TrialNum;
    
    Name.Trials(i , 1).id = e(Session,1).ev(TrialNum,1).id;
    
    Name.Trials(i , 1).FullName = e(Session,1).ev(TrialNum,1).FullId;
    
    Name.Trials(i , 1).startTime = e(Session,1).ev(TrialNum,1).startTime;
    
    Name.Trials(i , 1).SampleZero = e(Session,1).ev(TrialNum,1).SampleZero;
    
    Name.Trials(i , 1).coh1 = e(Session,1).ev(TrialNum,1).coh1;
    
    Name.Trials(i , 1).coh2 = e(Session,1).ev(TrialNum,1).coh2;
    
    Name.Trials(i , 1).stimConfig = e(Session,1).ev(TrialNum,1).stimConfig;
    
    Name.Trials(i , 1).behav = e(Session,1).ev(TrialNum,1).behav;
    
    Name.Trials(i , 1).rt = e(Session,1).ev(TrialNum,1).rt;
    
    Name.Trials(i , 1).fixOn = e(Session,1).ev(TrialNum,1).fixOn;
    
    Name.Trials(i , 1).leverDn = e(Session,1).ev(TrialNum,1).leverDn;
    
    Name.Trials(i , 1).stimOn = e(Session,1).ev(TrialNum,1).stimOn;
    
    Name.Trials(i , 1).signalOn = e(Session,1).ev(TrialNum,1).signalOn;
    
    Name.Trials(i , 1).leverUp = e(Session,1).ev(TrialNum,1).leverUp;
    
    Name.Trials(i , 1).trialEnd = e(Session,1).ev(TrialNum,1).trialEnd;
    
    Name.Trials(i , 1).usac = e(Session,1).usac.times(TrialNum,1);
    
    Name.Trials(i , 1).MU{1,1} = MultiUnits(i).Trode1;
    
    Name.Trials(i , 1).MU{2,1} = MultiUnits(i).Trode2;
    
    for j=1:length(Trode1)
        
     Name.Trials(i , 1).SU(j,1).trode = 1;
     Name.Trials(i , 1).SU(j,1).SingleUnits = SingleUnits(RawWaveforms, e , Session , TrialNum, Trode1(j));
        
    end
    
    for j=1:length(Trode2)
        
        Name.Trials(i , 1).SU(length(Trode1)+j , 1).trode = 2;
        Name.Trials(i , 1).SU(length(Trode1)+j , 1).SingleUnits = SingleUnits(RawWaveforms, e , Session , TrialNum, Trode2(j));
        
    end
    
    
    
end



end