% Function for filtering the raw electrode waveforms
% The function employs a stop band filter custom made for Erik Cook's lab
%
% Haider Riaz - haider.riaz@mail.mcgill.ca
% McIntyre Medical Building Room 1225
% Department of Physiology, McGill University
%
% Created by Haider Riaz 2014.


function [FiltTrode1 , FiltTrode2, TrialTime1, TrialTime2 ] = FilterWaveforms(RawWaveforms, e , Session, TrialNum, filterNum )


% Obtaining the frequencies
TimingMs_Trode1 = e(Session).H(1);

TimingMs_Trode2 = e(Session).H(2);

Trode1_Hz = (1/TimingMs_Trode1)*1000;

Trode2_Hz = (1/TimingMs_Trode2)*1000;


if(Trode1_Hz ~= Trode2_Hz)
    disp('Frequencies are different');
    FiltTrode1 = [];
    FiltTrode2 = [];
    TrialTime1 = [];
    TrialTime2 = [];
    return;
else
    
    Hertz  = Trode1_Hz;
    TimingMs = TimingMs_Trode2;
end

%Obtaining id
id = e(Session,1).ev(TrialNum,1).id;

if(isempty(RawWaveforms(1,id).RawWaveforms))
    
    FiltTrode1 = [];
    FiltTrode2 = [];
    TrialTime1 = [];
    TrialTime2 = [];
    return; 
    
end

%Obtaining RawWaveforms from Trode 1 and 2.
X = RawWaveforms(1,id).RawWaveforms{1,1};
X2 = RawWaveforms(1,id).RawWaveforms{2,1};




LengthWaveform = length(X);
LengthWaveform2 = length(X2);

% Trial Time Duration for each Trode
TrialTime1 = ((LengthWaveform-1)/Hertz);
TrialTime2 = ((LengthWaveform2-1)/Hertz);


%Time Difference
TimeDiffMs = e(Session,1).ev(TrialNum,1).SampleZero - double(e(Session,1).ev(TrialNum,1).startTime);



% Using Filter 1
if(filterNum == 1)
    
    %Building Filter
    Wp = [ 300  9000] * 2 / Hertz;
    Ws = [ 200 9500] * 2 / Hertz;
    [N,Wn] = buttord( Wp, Ws, 3, 20);
    [B,A] = butter(N,Wn);
    
    % Filtering trode 1
    FiltTrode1 = filtfilt(B , A , double(X));
    
    % Filtering trode 2
    FiltTrode2 = filtfilt(B , A , double(X2));
    
else
    
    HalfHz = Hertz/2;
    
    start = 300/HalfHz;
    
    last = 9000/HalfHz;
    
    [B1,A1] = butter(1,start,'high');
    
    [B2,A2] = butter(1,last,'low');
    
    % Filtering trode 1
    FiltTrode1 = filter(B1 , A1 , double(X));
    FiltTrode1 = filter(B2 , A2 , FiltTrode1);
    
    % Filtering trode 2
    FiltTrode2 = filter(B1 , A1 , double(X2));
    FiltTrode2 = filter(B2 , A2 , FiltTrode2);
    
    
    
end




JacksonTrialEnd = e(Session,1).ev(TrialNum,1).trialEnd;

TrialTime_Trode1 = ((LengthWaveform-1)*TimingMs) + TimeDiffMs;

TrialTime_Trode2 = ((LengthWaveform2-1)*TimingMs) + TimeDiffMs;

TimeTest1 = abs(JacksonTrialEnd - TrialTime_Trode1);

TimeTest2 = abs(JacksonTrialEnd - TrialTime_Trode2);

if(TimeTest1 > 40 || TimeTest2 > 40)
    
    FiltTrode1 = [];
    FiltTrode2 = [];
    TrialTime1 = [];
    TrialTime2 = [];
    return;
    
end
