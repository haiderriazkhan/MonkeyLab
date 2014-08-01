% Builds a plot of Joint Detect Probability vs Joint Neurometric for Multi
% Unit Spikes
%
% Haider Riaz - haider.riaz@mail.mcgill.ca
% McIntyre Medical Building Room 1225
% Department of Physiology, McGill University
%
% Created by Haider Riaz 2014.


function [JNeuroMetric, JdetectProb] = MultiUnitJointMetrics(HaiderData)


JdetectProb = zeros(50,1);

JNeuroMetric = zeros(50,1);



parfor i=1:length(HaiderData)
    
    correct = FiringRate(HaiderData(i) , 50, 150 , 'signalOn' , 0 , 0);
    
    fail = FiringRate(HaiderData(i) , 50, 150 , 'signalOn' , 0 , 2);
    
    
    MaxJDP = 0.5;
    
    for x=0:(pi/180):(2*pi)
        
        Correct = (sin(x)* correct(:,1) ) + (cos(x)* correct(:,2) );
        Fail = (sin(x)* fail(:,1) ) + (cos(x)* fail(:,2) );
        JDP = roc(Fail , Correct);
        
        if abs(JDP - 0.5) > abs(MaxJDP - 0.5)
            
            MaxJDP = JDP;
            % Angular measure in radian that will yield the weights that produce
            % the maximum JDP.
            
        end
          
        
    end
    
    JdetectProb(i , 1) = MaxJDP;
    
    
    
    
    
    
    
    Before = FiringRate(HaiderData(i) , -100, 0 , 'signalOn' , 0 , 0);
    
    Before = vertcat(Before , FiringRate(HaiderData(i) , -100, 0 , 'signalOn' , 0 , 2) );
    
    After = FiringRate(HaiderData(i) , 50, 150 , 'signalOn' , 0 , 0);
    
    After = vertcat(After , FiringRate(HaiderData(i) , 50, 150 , 'signalOn' , 0 , 2) );
    
    
    MaxNM = 0.5;
    
    for x=0:(pi/180):(2*pi)
        
        BF = (sin(x)* Before(:,1) ) + (cos(x)* Before(:,2) );
        AF = (sin(x)* After(:,1) ) + (cos(x)* After(:,2) );
        JNM = roc(BF , AF);
        
        if abs(JNM - 0.5) > abs(MaxNM - 0.5)
            
            MaxNM = JNM;
            % Angular measure in radian that will yield the weights that produce
            % the maximum JDP.
            
        end
          
        
    end
    
    JNeuroMetric(i , 1) = MaxNM;
    
    
end

figure(1);
Title =  'Joint Detect Probability vs Joint Neurometric for Multi Unit Spikes';
title(Title , 'FontSize', 20)
p = polyfit(abs(JNeuroMetric - 0.5),abs(JdetectProb - 0.5),1);   % p returns 2 coefficients fitting r = a_1 * x + a_2
r = p(1) .* abs(JNeuroMetric - 0.5)  + p(2); % compute a new vector r that has matching datapoints in x
scatter(abs(JNeuroMetric - 0.5) , abs(JdetectProb - 0.5), 'go')
hold on;
plot(abs(JNeuroMetric - 0.5), r, 'r-');
hold off;
Legend = {'Multi Unit Pairs', 'Line of Best Fit'};
legend(Legend);
xlabel('Joint Neurometric', 'FontSize', 20)
ylabel('Joint Detect Probability', 'FontSize', 20)



JNeuroMetric = abs(JNeuroMetric - 0.5);

JdetectProb = abs(JdetectProb - 0.5);



end
